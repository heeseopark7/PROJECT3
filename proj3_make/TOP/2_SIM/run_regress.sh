#!/bin/bash
# One-command regression for the RTL written so far.  Usage: bash 2_SIM/run_regress.sh
# Runs: iverilog (-g2001) sim, Verilator lint (-Wall), Yosys read_verilog (plain Verilog-2001),
#       and checks that every implemented ARCH combination gives the SAME output HASH (V10/V11/M6).
# To add a variant: append its code to ADDER_ARCHS / SHIFTER_ARCHS (and its file to ADD / SHF).
cd "$(dirname "$0")" || exit 1
RTL=../1_RTL
OUT=${TMPDIR:-/tmp}/proj3_regress
rm -rf "$OUT"; mkdir -p "$OUT"
rc=0

ADDER_ARCHS="4 0"       # implemented ADDER_ARCH codes   (4 BEH, 0 RCA)
SHIFTER_ARCHS="1 0"     # implemented SHIFTER_ARCH codes (1 barrel, 0 loop)

run_sim() {  # name tb "param-flags" rtl-files...      (param-flags example: "-Ptb.X=1 -Ptb.Y=2")
    local name=$1 tb=$2 par=$3; shift 3
    iverilog -g2001 -Wall -Wno-timescale -I$RTL $par -o "$OUT/$name.vvp" "$tb" "$@" || { echo "COMPILE FAIL: $name"; rc=1; return; }
    vvp "$OUT/$name.vvp" | tee "$OUT/$name.log" | grep -v '^$' | grep -v 'finish called'
    grep -q "RESULT: PASS" "$OUT/$name.log" || { echo ">>> $name FAILED"; rc=1; }
}

same_hash() {  # label log-glob-prefix
    local n; n=$(grep -h '^HASH' $OUT/$2*.log | sort -u | wc -l)
    if [ "$n" -ne 1 ]; then echo ">>> $1 output HASH differs between ARCH combos"; rc=1
    else echo "$1 HASH identical across all combos: $(grep -h '^HASH' $OUT/$2*.log | sort -u)"; fi
}

ADD="$RTL/adder_top.v $RTL/adder_beh.v $RTL/adder_rca.v"
SHF="$RTL/alu_shifter.v $RTL/shr_barrel.v $RTL/shr_loop.v"
CORE="$RTL/alu_core.v $ADD $SHF"
TOP="$RTL/alu_top.v $CORE"
MUL="$RTL/mul_top.v $RTL/mul_beh.v"
MAC="$RTL/mac_top.v $MUL $ADD"

echo "=== SIM ==="
for aa in $ADDER_ARCHS; do run_sim adder_a$aa TESTBENCH/tb_adder.v "-Ptb_adder.ARCH=$aa" $ADD; done
for sa in $SHIFTER_ARCHS; do run_sim shifter_s$sa TESTBENCH/tb_shifter.v "-Ptb_shifter.ARCH=$sa" $SHF; done
same_hash shifter shifter_

for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    run_sim core_a${aa}_s$sa TESTBENCH/tb_alu_core.v "-Ptb_alu_core.AARCH=$aa -Ptb_alu_core.SARCH=$sa" $CORE
done; done
same_hash alu_core core_

for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    run_sim top_a${aa}_s$sa TESTBENCH/tb_ALU.v "-Ptb_ALU.AARCH=$aa -Ptb_ALU.SARCH=$sa" $TOP
done; done
same_hash alu_top top_

run_sim mul_m0 TESTBENCH/tb_mul.v "-Ptb_mul.ARCH=0" $MUL
for aa in $ADDER_ARCHS; do
    run_sim mac_m0_a${aa}_st1 TESTBENCH/tb_MAC.v "-Ptb_MAC.AARCH=$aa" $MAC
done
same_hash mac_top mac_

echo "=== LINT (verilator --lint-only -Wall) ==="
for aa in $ADDER_ARCHS; do
    verilator --lint-only -Wall --top-module adder_top -GADDER_ARCH=$aa $ADD && echo "adder_top ADDER_ARCH=$aa: clean" || rc=1
done
for sa in $SHIFTER_ARCHS; do for x in 8 16 32; do
    verilator --lint-only -Wall --top-module alu_shifter -GXLEN=$x -GSHIFTER_ARCH=$sa $SHF && echo "alu_shifter XLEN=$x SHIFTER_ARCH=$sa: clean" || rc=1
done; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    verilator --lint-only -Wall -I$RTL --top-module alu_core -GADDER_ARCH=$aa -GSHIFTER_ARCH=$sa $CORE && echo "alu_core A=$aa S=$sa: clean" || rc=1
    verilator --lint-only -Wall -I$RTL --top-module alu_top  -GADDER_ARCH=$aa -GSHIFTER_ARCH=$sa $TOP  && echo "alu_top  A=$aa S=$sa: clean" || rc=1
done; done
verilator --lint-only -Wall --top-module mul_top $MUL && echo "mul_top: clean" || rc=1
verilator --lint-only -Wall --top-module mac_top $MAC && echo "mac_top: clean" || rc=1

echo "=== YOSYS read_verilog ==="
y() { yosys -q -p "read_verilog -I$RTL $1; hierarchy -check -top $2 $3" || rc=1; }
for aa in $ADDER_ARCHS; do y "$ADD" adder_top "-chparam ADDER_ARCH $aa"; done
for sa in $SHIFTER_ARCHS; do y "$SHF" alu_shifter "-chparam SHIFTER_ARCH $sa"; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    y "$CORE" alu_core "-chparam ADDER_ARCH $aa -chparam SHIFTER_ARCH $sa"
    y "$TOP"  alu_top  "-chparam ADDER_ARCH $aa -chparam SHIFTER_ARCH $sa"
done; done
y "$MUL" mul_top ""
y "$MAC" mac_top ""
[ $rc -eq 0 ] && echo "yosys: ok"

echo "=== NEGATIVE: unimplemented ARCH must fail elaboration ==="
neg() {  # label top param-flag rtl-files...
    local label=$1 top=$2 par=$3; shift 3
    iverilog -g2001 $par -s $top -o /dev/null "$@" >/dev/null 2>&1 && { echo "ERROR: $label compiled"; rc=1; } || echo "$label: rejected (expected)"
}
neg "adder ARCH=2"    adder_top   -Padder_top.ADDER_ARCH=2        $ADD
neg "shifter ARCH=2"  alu_shifter -Palu_shifter.SHIFTER_ARCH=2    $SHF
neg "mul ARCH=1"      mul_top     -Pmul_top.MULT_ARCH=1           $MUL
neg "mac STAGES=2"    mac_top     -Pmac_top.MAC_STAGES=2          $MAC
neg "mac A_W=6"       mac_top     -Pmac_top.A_W=6                 $MAC

[ $rc -eq 0 ] && echo "ALL OK" || echo "REGRESSION FAILED"
exit $rc

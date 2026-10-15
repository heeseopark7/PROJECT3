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

ADDER_ARCHS="4 0 2"     # implemented ADDER_ARCH codes   (4 BEH, 0 RCA, 2 Kogge-Stone)
SHIFTER_ARCHS="1 0"     # implemented SHIFTER_ARCH codes (1 barrel, 0 loop)

JOBS=${JOBS:-4}         # simulations run in parallel
ORDER=""                # job names in launch order (for printing)

# Launch one simulation in the background (at most JOBS at a time).
run_sim() {  # name tb "param-flags" rtl-files...      (param-flags example: "-Ptb.X=1 -Ptb.Y=2")
    local name=$1 tb=$2 par=$3; shift 3
    ORDER="$ORDER $name"
    while [ "$(jobs -r | wc -l)" -ge "$JOBS" ]; do sleep 0.5; done
    (
        if iverilog -g2001 -Wall -Wno-timescale -I$RTL $par -o "$OUT/$name.vvp" "$tb" "$@" > "$OUT/$name.compile" 2>&1; then
            vvp "$OUT/$name.vvp" > "$OUT/$name.log" 2>&1
            grep -q "RESULT: PASS" "$OUT/$name.log" && echo ok > "$OUT/$name.status" || echo fail > "$OUT/$name.status"
        else
            echo compile-fail > "$OUT/$name.status"
        fi
    ) &
}

# Wait for all launched simulations, then print their logs in launch order and set rc.
collect_sims() {
    wait
    for name in $ORDER; do
        st=$(cat "$OUT/$name.status" 2>/dev/null)
        if [ "$st" = "compile-fail" ]; then echo "COMPILE FAIL: $name"; cat "$OUT/$name.compile"; rc=1
        else
            grep -v '^$' "$OUT/$name.log" | grep -v 'finish called'
            [ "$st" = "ok" ] || { echo ">>> $name FAILED"; rc=1; }
        fi
    done
}

same_hash() {  # label log-glob-prefix
    local n; n=$(grep -h '^HASH' $OUT/$2*.log | sort -u | wc -l)
    if [ "$n" -ne 1 ]; then echo ">>> $1 output HASH differs between ARCH combos"; rc=1
    else echo "$1 HASH identical across all combos: $(grep -h '^HASH' $OUT/$2*.log | sort -u)"; fi
}

ADD="$RTL/adder_top.v $RTL/adder_beh.v $RTL/adder_rca.v $RTL/adder_ks.v"
SHF="$RTL/alu_shifter.v $RTL/shr_barrel.v $RTL/shr_loop.v"
CORE="$RTL/alu_core.v $ADD $SHF"
TOP="$RTL/alu_top.v $CORE"
MUL="$RTL/mul_top.v $RTL/mul_beh.v"
MAC="$RTL/mac_top.v $MUL $ADD"

echo "=== SIM (up to $JOBS in parallel) ==="
for aa in $ADDER_ARCHS; do run_sim adder_a$aa TESTBENCH/tb_adder.v "-Ptb_adder.ARCH=$aa" $ADD; done
for sa in $SHIFTER_ARCHS; do run_sim shifter_s$sa TESTBENCH/tb_shifter.v "-Ptb_shifter.ARCH=$sa" $SHF; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    run_sim core_a${aa}_s$sa TESTBENCH/tb_alu_core.v "-Ptb_alu_core.AARCH=$aa -Ptb_alu_core.SARCH=$sa" $CORE
done; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    run_sim top_a${aa}_s$sa TESTBENCH/tb_ALU.v "-Ptb_ALU.AARCH=$aa -Ptb_ALU.SARCH=$sa" $TOP
done; done
run_sim mul_m0 TESTBENCH/tb_mul.v "-Ptb_mul.ARCH=0" $MUL
for aa in $ADDER_ARCHS; do
    run_sim mac_m0_a${aa}_st1 TESTBENCH/tb_MAC.v "-Ptb_MAC.AARCH=$aa" $MAC
done
collect_sims

same_hash adder  adder_
same_hash shifter shifter_
same_hash alu_core core_
same_hash alu_top top_
same_hash mac_top mac_

echo "=== LINT (verilator --lint-only -Wall) ==="
for aa in $ADDER_ARCHS; do for w in 8 16 24 32 40; do
    verilator --lint-only -Wall --top-module adder_top -GADDER_ARCH=$aa -GW=$w $ADD && echo "adder_top ADDER_ARCH=$aa W=$w: clean" || rc=1
done; done
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
for aa in $ADDER_ARCHS; do for w in 8 16 24 32 40; do y "$ADD" adder_top "-chparam ADDER_ARCH $aa -chparam W $w"; done; done
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
neg "adder ARCH=1"    adder_top   -Padder_top.ADDER_ARCH=1        $ADD
neg "adder ARCH=3"    adder_top   -Padder_top.ADDER_ARCH=3        $ADD
neg "shifter ARCH=2"  alu_shifter -Palu_shifter.SHIFTER_ARCH=2    $SHF
neg "mul ARCH=1"      mul_top     -Pmul_top.MULT_ARCH=1           $MUL
neg "mac STAGES=2"    mac_top     -Pmac_top.MAC_STAGES=2          $MAC
neg "mac A_W=6"       mac_top     -Pmac_top.A_W=6                 $MAC

[ $rc -eq 0 ] && echo "ALL OK" || echo "REGRESSION FAILED"
exit $rc

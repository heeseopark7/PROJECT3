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
MULT_ARCHS="0 1"        # implemented MULT_ARCH codes    (0 BEH, 1 Array)

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
MUL="$RTL/mul_top.v $RTL/mul_beh.v $RTL/mul_csa_top.v $RTL/mul_array_csa.v $ADD"
MAC="$RTL/mac_top.v $MUL"

echo "=== SIM (up to $JOBS in parallel) ==="
# multiplier: 1,000,000 random pairs at A_W=16 (M2) for the default adder; launched first because they are the slowest
for m in $MULT_ARCHS; do
    run_sim mulfull_m$m TESTBENCH/tb_mul.v "-Ptb_mul.ARCH=$m -Ptb_mul.AARCH=4 -Ptb_mul.NR16=1000000" $MUL
done
for aa in $ADDER_ARCHS; do run_sim adder_a$aa TESTBENCH/tb_adder.v "-Ptb_adder.ARCH=$aa" $ADD; done
for sa in $SHIFTER_ARCHS; do run_sim shifter_s$sa TESTBENCH/tb_shifter.v "-Ptb_shifter.ARCH=$sa" $SHF; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    run_sim core_a${aa}_s$sa TESTBENCH/tb_alu_core.v "-Ptb_alu_core.AARCH=$aa -Ptb_alu_core.SARCH=$sa" $CORE
done; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    run_sim top_a${aa}_s$sa TESTBENCH/tb_ALU.v "-Ptb_ALU.AARCH=$aa -Ptb_ALU.SARCH=$sa" $TOP
done; done
# carry-save multipliers directly (o_s + o_c == a*b), then every (MULT_ARCH x ADDER_ARCH) with fewer random pairs
for m in $MULT_ARCHS; do
    [ "$m" = "0" ] && continue          # BEH has no carry-save form
    run_sim mulcsa_m$m TESTBENCH/tb_mul_csa.v "-Ptb_mul_csa.ARCH=$m -Ptb_mul_csa.NR16=200000" $MUL
done
for m in $MULT_ARCHS; do
    if [ "$m" = "0" ]; then run_sim mulx_m0_a4 TESTBENCH/tb_mul.v "-Ptb_mul.ARCH=0 -Ptb_mul.AARCH=4 -Ptb_mul.NR16=100000" $MUL; continue; fi
    for aa in $ADDER_ARCHS; do
        run_sim mulx_m${m}_a$aa TESTBENCH/tb_mul.v "-Ptb_mul.ARCH=$m -Ptb_mul.AARCH=$aa -Ptb_mul.NR16=100000" $MUL
    done
done
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do
    run_sim mac_m${m}_a${aa}_st1 TESTBENCH/tb_MAC.v "-Ptb_MAC.MARCH=$m -Ptb_MAC.AARCH=$aa" $MAC
done; done
collect_sims

same_hash adder  adder_
same_hash shifter shifter_
same_hash alu_core core_
same_hash alu_top top_
same_hash mul_1M mulfull_
same_hash mul_100k mulx_
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
for m in $MULT_ARCHS; do for w in 4 8 16; do
    verilator --lint-only -Wall --top-module mul_top -GMULT_ARCH=$m -GA_W=$w $MUL && echo "mul_top MULT_ARCH=$m A_W=$w: clean" || rc=1
done; done
for m in $MULT_ARCHS; do [ "$m" = "0" ] && continue; for w in 4 8 16; do
    verilator --lint-only -Wall --top-module mul_csa_top -GMULT_ARCH=$m -GA_W=$w $MUL && echo "mul_csa_top MULT_ARCH=$m A_W=$w: clean" || rc=1
done; done
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do
    verilator --lint-only -Wall --top-module mac_top -GMULT_ARCH=$m -GADDER_ARCH=$aa $MAC && echo "mac_top M=$m A=$aa: clean" || rc=1
done; done

echo "=== YOSYS read_verilog ==="
y() { yosys -q -p "read_verilog -I$RTL $1; hierarchy -check -top $2 $3" || rc=1; }
for aa in $ADDER_ARCHS; do for w in 8 16 24 32 40; do y "$ADD" adder_top "-chparam ADDER_ARCH $aa -chparam W $w"; done; done
for sa in $SHIFTER_ARCHS; do y "$SHF" alu_shifter "-chparam SHIFTER_ARCH $sa"; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    y "$CORE" alu_core "-chparam ADDER_ARCH $aa -chparam SHIFTER_ARCH $sa"
    y "$TOP"  alu_top  "-chparam ADDER_ARCH $aa -chparam SHIFTER_ARCH $sa"
done; done
for m in $MULT_ARCHS; do for w in 4 8 16; do y "$MUL" mul_top "-chparam MULT_ARCH $m -chparam A_W $w"; done; done
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do y "$MAC" mac_top "-chparam MULT_ARCH $m -chparam ADDER_ARCH $aa"; done; done
[ $rc -eq 0 ] && echo "yosys: ok"

echo "=== NEGATIVE: unimplemented ARCH must fail elaboration ==="
neg() {  # label top param-flag rtl-files...
    local label=$1 top=$2 par=$3; shift 3
    iverilog -g2001 $par -s $top -o /dev/null "$@" >/dev/null 2>&1 && { echo "ERROR: $label compiled"; rc=1; } || echo "$label: rejected (expected)"
}
neg "adder ARCH=1"    adder_top   -Padder_top.ADDER_ARCH=1        $ADD
neg "adder ARCH=3"    adder_top   -Padder_top.ADDER_ARCH=3        $ADD
neg "shifter ARCH=2"  alu_shifter -Palu_shifter.SHIFTER_ARCH=2    $SHF
neg "mul ARCH=2"      mul_top     -Pmul_top.MULT_ARCH=2           $MUL
neg "mul ARCH=3"      mul_top     -Pmul_top.MULT_ARCH=3           $MUL
neg "mul_csa ARCH=0"  mul_csa_top -Pmul_csa_top.MULT_ARCH=0       $MUL
neg "mul A_W=6"       mul_top     -Pmul_top.A_W=6                 $MUL
neg "mac STAGES=2"    mac_top     -Pmac_top.MAC_STAGES=2          $MAC
neg "mac A_W=6"       mac_top     -Pmac_top.A_W=6                 $MAC

[ $rc -eq 0 ] && echo "ALL OK" || echo "REGRESSION FAILED"
exit $rc

#!/bin/bash
# =============================================================================
# One-command regression.   Usage:  bash 2_SIM/run_regress.sh        (from anywhere)
#   MODE=full   (default) Phase 1 + Phase 2 + lint + yosys + negative tests
#   MODE=vl               Phase 1 only (Verilator, full volume) + its HASH checks; no lint/yosys
#   MODE=quick            Phase 2 (small volume) + lint + yosys + negative tests
#   MODE=static           NO simulation: re-check the HASH equality of logs already in $OUT, then lint + yosys + negative tests
#   JOBS=<n>              parallel jobs (default: number of CPUs)
#
# Phase 1  Verilator (--binary --timing), FULL volume: 1,000,000-vector adder/multiplier tests, exhaustive 8-bit
#          tests, long random streams.  Verilator is 2-state, so it cannot see X/Z.
# Phase 2  iverilog (-g2001 -Wall = Verilog-2001 compliance), SMALL volume, 4-state: the same testbenches,
#          compared with '!==', so X/Z on any output fails. (Brent-Kung x multiplier/MAC cross runs are skipped here:
#          iverilog is too slow on them; Phase 1 covers them.)
# Both phases use the testbenches' own PRNG (xorshift32), so every simulator sees the same stimulus.
# Pass rule: every test FAIL = 0 and reach checks 100%; for each block the output HASH must be identical for ALL
#            implemented architecture combinations (same stimulus -> bit-identical outputs).
# To add a variant: append its code to ADDER_ARCHS / SHIFTER_ARCHS / MULT_ARCHS (and its file to the file lists).
# =============================================================================
cd "$(dirname "$0")" || exit 1
RTL=../1_RTL
OUT=${TMPDIR:-/tmp}/proj3_regress
MODE=${MODE:-full}
JOBS=${JOBS:-$(nproc)}
[ "$MODE" = "static" ] || rm -rf "$OUT"
mkdir -p "$OUT"
rc=0

ADDER_ARCHS="4 0 1 2 3"     # 4 BEH, 0 RCA, 1 CLA, 2 Kogge-Stone, 3 Brent-Kung
SHIFTER_ARCHS="1 0"         # 1 barrel, 0 loop
MULT_ARCHS="0 1 2"          # 0 BEH, 1 Array, 2 Booth+Wallace

# ---- file lists ----------------------------------------------------------------------------------------------
ADD="$RTL/adder_top.v $RTL/adder_beh.v $RTL/adder_rca.v $RTL/adder_cla.v $RTL/adder_ks.v $RTL/adder_bk.v"
SHF="$RTL/alu_shifter.v $RTL/shr_barrel.v $RTL/shr_loop.v"
CORE="$RTL/alu_core.v $ADD $SHF"
TOP="$RTL/alu_top.v $CORE"
MUL="$RTL/mul_top.v $RTL/mul_beh.v $RTL/mul_csa_top.v $RTL/mul_array_csa.v $RTL/mul_booth_csa.v $ADD"
MAC="$RTL/mac_top.v $MUL"

# ---- job table: name | testbench | top | files | full-volume params | small-volume params ---------------------------
JN=(); JT=(); JP=(); JF=(); JV=(); JS=()
add_job() { JN+=("$1"); JT+=("$2"); JP+=("$3"); JF+=("$4"); JV+=("$5"); JS+=("$6"); }

for aa in $ADDER_ARCHS; do
    add_job "adder_a$aa" TESTBENCH/tb_adder_top.v tb_adder_top "$ADD" "ARCH=$aa" "ARCH=$aa NR_BIG=3000 NR_MID=1000 EXH8=0"
done
for sa in $SHIFTER_ARCHS; do
    add_job "shifter_s$sa" TESTBENCH/tb_alu_shifter.v tb_alu_shifter "$SHF" "ARCH=$sa" "ARCH=$sa NR=100 EXH8=0"
done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    add_job "core_a${aa}_s$sa" TESTBENCH/tb_alu_core.v tb_alu_core "$CORE" "AARCH=$aa SARCH=$sa" "AARCH=$aa SARCH=$sa NR=200 EXH8=0"
    add_job "top_a${aa}_s$sa"  TESTBENCH/tb_alu_top.v      tb_alu_top      "$TOP"  "AARCH=$aa SARCH=$sa" "AARCH=$aa SARCH=$sa NCYC=1500"
done; done
for m in $MULT_ARCHS; do      # 1,000,000 random pairs at A_W=16 (M2), baseline adder
    add_job "mulfull_m$m" TESTBENCH/tb_mul_top.v tb_mul_top "$MUL" "ARCH=$m AARCH=4 NR16=1000000" "ARCH=$m AARCH=4 NR16=1500 EXH8=0"
done
for m in $MULT_ARCHS; do      # carry-save multipliers directly: o_s + o_c == a*b
    [ "$m" = "0" ] && continue
    add_job "mulcsa_m$m" TESTBENCH/tb_mul_csa_top.v tb_mul_csa_top "$MUL" "ARCH=$m NR16=200000" "ARCH=$m NR16=1000 EXH8=0"
done
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do      # structured multipliers x every final adder
    [ "$m" = "0" ] && continue
    add_job "mulx_m${m}_a$aa" TESTBENCH/tb_mul_top.v tb_mul_top "$MUL" "ARCH=$m AARCH=$aa NR16=100000" "ARCH=$m AARCH=$aa NR16=1000 EXH8=0"
done; done
add_job "mulx_m0_a4" TESTBENCH/tb_mul_top.v tb_mul_top "$MUL" "ARCH=0 AARCH=4 NR16=100000" "ARCH=0 AARCH=4 NR16=1000 EXH8=0"
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do      # MAC stage 1: every (multiplier x adder)
    add_job "mac_m${m}_a${aa}_st1" TESTBENCH/tb_mac_top.v tb_mac_top "$MAC" "MARCH=$m AARCH=$aa STAGES=1" "MARCH=$m AARCH=$aa STAGES=1 NCYC=1500"
done; done
for m in $MULT_ARCHS; do      # MAC stages 2 and 3: baseline adder (stage 3 needs a carry-save multiplier)
    add_job "mac_m${m}_a4_st2" TESTBENCH/tb_mac_top.v tb_mac_top "$MAC" "MARCH=$m AARCH=4 STAGES=2" "MARCH=$m AARCH=4 STAGES=2 NCYC=1500"
    [ "$m" = "0" ] && continue
    add_job "mac_m${m}_a4_st3" TESTBENCH/tb_mac_top.v tb_mac_top "$MAC" "MARCH=$m AARCH=4 STAGES=3" "MARCH=$m AARCH=4 STAGES=3 NCYC=1500"
done

# ---- runners -------------------------------------------------------------------------------------------------
run_job() {   # phase idx     (phase: v = Verilator full volume, i = iverilog 4-state small volume)
    local ph=$1 i=$2 name="${JN[$2]}" top="${JP[$2]}" tb="${JT[$2]}" files="${JF[$2]}"
    local tag="${ph}_$name" par flags="" p
    if [ "$ph" = "v" ]; then
        par="${JV[$i]}"
        for p in $par; do flags="$flags -G$p"; done
        mkdir -p "$OUT/$tag"
        if verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style -Wno-TIMESCALEMOD -CFLAGS -O0 -I$RTL $flags \
                --top-module $top -Mdir "$OUT/$tag" -o sim "$tb" $files > "$OUT/$tag.build" 2>&1; then
            "$OUT/$tag/sim" > "$OUT/$tag.log" 2>&1
            grep -q "RESULT: PASS" "$OUT/$tag.log" && echo ok > "$OUT/$tag.status" || echo fail > "$OUT/$tag.status"
        else echo build-fail > "$OUT/$tag.status"; fi
    else
        par="${JV[$i]} ${JS[$i]}"       # small-volume values come last and override the defaults
        for p in $par; do flags="$flags -P$top.$p"; done
        if iverilog -g2001 -Wall -Wno-timescale -I$RTL $flags -s $top -o "$OUT/$tag.vvp" "$tb" $files > "$OUT/$tag.build" 2>&1; then
            vvp "$OUT/$tag.vvp" > "$OUT/$tag.log" 2>&1
            grep -q "RESULT: PASS" "$OUT/$tag.log" && echo ok > "$OUT/$tag.status" || echo fail > "$OUT/$tag.status"
        else echo build-fail > "$OUT/$tag.status"; fi
    fi
}

# iverilog re-evaluates a whole packed vector on every change, so a deep prefix adder (Brent-Kung 9 stages, Kogge-Stone
# 5 stages with huge fan-in) inside a 32-bit multiplier or a 40-bit MAC accumulator takes tens of minutes there.
# Those cross combinations are therefore run only in Phase 1 (Verilator); the adders themselves are still 4-state
# checked alone, in alu_core and in alu_top.
skip_in_iverilog() {   # job name
    case "$1" in mulx_*_a3|mac_*_a2_*|mac_*_a3_*) return 0;; esac
    return 1
}

run_phase() {   # phase
    local ph=$1 i
    for i in "${!JN[@]}"; do
        if [ "$ph" = "i" ] && skip_in_iverilog "${JN[$i]}"; then continue; fi
        while [ "$(jobs -r | wc -l)" -ge "$JOBS" ]; do sleep 0.3; done
        run_job "$ph" "$i" &
    done
    wait
}

report_phase() {   # phase label
    local ph=$1 i st tag
    echo "---- $2 ----"
    for i in "${!JN[@]}"; do
        if [ "$ph" = "i" ] && skip_in_iverilog "${JN[$i]}"; then continue; fi
        tag="${ph}_${JN[$i]}"
        st=$(cat "$OUT/$tag.status" 2>/dev/null)
        if [ "$st" = "build-fail" ]; then echo "BUILD FAIL: $tag"; head -20 "$OUT/$tag.build"; rc=1
        else
            grep -E "PASS=|^HASH|RESULT|coverage|carry-run" "$OUT/$tag.log" | grep -v "finish"
            [ "$st" = "ok" ] || { echo ">>> $tag FAILED"; rc=1; }
        fi
    done
}

same_hash() {   # phase label job-name-prefix
    local ph=$1 n
    n=$(for f in "$OUT"/${ph}_$3*.log; do grep -h '^HASH' "$f"; done | sort -u | wc -l)
    if [ "$n" -ne 1 ]; then echo ">>> [$ph] $2: output HASH differs between ARCH combinations"; rc=1
    else echo "[$ph] $2: output HASH identical across all combinations: $(grep -h '^HASH' "$OUT"/${ph}_$3*.log | sort -u)"; fi
}

check_hashes() {   # phase
    local ph=$1
    same_hash $ph adder   adder_
    same_hash $ph shifter shifter_
    same_hash $ph alu_core core_
    same_hash $ph alu_top  top_
    same_hash $ph mul_full mulfull_
    same_hash $ph mul_x    mulx_
    same_hash $ph mac_top  mac_
}

echo "regression: MODE=$MODE JOBS=$JOBS jobs=${#JN[@]}"
if [ "$MODE" = "full" ] || [ "$MODE" = "vl" ]; then
    echo "=== PHASE 1: Verilator, full volume ==="
    run_phase v
    report_phase v "Phase 1 results"
    check_hashes v
fi
if [ "$MODE" = "vl" ]; then
    [ $rc -eq 0 ] && echo "PHASE 1 OK" || echo "PHASE 1 FAILED"
    exit $rc
fi
if [ "$MODE" != "static" ]; then
    echo "=== PHASE 2: iverilog -g2001, 4-state, small volume ==="
    run_phase i
    report_phase i "Phase 2 results"
    check_hashes i
else
    echo "=== STATIC mode: using existing logs in $OUT ==="
    report_phase i "Phase 2 results (existing logs)"
    check_hashes i
fi

# ---- lint ----------------------------------------------------------------------------------------------------
echo "=== LINT (verilator --lint-only -Wall) ==="
lint() { verilator --lint-only -Wall -I$RTL "$@" > "$OUT/lint.tmp" 2>&1 && return 0; cat "$OUT/lint.tmp" | head -15; rc=1; return 1; }
lint_n=0
for aa in $ADDER_ARCHS; do for w in 8 16 24 32 40 64; do
    lint --top-module adder_top -GADDER_ARCH=$aa -GW=$w $ADD && lint_n=$((lint_n+1))
done; done
for sa in $SHIFTER_ARCHS; do for x in 8 16 32; do
    lint --top-module alu_shifter -GXLEN=$x -GSHIFTER_ARCH=$sa $SHF && lint_n=$((lint_n+1))
done; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do for x in 8 16 32; do
    lint --top-module alu_core -GXLEN=$x -GADDER_ARCH=$aa -GSHIFTER_ARCH=$sa $CORE && lint_n=$((lint_n+1))
    lint --top-module alu_top  -GXLEN=$x -GADDER_ARCH=$aa -GSHIFTER_ARCH=$sa $TOP  && lint_n=$((lint_n+1))
done; done; done
for m in $MULT_ARCHS; do for w in 4 8 16; do
    lint --top-module mul_top -GMULT_ARCH=$m -GA_W=$w $MUL && lint_n=$((lint_n+1))
    [ "$m" = "0" ] || { lint --top-module mul_csa_top -GMULT_ARCH=$m -GA_W=$w $MUL && lint_n=$((lint_n+1)); }
done; done
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do for st in 1 2 3; do for w in 4 8 16; do
    [ "$m" = "0" ] && [ "$st" = "3" ] && continue
    lint --top-module mac_top -GA_W=$w -GMULT_ARCH=$m -GADDER_ARCH=$aa -GMAC_STAGES=$st $MAC && lint_n=$((lint_n+1))
done; done; done; done
echo "lint: $lint_n configurations clean"

# ---- yosys ---------------------------------------------------------------------------------------------------
echo "=== YOSYS read_verilog + hierarchy + check ==="
ys_n=0
y() { yosys -q -p "read_verilog -I$RTL $1; hierarchy -check -top $2 $3; proc; flatten; opt_clean; check -assert" > "$OUT/yosys.tmp" 2>&1 \
        && ys_n=$((ys_n+1)) || { echo "YOSYS FAIL: $2 $3"; head -10 "$OUT/yosys.tmp"; rc=1; }; }
for aa in $ADDER_ARCHS; do for w in 8 16 24 32 40 64; do y "$ADD" adder_top "-chparam ADDER_ARCH $aa -chparam W $w"; done; done
for sa in $SHIFTER_ARCHS; do y "$SHF" alu_shifter "-chparam SHIFTER_ARCH $sa"; done
for aa in $ADDER_ARCHS; do for sa in $SHIFTER_ARCHS; do
    y "$CORE" alu_core "-chparam ADDER_ARCH $aa -chparam SHIFTER_ARCH $sa"
    y "$TOP"  alu_top  "-chparam ADDER_ARCH $aa -chparam SHIFTER_ARCH $sa"
done; done
for m in $MULT_ARCHS; do for w in 4 8 16; do y "$MUL" mul_top "-chparam MULT_ARCH $m -chparam A_W $w"; done; done
for m in $MULT_ARCHS; do for aa in $ADDER_ARCHS; do for st in 1 2 3; do
    [ "$m" = "0" ] && [ "$st" = "3" ] && continue
    y "$MAC" mac_top "-chparam MULT_ARCH $m -chparam ADDER_ARCH $aa -chparam MAC_STAGES $st"
done; done; done
echo "yosys: $ys_n configurations ok"

# ---- negative tests ------------------------------------------------------------------------------------------
echo "=== NEGATIVE: unimplemented / unsupported values must fail elaboration ==="
neg() {  # label top param-flags files...
    local label=$1 top=$2 par=$3; shift 3
    iverilog -g2001 $par -s $top -o /dev/null "$@" >/dev/null 2>&1 && { echo "ERROR: $label compiled"; rc=1; } || echo "$label: rejected (expected)"
}
neg "adder ARCH=5"       adder_top   -Padder_top.ADDER_ARCH=5                              $ADD
neg "shifter ARCH=2"     alu_shifter -Palu_shifter.SHIFTER_ARCH=2                          $SHF
neg "mul ARCH=3"         mul_top     -Pmul_top.MULT_ARCH=3                                 $MUL
neg "mul_csa ARCH=0"     mul_csa_top -Pmul_csa_top.MULT_ARCH=0                             $MUL
neg "mul_csa ARCH=3"     mul_csa_top -Pmul_csa_top.MULT_ARCH=3                             $MUL
neg "mul A_W=6"          mul_top     -Pmul_top.A_W=6                                       $MUL
neg "mac STAGES=4"       mac_top     -Pmac_top.MAC_STAGES=4                                $MAC
neg "mac M=0 STAGES=3"   mac_top     "-Pmac_top.MAC_STAGES=3 -Pmac_top.MULT_ARCH=0"        $MAC
neg "mac A_W=6"          mac_top     -Pmac_top.A_W=6                                       $MAC

[ $rc -eq 0 ] && echo "ALL OK" || echo "REGRESSION FAILED"
exit $rc

#!/bin/bash
# One-command regression for the RTL written so far.  Usage: bash 2_SIM/run_regress.sh
# Runs: iverilog (-g2001) sim, Verilator lint (-Wall), Yosys read_verilog (plain Verilog-2001).
cd "$(dirname "$0")" || exit 1
RTL=../1_RTL
OUT=${TMPDIR:-/tmp}/proj3_regress
mkdir -p "$OUT"
rc=0

run_sim() {  # name tb param-override rtl-files...
    local name=$1 tb=$2 par=$3; shift 3
    iverilog -g2001 -Wall -Wno-timescale -I$RTL -P"$par" -o "$OUT/$name.vvp" "$tb" "$@" || { echo "COMPILE FAIL: $name"; rc=1; return; }
    vvp "$OUT/$name.vvp" | tee "$OUT/$name.log" | grep -v '^$'
    grep -q "RESULT: PASS" "$OUT/$name.log" || { echo ">>> $name FAILED"; rc=1; }
}

ADD="$RTL/adder_top.v $RTL/adder_beh.v $RTL/adder_rca.v"
SHF="$RTL/alu_shifter.v $RTL/shr_barrel.v"

echo "=== SIM ==="
run_sim adder_beh   TESTBENCH/tb_adder.v   tb_adder.ARCH=4   $ADD
run_sim adder_rca   TESTBENCH/tb_adder.v   tb_adder.ARCH=0   $ADD
run_sim shr_barrel  TESTBENCH/tb_shifter.v tb_shifter.ARCH=1 $SHF

echo "=== LINT (verilator --lint-only -Wall) ==="
verilator --lint-only -Wall --top-module adder_top  $ADD && echo "adder_top: clean"   || rc=1
verilator --lint-only -Wall --top-module alu_shifter $SHF && echo "alu_shifter: clean" || rc=1

echo "=== YOSYS read_verilog ==="
yosys -q -p "read_verilog $ADD; hierarchy -check -top adder_top; read_verilog $SHF; hierarchy -check -top alu_shifter" && echo "yosys: ok" || rc=1

echo "=== NEGATIVE: unimplemented ARCH must fail ==="
iverilog -g2001 -Padder_top.ADDER_ARCH=2 -s adder_top -o /dev/null $ADD 2>&1 | head -2
iverilog -g2001 -Padder_top.ADDER_ARCH=2 -s adder_top -o /dev/null $ADD >/dev/null 2>&1 && { echo "ERROR: ADDER_ARCH=2 compiled"; rc=1; } || echo "adder ARCH=2: rejected (expected)"
iverilog -g2001 -Palu_shifter.SHIFTER_ARCH=0 -s alu_shifter -o /dev/null $SHF >/dev/null 2>&1 && { echo "ERROR: SHIFTER_ARCH=0 compiled"; rc=1; } || echo "shifter ARCH=0: rejected (expected)"

[ $rc -eq 0 ] && echo "ALL OK" || echo "REGRESSION FAILED"
exit $rc

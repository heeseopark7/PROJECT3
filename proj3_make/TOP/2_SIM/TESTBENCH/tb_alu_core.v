`timescale 1ns / 1ps
`include "alu_defs.vh"
// -----------------------------------------------------------------------------
// tb_alu_core : self-checking test of alu_core (V4 V5 V6 V7 V8, plus note examples).
//   XLEN = 8  : exhaustive (all a, b, and all 16 op codes incl. Reserved)
//   XLEN = 16, 32 : 7x7 corner pairs + fixed-seed random pairs, every pair on all 16 op codes.
//                   Random b has random upper bits, so "shamt uses only low bits" is exercised.
//   Reference model is written independently of the DUT formulas (extended-width arithmetic).
//   Every run prints a HASH of all DUT outputs; runs with different ARCH must print the same HASH (V10).
// -----------------------------------------------------------------------------
module alu_core_chk #(
    parameter   XLEN    = 8     ,
    parameter   AARCH   = 4     ,
    parameter   SARCH   = 1     ,
    parameter   EXH     = 1     ,
    parameter   NRAND   = 20000 ,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_hash  ,
    output reg  [15:0]  o_op_seen   ,   // op codes executed (16 = 10 ops + 6 Reserved)
    output reg  [15:0]  o_add_seen  ,   // {z,n,c,v} combos reached by ADD
    output reg  [15:0]  o_sub_seen  ,   // {z,n,c,v} combos reached by SUB
    output reg  [3:0]   o_sra_seen  ,   // bit0 SRA sign0, bit1 SRA sign1
    output reg  [63:0]  o_shamt_seen    // shamt values reached by SLL/SRL/SRA (AND of three)
);

localparam SHAMT_W = (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5);
localparam M = XLEN - 1;

reg  [XLEN-1:0]     a, b;
reg  [3:0]          op;
wire [XLEN-1:0]     res;
wire                fz, fn, fc, fv;

alu_core #(.XLEN(XLEN), .ADDER_ARCH(AARCH), .SHIFTER_ARCH(SARCH)) dut (
    .i_a(a), .i_b(b), .i_alu_op(op),
    .o_result(res), .o_flag_zero(fz), .o_flag_neg(fn), .o_flag_carry(fc), .o_flag_ovf(fv)
);

// expected values
reg  [XLEN-1:0]     e_res;
reg                 e_z, e_n, e_c, e_v;
reg  [XLEN:0]       ext;                // XLEN+1 bit sign-extended arithmetic
reg  [XLEN:0]       ea, eb;
reg  signed [XLEN-1:0] sa;
reg  [SHAMT_W-1:0]  sh;
reg  [63:0]         sh_l, sh_r, sh_a;
integer i, j, k, seed;
reg  [31:0]     rng;                // xorshift32 state (own PRNG: same stimulus in every simulator)
reg  [31:0]     r1, r2, r3;
function [31:0] rnd;            // advances rng and returns the new value
    input unused;               // Verilog-2001 functions need at least one input
    reg [31:0] x;
    begin
        x = rng;
        x = x ^ (x << 13);
        x = x ^ (x >> 17);
        x = x ^ (x << 5);
        rng = x;
        rnd = x;
    end
endfunction

task reference;
    begin
        e_res = 0; e_c = 0; e_v = 0;
        sa = a; sh = b[SHAMT_W-1:0];
        ea = {a[M], a}; eb = {b[M], b};
        case (op)
            `ALU_ADD: begin
                ext = ea + eb;
                e_res = ext[M:0];
                e_c = ({1'b0, a} + {1'b0, b}) >> XLEN;
                e_v = (ext[XLEN] != ext[XLEN-1]);
            end
            `ALU_SUB: begin
                ext = ea - eb;
                e_res = ext[M:0];
                e_c = (a >= b);                 // no borrow
                e_v = (ext[XLEN] != ext[XLEN-1]);
            end
            `ALU_SLT: begin
                ext = ea - eb;
                e_res = ($signed(a) < $signed(b)) ? 1 : 0;
                e_c = (a >= b);
                e_v = (ext[XLEN] != ext[XLEN-1]);
            end
            `ALU_SLTU: begin
                ext = ea - eb;
                e_res = (a < b) ? 1 : 0;
                e_c = (a >= b);
                e_v = (ext[XLEN] != ext[XLEN-1]);
            end
            `ALU_SLL: e_res = a << sh;
            `ALU_SRL: e_res = a >> sh;
            `ALU_SRA: e_res = sa >>> sh;
            `ALU_XOR: e_res = a ^ b;
            `ALU_OR:  e_res = a | b;
            `ALU_AND: e_res = a & b;
            default:  e_res = 0;                // Reserved
        endcase
        e_z = (e_res == 0);
        e_n = e_res[M];
    end
endtask

task check;
    input [XLEN-1:0] ta, tb;
    input [3:0]      top;
    reg [3:0] idx;
    begin
        a = ta; b = tb; op = top;
        #1;
        reference;
        if ({res, fz, fn, fc, fv} !== {e_res, e_z, e_n, e_c, e_v}) begin
            o_fail = o_fail + 1;
            if (o_fail < 20)
                $display("FAIL alu_core XLEN=%0d AARCH=%0d SARCH=%0d op=%b a=%h b=%h | exp res=%h znc v=%b%b%b%b | got res=%h %b%b%b%b",
                         XLEN, AARCH, SARCH, top, ta, tb, e_res, e_z, e_n, e_c, e_v, res, fz, fn, fc, fv);
        end else
            o_pass = o_pass + 1;
        o_hash = {o_hash[30:0], o_hash[31]} ^ {{(32-XLEN){1'b0}}, res} ^ {fz, fn, fc, fv, 28'd0};
        // reach counters (based on the expected, i.e. stimulus-defined, values)
        o_op_seen[top] = 1'b1;
        idx = {e_z, e_n, e_c, e_v};
        if (top == `ALU_ADD) o_add_seen[idx] = 1'b1;
        if (top == `ALU_SUB) o_sub_seen[idx] = 1'b1;
        if (top == `ALU_SRA) o_sra_seen[ta[M]] = 1'b1;
        if (top == `ALU_SLL) sh_l[b[SHAMT_W-1:0]] = 1'b1;
        if (top == `ALU_SRL) sh_r[b[SHAMT_W-1:0]] = 1'b1;
        if (top == `ALU_SRA) sh_a[b[SHAMT_W-1:0]] = 1'b1;
    end
endtask

task all_ops;
    input [XLEN-1:0] ta, tb;
    integer o;
    begin
        for (o = 0; o < 16; o = o + 1) check(ta, tb, o[3:0]);
    end
endtask

// literal check (values from the design note, XLEN = 32 only)
task lit;
    input [31:0] ta, tb;
    input [3:0]  top;
    input        z, n, c, v;
    input [31:0] r;
    begin
        a = ta; b = tb; op = top;
        #1;
        if ({res, fz, fn, fc, fv} !== {r, z, n, c, v}) begin
            o_fail = o_fail + 1;
            $display("FAIL note example op=%b a=%h b=%h | exp res=%h %b%b%b%b | got res=%h %b%b%b%b",
                     top, ta, tb, r, z, n, c, v, res, fz, fn, fc, fv);
        end else
            o_pass = o_pass + 1;
    end
endtask

reg [XLEN-1:0] corner [0:6];
reg [63:0]     full;

initial begin
    o_done = 0; o_pass = 0; o_fail = 0; o_hash = 32'h1234_5678;
    o_op_seen = 0; o_add_seen = 0; o_sub_seen = 0; o_sra_seen = 0; o_shamt_seen = 0;
    sh_l = 0; sh_r = 0; sh_a = 0;
    rng = 32'h2545F491 ^ (SEED * 32'h9E3779B1); if (rng == 32'd0) rng = 32'd1;
    full = (64'd1 << XLEN) - 64'd1;
    if (XLEN == 32) begin   // note examples first
        lit(32'hFFFFFFFF, 32'h00000001, `ALU_ADD,  1'b1, 1'b0, 1'b1, 1'b0, 32'h00000000);
        lit(32'h7FFFFFFF, 32'h00000001, `ALU_ADD,  1'b0, 1'b1, 1'b0, 1'b1, 32'h80000000);
        lit(32'h00000000, 32'h00000001, `ALU_SUB,  1'b0, 1'b1, 1'b0, 1'b0, 32'hFFFFFFFF);
        lit(32'h80000000, 32'h00000001, `ALU_SUB,  1'b0, 1'b0, 1'b1, 1'b1, 32'h7FFFFFFF);
        lit(32'h80000000, 32'h00000001, `ALU_SLT,  1'b0, 1'b0, 1'b1, 1'b1, 32'h00000001);
        lit(32'h80000000, 32'h00000001, `ALU_SLTU, 1'b1, 1'b0, 1'b1, 1'b1, 32'h00000000);
        lit(32'h80000000, 32'h00000004, `ALU_SRA,  1'b0, 1'b1, 1'b0, 1'b0, 32'hF8000000);
        lit(32'h00000001, 32'h00000025, `ALU_SLL,  1'b0, 1'b0, 1'b0, 1'b0, 32'h00000020);
    end
    if (EXH != 0) begin
        for (i = 0; i < (1 << XLEN); i = i + 1)
            for (j = 0; j < (1 << XLEN); j = j + 1)
                all_ops(i[XLEN-1:0], j[XLEN-1:0]);
    end else begin
        corner[0] = 0;
        corner[1] = 1;
        corner[2] = {XLEN{1'b1}};
        corner[3] = {1'b0, {(XLEN-1){1'b1}}};
        corner[4] = {1'b1, {(XLEN-1){1'b0}}};
        corner[5] = {(XLEN/2){2'b01}};
        corner[6] = {(XLEN/2){2'b10}};
        for (i = 0; i < 7; i = i + 1)
            for (j = 0; j < 7; j = j + 1)
                all_ops(corner[i], corner[j]);
        for (k = 0; k < NRAND; k = k + 1)
            begin r1 = rnd(1'b0); r2 = rnd(1'b0); all_ops(r1, r2); end
        // every shamt, random upper bits of b, both a signs
        for (k = 0; k < (1 << SHAMT_W); k = k + 1) begin
            r1 = rnd(1'b0); r2 = rnd(1'b0);
            all_ops({1'b1, {(XLEN-1){1'b0}}} | r1, (r2 << SHAMT_W) | k);
            r1 = rnd(1'b0); r2 = rnd(1'b0);
            all_ops({1'b0, {(XLEN-1){1'b1}}} & r1, (r2 << SHAMT_W) | k);
        end
    end
    o_shamt_seen = (sh_l & sh_r & sh_a);
    o_done = 1;
end
endmodule

module tb_alu_core;
parameter AARCH = 4;
parameter SARCH = 1;
parameter NR    = 20000;        // random pairs for XLEN = 16, 32 (each applied to all 16 op codes)
parameter EXH8  = 1;            // 1: XLEN = 8 exhaustive; 0: corners + random (small 4-state runs)

wire        d8, d16, d32;
wire [31:0] p8, p16, p32, f8, f16, f32, h8, h16, h32;
wire [15:0] os8, os16, os32, as8, as16, as32, ss8, ss16, ss32;
wire [3:0]  sra8, sra16, sra32;
wire [63:0] sh8, sh16, sh32;

alu_core_chk #(.XLEN(8 ), .AARCH(AARCH), .SARCH(SARCH), .EXH(EXH8), .NRAND(NR))               u8  (d8 , p8 , f8 , h8 , os8 , as8 , ss8 , sra8 , sh8 );
alu_core_chk #(.XLEN(16), .AARCH(AARCH), .SARCH(SARCH), .EXH(0), .NRAND(NR), .SEED(2))     u16 (d16, p16, f16, h16, os16, as16, ss16, sra16, sh16);
alu_core_chk #(.XLEN(32), .AARCH(AARCH), .SARCH(SARCH), .EXH(0), .NRAND(NR), .SEED(3))     u32 (d32, p32, f32, h32, os32, as32, ss32, sra32, sh32);

// Reachable {z,n,c,v} combos, index = z*8 + n*4 + c*2 + v (derived by hand, see docs/module_notes/alu_core.md)
//   ADD: 9 combos -> bits 0,2,3,4,5,6,8,10,11      SUB: 7 combos -> bits 0,2,3,4,5,6,10
localparam [15:0] ADD_REACH = 16'h0D7D;
localparam [15:0] SUB_REACH = 16'h047D;

wire [31:0] pass = p8 + p16 + p32;
wire [31:0] fail = f8 + f16 + f32;

function ok_cov;
    input [15:0] os, as, ss;
    input [3:0]  sra;
    input [63:0] sh;
    input integer xlen;
    begin
        ok_cov = (os == 16'hFFFF) && (as == ADD_REACH) && (ss == SUB_REACH) && (sra[1:0] == 2'b11)
                 && (sh == ((64'd1 << xlen) - 64'd1));
    end
endfunction

initial begin
    wait (d8 && d16 && d32);
    $display("tb_alu_core ADDER_ARCH=%0d SHIFTER_ARCH=%0d seeds=1,2,3 : PASS=%0d FAIL=%0d", AARCH, SARCH, pass, fail);
    $display("HASH %h %h %h", h8, h16, h32);
    $display("coverage ops=%h/%h/%h add=%h/%h/%h sub=%h/%h/%h sra=%b/%b/%b",
             os8, os16, os32, as8, as16, as32, ss8, ss16, ss32, sra8[1:0], sra16[1:0], sra32[1:0]);
    if (fail == 0 && ok_cov(os8, as8, ss8, sra8, sh8, 8) && ok_cov(os16, as16, ss16, sra16, sh16, 16)
                  && ok_cov(os32, as32, ss32, sra32, sh32, 32))
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

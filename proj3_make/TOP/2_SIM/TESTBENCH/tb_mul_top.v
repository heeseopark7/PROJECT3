`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_mul_top : self-checking test of mul_top (M1, M2). One testbench for every MULT_ARCH.
//   A_W = 4, 8 : exhaustive (all a, b)                     -> M1 (and A_W=4 for M7)
//   A_W = 16   : corners (incl. (-32768)*(-32768)) + 1,000,000 fixed-seed random pairs -> M2
//   Expected value is computed here with a signed '*', compared with '!=='.
//   The HASH of all products must be identical for every MULT_ARCH.
// -----------------------------------------------------------------------------
module mul_chk #(
    parameter   A_W     = 8         ,
    parameter   ARCH    = 0         ,
    parameter   AARCH   = 4         ,   // ADDER_ARCH of the final addition (structured multipliers)
    parameter   EXH     = 1         ,
    parameter   NRAND   = 1000000   ,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_hash  ,
    output reg  [4:0]   o_cov       // bit0 pos*pos, bit1 neg*neg, bit2 pos*neg or neg*pos, bit3 zero operand, bit4 (min)*(min)
);

reg  signed [A_W-1:0]       a, b;
wire signed [2*A_W-1:0]     p;
reg  signed [2*A_W-1:0]     exp;
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

mul_top #(.A_W(A_W), .MULT_ARCH(ARCH), .ADDER_ARCH(AARCH)) dut (.i_a(a), .i_b(b), .o_p(p));

task check;
    input signed [A_W-1:0] ta, tb;
    begin
        a = ta; b = tb;
        #1;
        exp = ta * tb;
        if (p !== exp) begin
            o_fail = o_fail + 1;
            if (o_fail < 20)
                $display("FAIL mul A_W=%0d ARCH=%0d a=%0d b=%0d exp=%0d got=%0d", A_W, ARCH, ta, tb, exp, p);
        end else begin
            o_pass = o_pass + 1;
            o_hash = {o_hash[30:0], o_hash[31]} ^ {{(32-2*A_W){1'b0}}, p} ^ (p >>> 16);
        end
        if (ta > 0 && tb > 0) o_cov[0] = 1;
        if (ta < 0 && tb < 0) o_cov[1] = 1;
        if ((ta > 0 && tb < 0) || (ta < 0 && tb > 0)) o_cov[2] = 1;
        if (ta == 0 || tb == 0) o_cov[3] = 1;
        if (ta == {1'b1, {(A_W-1){1'b0}}} && tb == {1'b1, {(A_W-1){1'b0}}}) o_cov[4] = 1;
    end
endtask

reg signed [A_W-1:0] corner [0:6];

initial begin
    o_done = 0; o_pass = 0; o_fail = 0; o_hash = 32'h1234_5678; o_cov = 0;
    rng = 32'h2545F491 ^ (SEED * 32'h9E3779B1); if (rng == 32'd0) rng = 32'd1;
    if (EXH != 0) begin
        for (i = -(1 << (A_W-1)); i < (1 << (A_W-1)); i = i + 1)
            for (j = -(1 << (A_W-1)); j < (1 << (A_W-1)); j = j + 1)
                check(i[A_W-1:0], j[A_W-1:0]);
    end else begin
        corner[0] = 0;
        corner[1] = 1;
        corner[2] = -1;
        corner[3] = {1'b1, {(A_W-1){1'b0}}};            // most negative
        corner[4] = {1'b0, {(A_W-1){1'b1}}};            // most positive
        corner[5] = {1'b1, {(A_W-2){1'b0}}, 1'b1};      // most negative + 1
        corner[6] = {(A_W/2){2'b10}};
        for (i = 0; i < 7; i = i + 1)
            for (j = 0; j < 7; j = j + 1)
                check(corner[i], corner[j]);
        for (k = 0; k < NRAND; k = k + 1)
            begin r1 = rnd(1'b0); r2 = rnd(1'b0); check(r1, r2); end
    end
    o_done = 1;
end
endmodule

module tb_mul_top;
parameter ARCH  = 0;
parameter AARCH = 4;
parameter EXH8  = 1;            // 1: A_W = 8 exhaustive (65,536 pairs); 0: corners + random (small 4-state runs)
parameter NR16  = 1000000;      // random pairs for A_W = 16 (M2: 1,000,000)
wire        d4, d8, d16;
wire [31:0] p4, p8, p16, f4, f8, f16, h4, h8, h16;
wire [4:0]  c4, c8, c16;

mul_chk #(.A_W(4 ), .ARCH(ARCH), .AARCH(AARCH), .EXH(1))                          u4  (d4 , p4 , f4 , h4 , c4 );
mul_chk #(.A_W(8 ), .ARCH(ARCH), .AARCH(AARCH), .EXH(EXH8), .NRAND(NR16))                          u8  (d8 , p8 , f8 , h8 , c8 );
mul_chk #(.A_W(16), .ARCH(ARCH), .AARCH(AARCH), .EXH(0), .NRAND(NR16), .SEED(2))  u16 (d16, p16, f16, h16, c16);

wire [31:0] pass = p4 + p8 + p16;
wire [31:0] fail = f4 + f8 + f16;

initial begin
    wait (d4 && d8 && d16);
    $display("tb_mul_top MULT_ARCH=%0d ADDER_ARCH=%0d random(A_W=16)=%0d seed=2 : PASS=%0d FAIL=%0d", ARCH, AARCH, NR16, pass, fail);
    $display("HASH %h %h %h", h4, h8, h16);
    $display("coverage (min*min zero pos*neg neg*neg pos*pos) A_W4=%b A_W8=%b A_W16=%b", c4, c8, c16);
    if (fail == 0 && c4 == 5'h1F && c8 == 5'h1F && c16 == 5'h1F)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

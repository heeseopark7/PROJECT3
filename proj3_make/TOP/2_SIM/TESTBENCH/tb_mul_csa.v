`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_mul_csa : self-checking test of the carry-save multipliers (mul_csa_top), BEFORE the final adder.
//   Contract under test:  o_s + o_c == i_a * i_b  (mod 2**(2*A_W)).
//   A_W = 4, 8 : exhaustive.   A_W = 16 : corners (incl. (-32768)*(-32768)) + fixed-seed random.
//   The sum/carry split itself is not unique, so only the sum o_s + o_c is checked (as the contract says).
//   Expected value is computed here with a signed '*'; the sum of the two vectors with '+'.
//   Lower-level test: if tb_mul fails for a structured multiplier, look here first.
// -----------------------------------------------------------------------------
module csa_chk #(
    parameter   A_W     = 8     ,
    parameter   ARCH    = 1     ,
    parameter   EXH     = 1     ,
    parameter   NRAND   = 200000,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [4:0]   o_cov       // bit0 pos*pos, bit1 neg*neg, bit2 mixed sign, bit3 zero operand, bit4 min*min
);

reg  signed [A_W-1:0]       a, b;
wire        [2*A_W-1:0]     s, c;
reg         [2*A_W-1:0]     exp, tot;
integer i, j, k, seed;

mul_csa_top #(.A_W(A_W), .MULT_ARCH(ARCH)) dut (.i_a(a), .i_b(b), .o_s(s), .o_c(c));

task check;
    input signed [A_W-1:0] ta, tb;
    begin
        a = ta; b = tb;
        #1;
        exp = ta * tb;
        tot = s + c;
        if (tot !== exp || ^{s, c} === 1'bx) begin
            o_fail = o_fail + 1;
            if (o_fail < 20)
                $display("FAIL mul_csa A_W=%0d ARCH=%0d a=%0d b=%0d s=%h c=%h s+c=%h exp=%h", A_W, ARCH, ta, tb, s, c, tot, exp);
        end else
            o_pass = o_pass + 1;
        if (ta > 0 && tb > 0) o_cov[0] = 1;
        if (ta < 0 && tb < 0) o_cov[1] = 1;
        if ((ta > 0 && tb < 0) || (ta < 0 && tb > 0)) o_cov[2] = 1;
        if (ta == 0 || tb == 0) o_cov[3] = 1;
        if (ta == {1'b1, {(A_W-1){1'b0}}} && tb == {1'b1, {(A_W-1){1'b0}}}) o_cov[4] = 1;
    end
endtask

reg signed [A_W-1:0] corner [0:6];

initial begin
    o_done = 0; o_pass = 0; o_fail = 0; o_cov = 0;
    seed = SEED;
    if (EXH != 0) begin
        for (i = -(1 << (A_W-1)); i < (1 << (A_W-1)); i = i + 1)
            for (j = -(1 << (A_W-1)); j < (1 << (A_W-1)); j = j + 1)
                check(i[A_W-1:0], j[A_W-1:0]);
    end else begin
        corner[0] = 0;
        corner[1] = 1;
        corner[2] = -1;
        corner[3] = {1'b1, {(A_W-1){1'b0}}};
        corner[4] = {1'b0, {(A_W-1){1'b1}}};
        corner[5] = {1'b1, {(A_W-2){1'b0}}, 1'b1};
        corner[6] = {(A_W/2){2'b10}};
        for (i = 0; i < 7; i = i + 1)
            for (j = 0; j < 7; j = j + 1)
                check(corner[i], corner[j]);
        for (k = 0; k < NRAND; k = k + 1)
            check($random(seed), $random(seed));
    end
    o_done = 1;
end
endmodule

module tb_mul_csa;
parameter ARCH  = 1;
parameter NR16  = 200000;
wire        d4, d8, d16;
wire [31:0] p4, p8, p16, f4, f8, f16;
wire [4:0]  c4, c8, c16;

csa_chk #(.A_W(4 ), .ARCH(ARCH), .EXH(1))                          u4  (d4 , p4 , f4 , c4 );
csa_chk #(.A_W(8 ), .ARCH(ARCH), .EXH(1))                          u8  (d8 , p8 , f8 , c8 );
csa_chk #(.A_W(16), .ARCH(ARCH), .EXH(0), .NRAND(NR16), .SEED(2))  u16 (d16, p16, f16, c16);

wire [31:0] pass = p4 + p8 + p16;
wire [31:0] fail = f4 + f8 + f16;

initial begin
    wait (d4 && d8 && d16);
    $display("tb_mul_csa MULT_ARCH=%0d random(A_W=16)=%0d seed=2 : PASS=%0d FAIL=%0d", ARCH, NR16, pass, fail);
    $display("coverage (min*min zero mixed neg*neg pos*pos) A_W4=%b A_W8=%b A_W16=%b", c4, c8, c16);
    if (fail == 0 && c4 == 5'h1F && c8 == 5'h1F && c16 == 5'h1F)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

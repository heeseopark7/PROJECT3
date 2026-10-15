`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_adder : self-checking test of adder_top (V1). One testbench for every ADDER_ARCH.
//   W = 8  : exhaustive (all a, b, cin)
//   W = 16, 32 : corner cases + fixed-seed random
//   Expected value is computed here with '+', compared with '!=='.
// -----------------------------------------------------------------------------
module adder_chk #(
    parameter   W       = 8     ,
    parameter   ARCH    = 4     ,
    parameter   EXH     = 1     ,
    parameter   NRAND   = 20000 ,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_cov   // bit0 cout=0, bit1 cout=1, bit2 cin=0, bit3 cin=1
);

reg  [W-1:0]    a, b;
reg             cin;
wire [W-1:0]    sum;
wire            cout;
reg  [W:0]      exp;
integer         i, j, k, seed;

adder_top #(.W(W), .ADDER_ARCH(ARCH)) dut (
    .i_a(a), .i_b(b), .i_cin(cin), .o_sum(sum), .o_cout(cout)
);

task check;
    input [W-1:0] ta, tb;
    input         tc;
    begin
        a = ta; b = tb; cin = tc;
        #1;
        exp = {1'b0, ta} + {1'b0, tb} + {{W{1'b0}}, tc};
        if ({cout, sum} !== exp) begin
            o_fail = o_fail + 1;
            $display("FAIL adder W=%0d ARCH=%0d a=%h b=%h cin=%b exp=%h got=%h",
                     W, ARCH, ta, tb, tc, exp, {cout, sum});
        end else
            o_pass = o_pass + 1;
        o_cov[0] = o_cov[0] | (exp[W] == 1'b0);
        o_cov[1] = o_cov[1] | (exp[W] == 1'b1);
        o_cov[2] = o_cov[2] | (tc == 1'b0);
        o_cov[3] = o_cov[3] | (tc == 1'b1);
    end
endtask

reg [W-1:0] corner [0:5];

initial begin
    o_done = 0; o_pass = 0; o_fail = 0; o_cov = 0;
    seed = SEED;
    corner[0] = 0;
    corner[1] = {W{1'b1}};
    corner[2] = {1'b1, {(W-1){1'b0}}};
    corner[3] = {1'b0, {(W-1){1'b1}}};
    corner[4] = 1;
    corner[5] = {(W/2){2'b10}};
    if (EXH != 0) begin
        for (i = 0; i < (1 << W); i = i + 1)
            for (j = 0; j < (1 << W); j = j + 1) begin
                check(i[W-1:0], j[W-1:0], 1'b0);
                check(i[W-1:0], j[W-1:0], 1'b1);
            end
    end else begin
        for (i = 0; i < 6; i = i + 1)
            for (j = 0; j < 6; j = j + 1) begin
                check(corner[i], corner[j], 1'b0);
                check(corner[i], corner[j], 1'b1);
            end
        for (k = 0; k < NRAND; k = k + 1)
            check($random(seed), $random(seed), $random(seed));
    end
    o_done = 1;
end
endmodule

module tb_adder;
parameter ARCH = 4;
wire        d8, d16, d32;
wire [31:0] p8, p16, p32, f8, f16, f32, c8, c16, c32;

adder_chk #(.W(8 ), .ARCH(ARCH), .EXH(1)) u8  (.o_done(d8 ), .o_pass(p8 ), .o_fail(f8 ), .o_cov(c8 ));
adder_chk #(.W(16), .ARCH(ARCH), .EXH(0), .SEED(2)) u16 (.o_done(d16), .o_pass(p16), .o_fail(f16), .o_cov(c16));
adder_chk #(.W(32), .ARCH(ARCH), .EXH(0), .SEED(3)) u32 (.o_done(d32), .o_pass(p32), .o_fail(f32), .o_cov(c32));

wire [31:0] pass = p8 + p16 + p32;
wire [31:0] fail = f8 + f16 + f32;

initial begin
    wait (d8 && d16 && d32);
    $display("tb_adder ADDER_ARCH=%0d seeds=1,2,3 : PASS=%0d FAIL=%0d", ARCH, pass, fail);
    $display("coverage (cout0 cout1 cin0 cin1) W8=%b W16=%b W32=%b", c8[3:0], c16[3:0], c32[3:0]);
    if (fail == 0 && c8[3:0] == 4'hF && c16[3:0] == 4'hF && c32[3:0] == 4'hF)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

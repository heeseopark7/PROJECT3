`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_shifter : self-checking test of alu_shifter. One testbench for every SHIFTER_ARCH.
//   XLEN = 8  : exhaustive data x all shamt x {SLL, SRL, SRA}
//   XLEN = 16, 32 : corner data + fixed-seed random data x all shamt x 3 ops
//   Expected value uses the language shift operators (reference model only).
// -----------------------------------------------------------------------------
module shifter_chk #(
    parameter   XLEN    = 8     ,
    parameter   ARCH    = 1     ,
    parameter   NRAND   = 2000  ,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_cov   // bit0 SLL, bit1 SRL, bit2 SRA sign0, bit3 SRA sign1, bit4 all shamt seen
);

localparam SHAMT_W = (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5);

reg  [XLEN-1:0]         din;
reg  [SHAMT_W-1:0]      shamt;
reg                     right, arith;
wire [XLEN-1:0]         dout;
reg  [XLEN-1:0]         exp;
reg  signed [XLEN-1:0]  sdin;
reg  [63:0]             seen_l, seen_r, seen_a;
integer                 i, j, k, seed;

alu_shifter #(.XLEN(XLEN), .SHIFTER_ARCH(ARCH)) dut (
    .i_din(din), .i_shamt(shamt), .i_right(right), .i_arith(arith), .o_dout(dout)
);

// op: 0 SLL, 1 SRL, 2 SRA
task check;
    input [XLEN-1:0]    td;
    input [1:0]         op;
    input [SHAMT_W-1:0] ts;
    begin
        din = td; shamt = ts;
        right = (op != 2'd0);
        arith = (op == 2'd2);
        sdin  = td;
        #1;
        case (op)
            2'd0:    exp = td << ts;
            2'd1:    exp = td >> ts;
            default: exp = sdin >>> ts;
        endcase
        if (dout !== exp) begin
            o_fail = o_fail + 1;
            $display("FAIL shifter XLEN=%0d ARCH=%0d op=%0d din=%h shamt=%0d exp=%h got=%h",
                     XLEN, ARCH, op, td, ts, exp, dout);
        end else
            o_pass = o_pass + 1;
        case (op)
            2'd0: begin o_cov[0] = 1; seen_l[ts] = 1; end
            2'd1: begin o_cov[1] = 1; seen_r[ts] = 1; end
            default: begin
                if (td[XLEN-1]) o_cov[3] = 1; else o_cov[2] = 1;
                seen_a[ts] = 1;
            end
        endcase
    end
endtask

task all_ops;
    input [XLEN-1:0] td;
    integer s, o;
    begin
        for (o = 0; o < 3; o = o + 1)
            for (s = 0; s < XLEN; s = s + 1)
                check(td, o[1:0], s[SHAMT_W-1:0]);
    end
endtask

reg [63:0] full;

initial begin
    o_done = 0; o_pass = 0; o_fail = 0; o_cov = 0;
    seen_l = 0; seen_r = 0; seen_a = 0;
    seed = SEED;
    full = (64'd1 << XLEN) - 64'd1;
    if (XLEN == 8) begin
        for (i = 0; i < 256; i = i + 1) all_ops(i[XLEN-1:0]);
    end else begin
        all_ops({XLEN{1'b0}});
        all_ops({XLEN{1'b1}});
        all_ops({1'b1, {(XLEN-1){1'b0}}});
        all_ops({1'b0, {(XLEN-1){1'b1}}});
        all_ops({{(XLEN-1){1'b0}}, 1'b1});
        all_ops({(XLEN/2){2'b10}});
        all_ops({(XLEN/2){2'b01}});
        for (k = 0; k < NRAND; k = k + 1) all_ops($random(seed));
    end
    o_cov[4] = (seen_l == full) && (seen_r == full) && (seen_a == full);
    o_done = 1;
end
endmodule

module tb_shifter;
parameter ARCH = 1;
wire        d8, d16, d32;
wire [31:0] p8, p16, p32, f8, f16, f32, c8, c16, c32;

shifter_chk #(.XLEN(8 ), .ARCH(ARCH))             u8  (.o_done(d8 ), .o_pass(p8 ), .o_fail(f8 ), .o_cov(c8 ));
shifter_chk #(.XLEN(16), .ARCH(ARCH), .SEED(2))   u16 (.o_done(d16), .o_pass(p16), .o_fail(f16), .o_cov(c16));
shifter_chk #(.XLEN(32), .ARCH(ARCH), .SEED(3))   u32 (.o_done(d32), .o_pass(p32), .o_fail(f32), .o_cov(c32));

wire [31:0] pass = p8 + p16 + p32;
wire [31:0] fail = f8 + f16 + f32;

initial begin
    wait (d8 && d16 && d32);
    $display("tb_shifter SHIFTER_ARCH=%0d seeds=1,2,3 : PASS=%0d FAIL=%0d", ARCH, pass, fail);
    $display("coverage (all_shamt SRAsign1 SRAsign0 SRL SLL) XLEN8=%b XLEN16=%b XLEN32=%b",
             c8[4:0], c16[4:0], c32[4:0]);
    if (fail == 0 && c8[4:0] == 5'h1F && c16[4:0] == 5'h1F && c32[4:0] == 5'h1F)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

`timescale 1ns / 1ps
`include "alu_defs.vh"
// -----------------------------------------------------------------------------
// tb_alu_top : self-checking test of alu_top (V9). One testbench for every ARCH combination.
//   1. Reset check    : o_valid = 0 while i_rst_n = 0 even with i_valid = 1 (async, checked mid-cycle).
//   2. Latency check  : one valid input -> o_valid = 0 after edge 1, o_valid = 1 + correct result after edge 2.
//   3. Random stream  : valid gaps, back-to-back valid, all 16 op codes, random async reset in mid-cycle.
//                       A cycle-accurate model (2 pipeline stages) is compared EVERY cycle:
//                       o_valid must match; result/flags are compared only when o_valid = 1 (don't care otherwise).
//   Reference ALU result uses extended-width arithmetic, written independently of the DUT.
//   Prints a HASH of all valid outputs; runs with different ARCH must print the same HASH (V10).
// -----------------------------------------------------------------------------
module alu_top_chk #(
    parameter   XLEN    = 8     ,
    parameter   AARCH   = 4     ,
    parameter   SARCH   = 1     ,
    parameter   NCYC    = 20000 ,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_hash  ,
    output reg  [15:0]  o_op_seen   ,
    output reg  [31:0]  o_gaps      ,   // valid=0 cycles that followed a valid=1 cycle
    output reg  [31:0]  o_b2b       ,   // back-to-back valid results at the output
    output reg  [31:0]  o_resets    ,   // mid-run async resets
    output reg  [31:0]  o_flush     ,   // in-flight results discarded by a reset
    output reg          o_lat_ok        // directed 2-edge latency check passed
);

localparam SHAMT_W = (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5);
localparam M = XLEN - 1;

reg                 clk, rst_n, vin;
reg  [XLEN-1:0]     a, b;
reg  [3:0]          op;
wire                vout, fz, fn, fc, fv;
wire [XLEN-1:0]     res;

alu_top #(.XLEN(XLEN), .ADDER_ARCH(AARCH), .SHIFTER_ARCH(SARCH)) dut (
    .i_clk(clk), .i_rst_n(rst_n), .i_valid(vin), .i_a(a), .i_b(b), .i_alu_op(op),
    .o_valid(vout), .o_result(res),
    .o_flag_zero(fz), .o_flag_neg(fn), .o_flag_carry(fc), .o_flag_ovf(fv)
);

always #5 clk = ~clk;

// ---- reference ALU ---------------------------------------------------------
reg  [XLEN-1:0]        r_res;
reg                    r_z, r_n, r_c, r_v;
reg  [XLEN:0]          ext, ea, eb;
reg  signed [XLEN-1:0] sa;
reg  [SHAMT_W-1:0]     sh;

task reference;
    input [XLEN-1:0] ra, rb;
    input [3:0]      rop;
    begin
        r_res = 0; r_c = 0; r_v = 0;
        sa = ra; sh = rb[SHAMT_W-1:0];
        ea = {ra[M], ra}; eb = {rb[M], rb};
        case (rop)
            `ALU_ADD: begin ext = ea + eb; r_res = ext[M:0]; r_c = ({1'b0, ra} + {1'b0, rb}) >> XLEN; r_v = (ext[XLEN] != ext[XLEN-1]); end
            `ALU_SUB: begin ext = ea - eb; r_res = ext[M:0]; r_c = (ra >= rb); r_v = (ext[XLEN] != ext[XLEN-1]); end
            `ALU_SLT: begin ext = ea - eb; r_res = ($signed(ra) < $signed(rb)) ? 1 : 0; r_c = (ra >= rb); r_v = (ext[XLEN] != ext[XLEN-1]); end
            `ALU_SLTU: begin ext = ea - eb; r_res = (ra < rb) ? 1 : 0; r_c = (ra >= rb); r_v = (ext[XLEN] != ext[XLEN-1]); end
            `ALU_SLL: r_res = ra << sh;
            `ALU_SRL: r_res = ra >> sh;
            `ALU_SRA: r_res = sa >>> sh;
            `ALU_XOR: r_res = ra ^ rb;
            `ALU_OR:  r_res = ra | rb;
            `ALU_AND: r_res = ra & rb;
            default:  r_res = 0;
        endcase
        r_z = (r_res == 0);
        r_n = r_res[M];
    end
endtask

// ---- cycle-accurate model: stage1 = input regs, stage2 = output regs ---------
reg                 s1v, s2v;
reg  [XLEN-1:0]     s1a, s1b;
reg  [3:0]          s1op;
reg  [XLEN-1:0]     s2res;
reg  [3:0]          s2flag;         // {z, n, c, v}
reg  [3:0]          s2op;           // op that produced the stage-2 value (op coverage)
reg                 prev_vin, prev_s2v;
integer             cyc, rst_cnt, seed, k;
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

task clear_model;
    begin
        if (s2v) o_flush = o_flush + 1;
        s1v = 0; s2v = 0;
    end
endtask

task step_model;    // called right after a posedge, using the values driven before it
    begin
        s2v = s1v;
        if (s1v) begin
            reference(s1a, s1b, s1op);
            s2res = r_res; s2flag = {r_z, r_n, r_c, r_v};
        end
        s1v = vin; s1a = a; s1b = b; s1op = op;
    end
endtask

task compare;
    begin
        if (vout !== s2v) begin
            o_fail = o_fail + 1;
            if (o_fail < 20) $display("FAIL alu_top XLEN=%0d cyc=%0d o_valid exp=%b got=%b", XLEN, cyc, s2v, vout);
        end else if (s2v) begin
            if ({res, fz, fn, fc, fv} !== {s2res, s2flag}) begin
                o_fail = o_fail + 1;
                if (o_fail < 20)
                    $display("FAIL alu_top XLEN=%0d AARCH=%0d SARCH=%0d cyc=%0d | exp res=%h znc v=%b | got res=%h %b%b%b%b",
                             XLEN, AARCH, SARCH, cyc, s2res, s2flag, res, fz, fn, fc, fv);
            end else begin
                o_pass = o_pass + 1;
                o_hash = {o_hash[30:0], o_hash[31]} ^ {{(32-XLEN){1'b0}}, res} ^ {fz, fn, fc, fv, 28'd0};
                o_op_seen[s2op] = 1'b1;
                if (prev_s2v) o_b2b = o_b2b + 1;
            end
        end else
            o_pass = o_pass + 1;    // o_valid = 0 and expected 0
        prev_s2v = s2v;
    end
endtask

task drive_random;
    begin
        r1 = rnd(1'b0); a  = r1;
        r1 = rnd(1'b0); b  = r1;
        r1 = rnd(1'b0); op = r1[3:0];
        r1 = rnd(1'b0); vin = ((r1 & 3) != 0);  // 75% valid -> gaps and bursts
        if (prev_vin && !vin) o_gaps = o_gaps + 1;
        prev_vin = vin;
    end
endtask

initial begin
    clk = 0; rst_n = 1; vin = 0; a = 0; b = 0; op = 0;
    o_done = 0; o_pass = 0; o_fail = 0; o_hash = 32'h1234_5678; o_op_seen = 0;
    o_gaps = 0; o_b2b = 0; o_resets = 0; o_flush = 0; o_lat_ok = 0;
    s1v = 0; s2v = 0; s1a = 0; s1b = 0; s1op = 0; s2res = 0; s2flag = 0; s2op = 0;
    prev_vin = 0; prev_s2v = 0; rst_cnt = 0; cyc = 0;
    rng = 32'h2545F491 ^ (SEED * 32'h9E3779B1); if (rng == 32'd0) rng = 32'd1;

    // ---- 1. reset with valid input held high ------------------------------
    #1 rst_n = 0; vin = 1; a = 1; b = 2; op = `ALU_ADD;
    #1 if (vout !== 1'b0) begin o_fail = o_fail + 1; $display("FAIL alu_top XLEN=%0d o_valid not 0 right after reset assert", XLEN); end else o_pass = o_pass + 1;
    for (k = 0; k < 3; k = k + 1) begin
        @(posedge clk); #1;
        if (vout !== 1'b0) begin o_fail = o_fail + 1; $display("FAIL alu_top XLEN=%0d o_valid != 0 during reset", XLEN); end else o_pass = o_pass + 1;
    end
    @(negedge clk); rst_n = 1; vin = 0;         // synchronous release

    // ---- 2. directed 2-edge latency ----------------------------------------
    @(negedge clk); vin = 1; a = 5; b = 7; op = `ALU_ADD;       // captured at the next posedge (edge 1)
    @(posedge clk); #1;
    if (vout !== 1'b0) begin o_fail = o_fail + 1; $display("FAIL alu_top XLEN=%0d o_valid=1 after edge 1", XLEN); end
    @(negedge clk); vin = 0;
    @(posedge clk); #1;                                           // edge 2
    if (vout === 1'b1 && res === 12 && fz === 1'b0 && fn === 1'b0 && fc === 1'b0 && fv === 1'b0) begin
        o_lat_ok = 1; o_pass = o_pass + 1;
    end else begin
        o_fail = o_fail + 1; $display("FAIL alu_top XLEN=%0d latency: o_valid=%b res=%h after edge 2", XLEN, vout, res);
    end
    @(posedge clk); #1;
    if (vout !== 1'b0) begin o_fail = o_fail + 1; $display("FAIL alu_top XLEN=%0d o_valid stuck high", XLEN); end

    // ---- 3. random stream with mid-cycle async resets -----------------------
    clear_model; prev_vin = 0; prev_s2v = 0;
    for (cyc = 0; cyc < NCYC; cyc = cyc + 1) begin
        @(negedge clk);
        if (rst_cnt > 0) begin
            rst_cnt = rst_cnt - 1;
            if (rst_cnt == 0) rst_n = 1;                        // release at the falling edge
        end
        drive_random;
        r1 = rnd(1'b0); r2 = rnd(1'b0);
        if (rst_n && ((r1 & 255) == 0)) begin                   // async assert between clock edges
            #2 rst_n = 0; rst_cnt = 1 + (r2 & 3); o_resets = o_resets + 1;
            clear_model;
            #1 if (vout !== 1'b0) begin o_fail = o_fail + 1; $display("FAIL alu_top XLEN=%0d cyc=%0d o_valid != 0 after async reset", XLEN, cyc); end else o_pass = o_pass + 1;
        end
        @(posedge clk); #1;
        if (!rst_n) clear_model; else begin s2op = s1op; step_model; end
        compare;
    end
    o_done = 1;
end
endmodule

module tb_alu_top;
parameter AARCH = 4;
parameter SARCH = 1;
parameter NCYC  = 20000;        // random-stream cycles per width

wire        d8, d16, d32, l8, l16, l32;
wire [31:0] p8, p16, p32, f8, f16, f32, h8, h16, h32;
wire [15:0] os8, os16, os32;
wire [31:0] g8, g16, g32, b8, b16, b32, r8, r16, r32, x8, x16, x32;

alu_top_chk #(.XLEN(8 ), .AARCH(AARCH), .SARCH(SARCH), .NCYC(NCYC), .SEED(1)) u8  (d8 , p8 , f8 , h8 , os8 , g8 , b8 , r8 , x8 , l8 );
alu_top_chk #(.XLEN(16), .AARCH(AARCH), .SARCH(SARCH), .NCYC(NCYC), .SEED(2)) u16 (d16, p16, f16, h16, os16, g16, b16, r16, x16, l16);
alu_top_chk #(.XLEN(32), .AARCH(AARCH), .SARCH(SARCH), .NCYC(NCYC), .SEED(3)) u32 (d32, p32, f32, h32, os32, g32, b32, r32, x32, l32);

wire [31:0] pass = p8 + p16 + p32;
wire [31:0] fail = f8 + f16 + f32;

function ok_cov;
    input [15:0] os;
    input [31:0] gaps, b2b, rsts, flush;
    input        lat;
    begin
        ok_cov = (os == 16'hFFFF) && (gaps > 0) && (b2b > 0) && (rsts > 0) && (flush > 0) && lat;
    end
endfunction

initial begin
    wait (d8 && d16 && d32);
    $display("tb_alu_top ADDER_ARCH=%0d SHIFTER_ARCH=%0d seeds=1,2,3 : PASS=%0d FAIL=%0d", AARCH, SARCH, pass, fail);
    $display("HASH %h %h %h", h8, h16, h32);
    $display("coverage ops=%h/%h/%h gaps=%0d/%0d/%0d b2b=%0d/%0d/%0d resets=%0d/%0d/%0d flushed=%0d/%0d/%0d latency2=%b/%b/%b",
             os8, os16, os32, g8, g16, g32, b8, b16, b32, r8, r16, r32, x8, x16, x32, l8, l16, l32);
    if (fail == 0 && ok_cov(os8, g8, b8, r8, x8, l8) && ok_cov(os16, g16, b16, r16, x16, l16) && ok_cov(os32, g32, b32, r32, x32, l32))
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

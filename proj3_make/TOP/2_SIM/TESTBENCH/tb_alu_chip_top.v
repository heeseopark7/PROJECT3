`timescale 1ns / 1ps
`include "alu_defs.vh"
// -----------------------------------------------------------------------------
// tb_alu_chip_top : self-checking test of alu_chip_top (alu_top behind input / output pads).
//   Same checks as tb_alu_top, for one XLEN per run (parameter XLEN, default 32):
//     - result / flags / o_valid against a cycle-accurate reference model (2 clock edges of latency)
//     - mid-run async resets (o_valid must drop at once, in-flight results are discarded)
//     - all 16 op codes (10 ops + 6 Reserved) must be exercised
//   Comparison uses '!==', so X/Z on any output fails. Pad cell models must be zero-delay (or
//   settle well inside 1 ns), because outputs are sampled 1 ns after each clock edge.
//   Stimulus: own xorshift32 PRNG (same stimulus in every simulator).
// -----------------------------------------------------------------------------
module tb_alu_chip_top;

parameter XLEN  = 32;           // 8, 16, 32
parameter AARCH = 4;            // ADDER_ARCH
parameter SARCH = 1;            // SHIFTER_ARCH
parameter NCYC  = 20000;        // random-stream cycles
parameter SEED  = 1;

localparam SHAMT_W = (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5);
localparam M = XLEN - 1;

reg                 clk, rst_n, vin;
reg  [XLEN-1:0]     a, b;
reg  [3:0]          op;
wire                vout, fz, fn, fc, fv;
wire [XLEN-1:0]     res;

alu_chip_top #(.XLEN(XLEN), .ADDER_ARCH(AARCH), .SHIFTER_ARCH(SARCH)) dut (
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
integer             cyc, pass, fail, n_valid, n_reset;
reg  [15:0]         op_seen;
reg  [31:0]         rng;            // xorshift32 state
reg  [31:0]         r1, r2, r3;

function [31:0] rnd;                // advances rng and returns the new value
    input unused;                   // Verilog-2001 functions need at least one input
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

function [XLEN-1:0] operand;        // corner values mixed with random values
    input [31:0] sel;
    input [31:0] rv;
    begin
        case (sel[2:0])
            3'd0:    operand = {XLEN{1'b0}};
            3'd1:    operand = {XLEN{1'b1}};
            3'd2:    operand = {1'b1, {M{1'b0}}};
            3'd3:    operand = {1'b0, {M{1'b1}}};
            default: operand = rv[XLEN-1:0];
        endcase
    end
endfunction

task clear_model;
    begin
        s1v = 0; s2v = 0;
    end
endtask

task step_model;                    // called right after a posedge, using the values driven before it
    begin
        s2v = s1v;
        if (s1v) begin
            reference(s1a, s1b, s1op);
            s2res = r_res; s2flag = {r_z, r_n, r_c, r_v}; s2op = s1op;
        end
        s1v = vin; s1a = a; s1b = b; s1op = op;
    end
endtask

task compare;
    begin
        if (vout !== s2v) begin
            fail = fail + 1;
            if (fail < 20) $display("FAIL alu_chip_top XLEN=%0d cyc=%0d o_valid exp=%b got=%b", XLEN, cyc, s2v, vout);
        end else if (s2v) begin
            if (res !== s2res || {fz, fn, fc, fv} !== s2flag) begin
                fail = fail + 1;
                if (fail < 20)
                    $display("FAIL alu_chip_top XLEN=%0d AARCH=%0d SARCH=%0d cyc=%0d op=%h | exp res=%h znc v=%b | got res=%h %b%b%b%b",
                             XLEN, AARCH, SARCH, cyc, s2op, s2res, s2flag, res, fz, fn, fc, fv);
            end else begin
                pass = pass + 1; op_seen[s2op] = 1'b1; n_valid = n_valid + 1;
            end
        end else pass = pass + 1;
    end
endtask

initial begin
    clk = 0; rst_n = 0; vin = 0; a = 0; b = 0; op = 0;
    pass = 0; fail = 0; n_valid = 0; n_reset = 0; op_seen = 16'h0000;
    rng = 32'h1234_5678 ^ (SEED * 32'h9E37_79B9); if (rng == 0) rng = 32'h1;
    clear_model;

    // ---- reset: o_valid must be 0 while rst_n = 0 ----
    #1 if (vout !== 1'b0) begin fail = fail + 1; $display("FAIL alu_chip_top XLEN=%0d o_valid != 0 during reset", XLEN); end else pass = pass + 1;
    repeat (2) @(posedge clk);
    #2 rst_n = 1;

    // ---- random stream ----
    for (cyc = 0; cyc < NCYC; cyc = cyc + 1) begin
        r1 = rnd(0); r2 = rnd(0); r3 = rnd(0);
        vin = (r1[1:0] != 2'b00);                   // about 3/4 of the cycles carry valid data
        op  = r1[7:4];                              // all 16 codes, Reserved included
        a   = operand(r2, r3);
        b   = operand(r2 >> 3, rnd(0));
        @(posedge clk);
        step_model;
        #1 compare;
        // mid-run async reset: o_valid must fall at once, in-flight results are discarded
        if (r1[15:8] == 8'h00) begin
            #1 rst_n = 0;
            #1 if (vout !== 1'b0) begin fail = fail + 1; $display("FAIL alu_chip_top XLEN=%0d cyc=%0d o_valid != 0 after async reset", XLEN, cyc); end else pass = pass + 1;
            clear_model; n_reset = n_reset + 1;
            #2 rst_n = 1;
        end
    end

    $display("tb_alu_chip_top XLEN=%0d ADDER_ARCH=%0d SHIFTER_ARCH=%0d seed=%0d : PASS=%0d FAIL=%0d", XLEN, AARCH, SARCH, SEED, pass, fail);
    $display("coverage ops=%h valid_results=%0d resets=%0d", op_seen, n_valid, n_reset);
    if (fail == 0 && op_seen == 16'hFFFF && n_valid > 0 && n_reset > 0)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end

endmodule

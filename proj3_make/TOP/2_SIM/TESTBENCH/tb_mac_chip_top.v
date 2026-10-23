`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_mac_chip_top : self-checking test of mac_chip_top (mac_top behind input / output pads).
//   Same checks as tb_mac_top, for one A_W per run (parameter A_W, default 16).
//   Reference model applies each command IMMEDIATELY at the clock edge that samples it
//   (clr has priority over en; acc wraps mod 2**ACC_W). The DUT o_acc after edge t must equal
//   the model value of edge t-MAC_STAGES  (latency = MAC_STAGES + 1 edges).
//   Phases:
//     A  reset-free random stream
//     B  random stream + mid-cycle async resets (in-flight commands are discarded)
//     C  worst-case product (min*min): 511 accumulations stay in range, the 512th wraps
//     D  reset in the middle of a stream, then recovery
//   Comparison uses '!==', so X/Z on o_acc fails. Pad cell models must be zero-delay (or settle
//   well inside 1 ns), because o_acc is sampled 1 ns after each clock edge.
//   Stimulus: own xorshift32 PRNG (same stimulus in every simulator).
// -----------------------------------------------------------------------------
module tb_mac_chip_top;

parameter A_W    = 16;          // 4, 8, 16
parameter MARCH  = 0;           // MULT_ARCH
parameter AARCH  = 4;           // ADDER_ARCH
parameter STAGES = 1;           // MAC_STAGES (3 only with MARCH 1 or 2)
parameter NCYC   = 20000;       // cycles of phase A (reset-free) and of phase B (with async resets)
parameter SEED   = 1;

localparam ACC_W = 2*A_W + 8;
localparam P_W   = 2*A_W;

reg                         clk, rst_n, en, clr;
reg  signed [A_W-1:0]       a, b;
wire        [ACC_W-1:0]     acc;

mac_chip_top #(.A_W(A_W), .MULT_ARCH(MARCH), .ADDER_ARCH(AARCH), .MAC_STAGES(STAGES)) dut (
    .i_clk(clk), .i_rst_n(rst_n), .i_a(a), .i_b(b), .i_en(en), .i_clr(clr), .o_acc(acc)
);

always #5 clk = ~clk;

// ---- reference model ---------------------------------------------------------
reg  signed [P_W-1:0]       m_p;
reg         [ACC_W-1:0]     m_acc;
reg         [ACC_W-1:0]     hist [0:4];     // hist[0] = model after the latest edge, hist[k] = k edges ago
reg  signed [63:0]          ideal;          // non-wrapping accumulator (wrap detection only)
reg  signed [63:0]          ideal_hi, ideal_lo;
reg                         prev_sign;
integer                     cyc, h, rst_cnt, k, nen, pass, fail;
reg  [31:0]                 cov;            // coverage bits, see the end of this file
reg  [31:0]                 rng;            // xorshift32 state
reg  [31:0]                 r1, r2;

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

task clear_model;
    begin
        m_acc = 0; ideal = 0; prev_sign = 0;
        for (h = 0; h < 5; h = h + 1) hist[h] = 0;
    end
endtask

task step_model;    // call right after a posedge, with the command that was driven before it
    begin
        for (h = 4; h > 0; h = h - 1) hist[h] = hist[h-1];
        m_p = a * b;
        if (clr) begin
            m_acc = 0; ideal = 0;
        end else if (en) begin
            m_acc = m_acc + {{(ACC_W-P_W){m_p[P_W-1]}}, m_p};
            ideal = ideal + m_p;
            if (ideal > ideal_hi || ideal < ideal_lo) begin
                cov[3] = 1;                                     // wrap happened
                ideal = $signed(m_acc);                         // continue from the wrapped value
            end
            if (m_p > 0) cov[0] = 1;
            if (m_p < 0) cov[1] = 1;
            if (m_acc[ACC_W-1] != prev_sign) cov[2] = 1;        // sign change during accumulation
        end
        prev_sign = m_acc[ACC_W-1];
        hist[0] = m_acc;
        cov[4 + {clr, en}] = 1;                                 // bits 4..7: clr/en combos 00 01 10 11
    end
endtask

task compare;
    begin
        if (acc !== hist[STAGES]) begin
            fail = fail + 1;
            if (fail < 20)
                $display("FAIL mac_chip_top A_W=%0d M=%0d A=%0d S=%0d cyc=%0d exp acc=%h got=%h", A_W, MARCH, AARCH, STAGES, cyc, hist[STAGES], acc);
        end else
            pass = pass + 1;
    end
endtask

task drive_random;
    input allow_clr;
    integer r;
    begin
        r1 = rnd(1'b0); r = r1 & 7;
        r1 = rnd(1'b0);
        case (r)
            0: a = {1'b1, {(A_W-1){1'b0}}};         // most negative
            1: a = {1'b0, {(A_W-1){1'b1}}};         // most positive
            2: a = 0;
            default: a = r1;
        endcase
        r1 = rnd(1'b0); r = r1 & 7;
        r1 = rnd(1'b0);
        case (r)
            0: b = {1'b1, {(A_W-1){1'b0}}};
            1: b = {1'b0, {(A_W-1){1'b1}}};
            2: b = -1;
            default: b = r1;
        endcase
        r1 = rnd(1'b0); r2 = rnd(1'b0);
        en  = ((r1 & 3) != 0);
        clr = allow_clr && ((r2 & 15) == 0);
    end
endtask

initial begin
    clk = 0; rst_n = 1; en = 0; clr = 0; a = 0; b = 0;
    pass = 0; fail = 0; cov = 0;
    rng = 32'h2545F491 ^ (SEED * 32'h9E3779B1); if (rng == 32'd0) rng = 32'd1; rst_cnt = 0; cyc = 0;
    ideal_hi = (64'sd1 <<< (ACC_W-1)) - 1;
    ideal_lo = -(64'sd1 <<< (ACC_W-1));
    clear_model;

    // ---- initial reset with active commands ----
    #1 rst_n = 0; en = 1; clr = 0; a = 3; b = 3;
    #1 if (acc !== {ACC_W{1'b0}}) begin fail = fail + 1; $display("FAIL mac_chip_top A_W=%0d acc != 0 right after reset", A_W); end else pass = pass + 1;
    repeat (3) begin
        @(posedge clk); #1;
        if (acc !== {ACC_W{1'b0}}) begin fail = fail + 1; $display("FAIL mac_chip_top A_W=%0d acc != 0 during reset", A_W); end else pass = pass + 1;
    end
    @(negedge clk); rst_n = 1; en = 0;

    // ---- Phase A: reset-free random stream ----
    for (cyc = 0; cyc < NCYC; cyc = cyc + 1) begin
        @(negedge clk);
        drive_random(1);
        @(posedge clk); #1;
        step_model;
        compare;
    end

    // ---- Phase B: random stream with mid-cycle async resets ----
    for (cyc = 0; cyc < NCYC; cyc = cyc + 1) begin
        @(negedge clk);
        if (rst_cnt > 0) begin
            rst_cnt = rst_cnt - 1;
            if (rst_cnt == 0) rst_n = 1;
        end
        drive_random(1);
        r1 = rnd(1'b0); r2 = rnd(1'b0);
        if (rst_n && ((r1 & 127) == 0)) begin
            #2 rst_n = 0; rst_cnt = 1 + (r2 & 3); cov[8] = 1;
            clear_model;
            #1 if (acc !== {ACC_W{1'b0}}) begin fail = fail + 1; $display("FAIL mac_chip_top A_W=%0d cyc=%0d acc != 0 after async reset", A_W, cyc); end else pass = pass + 1;
        end
        @(posedge clk); #1;
        if (!rst_n) clear_model; else step_model;
        compare;
    end
    // make sure reset is released before phase C
    @(negedge clk); rst_n = 1; en = 0; clr = 0;
    @(posedge clk); #1; step_model; compare;

    // ---- Phase C: worst-case product, 511 then 512 accumulations ----
    @(negedge clk); a = 0; b = 0; en = 0; clr = 1;               // clear
    @(posedge clk); #1; step_model; compare;
    for (nen = 1; nen <= 512; nen = nen + 1) begin
        @(negedge clk); a = {1'b1, {(A_W-1){1'b0}}}; b = {1'b1, {(A_W-1){1'b0}}}; en = 1; clr = 0;
        @(posedge clk); #1;
        step_model;                                             // model value after nen accumulations
        if (nen == 511) begin
            if (m_acc[ACC_W-1] !== 1'b0 || m_acc !== 511 * (64'd1 << (P_W-2))) begin
                fail = fail + 1; $display("FAIL mac_chip_top A_W=%0d after 511 worst-case products acc=%h (expected no overflow)", A_W, m_acc);
            end else begin pass = pass + 1; cov[9] = 1; end
        end
        if (nen == 512) begin
            if (m_acc[ACC_W-1] !== 1'b1 || m_acc !== (64'd1 << (ACC_W-1))) begin
                fail = fail + 1; $display("FAIL mac_chip_top A_W=%0d after 512 worst-case products acc=%h (expected wrap to MSB)", A_W, m_acc);
            end else begin pass = pass + 1; cov[10] = 1; end
        end
        cyc = nen;
        compare;
    end
    // drain the pipeline so the last values are compared too
    for (k = 0; k < 4; k = k + 1) begin
        @(negedge clk); en = 0; clr = 0;
        @(posedge clk); #1; step_model; compare;
    end

    // ---- Phase D: reset in the middle of a stream, then recovery ----
    @(negedge clk); a = 5; b = -7; en = 1; clr = 0;
    #2 rst_n = 0; clear_model;
    #1 if (acc !== {ACC_W{1'b0}}) begin fail = fail + 1; $display("FAIL mac_chip_top A_W=%0d acc != 0 after final async reset", A_W); end else pass = pass + 1;
    @(negedge clk); rst_n = 1; en = 1; a = 5; b = -7;            // first command after release
    for (k = 0; k < 6; k = k + 1) begin
        @(posedge clk); #1;
        step_model; compare;
        @(negedge clk);
    end
    cov[11] = 1;

    $display("tb_mac_chip_top A_W=%0d MULT_ARCH=%0d ADDER_ARCH=%0d MAC_STAGES=%0d cycles=%0d seed=%0d : PASS=%0d FAIL=%0d", A_W, MARCH, AARCH, STAGES, NCYC, SEED, pass, fail);
    // coverage bits: 0 pos product, 1 neg product, 2 acc sign change, 3 wrap seen,
    //                4..7 {clr,en} = 00 01 10 11, 8 mid-run reset, 9 511 ok, 10 512 wrap ok, 11 recovery done
    $display("coverage mask=%h (need 00000fff)", cov);
    if (fail == 0 && cov == 32'h0000_0FFF)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end

endmodule

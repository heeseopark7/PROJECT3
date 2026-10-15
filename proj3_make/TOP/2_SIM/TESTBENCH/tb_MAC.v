`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_MAC : self-checking test of mac_top (M3 M4 M5 M7). One testbench for every
//          (MULT_ARCH, ADDER_ARCH, MAC_STAGES) combination; A_W = 4, 8, 16 run in the same simulation.
//   Reference model applies each command IMMEDIATELY at the clock edge that samples it
//   (clr has priority over en; acc wraps mod 2**ACC_W). The DUT o_acc after edge t must equal
//   the model value of edge t-MAC_STAGES  (latency = MAC_STAGES + 1 edges).
//   Phases (per A_W):
//     A  reset-free random stream      -> HASH of the latency-aligned o_acc stream (M6: must match across ARCH/STAGES)
//     B  random stream + mid-cycle async resets (in-flight commands are discarded)
//     C  worst-case product (min*min): 511 accumulations stay in range, the 512th wraps (M4)
//     D  reset directly after reset: o_acc = 0 right after reset and recovery
//   Ideal (non-wrapping) accumulator is tracked only to detect that a wrap really happened.
// -----------------------------------------------------------------------------
module mac_chk #(
    parameter   A_W         = 8     ,
    parameter   MARCH       = 0     ,
    parameter   AARCH       = 4     ,
    parameter   STAGES      = 1     ,
    parameter   NA          = 20000 ,
    parameter   NB          = 20000 ,
    parameter   SEED        = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_hash  ,
    output reg  [31:0]  o_cov       // see tb_MAC top for bit meaning
);

localparam ACC_W = 2*A_W + 8;
localparam P_W   = 2*A_W;

reg                         clk, rst_n, en, clr;
reg  signed [A_W-1:0]       a, b;
wire        [ACC_W-1:0]     acc;

mac_top #(.A_W(A_W), .MULT_ARCH(MARCH), .ADDER_ARCH(AARCH), .MAC_STAGES(STAGES)) dut (
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
integer                     cyc, n, h, seed, rst_cnt, k, nen;

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
                o_cov[3] = 1;                                   // wrap happened
                ideal = $signed(m_acc) ;                        // continue from the wrapped value
            end
            if (m_p > 0) o_cov[0] = 1;
            if (m_p < 0) o_cov[1] = 1;
            if (m_acc[ACC_W-1] != prev_sign) o_cov[2] = 1;      // sign change during accumulation
        end
        prev_sign = m_acc[ACC_W-1];
        hist[0] = m_acc;
        o_cov[4 + {clr, en}] = 1;                               // bits 4..7: clr/en combos 00 01 10 11
    end
endtask

wire [63:0] acc64 = {{(64-ACC_W){1'b0}}, acc};     // zero-extended copy for the hash

task compare;
    input aligned_hash;
    begin
        if (acc !== hist[STAGES]) begin
            o_fail = o_fail + 1;
            if (o_fail < 20)
                $display("FAIL mac A_W=%0d M=%0d A=%0d S=%0d cyc=%0d exp acc=%h got=%h", A_W, MARCH, AARCH, STAGES, cyc, hist[STAGES], acc);
        end else
            o_pass = o_pass + 1;
        if (aligned_hash) begin
            n = cyc - STAGES;                                   // index of the command this value belongs to
            if (n >= 0 && n < NA - 4)
                o_hash = {o_hash[30:0], o_hash[31]} ^ acc64[31:0] ^ acc64[63:32];
        end
    end
endtask

task drive_random;
    input allow_clr;
    integer r;
    begin
        r = $random(seed) & 7;
        case (r)
            0: a = {1'b1, {(A_W-1){1'b0}}};         // most negative
            1: a = {1'b0, {(A_W-1){1'b1}}};         // most positive
            2: a = 0;
            default: a = $random(seed);
        endcase
        r = $random(seed) & 7;
        case (r)
            0: b = {1'b1, {(A_W-1){1'b0}}};
            1: b = {1'b0, {(A_W-1){1'b1}}};
            2: b = -1;
            default: b = $random(seed);
        endcase
        en  = (($random(seed) & 3) != 0);
        clr = allow_clr && (($random(seed) & 15) == 0);
    end
endtask

initial begin
    clk = 0; rst_n = 1; en = 0; clr = 0; a = 0; b = 0;
    o_done = 0; o_pass = 0; o_fail = 0; o_hash = 32'h1234_5678; o_cov = 0;
    seed = SEED; rst_cnt = 0; cyc = 0;
    ideal_hi = (64'sd1 <<< (ACC_W-1)) - 1;
    ideal_lo = -(64'sd1 <<< (ACC_W-1));
    clear_model;

    // ---- initial reset with active commands ----
    #1 rst_n = 0; en = 1; clr = 0; a = 3; b = 3;
    #1 if (acc !== {ACC_W{1'b0}}) begin o_fail = o_fail + 1; $display("FAIL mac A_W=%0d acc != 0 right after reset", A_W); end else o_pass = o_pass + 1;
    repeat (3) begin
        @(posedge clk); #1;
        if (acc !== {ACC_W{1'b0}}) begin o_fail = o_fail + 1; $display("FAIL mac A_W=%0d acc != 0 during reset", A_W); end else o_pass = o_pass + 1;
    end
    @(negedge clk); rst_n = 1; en = 0;

    // ---- Phase A: reset-free random stream ----
    for (cyc = 0; cyc < NA; cyc = cyc + 1) begin
        @(negedge clk);
        drive_random(1);
        @(posedge clk); #1;
        step_model;
        compare(1);
    end

    // ---- Phase B: random stream with mid-cycle async resets ----
    for (cyc = 0; cyc < NB; cyc = cyc + 1) begin
        @(negedge clk);
        if (rst_cnt > 0) begin
            rst_cnt = rst_cnt - 1;
            if (rst_cnt == 0) rst_n = 1;
        end
        drive_random(1);
        if (rst_n && (($random(seed) & 127) == 0)) begin
            #2 rst_n = 0; rst_cnt = 1 + ($random(seed) & 3); o_cov[8] = 1;
            clear_model;
            #1 if (acc !== {ACC_W{1'b0}}) begin o_fail = o_fail + 1; $display("FAIL mac A_W=%0d cyc=%0d acc != 0 after async reset", A_W, cyc); end else o_pass = o_pass + 1;
        end
        @(posedge clk); #1;
        if (!rst_n) clear_model; else step_model;
        compare(0);
    end
    // make sure reset is released before phase C
    @(negedge clk); rst_n = 1; en = 0; clr = 0;
    @(posedge clk); #1; step_model; compare(0);

    // ---- Phase C: worst-case product, 511 then 512 accumulations (M4) ----
    @(negedge clk); a = 0; b = 0; en = 0; clr = 1;               // clear
    @(posedge clk); #1; step_model; compare(0);
    for (nen = 1; nen <= 512; nen = nen + 1) begin
        @(negedge clk); a = {1'b1, {(A_W-1){1'b0}}}; b = {1'b1, {(A_W-1){1'b0}}}; en = 1; clr = 0;
        @(posedge clk); #1;
        step_model;                                             // model value after nen accumulations
        if (nen == 511) begin
            if (m_acc[ACC_W-1] !== 1'b0 || m_acc !== 511 * (64'd1 << (P_W-2))) begin
                o_fail = o_fail + 1; $display("FAIL mac A_W=%0d after 511 worst-case products acc=%h (expected no overflow)", A_W, m_acc);
            end else begin o_pass = o_pass + 1; o_cov[9] = 1; end
        end
        if (nen == 512) begin
            if (m_acc[ACC_W-1] !== 1'b1 || m_acc !== (64'd1 << (ACC_W-1))) begin
                o_fail = o_fail + 1; $display("FAIL mac A_W=%0d after 512 worst-case products acc=%h (expected wrap to MSB)", A_W, m_acc);
            end else begin o_pass = o_pass + 1; o_cov[10] = 1; end
        end
        cyc = nen;
        compare(0);
    end
    // drain the pipeline so the last values are compared too
    for (k = 0; k < 4; k = k + 1) begin
        @(negedge clk); en = 0; clr = 0;
        @(posedge clk); #1; step_model; compare(0);
    end

    // ---- Phase D: reset in the middle of a stream, then recovery ----
    @(negedge clk); a = 5; b = -7; en = 1; clr = 0;
    #2 rst_n = 0; clear_model;
    #1 if (acc !== {ACC_W{1'b0}}) begin o_fail = o_fail + 1; $display("FAIL mac A_W=%0d acc != 0 after final async reset", A_W); end else o_pass = o_pass + 1;
    @(negedge clk); rst_n = 1; en = 1; a = 5; b = -7;            // first command after release
    for (k = 0; k < 6; k = k + 1) begin
        @(posedge clk); #1;
        step_model; compare(0);
        @(negedge clk);
    end
    o_cov[11] = 1;
    o_done = 1;
end
endmodule

module tb_MAC;
parameter MARCH  = 0;
parameter AARCH  = 4;
parameter STAGES = 1;
parameter NCYC   = 20000;       // cycles of phase A (reset-free) and of phase B (with async resets)

wire        d4, d8, d16;
wire [31:0] p4, p8, p16, f4, f8, f16, h4, h8, h16, c4, c8, c16;

mac_chk #(.A_W(4 ), .MARCH(MARCH), .AARCH(AARCH), .STAGES(STAGES), .NA(NCYC), .NB(NCYC), .SEED(1)) u4  (d4 , p4 , f4 , h4 , c4 );
mac_chk #(.A_W(8 ), .MARCH(MARCH), .AARCH(AARCH), .STAGES(STAGES), .NA(NCYC), .NB(NCYC), .SEED(2)) u8  (d8 , p8 , f8 , h8 , c8 );
mac_chk #(.A_W(16), .MARCH(MARCH), .AARCH(AARCH), .STAGES(STAGES), .NA(NCYC), .NB(NCYC), .SEED(3)) u16 (d16, p16, f16, h16, c16);

wire [31:0] pass = p4 + p8 + p16;
wire [31:0] fail = f4 + f8 + f16;

// coverage bits: 0 pos product, 1 neg product, 2 acc sign change, 3 wrap seen,
//                4..7 {clr,en} = 00 01 10 11, 8 mid-run reset, 9 511 ok, 10 512 wrap ok, 11 recovery done
localparam [31:0] ALL_COV = 32'h0000_0FFF;

initial begin
    wait (d4 && d8 && d16);
    $display("tb_MAC MULT_ARCH=%0d ADDER_ARCH=%0d MAC_STAGES=%0d cycles=%0d seeds=1,2,3 : PASS=%0d FAIL=%0d", MARCH, AARCH, STAGES, NCYC, pass, fail);
    $display("HASH %h %h %h", h4, h8, h16);
    $display("coverage mask A_W4=%h A_W8=%h A_W16=%h (need %h)", c4, c8, c16, ALL_COV);
    if (fail == 0 && c4 == ALL_COV && c8 == ALL_COV && c16 == ALL_COV)
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end
endmodule

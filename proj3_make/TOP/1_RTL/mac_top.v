`default_nettype none
// -----------------------------------------------------------------------------
// mac_top
//   Purpose : Multiply-accumulate unit: acc <- acc + a*b, signed A_W x A_W, ACC_W-bit accumulator.
//             i_clr has priority over i_en (clr & en both 1 -> acc <- 0). No saturation: wraps mod 2**ACC_W.
//   Structure: [front end, depends on MAC_STAGES]  ->  p (product) + en + clr  ->  [accumulate stage]
//              Accumulate stage (same for every MAC_STAGES): adder_top(acc_q, sign-extended p) -> acc_q.
//              The loop acc_q -> adder -> acc_q is ONE cycle and has no register inside; pipelining is
//              done only on the multiplier side. Control (en, clr) travels through the same number of
//              registers as the data.
//              MAC_STAGES = 1: a_q b_q | mul_top ---------------------------------------> acc
//              MAC_STAGES = 2: a_q b_q | mul_top | p_q ------------------------------------> acc
//              MAC_STAGES = 3: a_q b_q | mul_csa_top | s_q c_q | adder_top | p_q ----------> acc
//                              (partial-product generation + compression | final addition | accumulate)
//   Latency : MAC_STAGES + 1 edges (edge n samples the command, edge n+MAC_STAGES updates acc_q).
//   Reset   : only acc_q and the en/clr registers are reset (async assert, active-low). Data registers
//             (a_q, b_q, p_q, s_q, c_q) free-run: no reset, no enable.
//   Note    : Every addition goes through adder_top. MAC_STAGES = 3 needs a carry-save multiplier
//             (MULT_ARCH 1 or 2); with MULT_ARCH = 0 (BEH) or any other unsupported value the module
//             fails at elaboration (it is NOT replaced by a smaller pipeline).
// -----------------------------------------------------------------------------
module mac_top #(
    parameter   A_W         = 16            ,   // operand width (4, 8, 16)
    parameter   ACC_W       = 2*A_W + 8     ,   // accumulator width (derived)
    parameter   MULT_ARCH   = 0             ,
    parameter   ADDER_ARCH  = 4             ,
    parameter   MAC_STAGES  = 1
)(
                i_clk   ,
                i_rst_n ,
                i_a     ,
                i_b     ,
                i_en    ,
                i_clr   ,
                o_acc
);

localparam  P_W     =   2*A_W               ;   // product width
localparam  EXT_W   =   ACC_W - P_W         ;   // sign-extension bits (ACC_W >= 2*A_W is required)

input   wire                            i_clk   ;
input   wire                            i_rst_n ;
input   wire    signed  [A_W-1:0]       i_a     ;
input   wire    signed  [A_W-1:0]       i_b     ;
input   wire                            i_en    ;
input   wire                            i_clr   ;
output  wire            [ACC_W-1:0]     o_acc   ;

// What the accumulate stage receives (driven by the front end of the selected MAC_STAGES)
wire    signed  [P_W-1:0]   w_p_acc     ;   // product to add
wire                        w_en_acc    ;
wire                        w_clr_acc   ;

generate
    if ((A_W == 4 || A_W == 8 || A_W == 16) && ACC_W >= P_W && MAC_STAGES == 1)
    begin : g_stage1
        // ---- input registers; multiplier and accumulator in the same cycle ----
        reg     signed  [A_W-1:0]   a_q     ;
        reg     signed  [A_W-1:0]   b_q     ;
        reg                         en_q    ;
        reg                         clr_q   ;

        always @(posedge i_clk) begin
            a_q     <=  i_a     ;
            b_q     <=  i_b     ;
        end

        always @(posedge i_clk or negedge i_rst_n) begin
            if (!i_rst_n) begin
                en_q    <=  1'b0    ;
                clr_q   <=  1'b0    ;
            end else begin
                en_q    <=  i_en    ;
                clr_q   <=  i_clr   ;
            end
        end

        mul_top #(.A_W(A_W), .MULT_ARCH(MULT_ARCH), .ADDER_ARCH(ADDER_ARCH)) u_mul (
            .i_a    (a_q        ),
            .i_b    (b_q        ),
            .o_p    (w_p_acc    )
        );

        assign  w_en_acc    =   en_q    ;
        assign  w_clr_acc   =   clr_q   ;
    end
    else if ((A_W == 4 || A_W == 8 || A_W == 16) && ACC_W >= P_W && MAC_STAGES == 2)
    begin : g_stage2
        // ---- input registers | multiplier | p_q | accumulate ----
        reg     signed  [A_W-1:0]   a_q     ;
        reg     signed  [A_W-1:0]   b_q     ;
        reg                         en1_q   ;
        reg                         clr1_q  ;
        wire    signed  [P_W-1:0]   w_p     ;
        reg     signed  [P_W-1:0]   p_q     ;
        reg                         en2_q   ;
        reg                         clr2_q  ;

        always @(posedge i_clk) begin
            a_q     <=  i_a     ;
            b_q     <=  i_b     ;
            p_q     <=  w_p     ;
        end

        always @(posedge i_clk or negedge i_rst_n) begin
            if (!i_rst_n) begin
                en1_q   <=  1'b0    ;
                clr1_q  <=  1'b0    ;
                en2_q   <=  1'b0    ;
                clr2_q  <=  1'b0    ;
            end else begin
                en1_q   <=  i_en    ;
                clr1_q  <=  i_clr   ;
                en2_q   <=  en1_q   ;
                clr2_q  <=  clr1_q  ;
            end
        end

        mul_top #(.A_W(A_W), .MULT_ARCH(MULT_ARCH), .ADDER_ARCH(ADDER_ARCH)) u_mul (
            .i_a    (a_q    ),
            .i_b    (b_q    ),
            .o_p    (w_p    )
        );

        assign  w_p_acc     =   p_q     ;
        assign  w_en_acc    =   en2_q   ;
        assign  w_clr_acc   =   clr2_q  ;
    end
    else if ((A_W == 4 || A_W == 8 || A_W == 16) && ACC_W >= P_W && MAC_STAGES == 3 && MULT_ARCH != 0)
    begin : g_stage3
        // ---- input registers | partial products + compression | s_q c_q | final addition | p_q | accumulate ----
        reg     signed  [A_W-1:0]   a_q     ;
        reg     signed  [A_W-1:0]   b_q     ;
        reg                         en1_q   ;
        reg                         clr1_q  ;
        wire            [P_W-1:0]   w_s     ;
        wire            [P_W-1:0]   w_c     ;
        reg             [P_W-1:0]   s_q     ;
        reg             [P_W-1:0]   c_q     ;
        reg                         en2_q   ;
        reg                         clr2_q  ;
        wire            [P_W-1:0]   w_sum   ;
        reg     signed  [P_W-1:0]   p_q     ;
        reg                         en3_q   ;
        reg                         clr3_q  ;
        // The carry-out of the final addition is not needed: the product is taken mod 2**(2*A_W).
        /* verilator lint_off UNUSEDSIGNAL */
        wire                        w_cout  ;
        /* verilator lint_on UNUSEDSIGNAL */

        always @(posedge i_clk) begin
            a_q     <=  i_a     ;
            b_q     <=  i_b     ;
            s_q     <=  w_s     ;
            c_q     <=  w_c     ;
            p_q     <=  w_sum   ;
        end

        always @(posedge i_clk or negedge i_rst_n) begin
            if (!i_rst_n) begin
                en1_q   <=  1'b0    ;
                clr1_q  <=  1'b0    ;
                en2_q   <=  1'b0    ;
                clr2_q  <=  1'b0    ;
                en3_q   <=  1'b0    ;
                clr3_q  <=  1'b0    ;
            end else begin
                en1_q   <=  i_en    ;
                clr1_q  <=  i_clr   ;
                en2_q   <=  en1_q   ;
                clr2_q  <=  clr1_q  ;
                en3_q   <=  en2_q   ;
                clr3_q  <=  clr2_q  ;
            end
        end

        mul_csa_top #(.A_W(A_W), .MULT_ARCH(MULT_ARCH)) u_csa (
            .i_a    (a_q    ),
            .i_b    (b_q    ),
            .o_s    (w_s    ),
            .o_c    (w_c    )
        );

        adder_top #(.W(P_W), .ADDER_ARCH(ADDER_ARCH)) u_final (
            .i_a    (s_q    ),
            .i_b    (c_q    ),
            .i_cin  (1'b0   ),
            .o_sum  (w_sum  ),
            .o_cout (w_cout )
        );

        assign  w_p_acc     =   p_q     ;
        assign  w_en_acc    =   en3_q   ;
        assign  w_clr_acc   =   clr3_q  ;
    end
    else
    begin : g_unsupported
        // Intentionally missing module: this MAC_STAGES / MULT_ARCH / A_W / ACC_W combination is not implemented
        // (MAC_STAGES 3 needs MULT_ARCH 1 or 2) -> elaboration error.
        mac_stages_not_implemented u_unsupported ();
    end
endgenerate

// ---- accumulate stage (identical for every MAC_STAGES): one cycle, no register inside the loop ----
wire            [ACC_W-1:0]     w_p_ext     ;   // product sign-extended to ACC_W
wire            [ACC_W-1:0]     w_sum       ;
// w_cout is intentionally unused: the accumulator wraps mod 2**ACC_W (no saturation, no carry flag).
/* verilator lint_off UNUSEDSIGNAL */
wire                            w_cout      ;
/* verilator lint_on UNUSEDSIGNAL */
reg             [ACC_W-1:0]     r_acc_d     ;
reg             [ACC_W-1:0]     acc_q       ;

assign  w_p_ext =   {{EXT_W{w_p_acc[P_W-1]}}, w_p_acc}  ;

adder_top #(.W(ACC_W), .ADDER_ARCH(ADDER_ARCH)) u_adder (
    .i_a    (acc_q      ),
    .i_b    (w_p_ext    ),
    .i_cin  (1'b0       ),
    .o_sum  (w_sum      ),
    .o_cout (w_cout     )
);

always @* begin
    r_acc_d =   acc_q       ;       // default: hold
    if (w_clr_acc)
        r_acc_d =   {ACC_W{1'b0}}   ;   // clear has priority over enable
    else if (w_en_acc)
        r_acc_d =   w_sum   ;
end

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)   acc_q   <=  {ACC_W{1'b0}}   ;
    else            acc_q   <=  r_acc_d         ;
end

assign  o_acc   =   acc_q   ;

endmodule
`default_nettype wire

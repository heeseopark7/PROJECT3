`default_nettype none
// -----------------------------------------------------------------------------
// mac_top
//   Purpose : Multiply-accumulate unit: acc <- acc + a*b, signed A_W x A_W, ACC_W-bit accumulator.
//   Structure (MAC_STAGES = 1): input regs a_q, b_q (data, no reset), en_q, clr_q (async reset)
//                               -> mul_top -> adder_top (acc_q + sign-extended product) -> acc_q
//              The accumulate loop acc_q -> adder -> acc_q is ONE cycle with no register inside.
//              i_clr has priority over i_en (clr & en both 1 -> acc <- 0). No saturation: wraps mod 2**ACC_W.
//   Latency : MAC_STAGES + 1 = 2 edges (edge n samples the command, edge n+1 updates acc_q).
//   Reset   : only acc_q, en_q, clr_q are reset (async assert, active-low). Data regs free-run.
//   Note    : Every addition goes through adder_top. MAC_STAGES 2 and 3 are not implemented yet and
//             fail at elaboration (they are NOT replaced by the 1-stage version).
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

wire    [ACC_W-1:0]     w_acc_q     ;

generate
    if (MAC_STAGES == 1 && (A_W == 4 || A_W == 8 || A_W == 16) && ACC_W >= P_W)
    begin : g_stage1
        // ---- input registers ----
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

        // ---- multiply, then accumulate (one cycle) ----
        wire    signed  [P_W-1:0]   w_p         ;
        wire            [ACC_W-1:0] w_p_ext     ;   // product sign-extended to ACC_W
        wire            [ACC_W-1:0] w_sum       ;
        // w_cout is intentionally unused: the accumulator wraps mod 2**ACC_W (no saturation, no carry flag).
        /* verilator lint_off UNUSEDSIGNAL */
        wire                        w_cout      ;
        /* verilator lint_on UNUSEDSIGNAL */
        reg             [ACC_W-1:0] r_acc_d     ;
        reg             [ACC_W-1:0] acc_q       ;

        mul_top #(.A_W(A_W), .MULT_ARCH(MULT_ARCH), .ADDER_ARCH(ADDER_ARCH)) u_mul (
            .i_a    (a_q    ),
            .i_b    (b_q    ),
            .o_p    (w_p    )
        );

        assign  w_p_ext =   {{EXT_W{w_p[P_W-1]}}, w_p}  ;

        adder_top #(.W(ACC_W), .ADDER_ARCH(ADDER_ARCH)) u_adder (
            .i_a    (acc_q      ),
            .i_b    (w_p_ext    ),
            .i_cin  (1'b0       ),
            .o_sum  (w_sum      ),
            .o_cout (w_cout     )
        );

        always @* begin
            r_acc_d =   acc_q       ;       // default: hold
            if (clr_q)
                r_acc_d =   {ACC_W{1'b0}}   ;   // clear has priority over enable
            else if (en_q)
                r_acc_d =   w_sum   ;
        end

        always @(posedge i_clk or negedge i_rst_n) begin
            if (!i_rst_n)   acc_q   <=  {ACC_W{1'b0}}   ;
            else            acc_q   <=  r_acc_d         ;
        end

        assign  w_acc_q =   acc_q   ;
    end
    else
    begin : g_unsupported
        // Intentionally missing module: this MAC_STAGES / A_W / ACC_W is not implemented -> elaboration error.
        mac_stages_not_implemented u_unsupported ();
    end
endgenerate

assign  o_acc   =   w_acc_q ;

endmodule
`default_nettype wire

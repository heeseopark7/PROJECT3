`default_nettype none
// -----------------------------------------------------------------------------
// adder_ks
//   Purpose : Kogge-Stone parallel-prefix adder. Fastest classic structure (few logic levels),
//             at the cost of the most cells and wiring.
//   Structure: 1) per-bit p = a^b (propagate), g = a&b (generate). Carry-in is folded into bit 0:
//                 g0' = g0 | (p0 & cin).
//              2) Prefix network, LV = ceil(log2 W) levels. Level l (span = 2**l): every bit i >= span
//                 combines with the bit span positions below:
//                    G_i <- G_i | (P_i & G_(i-span)),   P_i <- P_i & P_(i-span)
//                 bits i < span just pass through. After the last level G_i = group generate of bits i..0,
//                 i.e. the carry out of bit i.
//              3) c_0 = cin, c_(i+1) = G_i, sum_i = p_i ^ c_i, cout = G_(W-1).
//              Levels are slices of two packed vectors: G of level l = w_g[l*W +: W], P of level l = w_p[l*W +: W].
//              W need not be a power of two.
//   Latency : 0 (combinational)
//   Note    : No '+' here. Prefix cells are plain AND/OR.
// -----------------------------------------------------------------------------
module adder_ks #(
    parameter   W   = 32
)(
                i_a     ,
                i_b     ,
                i_cin   ,
                o_sum   ,
                o_cout
);

// Number of prefix levels = ceil(log2 W) (W is 2..64)
localparam  LV  =   (W > 32) ? 6 : ((W > 16) ? 5 : ((W > 8) ? 4 : ((W > 4) ? 3 : ((W > 2) ? 2 : 1))))   ;

input   wire    [W-1:0] i_a     ;
input   wire    [W-1:0] i_b     ;
input   wire            i_cin   ;
output  wire    [W-1:0] o_sum   ;
output  wire            o_cout  ;

wire    [W-1:0]         w_pb        ;   // bit propagate
wire    [W-1:0]         w_gb        ;   // bit generate with carry-in folded into bit 0

// G for levels 0..LV and P for levels 0..LV-1 (the last level needs no P). split_var: lint hint only.
wire    [(LV+1)*W-1:0]  w_g         /* verilator split_var */ ;
// Low bits (< span) of the last P level are never read; synthesis removes them.
/* verilator lint_off UNUSEDSIGNAL */
wire    [LV*W-1:0]      w_p         /* verilator split_var */ ;
/* verilator lint_on UNUSEDSIGNAL */

assign  w_pb    =   i_a ^ i_b                                               ;
assign  w_gb    =   {(i_a[W-1:1] & i_b[W-1:1]), (i_a[0] & i_b[0]) | (w_pb[0] & i_cin)}  ;

assign  w_g[0 +: W] =   w_gb    ;
assign  w_p[0 +: W] =   w_pb    ;

genvar                  gl, gi      ;
generate
    for     (gl = 0 ; gl < LV ; gl = gl + 1)
    begin : g_lvl
        localparam  SPAN    =   2**gl       ;
        for     (gi = 0 ; gi < W ; gi = gi + 1)
        begin : g_bit
            if (gi >= SPAN)
            begin : g_cell
                assign  w_g[(gl+1)*W + gi]  =   w_g[gl*W + gi] | (w_p[gl*W + gi] & w_g[gl*W + gi - SPAN])   ;
                if (gl < LV - 1)
                begin : g_pcell
                    assign  w_p[(gl+1)*W + gi]  =   w_p[gl*W + gi] & w_p[gl*W + gi - SPAN]                  ;
                end
            end
            else
            begin : g_pass
                assign  w_g[(gl+1)*W + gi]  =   w_g[gl*W + gi]  ;
                if (gl < LV - 1)
                begin : g_ppass
                    assign  w_p[(gl+1)*W + gi]  =   w_p[gl*W + gi]  ;
                end
            end
        end
    end
endgenerate

wire    [W-1:0]         w_cout_bits ;   // carry out of every bit = G of the last level
assign  w_cout_bits =   w_g[LV*W +: W]                          ;

assign  o_sum       =   w_pb ^ {w_cout_bits[W-2:0], i_cin}      ;
assign  o_cout      =   w_cout_bits[W-1]                        ;

endmodule
`default_nettype wire

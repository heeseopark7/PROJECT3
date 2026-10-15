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
//              Every level owns its own nets (g_lvl[l].w_g / .w_p) and reads the previous level by
//              hierarchical reference, so no vector feeds itself. W need not be a power of two.
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

// ---- pre-processing ------------------------------------------------------
wire    [W-1:0]     w_p         ;   // propagate
wire    [W-1:0]     w_gen       ;   // generate
wire    [W-1:0]     w_g_in      ;   // generate with carry-in folded into bit 0

assign  w_p     =   i_a ^ i_b                                       ;
assign  w_gen   =   i_a & i_b                                       ;
assign  w_g_in  =   {w_gen[W-1:1], w_gen[0] | (w_p[0] & i_cin)}     ;

// ---- prefix network ------------------------------------------------------
// The last level only produces G (carries); its group-P output would be unused, so it is not built.
genvar                  gl, gi      ;
generate
    for     (gl = 0 ; gl < LV ; gl = gl + 1)
    begin : g_lvl
        localparam  SPAN    =   2**gl       ;
        wire    [W-1:0]     w_gi    ;   // level input  G
        // Low bits (< SPAN) of the last level's P input are never read (those bits only pass G through);
        // synthesis removes them. The unused-bit lint warning is understood and silenced for this net only.
        /* verilator lint_off UNUSEDSIGNAL */
        wire    [W-1:0]     w_pi    ;   // level input  P
        /* verilator lint_on UNUSEDSIGNAL */
        wire    [W-1:0]     w_g     ;   // level output G

        if (gl == 0)
        begin : g_first
            assign  w_gi    =   w_g_in  ;
            assign  w_pi    =   w_p     ;
        end
        else
        begin : g_next
            assign  w_gi    =   g_lvl[gl-1].w_g         ;
            assign  w_pi    =   g_lvl[gl-1].g_pn.w_p_o  ;
        end

        for     (gi = 0 ; gi < W ; gi = gi + 1)
        begin : g_bit
            if (gi >= SPAN)
            begin : g_cell
                assign  w_g[gi]     =   w_gi[gi] | (w_pi[gi] & w_gi[gi-SPAN])   ;
            end
            else
            begin : g_pass
                assign  w_g[gi]     =   w_gi[gi]    ;
            end
        end

        if (gl < LV - 1)
        begin : g_pn
            wire    [W-1:0]     w_p_o   ;   // level output P
            for     (gi = 0 ; gi < W ; gi = gi + 1)
            begin : g_bit
                if (gi >= SPAN)
                begin : g_cell
                    assign  w_p_o[gi]   =   w_pi[gi] & w_pi[gi-SPAN]    ;
                end
                else
                begin : g_pass
                    assign  w_p_o[gi]   =   w_pi[gi]    ;
                end
            end
        end
    end
endgenerate

// ---- post-processing -----------------------------------------------------
wire    [W-1:0]     w_carry_out ;   // w_carry_out[i] = carry out of bit i = G_(i:0)
assign  w_carry_out =   g_lvl[LV-1].w_g                     ;

assign  o_sum       =   w_p ^ {w_carry_out[W-2:0], i_cin}   ;
assign  o_cout      =   w_carry_out[W-1]                    ;

endmodule
`default_nettype wire

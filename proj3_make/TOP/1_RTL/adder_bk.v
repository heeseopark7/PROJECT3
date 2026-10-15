`default_nettype none
// -----------------------------------------------------------------------------
// adder_bk
//   Purpose : Brent-Kung parallel-prefix adder. Fewer prefix cells and less wiring than Kogge-Stone,
//             but about twice the logic levels (2*log2(W) - 1).
//   Structure: 1) p = a^b, g = a&b per bit; carry-in folded into bit 0 (g0' = g0 | (p0 & cin)).
//              2) Up-sweep, levels d = 0..L-1 (L = ceil(log2 W)): every bit i with (i+1) a multiple of 2**(d+1)
//                 combines with bit i-2**d:   G_i <- G_i | (P_i & G_(i-2**d)),  P_i <- P_i & P_(i-2**d).
//                 After it, bits 2**k - 1 hold the group generate of bits 0 .. 2**k - 1.
//              3) Down-sweep, levels d = L-2..0: every bit i with (i+1) = 3*2**d + t*2**(d+1) (t >= 0) combines
//                 with bit i-2**d the same way. After it every G_i is the group generate of bits i..0
//                 (= carry out of bit i).
//              4) c_0 = cin, c_(i+1) = G_i, sum_i = p_i ^ c_i, cout = G_(W-1).
//              Stage s of the network is a slice of two packed vectors (G and P, W bits per stage); bits that a
//              stage does not touch pass through. Bits with index >= W simply do not exist, so W need not be a
//              power of two (every cell only reads lower-index bits).
//   Latency : 0 (combinational). Stages: (L) + (L-1) = 2L-1.
//   Note    : No '+' here. Prefix cells are plain AND/OR.
// -----------------------------------------------------------------------------
module adder_bk #(
    parameter   W   = 32
)(
                i_a     ,
                i_b     ,
                i_cin   ,
                o_sum   ,
                o_cout
);

// L = ceil(log2 W) (W is 2..64), number of up-sweep levels; total stages NS = 2L - 1
localparam  L   =   (W > 32) ? 6 : ((W > 16) ? 5 : ((W > 8) ? 4 : ((W > 4) ? 3 : ((W > 2) ? 2 : 1))))   ;
localparam  NS  =   2*L - 1                                                                              ;

input   wire    [W-1:0] i_a     ;
input   wire    [W-1:0] i_b     ;
input   wire            i_cin   ;
output  wire    [W-1:0] o_sum   ;
output  wire            o_cout  ;

wire    [W-1:0]         w_pb        ;   // bit propagate
wire    [W-1:0]         w_gb        ;   // bit generate with carry-in folded into bit 0

// Stage 0 = pre-processing output; stage s+1 = result of network stage s. split_var: lint hint only.
wire    [(NS+1)*W-1:0]  w_g         /* verilator split_var */ ;
// The P of the last stage is never read.
/* verilator lint_off UNUSEDSIGNAL */
wire    [(NS+1)*W-1:0]  w_p         /* verilator split_var */ ;
/* verilator lint_on UNUSEDSIGNAL */

assign  w_pb    =   i_a ^ i_b                                               ;
assign  w_gb    =   {(i_a[W-1:1] & i_b[W-1:1]), (i_a[0] & i_b[0]) | (w_pb[0] & i_cin)}  ;

assign  w_g[0 +: W] =   w_gb    ;
assign  w_p[0 +: W] =   w_pb    ;

genvar                  gs, gi      ;
generate
    for     (gs = 0 ; gs < NS ; gs = gs + 1)
    begin : g_stage
        // Up-sweep stages come first (d = gs), then the down-sweep stages (d = 2L-2-gs).
        localparam  UP      =   (gs < L)                ;
        localparam  D       =   UP ? gs : (2*L - 2 - gs)   ;
        localparam  SPAN    =   2**D                    ;
        for     (gi = 0 ; gi < W ; gi = gi + 1)
        begin : g_bit
            // Does bit gi take part in this stage?
            //   up-sweep  : (gi+1) % 2**(D+1) == 0
            //   down-sweep: (gi+1) % 2**(D+1) == 2**D  and  gi+1 > 2**(D+1)
            localparam  ACTIVE  =   UP ? (((gi + 1) % (2*SPAN)) == 0)
                                       : ((((gi + 1) % (2*SPAN)) == SPAN) && ((gi + 1) > 2*SPAN))   ;
            if (ACTIVE)
            begin : g_cell
                assign  w_g[(gs+1)*W + gi]  =   w_g[gs*W + gi] | (w_p[gs*W + gi] & w_g[gs*W + gi - SPAN])   ;
                assign  w_p[(gs+1)*W + gi]  =   w_p[gs*W + gi] & w_p[gs*W + gi - SPAN]                      ;
            end
            else
            begin : g_pass
                assign  w_g[(gs+1)*W + gi]  =   w_g[gs*W + gi]  ;
                assign  w_p[(gs+1)*W + gi]  =   w_p[gs*W + gi]  ;
            end
        end
    end
endgenerate

wire    [W-1:0]         w_cout_bits ;   // carry out of every bit = G of the last stage
assign  w_cout_bits =   w_g[NS*W +: W]                          ;

assign  o_sum       =   w_pb ^ {w_cout_bits[W-2:0], i_cin}      ;
assign  o_cout      =   w_cout_bits[W-1]                        ;

endmodule
`default_nettype wire

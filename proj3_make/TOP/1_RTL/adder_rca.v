`default_nettype none
// -----------------------------------------------------------------------------
// adder_rca
//   Purpose : Ripple-carry adder. Smallest structure, carry passes through every bit.
//   Structure: W full-adder cells in series. Cell k: p = a[k]^b[k], sum[k] = p ^ cin_k,
//              cout_k = (a[k] & b[k]) | (p & cin_k). cin_0 = i_cin, cin_(k+1) = cout_k, o_cout = cout_(W-1).
//              Each cell owns its own nets (g_bit[k].w_cin / .w_cout) and takes its carry-in from the
//              previous cell by hierarchical reference. (With one carry vector feeding itself, the lint
//              tool reported UNOPTFLAT "circular combinational logic" under -Wall; per-bit nets do not.)
//   Latency : 0 (combinational)
// -----------------------------------------------------------------------------
module adder_rca #(
    parameter   W   = 32
)(
                i_a     ,
                i_b     ,
                i_cin   ,
                o_sum   ,
                o_cout
);

input   wire    [W-1:0] i_a     ;
input   wire    [W-1:0] i_b     ;
input   wire            i_cin   ;
output  wire    [W-1:0] o_sum   ;
output  wire            o_cout  ;

genvar                  gk      ;
generate
    for     (gk = 0 ; gk < W ; gk = gk + 1)
    begin : g_bit
        wire            w_p     ;   // propagate
        wire            w_cin   ;   // carry into this cell
        wire            w_cout  ;   // carry out of this cell
        if (gk == 0)
        begin : g_first
            assign  w_cin   =   i_cin               ;
        end
        else
        begin : g_next
            assign  w_cin   =   g_bit[gk-1].w_cout  ;
        end
        assign  w_p         =   i_a[gk] ^ i_b[gk]                   ;
        assign  o_sum[gk]   =   w_p ^ w_cin                         ;
        assign  w_cout      =   (i_a[gk] & i_b[gk]) | (w_p & w_cin) ;
    end
endgenerate

assign  o_cout  =   g_bit[W-1].w_cout   ;

endmodule
`default_nettype wire

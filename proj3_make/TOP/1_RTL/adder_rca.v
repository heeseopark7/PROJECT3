`default_nettype none
// -----------------------------------------------------------------------------
// adder_rca
//   Purpose : Ripple-carry adder. Smallest structure, carry passes through every bit.
//   Structure: W full-adder cells in series. Cell k: p = a[k]^b[k], sum[k] = p ^ c[k],
//              c[k+1] = (a[k] & b[k]) | (p & c[k]); c[0] = i_cin, o_cout = c[W].
//              The carries are one packed vector written bit by bit.
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

// Carry chain. (split_var: lint hint only. Bit k+1 depends on bit k of the same vector, which is not a
// real loop; the hint tells the lint tool to treat the bits as separate signals.)
wire    [W:0]   w_c     /* verilator split_var */ ;

assign  w_c[0]  =   i_cin   ;

genvar                  gk      ;
generate
    for     (gk = 0 ; gk < W ; gk = gk + 1)
    begin : g_bit
        assign  o_sum[gk]   =   (i_a[gk] ^ i_b[gk]) ^ w_c[gk]                               ;
        assign  w_c[gk+1]   =   (i_a[gk] & i_b[gk]) | ((i_a[gk] ^ i_b[gk]) & w_c[gk])       ;
    end
endgenerate

assign  o_cout  =   w_c[W]  ;

endmodule
`default_nettype wire

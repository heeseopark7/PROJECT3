`default_nettype none
// -----------------------------------------------------------------------------
// adder_rca
//   Purpose : Ripple-carry adder. Smallest structure, carry passes through every bit.
//   Structure: per-bit propagate p = a^b, generate g = a&b, carry c[i+1] = g[i] | (p[i] & c[i]),
//              sum = p ^ c. The carry vector is written as one vector expression.
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

wire    [W-1:0] w_p     ;
wire    [W-1:0] w_g     ;
wire    [W:0]   w_c     ;

assign  w_c[0]  =   i_cin       ;
assign  o_cout  =   w_c[W]      ;

assign  w_p     =   i_a ^ i_b   ;
assign  w_g     =   i_a & i_b   ;
assign  o_sum   =   w_p ^ w_c[W-1:0]   ;
assign  w_c[W:1]    =   w_g | (w_p & w_c[W-1:0]);

endmodule
`default_nettype wire

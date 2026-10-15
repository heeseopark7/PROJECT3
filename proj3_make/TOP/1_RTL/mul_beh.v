`default_nettype none
// -----------------------------------------------------------------------------
// mul_beh
//   Purpose : Behavioral signed multiplier (baseline). The synthesis tool picks the structure.
//   Structure: one signed '*' expression. Both inputs are signed (two's complement, A_W bits),
//              the full 2*A_W-bit product is returned (no truncation, no overflow possible).
//   Latency : 0 (combinational)
//   Note    : '*' is allowed only here (and in testbench reference models).
// -----------------------------------------------------------------------------
module mul_beh #(
    parameter   A_W     = 16
)(
                i_a     ,
                i_b     ,
                o_p
);

input   wire    signed  [A_W-1:0]       i_a     ;
input   wire    signed  [A_W-1:0]       i_b     ;
output  wire    signed  [2*A_W-1:0]     o_p     ;

assign  o_p     =   i_a * i_b   ;

endmodule
`default_nettype wire

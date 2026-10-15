`default_nettype none
// -----------------------------------------------------------------------------
// adder_beh
//   Purpose : Behavioral adder (baseline). The synthesis tool picks the structure.
//   Structure: one '+' expression. {cout, sum} = a + b + cin.
//   Latency : 0 (combinational)
//   Note    : '+' is allowed only here (and in testbench reference models).
// -----------------------------------------------------------------------------
module adder_beh #(
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

wire            [W:0]   w_full  ;   // {carry out, sum}

assign  w_full  =   {1'b0, i_a} + {1'b0, i_b} + {{W{1'b0}}, i_cin}  ;
assign  o_sum   =   w_full[W-1:0]   ;
assign  o_cout  =   w_full[W]       ;

endmodule
`default_nettype wire

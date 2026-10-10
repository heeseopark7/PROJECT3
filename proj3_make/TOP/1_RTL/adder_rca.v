`timescale 1ns / 1ps

module adder_rca #(
    parameter   W   = 32
)(
                i_a     ,
                i_b     ,
                i_cin   ,
                o_sum   ,
                o_cout
);

input   [W-1:0] i_a     ;
input   [W-1:0] i_b     ;
input           i_cin   ;
output  [W-1:0] o_sum   ;
output          o_cout  ;

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
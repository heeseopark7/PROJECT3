module adder_cla #(
    parameter   W = 32
)(
                    i_a     ,
                    i_b     ,
                    i_cin   ,
                    o_sum   ,
                    o_cout  
);
input   [W-1:0]     i_a     ;
input   [W-1:0]     i_b     ;
input               i_cin   ;
output  [W-1:0]     o_sum   ;
output              o_cout  ;

wire    
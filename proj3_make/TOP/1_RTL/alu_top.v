`default_nettype none
// -----------------------------------------------------------------------------
// alu_top
//   Purpose : Registered wrapper around alu_core. Input regs -> alu_core -> output regs, so
//             later STA sees clean reg-to-reg paths (no I/O constraint effects).
//   Structure: input  regs : a_q, b_q, op_q (data, no reset, no enable), valid_in_q (async reset)
//              alu_core    : pure combinational
//              output regs : result_q, flag_q = {zero, neg, carry, ovf} (data, no reset, no enable),
//                            valid_out_q (async reset)
//   Latency : 2 clock edges (edge n captures the input, edge n+1 captures the result). 1 result / clock.
//   Reset   : only valid regs are reset (async assert, active-low i_rst_n). Data regs free-run.
//             o_result / o_flag_* are don't care while o_valid = 0.
// -----------------------------------------------------------------------------
module alu_top #(
    parameter   XLEN            = 32    ,   // data width (8, 16, 32)
    parameter   ADDER_ARCH      = 4     ,
    parameter   SHIFTER_ARCH    = 1
)(
                    i_clk           ,
                    i_rst_n         ,
                    i_valid         ,
                    i_a             ,
                    i_b             ,
                    i_alu_op        ,
                    o_valid         ,
                    o_result        ,
                    o_flag_zero     ,
                    o_flag_neg      ,
                    o_flag_carry    ,
                    o_flag_ovf
);

input   wire                i_clk           ;
input   wire                i_rst_n         ;
input   wire                i_valid         ;
input   wire    [XLEN-1:0]  i_a             ;
input   wire    [XLEN-1:0]  i_b             ;
input   wire    [3:0]       i_alu_op        ;
output  wire                o_valid         ;
output  wire    [XLEN-1:0]  o_result        ;
output  wire                o_flag_zero     ;
output  wire                o_flag_neg      ;
output  wire                o_flag_carry    ;
output  wire                o_flag_ovf      ;

// ---- input registers -----------------------------------------------------
reg     [XLEN-1:0]  a_q             ;
reg     [XLEN-1:0]  b_q             ;
reg     [3:0]       op_q            ;
reg                 valid_in_q      ;

always @(posedge i_clk) begin
    a_q     <=  i_a         ;
    b_q     <=  i_b         ;
    op_q    <=  i_alu_op    ;
end

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)   valid_in_q  <=  1'b0    ;
    else            valid_in_q  <=  i_valid ;
end

// ---- combinational core --------------------------------------------------
wire    [XLEN-1:0]  w_result        ;
wire                w_flag_zero     ;
wire                w_flag_neg      ;
wire                w_flag_carry    ;
wire                w_flag_ovf      ;

alu_core #(.XLEN(XLEN), .ADDER_ARCH(ADDER_ARCH), .SHIFTER_ARCH(SHIFTER_ARCH)) u_core (
    .i_a            (a_q            ),
    .i_b            (b_q            ),
    .i_alu_op       (op_q           ),
    .o_result       (w_result       ),
    .o_flag_zero    (w_flag_zero    ),
    .o_flag_neg     (w_flag_neg     ),
    .o_flag_carry   (w_flag_carry   ),
    .o_flag_ovf     (w_flag_ovf     )
);

// ---- output registers ----------------------------------------------------
reg     [XLEN-1:0]  result_q        ;
reg     [3:0]       flag_q          ;   // {zero, neg, carry, ovf}
reg                 valid_out_q     ;

always @(posedge i_clk) begin
    result_q    <=  w_result                                                    ;
    flag_q      <=  {w_flag_zero, w_flag_neg, w_flag_carry, w_flag_ovf}         ;
end

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)   valid_out_q <=  1'b0        ;
    else            valid_out_q <=  valid_in_q  ;
end

assign  o_valid         =   valid_out_q ;
assign  o_result        =   result_q    ;
assign  o_flag_zero     =   flag_q[3]   ;
assign  o_flag_neg      =   flag_q[2]   ;
assign  o_flag_carry    =   flag_q[1]   ;
assign  o_flag_ovf      =   flag_q[0]   ;

endmodule
`default_nettype wire

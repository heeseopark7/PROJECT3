`default_nettype none
`include "alu_defs.vh"
// -----------------------------------------------------------------------------
// alu_core
//   Purpose : Pure combinational ALU (10 ops + Reserved codes) with 4 status flags.
//   Structure: ADD/SUB/SLT/SLTU share ONE adder (adder_top):
//                sub = op is SUB/SLT/SLTU,  b_eff = b XOR sub,  {cout, sum} = a + b_eff + sub
//                ovf = (a[M] == b_eff[M]) & (sum[M] != a[M])
//                SLT bit = sum[M] XOR ovf,  SLTU bit = ~cout
//              SLL/SRL/SRA share one shifter (alu_shifter), shamt = i_b[log2(XLEN)-1:0].
//              XOR/OR/AND are plain bit operations. A case statement picks the result.
//              zero / neg are taken from the selected result; carry / ovf only for ADD/SUB/SLT/SLTU.
//   Latency : 0 (combinational)
//   Reserved op codes: result = 0, zero = 1, other flags 0.
//   Note    : No '+' '-' '*' here. Every addition goes through adder_top.
// -----------------------------------------------------------------------------
module alu_core #(
    parameter   XLEN            = 32    ,   // data width (8, 16, 32)
    parameter   ADDER_ARCH      = 4     ,
    parameter   SHIFTER_ARCH    = 1
)(
                    i_a             ,
                    i_b             ,
                    i_alu_op        ,
                    o_result        ,
                    o_flag_zero     ,
                    o_flag_neg      ,
                    o_flag_carry    ,
                    o_flag_ovf
);

// Shift-amount width = log2(XLEN) (XLEN is 8, 16 or 32 only)
localparam  SHAMT_W =   (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5)    ;
localparam  M       =   XLEN - 1                                    ;   // MSB index

input   wire    [XLEN-1:0]  i_a             ;
input   wire    [XLEN-1:0]  i_b             ;
input   wire    [3:0]       i_alu_op        ;
output  wire    [XLEN-1:0]  o_result        ;
output  wire                o_flag_zero     ;
output  wire                o_flag_neg      ;
output  wire                o_flag_carry    ;
output  wire                o_flag_ovf      ;

// ---- adder sharing -------------------------------------------------------
wire                w_sub       ;   // 1 for SUB, SLT, SLTU
wire    [XLEN-1:0]  w_b_eff     ;   // b inverted when subtracting
wire    [XLEN-1:0]  w_sum       ;
wire                w_cout      ;
wire                w_ovf       ;
wire                w_slt_bit   ;
wire                w_sltu_bit  ;

assign  w_sub       =   (i_alu_op == `ALU_SUB) | (i_alu_op == `ALU_SLT) | (i_alu_op == `ALU_SLTU)   ;
assign  w_b_eff     =   i_b ^ {XLEN{w_sub}}                                 ;

adder_top #(.W(XLEN), .ADDER_ARCH(ADDER_ARCH)) u_adder (
    .i_a        (i_a        ),
    .i_b        (w_b_eff    ),
    .i_cin      (w_sub      ),
    .o_sum      (w_sum      ),
    .o_cout     (w_cout     )
);

assign  w_ovf       =   (i_a[M] == w_b_eff[M]) & (w_sum[M] != i_a[M])       ;
assign  w_slt_bit   =   w_sum[M] ^ w_ovf                                    ;
assign  w_sltu_bit  =   ~w_cout                                             ;

// ---- shifter sharing -----------------------------------------------------
wire                w_shift_right   ;   // SRL, SRA
wire                w_shift_arith   ;   // SRA
wire    [XLEN-1:0]  w_shift_out     ;

assign  w_shift_right   =   (i_alu_op == `ALU_SRL) | (i_alu_op == `ALU_SRA) ;
assign  w_shift_arith   =   (i_alu_op == `ALU_SRA)                          ;

alu_shifter #(.XLEN(XLEN), .SHIFTER_ARCH(SHIFTER_ARCH)) u_shifter (
    .i_din      (i_a                    ),
    .i_shamt    (i_b[SHAMT_W-1:0]       ),
    .i_right    (w_shift_right          ),
    .i_arith    (w_shift_arith          ),
    .o_dout     (w_shift_out            )
);

// ---- result select and carry/ovf validity --------------------------------
reg     [XLEN-1:0]  r_result    ;
reg                 r_carry     ;
reg                 r_ovf       ;

always @* begin
    r_result    =   {XLEN{1'b0}}    ;
    r_carry     =   1'b0            ;
    r_ovf       =   1'b0            ;
    case (i_alu_op)
        `ALU_ADD,
        `ALU_SUB    : begin
            r_result    =   w_sum                           ;
            r_carry     =   w_cout                          ;
            r_ovf       =   w_ovf                           ;
        end
        `ALU_SLT    : begin
            r_result    =   {{(XLEN-1){1'b0}}, w_slt_bit}   ;
            r_carry     =   w_cout                          ;
            r_ovf       =   w_ovf                           ;
        end
        `ALU_SLTU   : begin
            r_result    =   {{(XLEN-1){1'b0}}, w_sltu_bit}  ;
            r_carry     =   w_cout                          ;
            r_ovf       =   w_ovf                           ;
        end
        `ALU_SLL,
        `ALU_SRL,
        `ALU_SRA    : r_result  =   w_shift_out             ;
        `ALU_XOR    : r_result  =   i_a ^ i_b               ;
        `ALU_OR     : r_result  =   i_a | i_b               ;
        `ALU_AND    : r_result  =   i_a & i_b               ;
        default     : r_result  =   {XLEN{1'b0}}            ;   // Reserved op codes
    endcase
end

// ---- outputs and flags ---------------------------------------------------
assign  o_result        =   r_result                    ;
assign  o_flag_zero     =   (r_result == {XLEN{1'b0}})  ;
assign  o_flag_neg      =   r_result[M]                 ;
assign  o_flag_carry    =   r_carry                     ;
assign  o_flag_ovf      =   r_ovf                       ;

endmodule
`default_nettype wire

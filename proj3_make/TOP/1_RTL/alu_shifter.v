// -----------------------------------------------------------------------------
// alu_shifter
//   Shared right shifter (log shifter) used for SLL / SRL / SRA.
//   - Left shift is done by: reverse input -> right shift -> reverse output.
//   - Each stage k shifts by 2**k when i_shamt[k] is 1, otherwise passes through.
//   - Fill bit is 1 only for arithmetic right shift of a negative value (SRA).
// -----------------------------------------------------------------------------
module alu_shifter #(
    parameter   XLEN    = 32                // data width (8, 16, 32)
)(
                    i_din       ,
                    i_shamt     ,
                    i_right     ,
                    i_arith     ,
                    o_dout
);

// Shift-amount width and number of shift stages (= log2(XLEN))
localparam  SHAMT_W =   $clog2(XLEN);

input   [XLEN-1:0]      i_din               ;   // data to shift
input   [SHAMT_W-1:0]   i_shamt             ;   // shift amount
input                   i_right             ;   // 1: right shift, 0: left shift
input                   i_arith             ;   // 1: arithmetic (only valid when i_right = 1)
output  [XLEN-1:0]      o_dout              ;   // shifted result

wire                    w_fill              ;   // bit shifted in at the empty positions
wire    [XLEN-1:0]      w_rev_din           ;   // bit-reversed input
wire    [XLEN-1:0]      w_stg[0:SHAMT_W]    ;   // stage levels: [0] = shifter input, [SHAMT_W] = shifter output
wire    [XLEN-1:0]      w_rev_dout          ;   // bit-reversed shifter output

// Fill = 1 only for SRA with a negative input (sign bit copied).
// SLL and SRL always fill with 0 because i_right = 0 or i_arith = 0.
assign  w_fill  = (i_right) & (i_arith) & (i_din[XLEN-1])       ;

// Input mux: right shift uses the input as is, left shift uses the reversed input.
assign  w_stg[0]   = i_right ? i_din : w_rev_din                ;

// Output mux: right shift uses the result as is, left shift reverses it back.
assign  o_dout  = i_right ? w_stg[SHAMT_W] : w_rev_dout ;

// Reverse the input bit order: w_rev_din[i] = i_din[XLEN-1-i]
genvar                  gi          ;
generate
    for     (gi = 0 ; gi < XLEN ; gi = gi + 1)
    begin : g_rev
        assign w_rev_din[gi] = i_din[XLEN-1-gi];
    end
endgenerate

// Shift stages: stage gk shifts right by 2**gk when i_shamt[gk] = 1.
//   Upper 2**gk bits are filled with w_fill, lower bits take the upper part of the previous level.
//   When i_shamt[gk] = 0 the previous level passes through unchanged.
genvar                  gk          ;
generate
    for     (gk = 0 ; gk < SHAMT_W ; gk = gk + 1)
    begin : g_stage
        assign  w_stg[gk+1] = i_shamt[gk] ? {{(2**gk){w_fill}}, w_stg[gk][XLEN-1:2**gk]}: w_stg[gk];
    end
endgenerate

// Reverse the shifter output bit order: w_rev_dout[i] = w_stg[SHAMT_W][XLEN-1-i]
genvar                  gl          ;
generate
    for     (gl = 0 ; gl < XLEN ; gl = gl + 1)
    begin : g_rev_out
        assign w_rev_dout[gl] = w_stg[SHAMT_W][XLEN-1-gl];
    end
endgenerate

endmodule
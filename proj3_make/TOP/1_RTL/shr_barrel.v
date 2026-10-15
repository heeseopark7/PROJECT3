`default_nettype none
// -----------------------------------------------------------------------------
// shr_barrel
//   Purpose : Logical right-shift core (barrel / log shifter). Fill bit comes from outside,
//             so the same core gives SRL (fill = 0) and SRA (fill = sign bit).
//   Structure: log2(XLEN) stages in series. Stage k shifts right by 2**k when i_shamt[k]=1,
//             otherwise passes through (a 2:1 mux per bit). No variable shift operator.
//   Latency : 0 (combinational)
// -----------------------------------------------------------------------------
module shr_barrel #(
    parameter   XLEN    = 32                // data width (8, 16, 32)
)(
                i_din       ,
                i_shamt     ,
                i_fill      ,
                o_dout
);

// Number of stages = shift-amount width = log2(XLEN) (XLEN is 8, 16 or 32 only)
localparam  SHAMT_W =   (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5)    ;

input   wire    [XLEN-1:0]      i_din       ;   // data to shift
input   wire    [SHAMT_W-1:0]   i_shamt     ;   // shift amount
input   wire                    i_fill      ;   // bit shifted in at the upper positions
output  wire    [XLEN-1:0]      o_dout      ;   // shifted result

// Stage levels packed in one vector: level k = w_stg[k*XLEN +: XLEN]
//   level 0 = shifter input, level SHAMT_W = shifter output
//   (split_var: lint hint only, tells Verilator the slices are separate signals, not a loop)
wire    [(SHAMT_W+1)*XLEN-1:0]  w_stg       /* verilator split_var */ ;

assign  w_stg[0 +: XLEN]    =   i_din       ;
assign  o_dout              =   w_stg[SHAMT_W*XLEN +: XLEN] ;

// Stage gk: shift right by 2**gk when i_shamt[gk] = 1.
//   Upper 2**gk bits take i_fill, the rest take the upper part of the previous level.
genvar                  gk          ;
generate
    for     (gk = 0 ; gk < SHAMT_W ; gk = gk + 1)
    begin : g_stage
        assign  w_stg[(gk+1)*XLEN +: XLEN]  =   i_shamt[gk]
                ? {{(2**gk){i_fill}}, w_stg[gk*XLEN + 2**gk +: XLEN-2**gk]}
                : w_stg[gk*XLEN +: XLEN]    ;
    end
endgenerate

endmodule
`default_nettype wire

`default_nettype none
// -----------------------------------------------------------------------------
// shr_loop
//   Purpose : Logical right-shift core, "one bit at a time" version (loop shifter). Same ports as
//             shr_barrel; the fill bit comes from outside, so one core gives SRL and SRA.
//   Structure: XLEN-1 single-bit shift stages in series. Stage k moves the data right by ONE bit
//             when i_shamt > k, otherwise passes it through (a 2:1 mux per bit plus a constant
//             comparison i_shamt > k per stage). Shifting by s therefore passes s active stages.
//             The stage levels are slices of one packed vector. No variable shift operator.
//   Latency : 0 (combinational)
//   Note    : i_shamt <= XLEN-1, so a stage XLEN-1 would never be active and is not built.
// -----------------------------------------------------------------------------
module shr_loop #(
    parameter   XLEN    = 32                // data width (8, 16, 32)
)(
                i_din       ,
                i_shamt     ,
                i_fill      ,
                o_dout
);

// Shift-amount width = log2(XLEN) (XLEN is 8, 16 or 32 only)
localparam  SHAMT_W =   (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5)    ;
localparam  NSTG    =   XLEN - 1                                    ;   // number of one-bit stages

input   wire    [XLEN-1:0]      i_din       ;   // data to shift
input   wire    [SHAMT_W-1:0]   i_shamt     ;   // shift amount
input   wire                    i_fill      ;   // bit shifted in at the upper positions
output  wire    [XLEN-1:0]      o_dout      ;   // shifted result

// Stage levels packed in one vector: level k = w_stg[k*XLEN +: XLEN]
//   level 0 = shifter input, level NSTG = shifter output
//   (split_var: lint hint only, tells the lint tool the slices are separate signals, not a loop)
wire    [(NSTG+1)*XLEN-1:0]     w_stg       /* verilator split_var */ ;

assign  w_stg[0 +: XLEN]    =   i_din       ;
assign  o_dout              =   w_stg[NSTG*XLEN +: XLEN]    ;

// Stage gk: shift right by one bit when i_shamt > gk.
genvar                  gk          ;
generate
    for     (gk = 0 ; gk < NSTG ; gk = gk + 1)
    begin : g_stage
        localparam  [SHAMT_W-1:0]   K   =   gk  ;       // stage index as a SHAMT_W-bit constant
        wire                        w_active    ;
        assign  w_active    =   (i_shamt > K)   ;
        assign  w_stg[(gk+1)*XLEN +: XLEN]  =   w_active
                ? {i_fill, w_stg[gk*XLEN + 1 +: XLEN-1]}
                : w_stg[gk*XLEN +: XLEN]    ;
    end
endgenerate

endmodule
`default_nettype wire

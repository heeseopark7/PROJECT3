`default_nettype none
// -----------------------------------------------------------------------------
// shr_loop
//   Purpose : Logical right-shift core, "one bit at a time" version (loop shifter). Same ports as
//             shr_barrel; the fill bit comes from outside, so one core gives SRL and SRA.
//   Structure: XLEN-1 single-bit shift stages in series. Stage k moves the data right by ONE bit
//             when i_shamt > k, otherwise passes it through (a 2:1 mux per bit plus a constant
//             comparison i_shamt > k per stage). Shifting by s therefore passes s active stages.
//             No variable shift operator.
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

// Each stage owns its own input/output wires (g_stage[k].w_in / .w_out) and takes its input from the
// previous stage's w_out by hierarchical reference. A single packed vector shared by all 31 stages
// (as in shr_barrel) makes the simulator re-evaluate every stage on every change and glitches cascade
// (2000 vectors took > 90 s in iverilog); separate nets avoid that.
genvar                  gk          ;
generate
    for     (gk = 0 ; gk < NSTG ; gk = gk + 1)
    begin : g_stage
        localparam  [SHAMT_W-1:0]   K   =   gk  ;       // stage index as a SHAMT_W-bit constant
        wire    [XLEN-1:0]          w_in        ;
        wire    [XLEN-1:0]          w_out       ;
        wire                        w_active    ;
        if (gk == 0)
        begin : g_first
            assign  w_in    =   i_din               ;
        end
        else
        begin : g_next
            assign  w_in    =   g_stage[gk-1].w_out ;
        end
        // Shift right by one bit when i_shamt > gk.
        assign  w_active    =   (i_shamt > K)                       ;
        assign  w_out       =   w_active ? {i_fill, w_in[XLEN-1:1]} : w_in  ;
    end
endgenerate

assign  o_dout  =   g_stage[NSTG-1].w_out   ;

endmodule
`default_nettype wire

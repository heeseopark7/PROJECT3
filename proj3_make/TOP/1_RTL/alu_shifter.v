`default_nettype none
// -----------------------------------------------------------------------------
// alu_shifter
//   Purpose : SLL / SRL / SRA shifter for the ALU.
//   Structure: one right-shift core (shr_loop or shr_barrel) shared by all three ops.
//              Left shift = reverse input bits -> right shift -> reverse output bits.
//              Fill bit = 1 only for SRA of a negative value (i_arith & sign bit).
//   Latency : 0 (combinational)
//   SHIFTER_ARCH : 0 loop (shr_loop)   1 barrel (shr_barrel, default)
//   Note    : An unimplemented SHIFTER_ARCH (or XLEN) is NOT replaced by another core.
//             It instantiates a module that does not exist, so elaboration fails.
// -----------------------------------------------------------------------------
module alu_shifter #(
    parameter   XLEN            = 32    ,   // data width (8, 16, 32)
    parameter   SHIFTER_ARCH    = 1
)(
                    i_din       ,
                    i_shamt     ,
                    i_right     ,
                    i_arith     ,
                    o_dout
);

// Shift-amount width = log2(XLEN) (XLEN is 8, 16 or 32 only)
localparam  SHAMT_W =   (XLEN == 8) ? 3 : ((XLEN == 16) ? 4 : 5)    ;

input   wire    [XLEN-1:0]      i_din       ;   // data to shift
input   wire    [SHAMT_W-1:0]   i_shamt     ;   // shift amount
input   wire                    i_right     ;   // 1: right shift, 0: left shift
input   wire                    i_arith     ;   // 1: arithmetic (only meaningful when i_right = 1)
output  wire    [XLEN-1:0]      o_dout      ;   // shifted result

wire                    w_fill      ;   // bit shifted in at the empty positions
wire    [XLEN-1:0]      w_rev_din   ;   // bit-reversed input
wire    [XLEN-1:0]      w_core_din  ;   // core input  (as is for right shift, reversed for left shift)
wire    [XLEN-1:0]      w_core_dout ;   // core output
wire    [XLEN-1:0]      w_rev_dout  ;   // bit-reversed core output

// Fill = 1 only for SRA with a negative input. SLL/SRL: i_right = 0 or i_arith = 0 -> fill 0.
assign  w_fill      =   i_right & i_arith & i_din[XLEN-1]       ;

// Input mux / output mux: right shift passes through, left shift goes through bit reversal.
assign  w_core_din  =   i_right ? i_din : w_rev_din             ;
assign  o_dout      =   i_right ? w_core_dout : w_rev_dout      ;

// Bit reversal: w_rev_din[i] = i_din[XLEN-1-i], w_rev_dout[i] = w_core_dout[XLEN-1-i]
genvar                  gi          ;
generate
    for     (gi = 0 ; gi < XLEN ; gi = gi + 1)
    begin : g_rev
        assign  w_rev_din[gi]   =   i_din[XLEN-1-gi]            ;
        assign  w_rev_dout[gi]  =   w_core_dout[XLEN-1-gi]      ;
    end
endgenerate

// Core selection
generate
    if ((XLEN == 8 || XLEN == 16 || XLEN == 32) && SHIFTER_ARCH == 0)
    begin : g_loop
        shr_loop #(.XLEN(XLEN)) u_core (
            .i_din      (w_core_din ),
            .i_shamt    (i_shamt    ),
            .i_fill     (w_fill     ),
            .o_dout     (w_core_dout)
        );
    end
    else if ((XLEN == 8 || XLEN == 16 || XLEN == 32) && SHIFTER_ARCH == 1)
    begin : g_barrel
        shr_barrel #(.XLEN(XLEN)) u_core (
            .i_din      (w_core_din ),
            .i_shamt    (i_shamt    ),
            .i_fill     (w_fill     ),
            .o_dout     (w_core_dout)
        );
    end
    else
    begin : g_unsupported
        // Intentionally missing module: this XLEN / SHIFTER_ARCH is not implemented -> elaboration error.
        shifter_arch_not_implemented u_unsupported ();
    end
endgenerate

endmodule
`default_nettype wire

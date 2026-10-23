`default_nettype none
// -----------------------------------------------------------------------------
// mac_chip_top
//   Purpose : Chip-level top for PnR. Wraps mac_top with input / output pad cells.
//             mac_top itself stays pad-free so variant comparison in synthesis is not
//             affected by I/O cells.
//   Structure: input  pads  : i_clk, i_rst_n, i_a, i_b, i_en, i_clr   (pad -> w_ net)
//              mac_top      : u_mac (all ARCH / width parameters passed through)
//              output pads  : o_acc                                    (w_ net -> pad)
//   Latency : same as mac_top (MAC_STAGES + 1 clock edges). Pads add no clock edge.
//   Status  : SKELETON. Pad cell instances are not written yet (see TODO below).
// -----------------------------------------------------------------------------
module mac_chip_top #(
    parameter   A_W         = 16            ,   // operand width (4, 8, 16)
    parameter   ACC_W       = 2*A_W + 8     ,   // accumulator width (derived)
    parameter   MULT_ARCH   = 0             ,
    parameter   ADDER_ARCH  = 4             ,
    parameter   MAC_STAGES  = 1
)(
                i_clk   ,
                i_rst_n ,
                i_a     ,
                i_b     ,
                i_en    ,
                i_clr   ,
                o_acc
);

input   wire                            i_clk   ;
input   wire                            i_rst_n ;
input   wire    signed  [A_W-1:0]       i_a     ;
input   wire    signed  [A_W-1:0]       i_b     ;
input   wire                            i_en    ;
input   wire                            i_clr   ;
output  wire            [ACC_W-1:0]     o_acc   ;

// ---- nets between the pads and mac_top ----------------------------------------
wire                            w_clk   ;
wire                            w_rst_n ;
wire    signed  [A_W-1:0]       w_a     ;
wire    signed  [A_W-1:0]       w_b     ;
wire                            w_en    ;
wire                            w_clr   ;
wire            [ACC_W-1:0]     w_acc   ;

// ---- input pads : i_* port -> w_* net -------------------------------------------
// TODO: instantiate one input pad per bit (i_clk, i_rst_n, i_a[A_W-1:0], i_b[A_W-1:0], i_en, i_clr)
//       pad pin facing the core drives the matching w_ net above.
PADDI ipad1 (
    .PAD            (i_clk          ),
    .Y              (w_clk          )
);

PADDI ipad2 (
    .PAD            (i_rst_n        ),
    .Y              (w_rst_n        )
);

PADDI ipad3 [A_W-1:0](
    .PAD            (i_a            ),
    .Y              (w_a            )
);

PADDI ipad4 [A_W-1:0](
    .PAD            (i_b            ),
    .Y              (w_b            )
);

PADDI ipad5 (
    .PAD            (i_en           ),
    .Y              (w_en           )
);

PADDI ipad6 (
    .PAD            (i_clr          ),
    .Y              (w_clr          )
);

// ---- core -------------------------------------------------------------------------
mac_top #(.A_W(A_W), .ACC_W(ACC_W), .MULT_ARCH(MULT_ARCH), .ADDER_ARCH(ADDER_ARCH), .MAC_STAGES(MAC_STAGES)) u_mac (
    .i_clk          (w_clk          ),
    .i_rst_n        (w_rst_n        ),
    .i_a            (w_a            ),
    .i_b            (w_b            ),
    .i_en           (w_en           ),
    .i_clr          (w_clr          ),
    .o_acc          (w_acc          )
);

// ---- output pads : w_* net -> o_* port ------------------------------------------
// TODO: instantiate one output pad per bit (o_acc[ACC_W-1:0])
//       the matching w_ net above drives the pad pin facing the core.
PADDO opad1 [ACC_W-1:0](
    .A              (w_acc          ),
    .PAD            (o_acc          )
);
endmodule
`default_nettype wire

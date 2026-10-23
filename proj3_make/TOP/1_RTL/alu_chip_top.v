`default_nettype none
// -----------------------------------------------------------------------------
// alu_chip_top
//   Purpose : Chip-level top for PnR. Wraps alu_top with input / output pad cells.
//             alu_top itself stays pad-free so variant comparison in synthesis is not
//             affected by I/O cells.
//   Structure: input  pads  : i_clk, i_rst_n, i_valid, i_a, i_b, i_alu_op   (pad -> w_ net)
//              alu_top      : u_alu (all ARCH parameters passed through)
//              output pads  : o_valid, o_result, o_flag_*                    (w_ net -> pad)
//   Latency : same as alu_top (2 clock edges). Pads add no clock edge.
//   Status  : SKELETON. Pad cell instances are not written yet (see TODO below).
// -----------------------------------------------------------------------------
module alu_chip_top #(
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

// ---- nets between the pads and alu_top ----------------------------------------
wire                w_clk           ;
wire                w_rst_n         ;
wire                w_valid_in      ;
wire    [XLEN-1:0]  w_a             ;
wire    [XLEN-1:0]  w_b             ;
wire    [3:0]       w_alu_op        ;
wire                w_valid_out     ;
wire    [XLEN-1:0]  w_result        ;
wire                w_flag_zero     ;
wire                w_flag_neg      ;
wire                w_flag_carry    ;
wire                w_flag_ovf      ;

// ---- input pads : i_* port -> w_* net -------------------------------------------
// TODO: instantiate one input pad per bit (i_clk, i_rst_n, i_valid, i_a[XLEN-1:0], i_b[XLEN-1:0], i_alu_op[3:0])
//       pad pin facing the core drives the matching w_ net above.
PADDI ipad1(
    .PAD            (i_clk          ),
    .Y              (w_clk          )
);

PADDI ipad2(
    .PAD            (i_rst_n        ),
    .Y              (w_rst_n        )
);

PADDI ipad3(
    .PAD            (i_valid        ),
    .Y              (w_valid        )
);

PADDI ipad4[XLEN-1:0](
    .PAD            (i_a            ),
    .Y              (w_a            )
);

PADDI ipad5[XLEN-1:0](
    .PAD            (i_b            ),
    .Y              (w_b            )
);

PADDI ipad6[3:0](
    .PAD            (i_alu_op       ),
    .Y              (w_alu_op       )
);

// ---- core -------------------------------------------------------------------------
alu_top #(.XLEN(XLEN), .ADDER_ARCH(ADDER_ARCH), .SHIFTER_ARCH(SHIFTER_ARCH)) u_alu (
    .i_clk          (w_clk          ),
    .i_rst_n        (w_rst_n        ),
    .i_valid        (w_valid_in     ),
    .i_a            (w_a            ),
    .i_b            (w_b            ),
    .i_alu_op       (w_alu_op       ),
    .o_valid        (w_valid_out    ),
    .o_result       (w_result       ),
    .o_flag_zero    (w_flag_zero    ),
    .o_flag_neg     (w_flag_neg     ),
    .o_flag_carry   (w_flag_carry   ),
    .o_flag_ovf     (w_flag_ovf     )
);

// ---- output pads : w_* net -> o_* port ------------------------------------------
// TODO: instantiate one output pad per bit (o_valid, o_result[XLEN-1:0], o_flag_zero/neg/carry/ovf)
//       the matching w_ net above drives the pad pin facing the core.

PADDO opad1(
    .A              (w_valid        ),
    .PAD            (o_valid        )
);

PADDO opad2[XLEN-1:0](
    .A              (w_result       ),
    .PAD            (o_result       )
);

PADDO opad3(
    .A              (w_flag_zero    ),
    .PAD            (o_flag_zero    )
);

PADDO opad4(
    .A              (w_flag_zero    ),
    .PAD            (o_flag_zero    )
);

PADDO opad5(
    .A              (w_flag_neg     ),
    .Y              (o_flag_neg     )
);

PADDO opad6(
    .A              (w_flag_carry   ),
    .Y              (o_flag_carry   )
);

PADDO opad7(
    .A              (w_flag_ovf     ),
    .Y              (o_flag_ovf     )
);

endmodule
`default_nettype wire

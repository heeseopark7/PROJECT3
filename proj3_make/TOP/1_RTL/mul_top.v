`default_nettype none
// -----------------------------------------------------------------------------
// mul_top
//   Purpose : Single multiplier entry point (full product). Architecture chosen by MULT_ARCH,
//             same ports for every choice.
//   Structure: generate-select of one multiplier module.
//                0 BEH (mul_beh, default)   1 Array (reserved)   2 Booth radix-4 + Wallace (reserved)
//   Latency : 0 (combinational)
//   Note    : An unimplemented MULT_ARCH (or A_W) is NOT replaced by another multiplier.
//             It instantiates a module that does not exist, so compile/elaboration fails.
//             The structured variants (stage 2) will also take ADDER_ARCH for their final addition.
// -----------------------------------------------------------------------------
module mul_top #(
    parameter   A_W         = 16    ,   // operand width (4, 8, 16)
    parameter   MULT_ARCH   = 0
)(
                i_a     ,
                i_b     ,
                o_p
);

input   wire    signed  [A_W-1:0]       i_a     ;
input   wire    signed  [A_W-1:0]       i_b     ;
output  wire    signed  [2*A_W-1:0]     o_p     ;

generate
    if ((A_W == 4 || A_W == 8 || A_W == 16) && MULT_ARCH == 0)
    begin : g_beh
        mul_beh #(.A_W(A_W)) u_mul (
            .i_a    (i_a    ),
            .i_b    (i_b    ),
            .o_p    (o_p    )
        );
    end
    else
    begin : g_unsupported
        // Intentionally missing module: this A_W / MULT_ARCH is not implemented yet -> elaboration error.
        mul_arch_not_implemented u_unsupported ();
    end
endgenerate

endmodule
`default_nettype wire

`default_nettype none
// -----------------------------------------------------------------------------
// mul_csa_top
//   Purpose : Entry point for the structured multipliers that stop at carry-save form.
//             Returns o_s, o_c with  o_s + o_c == i_a * i_b  (mod 2**(2*A_W)).
//   Structure: generate-select of one module by MULT_ARCH:
//                1 Array (mul_array_csa)    2 Booth radix-4 + Wallace (reserved)
//              MULT_ARCH = 0 (BEH) has no carry-save form and is NOT supported here.
//   Latency : 0 (combinational)
//   Note    : An unimplemented MULT_ARCH (or A_W) is NOT replaced by another multiplier.
//             It instantiates a module that does not exist, so elaboration fails.
// -----------------------------------------------------------------------------
module mul_csa_top #(
    parameter   A_W         = 16    ,   // operand width (4, 8, 16)
    parameter   MULT_ARCH   = 1
)(
                i_a     ,
                i_b     ,
                o_s     ,
                o_c
);

input   wire    signed  [A_W-1:0]       i_a     ;
input   wire    signed  [A_W-1:0]       i_b     ;
output  wire            [2*A_W-1:0]     o_s     ;
output  wire            [2*A_W-1:0]     o_c     ;

generate
    if ((A_W == 4 || A_W == 8 || A_W == 16) && MULT_ARCH == 1)
    begin : g_array
        mul_array_csa #(.A_W(A_W)) u_mul (
            .i_a    (i_a    ),
            .i_b    (i_b    ),
            .o_s    (o_s    ),
            .o_c    (o_c    )
        );
    end
    else
    begin : g_unsupported
        // Intentionally missing module: this A_W / MULT_ARCH has no carry-save multiplier yet -> elaboration error.
        mul_csa_arch_not_implemented u_unsupported ();
    end
endgenerate

endmodule
`default_nettype wire

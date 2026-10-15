`default_nettype none
// -----------------------------------------------------------------------------
// mul_top
//   Purpose : Single multiplier entry point (full product). Architecture chosen by MULT_ARCH,
//             same ports for every choice.
//   Structure: generate-select:
//                0 BEH    : mul_beh (one signed '*')
//                1 Array  : mul_csa_top (carry-save) -> adder_top (final addition, ADDER_ARCH)
//                2 Booth radix-4 + Wallace: same shape as 1 (mul_csa_top -> adder_top)
//   Latency : 0 (combinational)
//   Note    : An unimplemented MULT_ARCH (or A_W) is NOT replaced by another multiplier.
//             It instantiates a module that does not exist, so compile/elaboration fails.
//             The final carry-propagate addition of the structured variants goes through adder_top.
// -----------------------------------------------------------------------------
module mul_top #(
    parameter   A_W         = 16    ,   // operand width (4, 8, 16)
    parameter   MULT_ARCH   = 0     ,
    parameter   ADDER_ARCH  = 4
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
    else if (A_W == 4 || A_W == 8 || A_W == 16)
    begin : g_csa
        // MULT_ARCH 1 (Array) and 2 (Booth); any other value makes mul_csa_top fail at elaboration.
        wire    [2*A_W-1:0]     w_s     ;
        wire    [2*A_W-1:0]     w_c     ;
        wire    [2*A_W-1:0]     w_sum   ;
        // The carry-out of the final addition is not needed: the product is taken mod 2**(2*A_W).
        /* verilator lint_off UNUSEDSIGNAL */
        wire                    w_cout  ;
        /* verilator lint_on UNUSEDSIGNAL */

        mul_csa_top #(.A_W(A_W), .MULT_ARCH(MULT_ARCH)) u_csa (
            .i_a    (i_a    ),
            .i_b    (i_b    ),
            .o_s    (w_s    ),
            .o_c    (w_c    )
        );

        adder_top #(.W(2*A_W), .ADDER_ARCH(ADDER_ARCH)) u_adder (
            .i_a    (w_s    ),
            .i_b    (w_c    ),
            .i_cin  (1'b0   ),
            .o_sum  (w_sum  ),
            .o_cout (w_cout )
        );

        assign  o_p =   w_sum   ;
    end
    else
    begin : g_unsupported
        // Intentionally missing module: this A_W is not implemented -> elaboration error.
        mul_arch_not_implemented u_unsupported ();
    end
endgenerate

endmodule
`default_nettype wire

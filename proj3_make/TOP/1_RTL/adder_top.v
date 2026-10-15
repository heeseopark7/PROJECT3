`default_nettype none
// -----------------------------------------------------------------------------
// adder_top
//   Purpose : Single adder entry point. Every addition in the design goes through here.
//             The architecture is chosen with ADDER_ARCH (same ports for every choice).
//   Structure: generate-select of one adder module.
//                0 RCA (adder_rca)   1 CLA (reserved)   2 Kogge-Stone (adder_ks)
//                3 Brent-Kung (reserved)   4 BEH (adder_beh, default)
//   Latency : 0 (combinational)
//   Note    : An unimplemented ADDER_ARCH is NOT replaced by another adder.
//             It instantiates a module that does not exist, so compile/elaboration fails.
// -----------------------------------------------------------------------------
module adder_top #(
    parameter   W           = 32    ,
    parameter   ADDER_ARCH  = 4
)(
                i_a     ,
                i_b     ,
                i_cin   ,
                o_sum   ,
                o_cout
);

input   wire    [W-1:0] i_a     ;
input   wire    [W-1:0] i_b     ;
input   wire            i_cin   ;
output  wire    [W-1:0] o_sum   ;
output  wire            o_cout  ;

generate
    if (ADDER_ARCH == 0)
    begin : g_rca
        adder_rca #(.W(W)) u_adder (
            .i_a    (i_a    ),
            .i_b    (i_b    ),
            .i_cin  (i_cin  ),
            .o_sum  (o_sum  ),
            .o_cout (o_cout )
        );
    end
    else if (ADDER_ARCH == 2)
    begin : g_ks
        adder_ks #(.W(W)) u_adder (
            .i_a    (i_a    ),
            .i_b    (i_b    ),
            .i_cin  (i_cin  ),
            .o_sum  (o_sum  ),
            .o_cout (o_cout )
        );
    end
    else if (ADDER_ARCH == 4)
    begin : g_beh
        adder_beh #(.W(W)) u_adder (
            .i_a    (i_a    ),
            .i_b    (i_b    ),
            .i_cin  (i_cin  ),
            .o_sum  (o_sum  ),
            .o_cout (o_cout )
        );
    end
    else
    begin : g_unsupported
        // Intentionally missing module: ADDER_ARCH is not implemented yet -> elaboration error.
        adder_arch_not_implemented u_unsupported ();
    end
endgenerate

endmodule
`default_nettype wire

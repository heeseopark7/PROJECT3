`default_nettype none
// -----------------------------------------------------------------------------
// mul_booth_csa
//   Purpose : Signed multiplier, radix-4 Booth recoding + Wallace-tree compression, stopping before the
//             final carry-propagate addition. Outputs two vectors with  o_s + o_c == i_a * i_b  (mod 2**(2*A_W)).
//   Structure: n = A_W (even), m = n/2.
//              1) Booth recoding of b. Digit k (k = 0..m-1) looks at (b[2k+1], b[2k], b[2k-1]), b[-1] = 0:
//                    d_k = -2*b[2k+1] + b[2k] + b[2k-1]   in {-2,-1,0,1,2}
//                 one_k = b[2k] ^ b[2k-1]                  (|d| = 1)
//                 two_k = (b[2k+1] & ~b[2k] & ~b[2k-1]) | (~b[2k+1] & b[2k] & b[2k-1])   (|d| = 2)
//                 neg_k = b[2k+1]                           (subtract)
//              2) Partial product k = d_k * a  (m rows instead of n): select a or 2a with one/two, XOR with neg
//                 (one's complement), and add the missing "+1" as a separate bit neg_k at weight 2k.
//                 The selected value has n+1 bits (a sign-extended to n+1 bits).
//              3) Sign-extension elimination: a row's sign bit s has weight -2**n, and -s*2**n = (~s)*2**n - 2**n.
//                 So each row keeps its n low bits, puts (~s) at relative bit n, and the -2**(n+2k) terms of all rows
//                 are collected into one constant K = -2**n * (2**n - 1)/3  (mod 2**(2n)). K has zeros in its
//                 low n bits, so the neg_k bits (weights 0..n-2, even) and K share ONE extra row.
//                 -> m + 1 rows.
//              4) Wallace tree: while more than 2 rows remain, group rows in threes and replace each group by a
//                 sum row and a carry row (3:2 compressors on whole rows, carry row shifted left by one); leftover
//                 rows pass through. m + 1 = 3, 5, 9 rows (A_W = 4, 8, 16) take 1, 3, 4 levels.
//              The last two rows are (o_s, o_c).
//   Latency : 0 (combinational). Depth: Booth select + about 1/3/4 compressor levels.
//   Note    : No '+' '-' '*' on data here; the constant K is computed at elaboration only.
// -----------------------------------------------------------------------------
module mul_booth_csa #(
    parameter   A_W     = 16            // operand width: even (4, 8, 16)
)(
                i_a     ,
                i_b     ,
                o_s     ,
                o_c
);

localparam  P_W     =   2*A_W           ;   // product / row width
localparam  M       =   A_W/2           ;   // number of Booth digits = partial product rows
localparam  R0      =   M + 1           ;   // rows entering the tree (M Booth rows + one constant/neg row)

input   wire    signed  [A_W-1:0]   i_a     ;
input   wire    signed  [A_W-1:0]   i_b     ;
output  wire            [P_W-1:0]   o_s     ;
output  wire            [P_W-1:0]   o_c     ;

// Elaboration-time helpers (constant functions). Row count after l compression levels, and number of levels.
function integer f_height;
    input integer fl;
    integer fi, fh;
    begin
        fh = R0;
        for (fi = 0; fi < fl; fi = fi + 1)
            fh = 2*(fh/3) + (fh - 3*(fh/3));
        f_height = fh;
    end
endfunction

function integer f_levels;
    input integer fr;
    integer fh, fn;
    begin
        fh = fr;
        fn = 0;
        while (fh > 2) begin
            fh = 2*(fh/3) + (fh - 3*(fh/3));
            fn = fn + 1;
        end
        f_levels = fn;
    end
endfunction

localparam  LV      =   f_levels(R0)    ;   // compression levels

// Sign-extension constant K = -(2**n) * ((2**n - 1) / 3)  mod 2**(2n)   (elaboration-time arithmetic)
localparam  [31:0]      K_FULL  =   -((2**A_W) * ((2**A_W - 1) / 3))    ;
localparam  [P_W-1:0]   K_BOOTH =   K_FULL[P_W-1:0]                     ;

// ---- row array: g_lvl[l].g_out[r].w_o is row r after l compression levels (level 0 = Booth rows) ----
genvar                  gl, gr, gp      ;
generate
    for     (gl = 0 ; gl <= LV ; gl = gl + 1)
    begin : g_lvl
        localparam  HOUT    =   f_height(gl)    ;   // rows leaving this level
        for     (gr = 0 ; gr < HOUT ; gr = gr + 1)
        begin : g_out
            wire    [P_W-1:0]   w_o     ;

            if (gl == 0)
            begin : g_src
                if (gr < M)
                begin : g_booth
                    // ---- Booth row k = gr ----
                    localparam  K   =   gr  ;
                    wire                w_hi    ;       // b[2k+1]
                    wire                w_mid   ;       // b[2k]
                    wire                w_lo    ;       // b[2k-1]
                    wire                w_one   ;
                    wire                w_two   ;
                    wire                w_neg   ;
                    wire    [A_W:0]     w_base  ;       // |d| * a, n+1 bits (before inversion)
                    wire    [A_W:0]     w_inner ;       // {~sign, low n bits} after the neg XOR

                    assign  w_hi    =   i_b[2*K+1]  ;
                    assign  w_mid   =   i_b[2*K]    ;
                    if (K == 0)
                    begin : g_lo0
                        assign  w_lo    =   1'b0        ;
                    end
                    else
                    begin : g_lon
                        assign  w_lo    =   i_b[2*K-1]  ;
                    end

                    assign  w_one   =   w_mid ^ w_lo                                                ;
                    assign  w_two   =   (w_hi & ~w_mid & ~w_lo) | (~w_hi & w_mid & w_lo)            ;
                    assign  w_neg   =   w_hi                                                        ;

                    // a sign-extended to n+1 bits, and a shifted left by one (2a), both n+1 bits
                    assign  w_base  =   ({(A_W+1){w_one}} & {i_a[A_W-1], i_a})
                                      | ({(A_W+1){w_two}} & {i_a, 1'b0})                            ;
                    assign  w_inner =   {~(w_base[A_W] ^ w_neg), w_base[A_W-1:0] ^ {A_W{w_neg}}}    ;

                    // place at weight 2k
                    if (K == 0)
                    begin : g_w0
                        assign  w_o =   {{(P_W-A_W-1){1'b0}}, w_inner}                      ;
                    end
                    else
                    begin : g_wn
                        assign  w_o =   {{(P_W-A_W-1-2*K){1'b0}}, w_inner, {(2*K){1'b0}}}   ;
                    end
                end
                else
                begin : g_const
                    // ---- constant row: the neg_k bits at weights 0, 2, .., n-2 and the constant K (zero below bit n) ----
                    for     (gp = 0 ; gp < P_W ; gp = gp + 1)
                    begin : g_bit
                        if (gp < A_W && (gp % 2) == 0)
                        begin : g_neg
                            assign  w_o[gp] =   i_b[gp+1]       ;   // neg_k = b[2k+1], weight 2k = gp
                        end
                        else
                        begin : g_k
                            assign  w_o[gp] =   K_BOOTH[gp]     ;
                        end
                    end
                end
            end
            else
            begin : g_cmp
                // ---- Wallace level: groups of three input rows -> (sum row, carry row); leftover rows pass ----
                localparam  HIN =   f_height(gl-1)  ;   // rows entering this level
                localparam  G   =   HIN/3           ;   // number of 3:2 groups
                if (gr < 2*G)
                begin : g_c32
                    localparam  IA  =   3*(gr/2)    ;   // first input row of this group
                    if ((gr % 2) == 0)
                    begin : g_sum
                        wire    [P_W-1:0]   w_x     ;
                        wire    [P_W-1:0]   w_y     ;
                        wire    [P_W-1:0]   w_z     ;
                        assign  w_x =   g_lvl[gl-1].g_out[IA].w_o   ;
                        assign  w_y =   g_lvl[gl-1].g_out[IA+1].w_o ;
                        assign  w_z =   g_lvl[gl-1].g_out[IA+2].w_o ;
                        assign  w_o =   w_x ^ w_y ^ w_z             ;
                    end
                    else
                    begin : g_carry
                        // majority, shifted left by one. The carry out of the top bit is dropped (mod 2**P_W),
                        // so only bits P_W-2..0 of the inputs are read.
                        wire    [P_W-2:0]   w_x     ;
                        wire    [P_W-2:0]   w_y     ;
                        wire    [P_W-2:0]   w_z     ;
                        assign  w_x =   g_lvl[gl-1].g_out[IA].w_o[P_W-2:0]      ;
                        assign  w_y =   g_lvl[gl-1].g_out[IA+1].w_o[P_W-2:0]    ;
                        assign  w_z =   g_lvl[gl-1].g_out[IA+2].w_o[P_W-2:0]    ;
                        assign  w_o =   {((w_x & w_y) | (w_x & w_z) | (w_y & w_z)), 1'b0}   ;
                    end
                end
                else
                begin : g_pass
                    assign  w_o =   g_lvl[gl-1].g_out[3*G + (gr - 2*G)].w_o ;
                end
            end
        end
    end
endgenerate

assign  o_s     =   g_lvl[LV].g_out[0].w_o  ;
assign  o_c     =   g_lvl[LV].g_out[1].w_o  ;

endmodule
`default_nettype wire

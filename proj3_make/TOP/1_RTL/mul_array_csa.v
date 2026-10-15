`default_nettype none
// -----------------------------------------------------------------------------
// mul_array_csa
//   Purpose : Signed array multiplier that stops before the final carry-propagate addition.
//             Outputs two vectors (sum, carry) with  o_s + o_c == i_a * i_b  (mod 2**(2*A_W)).
//   Structure: Baugh-Wooley partial products + a chain of A_W carry-save adder rows.
//              1) Partial product row i (i = 0..A_W-1): bit j = a[j] & b[i], placed at weight i+j.
//                 Baugh-Wooley: the bits that carry a sign weight (j = A_W-1 xor i = A_W-1) are inverted
//                 (NAND instead of AND). The bit a[A_W-1]&b[A_W-1] stays an AND.
//              2) Constant correction: add 1 at bit A_W and at bit 2*A_W-1.  (Derivation in
//                 docs/module_notes/mul_array_csa.md.) The constant is the starting value of the sum vector.
//              3) Row i is one row of full adders (3:2 compressors): (S, C, partial product i) -> (S', C'),
//                 where the carry vector is shifted left by one. Carries out of the top bit are dropped (mod 2**(2*A_W)).
//              After the last row, (S, C) is the carry-save result. No carry ripples across a row.
//              The rows are slices of one packed vector (no hierarchical references).
//   Latency : 0 (combinational). Depth: about A_W full-adder delays (rows in series).
//   Note    : No '+' '*' here; compressors are XOR/AND/OR only.
// -----------------------------------------------------------------------------
module mul_array_csa #(
    parameter   A_W     = 16
)(
                i_a     ,
                i_b     ,
                o_s     ,
                o_c
);

localparam  P_W     =   2*A_W           ;   // product / vector width

input   wire    signed  [A_W-1:0]   i_a     ;
input   wire    signed  [A_W-1:0]   i_b     ;
output  wire            [P_W-1:0]   o_s     ;
output  wire            [P_W-1:0]   o_c     ;

// Baugh-Wooley constant: ones at bit A_W and bit P_W-1
localparam  [P_W-1:0]   K_BW    =   ({{(P_W-1){1'b0}}, 1'b1} << A_W) | ({{(P_W-1){1'b0}}, 1'b1} << (P_W-1))  ;

// Row r of the array is the slice w_rows[r*2*P_W +: 2*P_W] = {maj (P_W bits), sum (P_W bits)}:
//   sum = x_s ^ x_c ^ pp,   maj = majority(x_s, x_c, pp),   carry vector = maj shifted left by one bit.
//   Row 0 is the starting value {0, K_BW}. Row i+1 is the result of adding partial product row i.
//   x_s, x_c are the previous row's sum and carry vectors. The carry out of the top bit (maj[P_W-1]) is
//   dropped (product is taken mod 2**P_W); it is the only bit of each row that is never read.
//   (split_var: lint hint only, tells the lint tool the rows are separate signals, not a loop.)
/* verilator lint_off UNUSEDSIGNAL */
wire    [(A_W+1)*2*P_W-1:0]     w_rows  /* verilator split_var */ ;
/* verilator lint_on UNUSEDSIGNAL */

assign  w_rows[0 +: 2*P_W]  =   {{P_W{1'b0}}, K_BW}    ;

genvar                  gi          ;
generate
    for     (gi = 0 ; gi < A_W ; gi = gi + 1)
    begin : g_row
        localparam  BASE    =   gi*2*P_W    ;           // this row's input (previous result)
        localparam  NEXT    =   (gi+1)*2*P_W;           // this row's output
        wire    [A_W-1:0]       w_row   ;   // partial product row i, before weighting
        wire    [P_W-1:0]       w_pp    ;   // partial product row i at weight i
        wire    [P_W-1:0]       w_xs    ;   // previous sum vector
        wire    [P_W-1:0]       w_xc    ;   // previous carry vector (previous maj shifted left by one)

        assign  w_xs    =   w_rows[BASE +: P_W]                 ;
        assign  w_xc    =   {w_rows[BASE + P_W +: P_W-1], 1'b0} ;

        // Baugh-Wooley partial product row: AND bits, except the bits with sign weight, which are inverted.
        //   rows 0 .. A_W-2 : the top bit (a[A_W-1] & b[i]) is inverted
        //   row  A_W-1      : the low A_W-1 bits (a[j] & b[A_W-1]) are inverted, the top bit stays AND
        if (gi < A_W - 1)
        begin : g_pp_a
            assign  w_row   =   {~(i_a[A_W-1] & i_b[gi]), i_a[A_W-2:0] & {(A_W-1){i_b[gi]}}}    ;
        end
        else
        begin : g_pp_b
            assign  w_row   =   {(i_a[A_W-1] & i_b[gi]), ~(i_a[A_W-2:0] & {(A_W-1){i_b[gi]}})}  ;
        end

        // place the row at weight i
        if (gi == 0)
        begin : g_w0
            assign  w_pp    =   {{(P_W-A_W){1'b0}}, w_row}                      ;
        end
        else
        begin : g_wn
            assign  w_pp    =   {{(P_W-A_W-gi){1'b0}}, w_row, {gi{1'b0}}}       ;
        end

        // 3:2 compression of (x_s, x_c, pp)
        assign  w_rows[NEXT +: 2*P_W]   =   {
                ((w_xs & w_xc) | (w_xs & w_pp) | (w_xc & w_pp)),    // maj
                (w_xs ^ w_xc ^ w_pp)                                // sum
            }   ;
    end
endgenerate

assign  o_s     =   w_rows[A_W*2*P_W +: P_W]                        ;
assign  o_c     =   {w_rows[A_W*2*P_W + P_W +: P_W-1], 1'b0}        ;

endmodule
`default_nettype wire

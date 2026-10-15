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

// Each row owns its nets (g_row[i].w_*) and reads the previous row by hierarchical reference.
// A row's result is ONE vector  w_sc = {maj (P_W bits), sum (P_W bits)}  written by ONE assign, so a change in
// the previous row reaches the next row as a single event. (Writing sum and carry as separate nets made the
// simulator re-evaluate each later row twice per change: 2**rows glitches, 4.7 ms per A_W=16 vector.)
//   sum = x_s ^ x_c ^ pp,   maj = majority(x_s, x_c, pp),   carry vector = maj shifted left by one bit.
//   x_s, x_c are the previous row's sum and carry vectors. The carry out of the top bit (maj[P_W-1]) is
//   dropped (product is taken mod 2**P_W); it is the only bit of w_sc that is never read.
genvar                  gi          ;
generate
    for     (gi = 0 ; gi < A_W ; gi = gi + 1)
    begin : g_row
        wire    [A_W-1:0]       w_row   ;   // partial product row i, before weighting
        wire    [P_W-1:0]       w_pp    ;   // partial product row i at weight i
        // The top bit of w_sc / w_prev is the dropped carry-out (mod 2**P_W) and is intentionally unread.
        /* verilator lint_off UNUSEDSIGNAL */
        wire    [2*P_W-1:0]     w_prev  ;   // previous row's {maj, sum}
        wire    [2*P_W-1:0]     w_sc    ;   // this row's {maj, sum}
        /* verilator lint_on UNUSEDSIGNAL */

        if (gi == 0)
        begin : g_first
            assign  w_prev  =   {{P_W{1'b0}}, K_BW}    ;   // start: sum = Baugh-Wooley constant, no carries
        end
        else
        begin : g_next
            assign  w_prev  =   g_row[gi-1].w_sc    ;
        end

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

        // 3:2 compression of (x_s, x_c, pp):  x_s = prev sum,  x_c = prev maj shifted left by one
        assign  w_sc    =   {
                // maj = (x_s & x_c) | (x_s & pp) | (x_c & pp)
                (  (w_prev[P_W-1:0]                       & {w_prev[2*P_W-2:P_W], 1'b0})
                 | (w_prev[P_W-1:0]                       & w_pp)
                 | ({w_prev[2*P_W-2:P_W], 1'b0}           & w_pp) ),
                // sum = x_s ^ x_c ^ pp
                (w_prev[P_W-1:0] ^ {w_prev[2*P_W-2:P_W], 1'b0} ^ w_pp)
            }   ;
    end
endgenerate

assign  o_s     =   g_row[A_W-1].w_sc[P_W-1:0]                      ;
assign  o_c     =   {g_row[A_W-1].w_sc[2*P_W-2:P_W], 1'b0}          ;

endmodule
`default_nettype wire

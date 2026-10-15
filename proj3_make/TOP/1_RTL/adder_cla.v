`default_nettype none
// -----------------------------------------------------------------------------
// adder_cla
//   Purpose : Carry-lookahead adder with a radix-4 lookahead tree. Medium speed and area between RCA and
//             the parallel-prefix adders (Kogge-Stone, Brent-Kung).
//   Structure: Nodes are (G, P) pairs, "this group generates / propagates a carry".
//              Level 0 : one node per bit,  G = a&b, P = a^b.
//              Level l+1 : one node per 4 nodes of level l (the last group may have 1..3 nodes).
//                 Level 1 nodes are the 4-bit blocks, level 2 nodes are 16-bit groups, and so on, until one root.
//                 A group of k children (child 0 = lowest) has
//                    G = g(k-1) | p(k-1) g(k-2) | ... | p(k-1)..p(1) g(0)      (flat AND-OR, no ripple)
//                    P = p(k-1) ... p(0)
//              Carries then go back DOWN the tree: the root's carry-in is i_cin; child i of a group gets
//                    c(i) = g(i-1) | p(i-1) g(i-2) | ... | p(i-1)..p(0) c(group)     (child 0 gets c(group)).
//              Level-0 carries are the bit carries: sum_i = p_i ^ c_i, o_cout = G_root | (P_root & i_cin).
//              W = 32 gives 8 four-bit blocks and a lookahead tree of 2 more levels (8 -> 2 -> 1).
//              Tree nodes live in packed vectors (index = level offset + position); any W >= 2 works.
//   Latency : 0 (combinational)
//   Note    : No '+' here. Lookahead logic is plain AND/OR.
// -----------------------------------------------------------------------------
module adder_cla #(
    parameter   W   = 32
)(
                i_a     ,
                i_b     ,
                i_cin   ,
                o_sum   ,
                o_cout
);

// ---- elaboration-time tree shape (constant functions) ----
// number of nodes at level fl: W, ceil(W/4), ceil(W/16), ...
function integer f_n;
    input integer fl;
    integer fi, fn;
    begin
        fn = W;
        for (fi = 0; fi < fl; fi = fi + 1)
            fn = (fn + 3)/4;
        f_n = fn;
    end
endfunction

// index of the first node of level fl in the packed vectors
function integer f_off;
    input integer fl;
    integer fi, fo;
    begin
        fo = 0;
        for (fi = 0; fi < fl; fi = fi + 1)
            fo = fo + f_n(fi);
        f_off = fo;
    end
endfunction

// number of levels above level 0 (the root is at level f_lvl)
function integer f_lvl;
    input integer fw;
    integer fn, fk;
    begin
        fn = fw;
        fk = 0;
        while (fn > 1) begin
            fn = (fn + 3)/4;
            fk = fk + 1;
        end
        f_lvl = fk;
    end
endfunction

localparam  LVL     =   f_lvl(W)            ;   // root level
localparam  TOT     =   f_off(LVL + 1)      ;   // total number of nodes
localparam  ROOT    =   f_off(LVL)          ;   // index of the root node

input   wire    [W-1:0] i_a     ;
input   wire    [W-1:0] i_b     ;
input   wire            i_cin   ;
output  wire    [W-1:0] o_sum   ;
output  wire            o_cout  ;

// Node vectors: group generate, group propagate, carry INTO the node. split_var: lint hint only
// (G/P flow up the tree, C flows down; the packed vectors are not real loops).
wire    [TOT-1:0]       w_g     /* verilator split_var */ ;
wire    [TOT-1:0]       w_p     /* verilator split_var */ ;
wire    [TOT-1:0]       w_c     /* verilator split_var */ ;

// ---- level 0: bits ----
assign  w_g[W-1:0]  =   i_a & i_b   ;
assign  w_p[W-1:0]  =   i_a ^ i_b   ;

genvar                  gl, gj      ;
generate
    // ---- upward: build level gl+1 from level gl ----
    for     (gl = 0 ; gl < LVL ; gl = gl + 1)
    begin : g_up
        localparam  NIN     =   f_n(gl)         ;
        localparam  NOUT    =   f_n(gl + 1)     ;
        localparam  OIN     =   f_off(gl)       ;
        localparam  OOUT    =   f_off(gl + 1)   ;
        for     (gj = 0 ; gj < NOUT ; gj = gj + 1)
        begin : g_node
            localparam  K   =   ((NIN - 4*gj) > 4) ? 4 : (NIN - 4*gj)   ;   // children in this group
            localparam  B   =   OIN + 4*gj                                  ;   // first child
            if (K == 1)
            begin : g_k1
                assign  w_g[OOUT+gj]    =   w_g[B]  ;
                assign  w_p[OOUT+gj]    =   w_p[B]  ;
            end
            else if (K == 2)
            begin : g_k2
                assign  w_g[OOUT+gj]    =   w_g[B+1] | (w_p[B+1] & w_g[B])                              ;
                assign  w_p[OOUT+gj]    =   w_p[B+1] & w_p[B]                                           ;
            end
            else if (K == 3)
            begin : g_k3
                assign  w_g[OOUT+gj]    =   w_g[B+2] | (w_p[B+2] & w_g[B+1]) | (w_p[B+2] & w_p[B+1] & w_g[B])   ;
                assign  w_p[OOUT+gj]    =   w_p[B+2] & w_p[B+1] & w_p[B]                                ;
            end
            else
            begin : g_k4
                assign  w_g[OOUT+gj]    =   w_g[B+3] | (w_p[B+3] & w_g[B+2]) | (w_p[B+3] & w_p[B+2] & w_g[B+1])
                                          | (w_p[B+3] & w_p[B+2] & w_p[B+1] & w_g[B])                   ;
                assign  w_p[OOUT+gj]    =   w_p[B+3] & w_p[B+2] & w_p[B+1] & w_p[B]                     ;
            end
        end
    end

    // ---- root carry-in ----
    assign  w_c[ROOT]   =   i_cin   ;

    // ---- downward: carries into the nodes of level gl, from the carries into level gl+1 ----
    for     (gl = 0 ; gl < LVL ; gl = gl + 1)
    begin : g_dn
        localparam  N   =   f_n(gl)         ;
        localparam  O   =   f_off(gl)       ;
        localparam  OP  =   f_off(gl + 1)   ;
        for     (gj = 0 ; gj < N ; gj = gj + 1)
        begin : g_node
            localparam  I   =   gj - 4*(gj/4)       ;   // position in the group
            localparam  B   =   O + 4*(gj/4)        ;   // first sibling
            localparam  CP  =   OP + (gj/4)         ;   // carry into the parent
            if (I == 0)
            begin : g_i0
                assign  w_c[O+gj]   =   w_c[CP]     ;
            end
            else if (I == 1)
            begin : g_i1
                assign  w_c[O+gj]   =   w_g[B] | (w_p[B] & w_c[CP])                                     ;
            end
            else if (I == 2)
            begin : g_i2
                assign  w_c[O+gj]   =   w_g[B+1] | (w_p[B+1] & w_g[B]) | (w_p[B+1] & w_p[B] & w_c[CP])  ;
            end
            else
            begin : g_i3
                assign  w_c[O+gj]   =   w_g[B+2] | (w_p[B+2] & w_g[B+1]) | (w_p[B+2] & w_p[B+1] & w_g[B])
                                      | (w_p[B+2] & w_p[B+1] & w_p[B] & w_c[CP])                        ;
            end
        end
    end
endgenerate

assign  o_sum   =   w_p[W-1:0] ^ w_c[W-1:0]                 ;
assign  o_cout  =   w_g[ROOT] | (w_p[ROOT] & i_cin)         ;

endmodule
`default_nettype wire

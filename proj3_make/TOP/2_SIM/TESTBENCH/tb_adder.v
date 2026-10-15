`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// tb_adder : self-checking test of adder_top (V1 V2 V3). One testbench for every ADDER_ARCH.
//   W = 8       : exhaustive (all a, b, cin)                                   -> V1
//   W = 16, 32  : directed carry-chain cases + corners + fixed-seed random     -> V2, V3
//                 (W = 32 runs 1,000,000 random vectors per architecture)
//   W = 24, 40  : also tested (the MAC accumulators use ACC_W = 16, 24, 40; same directed + random as above)
//   Directed carry-chain cases: for every generate position k and every propagate length L, a vector
//   with one generate at bit k, L propagate bits above it and "kill" (a=b=0) everywhere else; the same
//   with the chain starting at carry-in; plus all-ones + 1, 0x55.. + 0xAA.., single-bit propagate.
//   Expected value is computed here with '+', compared with '!=='.
//   Reach check (testbench counter): the longest run of 1s in the carry vector c[W:0] takes EVERY value 0 .. W+1.
// -----------------------------------------------------------------------------
module adder_chk #(
    parameter   W       = 8     ,
    parameter   ARCH    = 4     ,
    parameter   EXH     = 1     ,
    parameter   NRAND   = 20000 ,
    parameter   SEED    = 1
)(
    output reg          o_done  ,
    output reg  [31:0]  o_pass  ,
    output reg  [31:0]  o_fail  ,
    output reg  [31:0]  o_hash  ,
    output reg  [3:0]   o_cov   ,   // bit0 cout=0, bit1 cout=1, bit2 cin=0, bit3 cin=1
    output reg  [63:0]  o_len       // bit L set: a vector whose longest carry run is L was applied (L = 0 .. W+1)
);

reg  [W-1:0]    a, b;
reg             cin;
wire [W-1:0]    sum;
wire            cout;
reg  [W:0]      exp;
reg  [63:0]     hv;             // zero-extended {cout, sum} for the hash
integer         i, j, k, L, q, seed, run, best;
reg             c;
reg  [W-1:0]    va, vb;

adder_top #(.W(W), .ADDER_ARCH(ARCH)) dut (
    .i_a(a), .i_b(b), .i_cin(cin), .o_sum(sum), .o_cout(cout)
);

task check;
    input [W-1:0] ta, tb;
    input         tc;
    begin
        a = ta; b = tb; cin = tc;
        #1;
        exp = {1'b0, ta} + {1'b0, tb} + {{W{1'b0}}, tc};
        if ({cout, sum} !== exp) begin
            o_fail = o_fail + 1;
            if (o_fail < 20)
                $display("FAIL adder W=%0d ARCH=%0d a=%h b=%h cin=%b exp=%h got=%h",
                         W, ARCH, ta, tb, tc, exp, {cout, sum});
        end else begin
            o_pass = o_pass + 1;
            hv = {{(63-W){1'b0}}, cout, sum};
            o_hash = {o_hash[30:0], o_hash[31]} ^ hv[31:0] ^ hv[63:32];
        end
        o_cov[0] = o_cov[0] | (exp[W] == 1'b0);
        o_cov[1] = o_cov[1] | (exp[W] == 1'b1);
        o_cov[2] = o_cov[2] | (tc == 1'b0);
        o_cov[3] = o_cov[3] | (tc == 1'b1);
        // longest run of 1s in the carry vector c[W:0] (bitwise recurrence, independent of the DUT)
        c = tc; run = tc ? 1 : 0; best = run;
        for (q = 0; q < W; q = q + 1) begin
            c = (ta[q] & tb[q]) | ((ta[q] ^ tb[q]) & c);
            if (c) run = run + 1; else run = 0;
            if (run > best) best = run;
        end
        o_len[best] = 1'b1;
    end
endtask

// Directed chain: bit k generates (a=b=1), the next L bits propagate (polarity chosen by pol), all others kill.
task chain;
    input integer gk;       // generate position, or -1 to start the chain at carry-in
    input integer len;      // number of propagate bits
    input [W-1:0] pol;      // for each propagate bit: 0 -> (a=1,b=0), 1 -> (a=0,b=1)
    begin
        va = 0; vb = 0;
        if (gk >= 0) begin va[gk] = 1'b1; vb[gk] = 1'b1; end
        for (q = 0; q < len; q = q + 1)
            if (gk + 1 + q < W) begin
                if (pol[q]) vb[gk + 1 + q] = 1'b1; else va[gk + 1 + q] = 1'b1;
            end
        check(va, vb, (gk < 0) ? 1'b1 : 1'b0);
    end
endtask

reg [W-1:0] corner [0:5];

initial begin
    o_done = 0; o_pass = 0; o_fail = 0; o_hash = 32'h1234_5678; o_cov = 0; o_len = 0;
    seed = SEED;
    corner[0] = 0;
    corner[1] = {W{1'b1}};
    corner[2] = {1'b1, {(W-1){1'b0}}};
    corner[3] = {1'b0, {(W-1){1'b1}}};
    corner[4] = 1;
    corner[5] = {(W/2){2'b10}};
    if (EXH != 0) begin
        for (i = 0; i < (1 << W); i = i + 1)
            for (j = 0; j < (1 << W); j = j + 1) begin
                check(i[W-1:0], j[W-1:0], 1'b0);
                check(i[W-1:0], j[W-1:0], 1'b1);
            end
    end else begin
        // corners
        for (i = 0; i < 6; i = i + 1)
            for (j = 0; j < 6; j = j + 1) begin
                check(corner[i], corner[j], 1'b0);
                check(corner[i], corner[j], 1'b1);
            end
        // V2: classic carry chains
        check({W{1'b1}}, 1, 1'b0);                          // all-ones + 1
        check({W{1'b1}}, 0, 1'b1);                          // all-ones + cin
        check({(W/2){2'b01}}, {(W/2){2'b10}}, 1'b0);        // 0x55.. + 0xAA..
        check({(W/2){2'b01}}, {(W/2){2'b10}}, 1'b1);        // 0x55.. + 0xAA.. + 1 (full-length chain)
        for (i = 0; i < W; i = i + 1) begin                 // single-bit propagate
            check(1 << i, {W{1'b1}} ^ (1 << i), 1'b0);
            check(1 << i, {W{1'b1}} ^ (1 << i), 1'b1);
            check(1 << i, 1 << i, 1'b0);
        end
        // V2: every (generate position, propagate length), several propagate polarities
        for (k = 0; k < W; k = k + 1)
            for (L = 0; L <= W - 1 - k; L = L + 1) begin
                chain(k, L, {W{1'b0}});
                chain(k, L, {W{1'b1}});
                chain(k, L, {(W/2){2'b01}});
                chain(k, L, $random(seed));
            end
        // chains that start at carry-in
        for (L = 0; L <= W; L = L + 1) begin
            chain(-1, L, {W{1'b0}});
            chain(-1, L, $random(seed));
        end
        // V3: random
        for (k = 0; k < NRAND; k = k + 1)
            check($random(seed), $random(seed), $random(seed));
    end
    o_done = 1;
end
endmodule

module tb_adder;
parameter ARCH = 4;
wire        d8, d16, d24, d32, d40;
wire [31:0] p8, p16, p24, p32, p40, f8, f16, f24, f32, f40, h8, h16, h24, h32, h40;
wire [3:0]  c8, c16, c24, c32, c40;
wire [63:0] l8, l16, l24, l32, l40;

adder_chk #(.W(8 ), .ARCH(ARCH), .EXH(1))                                u8  (d8 , p8 , f8 , h8 , c8 , l8 );
adder_chk #(.W(16), .ARCH(ARCH), .EXH(0), .NRAND(200000),  .SEED(2))     u16 (d16, p16, f16, h16, c16, l16);
adder_chk #(.W(24), .ARCH(ARCH), .EXH(0), .NRAND(200000),  .SEED(4))     u24 (d24, p24, f24, h24, c24, l24);
adder_chk #(.W(32), .ARCH(ARCH), .EXH(0), .NRAND(1000000), .SEED(3))     u32 (d32, p32, f32, h32, c32, l32);
adder_chk #(.W(40), .ARCH(ARCH), .EXH(0), .NRAND(200000),  .SEED(5))     u40 (d40, p40, f40, h40, c40, l40);

wire [31:0] pass = p8 + p16 + p24 + p32 + p40;
wire [31:0] fail = f8 + f16 + f24 + f32 + f40;

function ok_cov;
    input [3:0]  cv;
    input [63:0] len;
    input integer w;
    begin
        ok_cov = (cv == 4'hF) && (len == ((64'd1 << (w + 2)) - 64'd1));   // every carry-run length 0 .. W+1
    end
endfunction

initial begin
    wait (d8 && d16 && d24 && d32 && d40);
    $display("tb_adder ADDER_ARCH=%0d seeds=1,2,3,4,5 : PASS=%0d FAIL=%0d", ARCH, pass, fail);
    $display("HASH %h %h %h %h %h", h8, h16, h24, h32, h40);
    $display("coverage (cout0 cout1 cin0 cin1) W8=%b W16=%b W24=%b W32=%b W40=%b", c8, c16, c24, c32, c40);
    $display("carry-run lengths reached: W8=%0d/10 W16=%0d/18 W24=%0d/26 W32=%0d/34 W40=%0d/42",
             cnt(l8), cnt(l16), cnt(l24), cnt(l32), cnt(l40));
    if (fail == 0 && ok_cov(c8, l8, 8) && ok_cov(c16, l16, 16) && ok_cov(c24, l24, 24) && ok_cov(c32, l32, 32) && ok_cov(c40, l40, 40))
        $display("RESULT: PASS");
    else
        $display("RESULT: FAIL");
    $finish;
end

function integer cnt;
    input [63:0] v;
    integer n, t;
    begin
        n = 0;
        for (t = 0; t < 64; t = t + 1) if (v[t]) n = n + 1;
        cnt = n;
    end
endfunction
endmodule

// RTL file list (paths relative to this directory). Pass the directory as an include directory so that
// `include "alu_defs.vh" is found:  +incdir+<path to 1_RTL>
+incdir+.
// ALU
alu_top.v
alu_core.v
alu_shifter.v
shr_barrel.v
shr_loop.v
// adders (shared by ALU, MAC accumulator and multiplier final addition)
adder_top.v
adder_beh.v
adder_rca.v
adder_cla.v
adder_ks.v
adder_bk.v
// MAC and multipliers
mac_top.v
mul_top.v
mul_beh.v
mul_csa_top.v
mul_array_csa.v
mul_booth_csa.v

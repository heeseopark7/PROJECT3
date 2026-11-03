xrun -64bit \
     +max_err_count+50 \
     +define+function_sim \
     +incdir+../../1_RTL \
     -access +rwc \
     -profile \
     -profthread \
     -gui \
     +libext+.v \
     ../TESTBENCH/tb_mac_top.v \
     ../../1_RTL/alu_top.v \
     ../../1_RTL/alu_core.v \
     ../../1_RTL/adder_top.v \
     ../../1_RTL/adder_rca.v \
     ../../1_RTL/adder_cla.v \
     ../../1_RTL/adder_ks.v \
     ../../1_RTL/adder_bk.v \
     ../../1_RTL/adder_beh.v \
     ../../1_RTL/alu_shifter.v \
     ../../1_RTL/shr_loop.v \
     ../../1_RTL/shr_barrel.v \
     ../../1_RTL/mac_top.v \
     ../../1_RTL/mul_top.v \
     ../../1_RTL/mul_beh.v \
     ../../1_RTL/mul_csa_top.v \
     ../../1_RTL/mul_array_csa.v \
     ../../1_RTL/mul_booth_csa.v \
     -l func_sim.log

xrun -64bit \
     +max_err_count+50 \
     +define+function_sim \
     +incdir+../../1_RTL \
     -access +rwc \
     -profile \
     -profthread \
     -gui \
     +libext+.v \
     ../TESTBENCH/tb_alu_top.v \
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
     /GPDK045/digital/giolib045_v3.5/vlog/pads_FF_s1vg.v \
     /GPDK045/digital/gsclib045_all_v4.4/gsclib045_svt_v4.4/gsclib045/verilog/slow_vdd1v0_basicCells.v \
     -l func_sim.log

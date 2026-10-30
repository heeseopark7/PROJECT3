######################################################################

# Created by Genus(TM) Synthesis Solution 22.17-s071_1 on Fri Oct 30 03:18:59 KST 2026

# This file contains the Genus script for design:mac_chip_top

######################################################################

set_db -quiet init_lib_search_path {../../../../SoC/GPDK045/digital/gsclib045_all_v4.4/gsclib045/timing ../../../../SoC/GPDK045/digital/giolib045_v3.5/timing ../../../../SoC/GPDK045/digital/gsclib045_all_v4.4/gsclib045/lef ../../../../SoC/GPDK045/digital/giolib045_v3.5/lef ../../../../SoC/GPDK045/digital/gsclib045_all_v4.4/gsclib045_tech/qrc/qx}
set_db -quiet operating_conditions_min PVT_1P1V_0C
set_db -quiet operating_conditions_min_library library:default_emulate_libset_max/fast_vdd1v0
set_db -quiet operating_conditions_library_given true
set_db -quiet design_mode_process 60.0
set_db -quiet phys_assume_met_fill 0.0
set_db -quiet map_placed_for_route_early_global false
set_db -quiet phys_use_invs_extraction true
set_db -quiet phys_route_time_out 120.0
set_db -quiet db_units 2000
set_db -quiet capacitance_per_unit_length_mmmc {}
set_db -quiet resistance_per_unit_length_mmmc {}
set_db -quiet runtime_by_stage {{PBS_Generic-Start 0 19 0.0 17.989909} {to_generic 4 23 4 22} {first_condense 4 28 4 27} {PBS_Generic_Opt-Post 9 28 8.995711 26.98562} {{PBS_Generic-Postgen HBO Optimizations} 0 28 0.0 26.98562} {PBS_TechMap-Start 0 31 0.0 28.962818000000002} {{PBS_TechMap-Premap HBO Optimizations} 0 31 0.0 28.962818000000002} {second_condense 3 34 3 33} {reify 31 65 42 76} {global_incr_map 0 65 0 77} {{PBS_Techmap-Global Mapping} 34 65 34.084158999999985 63.04697699999999} {{PBS_TechMap-Datapath Postmap Operations} 2 67 1.9898640000000043 65.036841} {{PBS_TechMap-Postmap HBO Optimizations} 0 67 -0.009231999999997242 65.027609} {{PBS_TechMap-Postmap Clock Gating} 0 67 0.0 65.027609} {{PBS_TechMap-Postmap Cleanup} 0 67 -0.009890999999996097 65.017718} {PBS_Techmap-Post_MBCI 0 67 0.0 65.017718} {incr_opt 1 70 0 80} }
set_db -quiet timing_adjust_tns_of_complex_flops false
set_db -quiet hdl_array_naming_style %s_%d
set_db -quiet tinfo_tstamp_file .rs_hah013.tstamp
set_db -quiet metric_enable true
set_db -quiet auto_ungroup none
set_db -quiet max_cpus_per_server 2
set_db -quiet syn_generic_effort high
set_db -quiet use_area_from_lef true
set_db -quiet uniquify_naming_style mac_chip_top_%s_%d
set_db -quiet optimize_merge_flops false
set_db -quiet optimize_merge_latches false
set_db -quiet phys_use_segment_parasitics true
set_db -quiet probabilistic_extraction true
set_db -quiet ple_correlation_factors {1.9000 2.0000}
set_db -quiet maximum_interval_of_vias inf
set_db -quiet layer_aware_buffer true
set_db -quiet ple_mode global
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/ANTENNA .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY1X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY1X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY2X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY2X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY3X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY3X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY4X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY4X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/HOLDX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TIEHI .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TIELO .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX12 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX16 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX20 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX3 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX6 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX12 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX16 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX20 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX3 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX6 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/ANTENNA .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DFFSXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY1X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY1X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY2X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY2X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY3X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY3X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY4X1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/DLY4X4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/HOLDX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFNSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFQXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRHQX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFSXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFTRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/SDFFXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TIEHI .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TIELO .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX12 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX16 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX20 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX3 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX6 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNCAX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX12 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX16 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX20 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX3 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX6 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNTSCAX8 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATNXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATSRXL .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATX1 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATX2 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATX4 .avoid true
set_db -quiet lib_cell:default_emulate_libset_max/fast_vdd1v0/TLATXL .avoid true
set_db -quiet operating_conditions operating_condition:default_emulate_libset_max/slow_vdd1v0/PVT_0P9V_125C
set_db -quiet wireload_selection none
set_db -quiet operating_condition:default_emulate_libset_max/fast_vdd1v0/PVT_1P1V_0C .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/fast_vdd1v0/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/slow_vdd1v0/PVT_0P9V_125C .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/slow_vdd1v0/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/giolib045/slow .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/giolib045/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/fast_vdd1v0/PVT_1P1V_0C .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/fast_vdd1v0/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/slow_vdd1v0/PVT_0P9V_125C .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/slow_vdd1v0/_nominal_ .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/giolib045/slow .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/giolib045/_nominal_ .tree_type balanced_tree
# BEGIN MSV SECTION
# END MSV SECTION
define_clock -name MAIN_CLOCK -domain domain_1 -period 8000.0 -divide_period 1 -rise 0 -divide_rise 1 -fall 1 -divide_fall 2 -remove -design design:mac_chip_top port:mac_chip_top/i_clk
set_db -quiet clock:mac_chip_top/MAIN_CLOCK .slew {100.0 100.0 100.0 100.0}
set_db -quiet clock:mac_chip_top/MAIN_CLOCK .clock_network_late_latency {200.0 200.0 200.0 200.0}
set_db -quiet clock:mac_chip_top/MAIN_CLOCK .clock_source_late_latency {200.0 200.0 200.0 200.0}
set_db -quiet clock:mac_chip_top/MAIN_CLOCK .clock_setup_uncertainty {100.0 100.0}
define_cost_group -design design:mac_chip_top -name MAIN_CLOCK
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del port:mac_chip_top/i_rst_n
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_1_1 {{port:mac_chip_top/i_a[15]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_2_1 {{port:mac_chip_top/i_a[14]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_3_1 {{port:mac_chip_top/i_a[13]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_4_1 {{port:mac_chip_top/i_a[12]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_5_1 {{port:mac_chip_top/i_a[11]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_6_1 {{port:mac_chip_top/i_a[10]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_7_1 {{port:mac_chip_top/i_a[9]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_8_1 {{port:mac_chip_top/i_a[8]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_9_1 {{port:mac_chip_top/i_a[7]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_10_1 {{port:mac_chip_top/i_a[6]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_11_1 {{port:mac_chip_top/i_a[5]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_12_1 {{port:mac_chip_top/i_a[4]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_13_1 {{port:mac_chip_top/i_a[3]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_14_1 {{port:mac_chip_top/i_a[2]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_15_1 {{port:mac_chip_top/i_a[1]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_16_1 {{port:mac_chip_top/i_a[0]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_17_1 {{port:mac_chip_top/i_b[15]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_18_1 {{port:mac_chip_top/i_b[14]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_19_1 {{port:mac_chip_top/i_b[13]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_20_1 {{port:mac_chip_top/i_b[12]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_21_1 {{port:mac_chip_top/i_b[11]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_22_1 {{port:mac_chip_top/i_b[10]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_23_1 {{port:mac_chip_top/i_b[9]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_24_1 {{port:mac_chip_top/i_b[8]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_25_1 {{port:mac_chip_top/i_b[7]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_26_1 {{port:mac_chip_top/i_b[6]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_27_1 {{port:mac_chip_top/i_b[5]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_28_1 {{port:mac_chip_top/i_b[4]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_29_1 {{port:mac_chip_top/i_b[3]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_30_1 {{port:mac_chip_top/i_b[2]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_31_1 {{port:mac_chip_top/i_b[1]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_32_1 {{port:mac_chip_top/i_b[0]}}
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_33_1 port:mac_chip_top/i_en
external_delay -accumulate -input {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_34_1 port:mac_chip_top/i_clr
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_35_1 port:mac_chip_top/i_rst_n
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_36_1 {{port:mac_chip_top/i_a[15]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_37_1 {{port:mac_chip_top/i_a[14]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_38_1 {{port:mac_chip_top/i_a[13]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_39_1 {{port:mac_chip_top/i_a[12]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_40_1 {{port:mac_chip_top/i_a[11]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_41_1 {{port:mac_chip_top/i_a[10]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_42_1 {{port:mac_chip_top/i_a[9]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_43_1 {{port:mac_chip_top/i_a[8]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_44_1 {{port:mac_chip_top/i_a[7]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_45_1 {{port:mac_chip_top/i_a[6]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_46_1 {{port:mac_chip_top/i_a[5]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_47_1 {{port:mac_chip_top/i_a[4]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_48_1 {{port:mac_chip_top/i_a[3]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_49_1 {{port:mac_chip_top/i_a[2]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_50_1 {{port:mac_chip_top/i_a[1]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_51_1 {{port:mac_chip_top/i_a[0]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_52_1 {{port:mac_chip_top/i_b[15]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_53_1 {{port:mac_chip_top/i_b[14]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_54_1 {{port:mac_chip_top/i_b[13]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_55_1 {{port:mac_chip_top/i_b[12]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_56_1 {{port:mac_chip_top/i_b[11]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_57_1 {{port:mac_chip_top/i_b[10]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_58_1 {{port:mac_chip_top/i_b[9]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_59_1 {{port:mac_chip_top/i_b[8]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_60_1 {{port:mac_chip_top/i_b[7]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_61_1 {{port:mac_chip_top/i_b[6]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_62_1 {{port:mac_chip_top/i_b[5]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_63_1 {{port:mac_chip_top/i_b[4]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_64_1 {{port:mac_chip_top/i_b[3]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_65_1 {{port:mac_chip_top/i_b[2]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_66_1 {{port:mac_chip_top/i_b[1]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_67_1 {{port:mac_chip_top/i_b[0]}}
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_68_1 port:mac_chip_top/i_en
external_delay -accumulate -input {10.0 10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name in_del_69_1 port:mac_chip_top/i_clr
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del {{port:mac_chip_top/o_acc[39]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_69_1 {{port:mac_chip_top/o_acc[38]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_70_1 {{port:mac_chip_top/o_acc[37]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_71_1 {{port:mac_chip_top/o_acc[36]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_72_1 {{port:mac_chip_top/o_acc[35]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_73_1 {{port:mac_chip_top/o_acc[34]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_74_1 {{port:mac_chip_top/o_acc[33]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_75_1 {{port:mac_chip_top/o_acc[32]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_76_1 {{port:mac_chip_top/o_acc[31]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_77_1 {{port:mac_chip_top/o_acc[30]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_78_1 {{port:mac_chip_top/o_acc[29]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_79_1 {{port:mac_chip_top/o_acc[28]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_80_1 {{port:mac_chip_top/o_acc[27]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_81_1 {{port:mac_chip_top/o_acc[26]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_82_1 {{port:mac_chip_top/o_acc[25]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_83_1 {{port:mac_chip_top/o_acc[24]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_84_1 {{port:mac_chip_top/o_acc[23]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_85_1 {{port:mac_chip_top/o_acc[22]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_86_1 {{port:mac_chip_top/o_acc[21]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_87_1 {{port:mac_chip_top/o_acc[20]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_88_1 {{port:mac_chip_top/o_acc[19]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_89_1 {{port:mac_chip_top/o_acc[18]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_90_1 {{port:mac_chip_top/o_acc[17]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_91_1 {{port:mac_chip_top/o_acc[16]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_92_1 {{port:mac_chip_top/o_acc[15]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_93_1 {{port:mac_chip_top/o_acc[14]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_94_1 {{port:mac_chip_top/o_acc[13]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_95_1 {{port:mac_chip_top/o_acc[12]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_96_1 {{port:mac_chip_top/o_acc[11]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_97_1 {{port:mac_chip_top/o_acc[10]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_98_1 {{port:mac_chip_top/o_acc[9]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_99_1 {{port:mac_chip_top/o_acc[8]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_100_1 {{port:mac_chip_top/o_acc[7]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_101_1 {{port:mac_chip_top/o_acc[6]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_102_1 {{port:mac_chip_top/o_acc[5]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_103_1 {{port:mac_chip_top/o_acc[4]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_104_1 {{port:mac_chip_top/o_acc[3]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_105_1 {{port:mac_chip_top/o_acc[2]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_106_1 {{port:mac_chip_top/o_acc[1]}}
external_delay -accumulate -output {no_value no_value 100.0 100.0} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_107_1 {{port:mac_chip_top/o_acc[0]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_108_1 {{port:mac_chip_top/o_acc[39]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_109_1 {{port:mac_chip_top/o_acc[38]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_110_1 {{port:mac_chip_top/o_acc[37]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_111_1 {{port:mac_chip_top/o_acc[36]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_112_1 {{port:mac_chip_top/o_acc[35]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_113_1 {{port:mac_chip_top/o_acc[34]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_114_1 {{port:mac_chip_top/o_acc[33]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_115_1 {{port:mac_chip_top/o_acc[32]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_116_1 {{port:mac_chip_top/o_acc[31]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_117_1 {{port:mac_chip_top/o_acc[30]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_118_1 {{port:mac_chip_top/o_acc[29]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_119_1 {{port:mac_chip_top/o_acc[28]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_120_1 {{port:mac_chip_top/o_acc[27]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_121_1 {{port:mac_chip_top/o_acc[26]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_122_1 {{port:mac_chip_top/o_acc[25]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_123_1 {{port:mac_chip_top/o_acc[24]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_124_1 {{port:mac_chip_top/o_acc[23]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_125_1 {{port:mac_chip_top/o_acc[22]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_126_1 {{port:mac_chip_top/o_acc[21]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_127_1 {{port:mac_chip_top/o_acc[20]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_128_1 {{port:mac_chip_top/o_acc[19]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_129_1 {{port:mac_chip_top/o_acc[18]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_130_1 {{port:mac_chip_top/o_acc[17]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_131_1 {{port:mac_chip_top/o_acc[16]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_132_1 {{port:mac_chip_top/o_acc[15]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_133_1 {{port:mac_chip_top/o_acc[14]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_134_1 {{port:mac_chip_top/o_acc[13]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_135_1 {{port:mac_chip_top/o_acc[12]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_136_1 {{port:mac_chip_top/o_acc[11]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_137_1 {{port:mac_chip_top/o_acc[10]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_138_1 {{port:mac_chip_top/o_acc[9]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_139_1 {{port:mac_chip_top/o_acc[8]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_140_1 {{port:mac_chip_top/o_acc[7]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_141_1 {{port:mac_chip_top/o_acc[6]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_142_1 {{port:mac_chip_top/o_acc[5]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_143_1 {{port:mac_chip_top/o_acc[4]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_144_1 {{port:mac_chip_top/o_acc[3]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_145_1 {{port:mac_chip_top/o_acc[2]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_146_1 {{port:mac_chip_top/o_acc[1]}}
external_delay -accumulate -output {-10.0 -10.0 no_value no_value} -clock clock:mac_chip_top/MAIN_CLOCK -name ou_del_147_1 {{port:mac_chip_top/o_acc[0]}}
path_group -paths [specify_paths -lenient -to clock:mac_chip_top/MAIN_CLOCK]  -name MAIN_CLOCK -group cost_group:mac_chip_top/MAIN_CLOCK -user_priority -1047552
# BEGIN DFT SECTION
set_db -quiet dft_scan_style muxed_scan
set_db -quiet dft_scanbit_waveform_analysis false
# END DFT SECTION
set_db -quiet design:mac_chip_top .seq_reason_deleted_internal {}
set_db -quiet design:mac_chip_top .qos_by_stage {{to_generic {wns -11111111} {tns -111111111} {vep -111111111} {area 1100608} {cell_count 2307} {utilization  0.00} {runtime 4 23 4 22} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 1101497} {cell_count 2646} {utilization  0.00} {runtime 4 28 4 27} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 1101497} {cell_count 2646} {utilization  0.00} {runtime 3 34 3 33} }{reify {wns 5204} {tns 0} {vep 0} {area 1096481} {cell_count 694} {utilization  0.00} {runtime 31 65 42 76} }{global_incr_map {wns 5207} {tns 0} {vep 0} {area 1096463} {cell_count 685} {utilization  0.00} {runtime 0 65 0 77} }{incr_opt {wns 214748365} {tns 0} {vep 0} {area 1096457} {cell_count 682} {utilization  0.00} {runtime 1 70 0 80} }}
set_db -quiet design:mac_chip_top .seq_mbci_coverage 0.0
set_db -quiet design:mac_chip_top .hdl_filelist {{default -sv {SYNTHESIS} {../1_RTL/mac_chip_top.v ../1_RTL/mac_top.v ../1_RTL/mul_top.v ../1_RTL/mul_beh.v ../1_RTL/adder_top.v ../1_RTL/adder_beh.v} {../1_RTL} {}}}
set_db -quiet design:mac_chip_top .verification_directory fv/mac_chip_top
set_db -quiet port:mac_chip_top/i_clk .is_ideal_network true
set_db -quiet port:mac_chip_top/i_clk .original_name i_clk
set_db -quiet port:mac_chip_top/i_clk .ideal_network true
set_db -quiet port:mac_chip_top/i_rst_n .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_rst_n .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_rst_n .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_rst_n .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_rst_n .is_ideal_network true
set_db -quiet port:mac_chip_top/i_rst_n .original_name i_rst_n
set_db -quiet port:mac_chip_top/i_rst_n .ideal_network true
set_db -quiet {port:mac_chip_top/i_a[15]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[15]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[15]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[15]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[15]} .original_name {i_a[15]}
set_db -quiet {port:mac_chip_top/i_a[14]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[14]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[14]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[14]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[14]} .original_name {i_a[14]}
set_db -quiet {port:mac_chip_top/i_a[13]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[13]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[13]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[13]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[13]} .original_name {i_a[13]}
set_db -quiet {port:mac_chip_top/i_a[12]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[12]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[12]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[12]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[12]} .original_name {i_a[12]}
set_db -quiet {port:mac_chip_top/i_a[11]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[11]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[11]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[11]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[11]} .original_name {i_a[11]}
set_db -quiet {port:mac_chip_top/i_a[10]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[10]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[10]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[10]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[10]} .original_name {i_a[10]}
set_db -quiet {port:mac_chip_top/i_a[9]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[9]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[9]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[9]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[9]} .original_name {i_a[9]}
set_db -quiet {port:mac_chip_top/i_a[8]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[8]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[8]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[8]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[8]} .original_name {i_a[8]}
set_db -quiet {port:mac_chip_top/i_a[7]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[7]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[7]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[7]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[7]} .original_name {i_a[7]}
set_db -quiet {port:mac_chip_top/i_a[6]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[6]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[6]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[6]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[6]} .original_name {i_a[6]}
set_db -quiet {port:mac_chip_top/i_a[5]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[5]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[5]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[5]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[5]} .original_name {i_a[5]}
set_db -quiet {port:mac_chip_top/i_a[4]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[4]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[4]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[4]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[4]} .original_name {i_a[4]}
set_db -quiet {port:mac_chip_top/i_a[3]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[3]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[3]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[3]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[3]} .original_name {i_a[3]}
set_db -quiet {port:mac_chip_top/i_a[2]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[2]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[2]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[2]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[2]} .original_name {i_a[2]}
set_db -quiet {port:mac_chip_top/i_a[1]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[1]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[1]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[1]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[1]} .original_name {i_a[1]}
set_db -quiet {port:mac_chip_top/i_a[0]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[0]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[0]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[0]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_a[0]} .original_name {i_a[0]}
set_db -quiet {port:mac_chip_top/i_b[15]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[15]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[15]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[15]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[15]} .original_name {i_b[15]}
set_db -quiet {port:mac_chip_top/i_b[14]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[14]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[14]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[14]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[14]} .original_name {i_b[14]}
set_db -quiet {port:mac_chip_top/i_b[13]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[13]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[13]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[13]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[13]} .original_name {i_b[13]}
set_db -quiet {port:mac_chip_top/i_b[12]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[12]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[12]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[12]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[12]} .original_name {i_b[12]}
set_db -quiet {port:mac_chip_top/i_b[11]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[11]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[11]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[11]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[11]} .original_name {i_b[11]}
set_db -quiet {port:mac_chip_top/i_b[10]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[10]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[10]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[10]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[10]} .original_name {i_b[10]}
set_db -quiet {port:mac_chip_top/i_b[9]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[9]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[9]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[9]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[9]} .original_name {i_b[9]}
set_db -quiet {port:mac_chip_top/i_b[8]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[8]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[8]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[8]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[8]} .original_name {i_b[8]}
set_db -quiet {port:mac_chip_top/i_b[7]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[7]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[7]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[7]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[7]} .original_name {i_b[7]}
set_db -quiet {port:mac_chip_top/i_b[6]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[6]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[6]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[6]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[6]} .original_name {i_b[6]}
set_db -quiet {port:mac_chip_top/i_b[5]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[5]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[5]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[5]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[5]} .original_name {i_b[5]}
set_db -quiet {port:mac_chip_top/i_b[4]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[4]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[4]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[4]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[4]} .original_name {i_b[4]}
set_db -quiet {port:mac_chip_top/i_b[3]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[3]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[3]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[3]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[3]} .original_name {i_b[3]}
set_db -quiet {port:mac_chip_top/i_b[2]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[2]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[2]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[2]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[2]} .original_name {i_b[2]}
set_db -quiet {port:mac_chip_top/i_b[1]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[1]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[1]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[1]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[1]} .original_name {i_b[1]}
set_db -quiet {port:mac_chip_top/i_b[0]} .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[0]} .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[0]} .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[0]} .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet {port:mac_chip_top/i_b[0]} .original_name {i_b[0]}
set_db -quiet port:mac_chip_top/i_en .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_en .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_en .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_en .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_en .original_name i_en
set_db -quiet port:mac_chip_top/i_clr .driver_pin_rise_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_clr .driver_pin_fall_min lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_clr .driver_pin_rise_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_clr .driver_pin_fall_max lib_pin:default_emulate_libset_max/giolib045/PADDI/Y
set_db -quiet port:mac_chip_top/i_clr .original_name i_clr
set_db -quiet {port:mac_chip_top/o_acc[39]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[39]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[39]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[39]} .original_name {o_acc[39]}
set_db -quiet {port:mac_chip_top/o_acc[39]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[38]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[38]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[38]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[38]} .original_name {o_acc[38]}
set_db -quiet {port:mac_chip_top/o_acc[38]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[37]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[37]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[37]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[37]} .original_name {o_acc[37]}
set_db -quiet {port:mac_chip_top/o_acc[37]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[36]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[36]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[36]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[36]} .original_name {o_acc[36]}
set_db -quiet {port:mac_chip_top/o_acc[36]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[35]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[35]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[35]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[35]} .original_name {o_acc[35]}
set_db -quiet {port:mac_chip_top/o_acc[35]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[34]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[34]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[34]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[34]} .original_name {o_acc[34]}
set_db -quiet {port:mac_chip_top/o_acc[34]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[33]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[33]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[33]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[33]} .original_name {o_acc[33]}
set_db -quiet {port:mac_chip_top/o_acc[33]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[32]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[32]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[32]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[32]} .original_name {o_acc[32]}
set_db -quiet {port:mac_chip_top/o_acc[32]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[31]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[31]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[31]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[31]} .original_name {o_acc[31]}
set_db -quiet {port:mac_chip_top/o_acc[31]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[30]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[30]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[30]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[30]} .original_name {o_acc[30]}
set_db -quiet {port:mac_chip_top/o_acc[30]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[29]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[29]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[29]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[29]} .original_name {o_acc[29]}
set_db -quiet {port:mac_chip_top/o_acc[29]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[28]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[28]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[28]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[28]} .original_name {o_acc[28]}
set_db -quiet {port:mac_chip_top/o_acc[28]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[27]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[27]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[27]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[27]} .original_name {o_acc[27]}
set_db -quiet {port:mac_chip_top/o_acc[27]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[26]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[26]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[26]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[26]} .original_name {o_acc[26]}
set_db -quiet {port:mac_chip_top/o_acc[26]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[25]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[25]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[25]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[25]} .original_name {o_acc[25]}
set_db -quiet {port:mac_chip_top/o_acc[25]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[24]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[24]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[24]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[24]} .original_name {o_acc[24]}
set_db -quiet {port:mac_chip_top/o_acc[24]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[23]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[23]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[23]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[23]} .original_name {o_acc[23]}
set_db -quiet {port:mac_chip_top/o_acc[23]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[22]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[22]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[22]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[22]} .original_name {o_acc[22]}
set_db -quiet {port:mac_chip_top/o_acc[22]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[21]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[21]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[21]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[21]} .original_name {o_acc[21]}
set_db -quiet {port:mac_chip_top/o_acc[21]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[20]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[20]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[20]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[20]} .original_name {o_acc[20]}
set_db -quiet {port:mac_chip_top/o_acc[20]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[19]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[19]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[19]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[19]} .original_name {o_acc[19]}
set_db -quiet {port:mac_chip_top/o_acc[19]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[18]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[18]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[18]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[18]} .original_name {o_acc[18]}
set_db -quiet {port:mac_chip_top/o_acc[18]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[17]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[17]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[17]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[17]} .original_name {o_acc[17]}
set_db -quiet {port:mac_chip_top/o_acc[17]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[16]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[16]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[16]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[16]} .original_name {o_acc[16]}
set_db -quiet {port:mac_chip_top/o_acc[16]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[15]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[15]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[15]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[15]} .original_name {o_acc[15]}
set_db -quiet {port:mac_chip_top/o_acc[15]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[14]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[14]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[14]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[14]} .original_name {o_acc[14]}
set_db -quiet {port:mac_chip_top/o_acc[14]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[13]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[13]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[13]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[13]} .original_name {o_acc[13]}
set_db -quiet {port:mac_chip_top/o_acc[13]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[12]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[12]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[12]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[12]} .original_name {o_acc[12]}
set_db -quiet {port:mac_chip_top/o_acc[12]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[11]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[11]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[11]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[11]} .original_name {o_acc[11]}
set_db -quiet {port:mac_chip_top/o_acc[11]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[10]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[10]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[10]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[10]} .original_name {o_acc[10]}
set_db -quiet {port:mac_chip_top/o_acc[10]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[9]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[9]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[9]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[9]} .original_name {o_acc[9]}
set_db -quiet {port:mac_chip_top/o_acc[9]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[8]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[8]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[8]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[8]} .original_name {o_acc[8]}
set_db -quiet {port:mac_chip_top/o_acc[8]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[7]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[7]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[7]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[7]} .original_name {o_acc[7]}
set_db -quiet {port:mac_chip_top/o_acc[7]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[6]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[6]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[6]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[6]} .original_name {o_acc[6]}
set_db -quiet {port:mac_chip_top/o_acc[6]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[5]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[5]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[5]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[5]} .original_name {o_acc[5]}
set_db -quiet {port:mac_chip_top/o_acc[5]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[4]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[4]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[4]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[4]} .original_name {o_acc[4]}
set_db -quiet {port:mac_chip_top/o_acc[4]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[3]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[3]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[3]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[3]} .original_name {o_acc[3]}
set_db -quiet {port:mac_chip_top/o_acc[3]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[2]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[2]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[2]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[2]} .original_name {o_acc[2]}
set_db -quiet {port:mac_chip_top/o_acc[2]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[1]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[1]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[1]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[1]} .original_name {o_acc[1]}
set_db -quiet {port:mac_chip_top/o_acc[1]} .external_pin_cap {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[0]} .external_pin_cap_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[0]} .external_capacitance_max {3.0 3.0}
set_db -quiet {port:mac_chip_top/o_acc[0]} .external_capacitance_min 3.0
set_db -quiet {port:mac_chip_top/o_acc[0]} .original_name {o_acc[0]}
set_db -quiet {port:mac_chip_top/o_acc[0]} .external_pin_cap {3.0 3.0}
set_db -quiet inst:mac_chip_top/ipad1 .dont_touch_reason set_dont_touch
set_db -quiet inst:mac_chip_top/ipad1 .dont_touch_file 0
set_db -quiet inst:mac_chip_top/ipad1 .dont_touch true
set_db -quiet inst:mac_chip_top/ipad1 .preserve true
set_db -quiet inst:mac_chip_top/ipad2 .dont_touch_reason set_dont_touch
set_db -quiet inst:mac_chip_top/ipad2 .dont_touch_file 0
set_db -quiet inst:mac_chip_top/ipad2 .dont_touch true
set_db -quiet inst:mac_chip_top/ipad2 .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[0]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[0]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[0]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[0]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[1]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[1]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[1]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[1]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[2]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[2]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[2]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[2]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[3]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[3]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[3]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[3]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[4]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[4]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[4]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[4]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[5]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[5]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[5]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[5]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[6]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[6]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[6]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[6]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[7]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[7]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[7]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[7]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[8]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[8]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[8]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[8]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[9]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[9]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[9]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[9]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[10]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[10]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[10]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[10]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[11]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[11]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[11]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[11]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[12]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[12]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[12]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[12]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[13]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[13]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[13]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[13]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[14]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[14]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[14]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[14]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad3[15]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad3[15]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad3[15]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad3[15]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[0]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[0]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[0]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[0]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[1]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[1]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[1]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[1]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[2]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[2]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[2]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[2]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[3]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[3]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[3]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[3]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[4]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[4]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[4]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[4]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[5]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[5]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[5]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[5]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[6]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[6]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[6]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[6]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[7]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[7]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[7]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[7]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[8]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[8]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[8]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[8]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[9]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[9]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[9]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[9]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[10]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[10]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[10]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[10]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[11]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[11]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[11]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[11]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[12]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[12]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[12]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[12]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[13]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[13]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[13]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[13]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[14]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[14]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[14]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[14]} .preserve true
set_db -quiet {inst:mac_chip_top/ipad4[15]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/ipad4[15]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/ipad4[15]} .dont_touch true
set_db -quiet {inst:mac_chip_top/ipad4[15]} .preserve true
set_db -quiet inst:mac_chip_top/ipad5 .dont_touch_reason set_dont_touch
set_db -quiet inst:mac_chip_top/ipad5 .dont_touch_file 0
set_db -quiet inst:mac_chip_top/ipad5 .dont_touch true
set_db -quiet inst:mac_chip_top/ipad5 .preserve true
set_db -quiet inst:mac_chip_top/ipad6 .dont_touch_reason set_dont_touch
set_db -quiet inst:mac_chip_top/ipad6 .dont_touch_file 0
set_db -quiet inst:mac_chip_top/ipad6 .dont_touch true
set_db -quiet inst:mac_chip_top/ipad6 .preserve true
set_db -quiet {inst:mac_chip_top/opad1[0]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[0]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[0]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[0]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[1]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[1]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[1]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[1]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[2]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[2]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[2]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[2]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[3]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[3]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[3]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[3]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[4]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[4]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[4]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[4]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[5]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[5]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[5]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[5]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[6]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[6]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[6]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[6]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[7]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[7]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[7]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[7]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[8]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[8]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[8]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[8]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[9]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[9]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[9]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[9]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[10]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[10]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[10]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[10]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[11]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[11]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[11]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[11]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[12]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[12]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[12]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[12]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[13]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[13]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[13]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[13]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[14]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[14]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[14]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[14]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[15]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[15]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[15]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[15]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[16]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[16]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[16]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[16]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[17]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[17]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[17]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[17]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[18]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[18]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[18]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[18]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[19]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[19]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[19]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[19]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[20]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[20]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[20]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[20]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[21]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[21]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[21]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[21]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[22]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[22]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[22]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[22]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[23]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[23]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[23]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[23]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[24]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[24]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[24]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[24]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[25]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[25]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[25]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[25]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[26]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[26]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[26]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[26]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[27]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[27]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[27]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[27]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[28]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[28]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[28]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[28]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[29]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[29]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[29]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[29]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[30]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[30]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[30]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[30]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[31]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[31]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[31]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[31]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[32]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[32]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[32]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[32]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[33]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[33]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[33]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[33]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[34]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[34]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[34]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[34]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[35]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[35]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[35]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[35]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[36]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[36]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[36]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[36]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[37]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[37]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[37]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[37]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[38]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[38]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[38]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[38]} .preserve true
set_db -quiet {inst:mac_chip_top/opad1[39]} .dont_touch_reason set_dont_touch
set_db -quiet {inst:mac_chip_top/opad1[39]} .dont_touch_file 0
set_db -quiet {inst:mac_chip_top/opad1[39]} .dont_touch true
set_db -quiet {inst:mac_chip_top/opad1[39]} .preserve true
set_db -quiet module:mac_chip_top/mac_top_A_W16_ACC_W40_MULT_ARCH0_ADDER_ARCH4_MAC_STAGES1 .hdl_filelist {{default -sv {SYNTHESIS} {../1_RTL/mac_top.v ../1_RTL/mul_top.v ../1_RTL/mul_beh.v ../1_RTL/adder_top.v ../1_RTL/adder_beh.v} {../1_RTL} {}}}
set_db -quiet module:mac_chip_top/mul_top_A_W16_MULT_ARCH0_ADDER_ARCH4 .hdl_filelist {{default -sv {SYNTHESIS} {../1_RTL/mul_top.v ../1_RTL/mul_beh.v} {../1_RTL} {}}}
set_db -quiet module:mac_chip_top/mul_beh_A_W16 .hdl_filelist {{default -sv {SYNTHESIS} {../1_RTL/mul_beh.v} {../1_RTL} {}}}
set_db -quiet module:mac_chip_top/adder_top_W40_ADDER_ARCH4 .hdl_filelist {{default -sv {SYNTHESIS} {../1_RTL/adder_top.v ../1_RTL/adder_beh.v} {../1_RTL} {}}}
set_db -quiet module:mac_chip_top/adder_beh_W40 .hdl_filelist {{default -sv {SYNTHESIS} {../1_RTL/adder_beh.v} {../1_RTL} {}}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.en_q_reg .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.en_q_reg .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.en_q_reg .original_name u_mac/g_stage1.en_q
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.en_q_reg .single_bit_orig_name u_mac/g_stage1.en_q
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.en_q_reg/Q .original_name u_mac/g_stage1.en_q/q
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.clr_q_reg .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.clr_q_reg .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.clr_q_reg .original_name u_mac/g_stage1.clr_q
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.clr_q_reg .single_bit_orig_name u_mac/g_stage1.clr_q
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.clr_q_reg/Q .original_name u_mac/g_stage1.clr_q/q
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_15 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_15 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_15 .original_name {{u_mac/g_stage1.a_q[15]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_15 .single_bit_orig_name {u_mac/g_stage1.a_q[15]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_15/Q .original_name {u_mac/g_stage1.a_q[15]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_14 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_14 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_14 .original_name {{u_mac/g_stage1.a_q[14]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_14 .single_bit_orig_name {u_mac/g_stage1.a_q[14]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_14/Q .original_name {u_mac/g_stage1.a_q[14]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_8 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_8 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_8 .original_name {{u_mac/g_stage1.a_q[8]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_8 .single_bit_orig_name {u_mac/g_stage1.a_q[8]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_8/Q .original_name {u_mac/g_stage1.a_q[8]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_0 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_0 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_0 .original_name {{u_mac/g_stage1.b_q[0]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_0 .single_bit_orig_name {u_mac/g_stage1.b_q[0]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_0/Q .original_name {u_mac/g_stage1.b_q[0]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_0 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_0 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_0 .original_name {{u_mac/g_stage1.a_q[0]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_0 .single_bit_orig_name {u_mac/g_stage1.a_q[0]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_0/Q .original_name {u_mac/g_stage1.a_q[0]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_12 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_12 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_12 .original_name {{u_mac/g_stage1.a_q[12]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_12 .single_bit_orig_name {u_mac/g_stage1.a_q[12]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_12/Q .original_name {u_mac/g_stage1.a_q[12]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_15 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_15 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_15 .original_name {{u_mac/g_stage1.b_q[15]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_15 .single_bit_orig_name {u_mac/g_stage1.b_q[15]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_15/Q .original_name {u_mac/g_stage1.b_q[15]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_7 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_7 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_7 .original_name {{u_mac/g_stage1.a_q[7]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_7 .single_bit_orig_name {u_mac/g_stage1.a_q[7]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_7/Q .original_name {u_mac/g_stage1.a_q[7]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_14 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_14 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_14 .original_name {{u_mac/g_stage1.b_q[14]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_14 .single_bit_orig_name {u_mac/g_stage1.b_q[14]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_14/Q .original_name {u_mac/g_stage1.b_q[14]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_13 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_13 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_13 .original_name {{u_mac/g_stage1.b_q[13]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_13 .single_bit_orig_name {u_mac/g_stage1.b_q[13]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_13/Q .original_name {u_mac/g_stage1.b_q[13]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_11 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_11 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_11 .original_name {{u_mac/g_stage1.a_q[11]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_11 .single_bit_orig_name {u_mac/g_stage1.a_q[11]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_11/Q .original_name {u_mac/g_stage1.a_q[11]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_6 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_6 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_6 .original_name {{u_mac/g_stage1.a_q[6]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_6 .single_bit_orig_name {u_mac/g_stage1.a_q[6]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_6/Q .original_name {u_mac/g_stage1.a_q[6]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_12 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_12 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_12 .original_name {{u_mac/g_stage1.b_q[12]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_12 .single_bit_orig_name {u_mac/g_stage1.b_q[12]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_12/Q .original_name {u_mac/g_stage1.b_q[12]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_11 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_11 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_11 .original_name {{u_mac/g_stage1.b_q[11]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_11 .single_bit_orig_name {u_mac/g_stage1.b_q[11]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_11/Q .original_name {u_mac/g_stage1.b_q[11]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_5 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_5 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_5 .original_name {{u_mac/g_stage1.a_q[5]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_5 .single_bit_orig_name {u_mac/g_stage1.a_q[5]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_5/Q .original_name {u_mac/g_stage1.a_q[5]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_10 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_10 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_10 .original_name {{u_mac/g_stage1.b_q[10]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_10 .single_bit_orig_name {u_mac/g_stage1.b_q[10]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_10/Q .original_name {u_mac/g_stage1.b_q[10]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_9 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_9 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_9 .original_name {{u_mac/g_stage1.b_q[9]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_9 .single_bit_orig_name {u_mac/g_stage1.b_q[9]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_9/Q .original_name {u_mac/g_stage1.b_q[9]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_13 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_13 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_13 .original_name {{u_mac/g_stage1.a_q[13]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_13 .single_bit_orig_name {u_mac/g_stage1.a_q[13]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_13/Q .original_name {u_mac/g_stage1.a_q[13]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_10 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_10 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_10 .original_name {{u_mac/g_stage1.a_q[10]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_10 .single_bit_orig_name {u_mac/g_stage1.a_q[10]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_10/Q .original_name {u_mac/g_stage1.a_q[10]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_4 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_4 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_4 .original_name {{u_mac/g_stage1.a_q[4]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_4 .single_bit_orig_name {u_mac/g_stage1.a_q[4]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_4/Q .original_name {u_mac/g_stage1.a_q[4]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_8 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_8 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_8 .original_name {{u_mac/g_stage1.b_q[8]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_8 .single_bit_orig_name {u_mac/g_stage1.b_q[8]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_8/Q .original_name {u_mac/g_stage1.b_q[8]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_7 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_7 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_7 .original_name {{u_mac/g_stage1.b_q[7]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_7 .single_bit_orig_name {u_mac/g_stage1.b_q[7]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_7/Q .original_name {u_mac/g_stage1.b_q[7]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_3 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_3 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_3 .original_name {{u_mac/g_stage1.a_q[3]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_3 .single_bit_orig_name {u_mac/g_stage1.a_q[3]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_3/Q .original_name {u_mac/g_stage1.a_q[3]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_6 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_6 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_6 .original_name {{u_mac/g_stage1.b_q[6]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_6 .single_bit_orig_name {u_mac/g_stage1.b_q[6]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_6/Q .original_name {u_mac/g_stage1.b_q[6]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_5 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_5 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_5 .original_name {{u_mac/g_stage1.b_q[5]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_5 .single_bit_orig_name {u_mac/g_stage1.b_q[5]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_5/Q .original_name {u_mac/g_stage1.b_q[5]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_9 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_9 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_9 .original_name {{u_mac/g_stage1.a_q[9]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_9 .single_bit_orig_name {u_mac/g_stage1.a_q[9]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_9/Q .original_name {u_mac/g_stage1.a_q[9]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_2 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_2 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_2 .original_name {{u_mac/g_stage1.a_q[2]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_2 .single_bit_orig_name {u_mac/g_stage1.a_q[2]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_2/Q .original_name {u_mac/g_stage1.a_q[2]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_4 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_4 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_4 .original_name {{u_mac/g_stage1.b_q[4]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_4 .single_bit_orig_name {u_mac/g_stage1.b_q[4]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_4/Q .original_name {u_mac/g_stage1.b_q[4]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_3 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_3 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_3 .original_name {{u_mac/g_stage1.b_q[3]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_3 .single_bit_orig_name {u_mac/g_stage1.b_q[3]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_3/Q .original_name {u_mac/g_stage1.b_q[3]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_1 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_1 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_1 .original_name {{u_mac/g_stage1.a_q[1]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.a_q_reg_1 .single_bit_orig_name {u_mac/g_stage1.a_q[1]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.a_q_reg_1/Q .original_name {u_mac/g_stage1.a_q[1]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_2 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_2 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_2 .original_name {{u_mac/g_stage1.b_q[2]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_2 .single_bit_orig_name {u_mac/g_stage1.b_q[2]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_2/Q .original_name {u_mac/g_stage1.b_q[2]/q}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_1 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_1 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_1 .original_name {{u_mac/g_stage1.b_q[1]}}
set_db -quiet inst:mac_chip_top/u_mac/g_stage1.b_q_reg_1 .single_bit_orig_name {u_mac/g_stage1.b_q[1]}
set_db -quiet pin:mac_chip_top/u_mac/g_stage1.b_q_reg_1/Q .original_name {u_mac/g_stage1.b_q[1]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_0 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_0 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_0 .original_name {{u_mac/acc_q[0]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_0 .single_bit_orig_name {u_mac/acc_q[0]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_0/Q .original_name {u_mac/acc_q[0]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_1 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_1 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_1 .original_name {{u_mac/acc_q[1]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_1 .single_bit_orig_name {u_mac/acc_q[1]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_1/Q .original_name {u_mac/acc_q[1]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_2 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_2 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_2 .original_name {{u_mac/acc_q[2]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_2 .single_bit_orig_name {u_mac/acc_q[2]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_2/Q .original_name {u_mac/acc_q[2]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_3 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_3 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_3 .original_name {{u_mac/acc_q[3]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_3 .single_bit_orig_name {u_mac/acc_q[3]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_3/Q .original_name {u_mac/acc_q[3]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_4 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_4 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_4 .original_name {{u_mac/acc_q[4]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_4 .single_bit_orig_name {u_mac/acc_q[4]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_4/Q .original_name {u_mac/acc_q[4]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_5 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_5 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_5 .original_name {{u_mac/acc_q[5]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_5 .single_bit_orig_name {u_mac/acc_q[5]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_5/Q .original_name {u_mac/acc_q[5]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_6 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_6 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_6 .original_name {{u_mac/acc_q[6]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_6 .single_bit_orig_name {u_mac/acc_q[6]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_6/Q .original_name {u_mac/acc_q[6]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_7 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_7 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_7 .original_name {{u_mac/acc_q[7]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_7 .single_bit_orig_name {u_mac/acc_q[7]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_7/Q .original_name {u_mac/acc_q[7]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_8 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_8 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_8 .original_name {{u_mac/acc_q[8]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_8 .single_bit_orig_name {u_mac/acc_q[8]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_8/Q .original_name {u_mac/acc_q[8]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_9 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_9 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_9 .original_name {{u_mac/acc_q[9]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_9 .single_bit_orig_name {u_mac/acc_q[9]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_9/Q .original_name {u_mac/acc_q[9]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_10 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_10 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_10 .original_name {{u_mac/acc_q[10]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_10 .single_bit_orig_name {u_mac/acc_q[10]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_10/Q .original_name {u_mac/acc_q[10]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_11 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_11 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_11 .original_name {{u_mac/acc_q[11]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_11 .single_bit_orig_name {u_mac/acc_q[11]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_11/Q .original_name {u_mac/acc_q[11]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_12 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_12 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_12 .original_name {{u_mac/acc_q[12]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_12 .single_bit_orig_name {u_mac/acc_q[12]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_12/Q .original_name {u_mac/acc_q[12]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_13 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_13 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_13 .original_name {{u_mac/acc_q[13]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_13 .single_bit_orig_name {u_mac/acc_q[13]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_13/Q .original_name {u_mac/acc_q[13]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_14 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_14 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_14 .original_name {{u_mac/acc_q[14]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_14 .single_bit_orig_name {u_mac/acc_q[14]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_14/Q .original_name {u_mac/acc_q[14]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_15 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_15 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_15 .original_name {{u_mac/acc_q[15]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_15 .single_bit_orig_name {u_mac/acc_q[15]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_15/Q .original_name {u_mac/acc_q[15]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_16 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_16 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_16 .original_name {{u_mac/acc_q[16]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_16 .single_bit_orig_name {u_mac/acc_q[16]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_16/Q .original_name {u_mac/acc_q[16]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_17 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_17 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_17 .original_name {{u_mac/acc_q[17]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_17 .single_bit_orig_name {u_mac/acc_q[17]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_17/Q .original_name {u_mac/acc_q[17]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_18 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_18 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_18 .original_name {{u_mac/acc_q[18]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_18 .single_bit_orig_name {u_mac/acc_q[18]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_18/Q .original_name {u_mac/acc_q[18]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_19 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_19 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_19 .original_name {{u_mac/acc_q[19]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_19 .single_bit_orig_name {u_mac/acc_q[19]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_19/Q .original_name {u_mac/acc_q[19]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_20 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_20 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_20 .original_name {{u_mac/acc_q[20]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_20 .single_bit_orig_name {u_mac/acc_q[20]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_20/Q .original_name {u_mac/acc_q[20]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_21 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_21 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_21 .original_name {{u_mac/acc_q[21]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_21 .single_bit_orig_name {u_mac/acc_q[21]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_21/Q .original_name {u_mac/acc_q[21]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_22 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_22 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_22 .original_name {{u_mac/acc_q[22]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_22 .single_bit_orig_name {u_mac/acc_q[22]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_22/Q .original_name {u_mac/acc_q[22]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_23 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_23 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_23 .original_name {{u_mac/acc_q[23]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_23 .single_bit_orig_name {u_mac/acc_q[23]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_23/Q .original_name {u_mac/acc_q[23]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_24 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_24 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_24 .original_name {{u_mac/acc_q[24]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_24 .single_bit_orig_name {u_mac/acc_q[24]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_24/Q .original_name {u_mac/acc_q[24]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_25 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_25 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_25 .original_name {{u_mac/acc_q[25]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_25 .single_bit_orig_name {u_mac/acc_q[25]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_25/Q .original_name {u_mac/acc_q[25]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_26 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_26 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_26 .original_name {{u_mac/acc_q[26]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_26 .single_bit_orig_name {u_mac/acc_q[26]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_26/Q .original_name {u_mac/acc_q[26]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_27 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_27 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_27 .original_name {{u_mac/acc_q[27]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_27 .single_bit_orig_name {u_mac/acc_q[27]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_27/Q .original_name {u_mac/acc_q[27]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_28 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_28 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_28 .original_name {{u_mac/acc_q[28]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_28 .single_bit_orig_name {u_mac/acc_q[28]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_28/Q .original_name {u_mac/acc_q[28]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_29 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_29 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_29 .original_name {{u_mac/acc_q[29]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_29 .single_bit_orig_name {u_mac/acc_q[29]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_29/Q .original_name {u_mac/acc_q[29]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_30 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_30 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_30 .original_name {{u_mac/acc_q[30]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_30 .single_bit_orig_name {u_mac/acc_q[30]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_30/Q .original_name {u_mac/acc_q[30]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_31 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_31 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_31 .original_name {{u_mac/acc_q[31]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_31 .single_bit_orig_name {u_mac/acc_q[31]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_31/Q .original_name {u_mac/acc_q[31]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_32 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_32 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_32 .original_name {{u_mac/acc_q[32]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_32 .single_bit_orig_name {u_mac/acc_q[32]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_32/Q .original_name {u_mac/acc_q[32]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_33 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_33 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_33 .original_name {{u_mac/acc_q[33]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_33 .single_bit_orig_name {u_mac/acc_q[33]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_33/Q .original_name {u_mac/acc_q[33]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_34 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_34 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_34 .original_name {{u_mac/acc_q[34]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_34 .single_bit_orig_name {u_mac/acc_q[34]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_34/Q .original_name {u_mac/acc_q[34]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_35 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_35 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_35 .original_name {{u_mac/acc_q[35]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_35 .single_bit_orig_name {u_mac/acc_q[35]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_35/Q .original_name {u_mac/acc_q[35]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_36 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_36 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_36 .original_name {{u_mac/acc_q[36]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_36 .single_bit_orig_name {u_mac/acc_q[36]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_36/Q .original_name {u_mac/acc_q[36]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_37 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_37 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_37 .original_name {{u_mac/acc_q[37]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_37 .single_bit_orig_name {u_mac/acc_q[37]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_37/Q .original_name {u_mac/acc_q[37]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_38 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_38 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_38 .original_name {{u_mac/acc_q[38]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_38 .single_bit_orig_name {u_mac/acc_q[38]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_38/Q .original_name {u_mac/acc_q[38]/q}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_39 .orig_hdl_instantiated false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_39 .gint_phase_inversion false
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_39 .original_name {{u_mac/acc_q[39]}}
set_db -quiet inst:mac_chip_top/u_mac/acc_q_reg_39 .single_bit_orig_name {u_mac/acc_q[39]}
set_db -quiet pin:mac_chip_top/u_mac/acc_q_reg_39/Q .original_name {u_mac/acc_q[39]/q}
# BEGIN PMBIST SECTION
# END PMBIST SECTION
# BEGIN PHYSICAL ANNOTATION SECTION
# END PHYSICAL ANNOTATION SECTION
# BEGIN GLO TBR TABLE
set_db -quiet design:mac_chip_top .set_boundary_change_new {start restore}
set_db -quiet design:mac_chip_top .set_boundary_change_new {finish restore}
# END GLO TBR TABLE
set_db -quiet source_verbose true
#############################################################
#####   FLOW WRITE   ########################################
##
## Written by Genus(TM) Synthesis Solution version 22.17-s071_1
## flowkit v22.15-s003_1
## Written on 03:18:59 30-Oct 2026
#############################################################
#####   Flow Definitions   ##################################

#############################################################
#####   Step Definitions   ##################################


#############################################################
#####   Attribute Definitions   #############################

if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}


#############################################################
#####   Flow History   ######################################

if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}
if {[is_attribute flow_plugin_steps -obj_type root]} {set_db flow_plugin_steps {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_remark -obj_type root]} {set_db flow_remark {}}
if {[is_attribute flow_features -obj_type root]} {set_db flow_features {}}
if {[is_attribute flow_feature_values -obj_type root]} {set_db flow_feature_values {}}
if {[is_attribute flow_write_db_args -obj_type root]} {set_db flow_write_db_args {}}
if {[is_attribute flow_write_db_sdc -obj_type root]} {set_db flow_write_db_sdc true}
if {[is_attribute flow_write_db_common -obj_type root]} {set_db flow_write_db_common false}
if {[is_attribute flow_post_db_overwrite -obj_type root]} {set_db flow_post_db_overwrite {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_last -obj_type root]} {set_db flow_step_last {}}
if {[is_attribute flow_step_current -obj_type root]} {set_db flow_step_current {}}
if {[is_attribute flow_step_canonical_current -obj_type root]} {set_db flow_step_canonical_current {}}
if {[is_attribute flow_step_next -obj_type root]} {set_db flow_step_next {}}
if {[is_attribute flow_working_directory -obj_type root]} {set_db flow_working_directory .}
if {[is_attribute flow_branch -obj_type root]} {set_db flow_branch {}}
if {[is_attribute flow_caller_data -obj_type root]} {set_db flow_caller_data {}}
if {[is_attribute flow_metrics_snapshot_uuid -obj_type root]} {set_db flow_metrics_snapshot_uuid {}}
if {[is_attribute flow_starting_db -obj_type root]} {set_db flow_starting_db {}}
if {[is_attribute flow_db_directory -obj_type root]} {set_db flow_db_directory dbs}
if {[is_attribute flow_report_directory -obj_type root]} {set_db flow_report_directory reports}
if {[is_attribute flow_log_directory -obj_type root]} {set_db flow_log_directory logs}
if {[is_attribute flow_mail_to -obj_type root]} {set_db flow_mail_to {}}
if {[is_attribute flow_exit_when_done -obj_type root]} {set_db flow_exit_when_done false}
if {[is_attribute flow_mail_on_error -obj_type root]} {set_db flow_mail_on_error false}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_history -obj_type root]} {set_db flow_history {}}
if {[is_attribute flow_step_last_status -obj_type root]} {set_db flow_step_last_status not_run}
if {[is_attribute flow_step_last_msg -obj_type root]} {set_db flow_step_last_msg {}}
if {[is_attribute flow_run_tag -obj_type root]} {set_db flow_run_tag {}}
if {[is_attribute flow_current_cache -obj_type root]} {set_db flow_current_cache {}}
if {[is_attribute flow_step_order_cache -obj_type root]} {set_db flow_step_order_cache {}}
if {[is_attribute flow_step_results_cache -obj_type root]} {set_db flow_step_results_cache {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_execute_in_global -obj_type root]} {set_db flow_execute_in_global true}
if {[is_attribute flow_overwrite_db -obj_type root]} {set_db flow_overwrite_db false}
if {[is_attribute flow_print_run_information -obj_type root]} {set_db flow_print_run_information false}
if {[is_attribute flow_verbose -obj_type root]} {set_db flow_verbose true}
if {[is_attribute flow_print_run_information_full -obj_type root]} {set_db flow_print_run_information_full false}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_init_header_tcl -obj_type root]} {set_db flow_init_header_tcl {}}
if {[is_attribute flow_init_footer_tcl -obj_type root]} {set_db flow_init_footer_tcl {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_step_last_number -obj_type root]} {set_db flow_step_last_number 0}
if {[is_attribute flow_autoload_applets -obj_type root]} {set_db flow_autoload_applets false}
if {[is_attribute flow_autoload_dir -obj_type root]} {set_db flow_autoload_dir error}
if {[is_attribute flow_skip_auto_db_save -obj_type root]} {set_db flow_skip_auto_db_save true}
if {[is_attribute flow_skip_auto_generate_metrics -obj_type root]} {set_db flow_skip_auto_generate_metrics false}
if {[is_attribute flow_top -obj_type root]} {set_db flow_top {}}
if {[is_attribute flow_hier_path -obj_type root]} {set_db flow_hier_path {}}
if {[is_attribute flow_schedule -obj_type root]} {set_db flow_schedule {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_script -obj_type root]} {set_db flow_script {}}
if {[is_attribute flow_yaml_script -obj_type root]} {set_db flow_yaml_script {}}
if {[is_attribute flow_cla_enabled_features -obj_type root]} {set_db flow_cla_enabled_features {}}
if {[is_attribute flow_cla_inject_tcl -obj_type root]} {set_db flow_cla_inject_tcl {}}
if {[is_attribute flow_error_message -obj_type root]} {set_db flow_error_message {}}
if {[is_attribute flow_error_errorinfo -obj_type root]} {set_db flow_error_errorinfo {}}
if {[is_attribute flow_exclude_time_for_init_flow -obj_type root]} {set_db flow_exclude_time_for_init_flow false}
if {[is_attribute flow_error_write_db -obj_type root]} {set_db flow_error_write_db true}
if {[is_attribute flow_advanced_metric_isolation -obj_type root]} {set_db flow_advanced_metric_isolation flow}
if {[is_attribute flow_yaml_root -obj_type root]} {set_db flow_yaml_root {}}
if {[is_attribute flow_yaml_root_dir -obj_type root]} {set_db flow_yaml_root_dir {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}

#############################################################
#####   User Defined Attributes   ###########################


################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/04/2026 05:07:34
#
################################################################################
if { ![is_common_ui_mode] } { error "ERROR: This script requires common_ui to be active."}

read_physical -lef {/home/hah013/PROJ3/proj3_make/TOP/3_SYN/../../../../SoC/GPDK045/digital/gsclib045_all_v4.4/gsclib045/lef/gsclib045_tech.lef /home/hah013/PROJ3/proj3_make/TOP/3_SYN/../../../../SoC/GPDK045/digital/gsclib045_all_v4.4/gsclib045/lef/gsclib045_macro.lef}

read_netlist ./mapped/alu_top_mapped.v

init_design

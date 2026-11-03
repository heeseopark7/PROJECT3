
########################################
# InitDesign (Setup, Floorplan)
# Target : alu_top only (block-level, no IO pad ring)
# Run from 5_PNR :  innovus -init 0_InitDesign.tcl   (legacy UI, no -stylus)
########################################

## PDK root. Same location convention as 3_SYN/script/alu_top.tcl (4 levels up from 3_SYN / 5_PNR).
set PDK ../../../../SoC/GPDK045

## Initialization
set init_gnd_net VSS
set init_pwr_net VDD
set init_lef_file [list \
    $PDK/digital/gsclib045_all_v4.4/gsclib045_tech/lef/gsclib045_tech.lef \
    $PDK/digital/gsclib045_all_v4.4/gsclib045/lef/gsclib045_macro.lef \
    $PDK/digital/gsclib045_all_v4.4/gsclib045/lef/gsclib045_multibitsDFF.lef ]
set init_verilog ../3_SYN/mapped/alu_top_syn_final.v
set init_mmmc_file alu_top.mmmc.view
set init_top_cell alu_top
## No init_io_file : the synthesized netlist has no pads, so alu_top is placed as a plain block.
## (init.io / add_pad / giolib045 were for cmsdk_mcu only.)
init_design

## Check Design
checkDesign -netlist -physicalLibrary -powerGround -tieHilo -timingLibrary -spef -floorplan -place -outdir checkDesign

##################################################
## Floorplan :: aspect ratio 1, core utilization 0.7
## Std-cell area is ~1.7e3 um^2 after synthesis -> core is roughly 50 x 50 um.
## Margin 30 um on each side = room for the core power ring (2 wires x 5 + spacing 5 + offset 5 = 20 um).
## Utilization is a starting value; adjust after the first placement/congestion report.
##################################################
floorPlan -site CoreSite -r 1 0.7 30 30 30 30

## IO pins : not placed here. 2_PlaceOpt.tcl lets the placer assign them (place_global_place_io_pins).

# Verify Timing
report_analysis_views 
timeDesign -prePlace

## If there is no error, Save Design
saveDesign -def InitDesign
exit

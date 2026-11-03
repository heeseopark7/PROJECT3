#######################
#### Chip Finish ######
#######################
restoreDesign RouteDesign.dat

# Add Filler
getFillerMode -quiet
addFiller -cell FILL1 FILL8 FILL64 FILL4 FILL32 FILL2 FILL16 -prefix FILLER

# DRC
verify_drc

# LVS : Connectivity 
verifyConnectivity -type all -geomConnect -error 1000 -warning 50

# Error Browser
setLayerPreference violation -isVisible 1
violationBrowser -all -no_display_false -displayByLayer

# Extraction 
extractRC

# If there is no error, save Design
saveDesign -rc -def ChipFinish

#####################
#### Write Out ######
#####################
# Write Out Files

# Netlist  file : -flat options is useful to next tool stages
saveNetlist -flat alu_top.v

# SDF OUT, but I recommend to use sdf file which is from Tempus tool
# SDF version 3.0 :: RECREM included in the SDF file
write_sdf alu_top.sdf

# SDF version 2.1
write_sdf -version 2.1 alu_top.sdf_2.1

# Write Out Constraint
writeTimingCon alu_top.sdc

# GDS file : without layermap file for GPDK045
streamOut alu_top.gds -libName DesignLib -units 2000 -mode ALL

exit

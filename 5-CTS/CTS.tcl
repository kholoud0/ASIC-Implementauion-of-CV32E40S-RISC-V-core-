set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


open_block /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/riscv_core2:riscv_core_4_placed.design
link_block
####################################################################################
###################################  CTS  ###################################
####################################################################################

set_dont_touch_network -clear [get_clocks CLK_I]

set_dont_use [get_lib_cells */*_INV_S_10*]

set_dont_use [get_lib_cells */*_INV_S_12*]

set_dont_use [get_lib_cells */*_INV_S_14*]

set_dont_use [get_lib_cells */*_INV_S_16*]

set_dont_use [get_lib_cells */*_INV_S_20*]

set_dont_use [get_lib_cells */*_INV_S_18*]
set_dont_use [get_lib_cells */*_BUF*]
############################################################
#source /home/islam/ICpedia_Tasks/GPCore-aes_ip/core_updated/syn/cons/dont_use_generic.tcl

#create_routing_rule ROUTE_RULES_1 \
 # -widths {M3 0.2 M4 0.2 } \
  #-spacings {M3 0.42 M4 0.63 }
#########################  include buffers to cts  ########################
set_lib_cell_purpose -exclude cts [get_lib_cells -of [get_cells *]]
#set_lib_cell_purpose -include cts */*AOBUF_IW*
#set_lib_cell_purpose -include cts */*BUF*
set_lib_cell_purpose -include cts */*_INV_S_2*
set_lib_cell_purpose -include cts */*_INV_S_3*
set_lib_cell_purpose -include cts */*_INV_S_4*
set_lib_cell_purpose -include cts */*_INV_S_6*
set_lib_cell_purpose -include cts */*_INV_S_8*
check_design -checks pre_clock_tree_stage

create_routing_rule ROUTE_RULES -multiplier_spacing 3 -multiplier_width 3
set_clock_routing_rules -rules ROUTE_RULES -min_routing_layer M2  -max_routing_layer M4
set_clock_tree_options -target_latency 0.000 -target_skew 0.000 
set cts_enable_drc_fixing_on_data true

clock_opt

# clock_opt -from final_opto               #optimization
check_pg_drc
write_verilog /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/results/${DESIGN}.cts.gate.v

set_propagated_clock [get_clocks CLK_I]


#create_tap_cells -lib_cell saed14rvt_frame_timing_ccs/SAEDRVT14_TAPDS -pattern stagger -distance 15

save_block -as ${DESIGN}_5_cts

print_res {cts}
report_qor > $dir/cts/qor.rpt

create_utilization_configuration config_sr \
            -capacity site_row -exclude {hard_macros macro_keepouts}
report_utilization -config config_sr -verbose > $dir/cts/utilization_site_row.rpt
report_clock_timing  -type skew >  $dir/cts/clock_skew.rpt
report_clock_qor -type area >  $dir/cts/clock_qor_area.rpt


 close_blocks -force -purge
close_lib


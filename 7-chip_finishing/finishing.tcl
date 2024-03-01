set_host_options -max_cores 8
set DESIGN riscv_core
source /mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/2-Floorplan/scripts/proc_block.tcl

set dir "/mnt/hgfs/Gp_CV32e40p/ASIC-Implementauion-of-CV32E40S-RISC-V-core-/report"


####################################################################################
###################################  FINISHING  ###################################
####################################################################################

############################################################

## std filler
set pnr_std_fillers "SAEDRVT14_FILL*"
set std_fillers "  saed14rvt_ss0p6vm40c:SAEDRVT14_FILL16   saed14rvt_ss0p6vm40c:SAEDRVT14_FILL32   saed14rvt_ss0p6vm40c:SAEDRVT14_FILL64 saed14rvt_ss0p6vm40c:SAEDRVT14_FILL_ECO_1    saed14rvt_ss0p6vm40c:SAEDRVT14_FILL_ECO_2      saed14rvt_ss0p6vm40c:SAEDRVT14_FILL_ECO_3  saed14rvt_ss0p6vm40c:SAEDRVT14_FILL_ECO_6  saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV1ECO_15  saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV1ECO_9  saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV1ECO_6  saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV1ECO_18 saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV3_3    saed14rvt_ss0p6vm40c/SAEDRVT14_DCAP_PV1ECO_12  "
#foreach filler $pnr_std_fillers { lappend std_fillers "*/${filler}" }
create_stdcell_filler -lib_cell $std_fillers

connect_pg_net -net $NDM_POWER_NET [get_pins -hierarchical "*/VDD"]
connect_pg_net -net $NDM_GROUND_NET [get_pins -hierarchical "*/VSS"]

############################################################

write_verilog /home/ICer/cv32e40p_updated/results/riscv_core.icc2.gate.v
print_res {finishing}
report_qor > $dir/finishing/qor.rpt
-config config_sr -verbose > $dir/finishing/utilization.rpt
############################################################
##NAR STREAMOUT-I U VERILOG OUT-I PAHY SCRIPTUM CHKA, BAITS AVELATSNENQ CHE EREVI?
if { 1 } {
#report_area
report_timing
report_power 

save_block -as ${DESIGN}_4_finished


change_names -rules verilog -verbose
write_verilog \
	-include {pg_netlist unconnected_ports} \
	/home/ICer/cv32e40p_updated/ICC2-20220416T120705Z-001/ICC2/scripts/outputs/${DESIGN}_pg.v

write_gds -design ${DESIGN}_4_finished \
	  -layer_map $GDS_MAP_FILE \
	  -keep_data_type \
	  -fill include \
	  -output_pin all \
	  -merge_files "$STD_CELL_GDS" \
	  -long_names \
	  /home/ICer/cv32e40p_updated/ICC2-20220416T120705Z-001/ICC2/scripts/outputs/${DESIGN}.gds

write_parasitics -output    {/home/ICer/cv32e40p_updated/results/core_final.spf}

close_block
close_lib

exit

}

set_property PACKAGE_PIN A13 [get_ports Clk100M]

set_property PACKAGE_PIN G8  [get_ports BaseX_gtrefclk_p]
set_property PACKAGE_PIN K6  [get_ports {BaseX_rxp[0]}]
set_property PACKAGE_PIN H6  [get_ports {BaseX_rxp[1]}]
set_property PACKAGE_PIN G4  [get_ports {BaseX_rxp[2]}]
set_property PACKAGE_PIN F6  [get_ports {BaseX_rxp[3]}]

set_property PACKAGE_PIN L8 [get_ports {Aurora_Clk_P[0]}]
set_property PACKAGE_PIN T6 [get_ports {Aurora_Rx_P[0]}]
set_property PACKAGE_PIN R4 [get_ports {Aurora_Rx_P[1]}]
set_property PACKAGE_PIN P6 [get_ports {Aurora_Rx_P[2]}]
set_property PACKAGE_PIN M6 [get_ports {Aurora_Rx_P[3]}]

set_property PACKAGE_PIN R8 [get_ports {Aurora_Clk_P[1]}]
set_property PACKAGE_PIN Y6 [get_ports {Aurora_Rx_P[4]}]
set_property PACKAGE_PIN W4 [get_ports {Aurora_Rx_P[5]}]
set_property PACKAGE_PIN V6 [get_ports {Aurora_Rx_P[6]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Clk100M_IBUF]
# REF:NanBCSU.xdc

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Aurora_Top_P3_inst/gt_common_support/gt_qpllclk
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_shared_clock_reset_block/refclk]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_gt_common_block/qplloutclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Clk100M_IBUF]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_shared_clock_reset_block/refclk] 
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_gt_common_block/qplloutclk] 
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Clk100M_IBUF]


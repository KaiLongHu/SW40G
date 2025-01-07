create_clock -period 6.400 -name BaseX_gtrefclk_p -waveform {0.000 3.200} [get_ports BaseX_gtrefclk_p]
create_clock -period 6.400 -name {Aurora_Clk_P[0]} -waveform {0.000 3.200} [get_ports {Aurora_Clk_P[0]}]
create_clock -period 6.400 -name {Aurora_Clk_P[1]} -waveform {0.000 3.200} [get_ports {Aurora_Clk_P[1]}]
create_clock -period 10.000 -name Clk100M -waveform {0.000 5.000} [get_ports Clk100M]


set_property PACKAGE_PIN AD23 [get_ports Clk100M]
set_property IOSTANDARD LVCMOS33 [get_ports Clk100M]

set_property PACKAGE_PIN C8 [get_ports BaseX_gtrefclk_p]
set_property PACKAGE_PIN E4 [get_ports {BaseX_rxp[0]}]
set_property PACKAGE_PIN D6 [get_ports {BaseX_rxp[1]}]
set_property PACKAGE_PIN B6 [get_ports {BaseX_rxp[2]}]
set_property PACKAGE_PIN A8 [get_ports {BaseX_rxp[3]}]

set_property PACKAGE_PIN G8 [get_ports {Aurora_Clk_P[0]}]
set_property PACKAGE_PIN K6 [get_ports {Aurora_Rx_P[0]}]
set_property PACKAGE_PIN H6 [get_ports {Aurora_Rx_P[1]}]
set_property PACKAGE_PIN G4 [get_ports {Aurora_Rx_P[2]}]
set_property PACKAGE_PIN F6 [get_ports {Aurora_Rx_P[3]}]

set_property PACKAGE_PIN L8 [get_ports {Aurora_Clk_P[1]}]
set_property PACKAGE_PIN T6 [get_ports {Aurora_Rx_P[4]}]
set_property PACKAGE_PIN R4 [get_ports {Aurora_Rx_P[5]}]
set_property PACKAGE_PIN P6 [get_ports {Aurora_Rx_P[6]}]



set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Clk100M_IBUF]

set_false_path -from [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i0/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK] -to [get_clocks BaseX_gtrefclk_p]
set_false_path -from [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i0/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/TXOUTCLK] -to [get_clocks BaseX_gtrefclk_p]
set_false_path -from [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i1/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK] -to [get_clocks BaseX_gtrefclk_p]
set_false_path -from [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i2/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK] -to [get_clocks BaseX_gtrefclk_p]
set_false_path -from [get_clocks Clk100M] -to [get_clocks BaseX_gtrefclk_p]
set_false_path -from [get_clocks BaseX_gtrefclk_p] -to [get_clocks -of_objects [get_pins Glb_Rst_Gen_Inst/ClockGenInst/inst/mmcm_adv_inst/CLKOUT4]]
set_false_path -from [get_clocks BaseX_gtrefclk_p] -to [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i0/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK]
set_false_path -from [get_clocks BaseX_gtrefclk_p] -to [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i0/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/TXOUTCLK]
set_false_path -from [get_clocks BaseX_gtrefclk_p] -to [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i1/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK]
set_false_path -from [get_clocks BaseX_gtrefclk_p] -to [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i2/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK]
set_false_path -from [get_clocks BaseX_gtrefclk_p] -to [get_clocks ten_gig_eth_pcs_pma_example_design_Port4_dut/ten_gig_eth_pcs_pma_support_Port4_dut/ten_gig_eth_pcs_pma_i3/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_10gbaser_i/gtxe2_i/RXOUTCLK]
set_false_path -from [get_clocks Clk100M] -to [get_clocks -of_objects [get_pins Aurora_Top_P3_inst/clock_module/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks Clk100M] -to [get_clocks -of_objects [get_pins Aurora_Top_lane2_P2_inst/clock_module/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins Glb_Rst_Gen_Inst/ClockGenInst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins Aurora_Top_P3_inst/clock_module/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins Glb_Rst_Gen_Inst/ClockGenInst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins Aurora_Top_lane2_P2_inst/clock_module/mmcm_adv_inst/CLKOUT0]]

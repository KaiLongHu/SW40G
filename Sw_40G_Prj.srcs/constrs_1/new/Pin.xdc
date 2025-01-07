create_clock -period 6.400 -name BaseX_gtrefclk_p -waveform {0.000 3.200} [get_ports BaseX_gtrefclk_p]
create_clock -period 6.400 -name Aurora_Clk_P[0] -waveform {0.000 3.200} [get_ports Aurora_Clk_P[0]]
create_clock -period 6.400 -name Aurora_Clk_P[1] -waveform {0.000 3.200} [get_ports Aurora_Clk_P[1]]
create_clock -period 10.000 -name Clk100M -waveform {0.000 5.000} [get_ports Clk100M]


set_property PACKAGE_PIN AD23 [get_ports Clk100M]
set_property IOSTANDARD LVCMOS33 [get_ports Clk100M]
# 
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

set_property PACKAGE_PIN R8  [get_ports {Aurora_Clk_P[1]}]
set_property PACKAGE_PIN AA4 [get_ports {Aurora_Rx_P[4]}]
set_property PACKAGE_PIN Y6  [get_ports {Aurora_Rx_P[5]}]
set_property PACKAGE_PIN W4  [get_ports {Aurora_Rx_P[6]}]



set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets Clk100M_IBUF]

set_property SEVERITY {Warning} [get_drc_checks {REQP-52}]




# REF:NanBCSU.xdc


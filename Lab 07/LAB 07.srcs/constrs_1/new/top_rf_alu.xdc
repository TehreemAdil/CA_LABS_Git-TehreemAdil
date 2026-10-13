## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches for ALU Operation (sw_alu_op[3:0])
set_property PACKAGE_PIN V17 [get_ports {sw_alu_op[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_alu_op[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw_alu_op[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_alu_op[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw_alu_op[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_alu_op[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw_alu_op[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_alu_op[3]}]

## LEDs for ALU Result (led_result[3:0]) mapped to Rightmost LEDs
set_property PACKAGE_PIN U16 [get_ports {led_result[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_result[0]}]
set_property PACKAGE_PIN E19 [get_ports {led_result[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_result[1]}]
set_property PACKAGE_PIN U19 [get_ports {led_result[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_result[2]}]
set_property PACKAGE_PIN V19 [get_ports {led_result[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_result[3]}]

## LEDs for FSM State (led_state[1:0]) mapped to Leftmost LEDs
set_property PACKAGE_PIN P1 [get_ports {led_state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_state[0]}]
set_property PACKAGE_PIN L1 [get_ports {led_state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_state[1]}]

## Button for Reset (rst) mapped to Center Button
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
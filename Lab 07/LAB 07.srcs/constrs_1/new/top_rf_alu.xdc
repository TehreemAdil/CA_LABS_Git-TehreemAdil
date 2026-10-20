## Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset Button
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports rst]

## Switches for ALU Operation (Choose operation to run)
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {switches_alu_op[0]}]
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports {switches_alu_op[1]}]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports {switches_alu_op[2]}]
set_property -dict { PACKAGE_PIN W17  IOSTANDARD LVCMOS33 } [get_ports {switches_alu_op[3]}]

## Switches for Destination Register (rd)
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33 } [get_ports {switch_rd[0]}]
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports {switch_rd[1]}]
set_property -dict { PACKAGE_PIN W14  IOSTANDARD LVCMOS33 } [get_ports {switch_rd[2]}]
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33 } [get_ports {switch_rd[3]}]
set_property -dict { PACKAGE_PIN V2   IOSTANDARD LVCMOS33 } [get_ports {switch_rd[4]}]

## Switch for WriteEnable
set_property -dict { PACKAGE_PIN T3   IOSTANDARD LVCMOS33 } [get_ports switch_we]

## LEDs for ALU Result (Lower bits)
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {leds_result[0]}]
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33 } [get_ports {leds_result[1]}]
set_property -dict { PACKAGE_PIN U19  IOSTANDARD LVCMOS33 } [get_ports {leds_result[2]}]
set_property -dict { PACKAGE_PIN V19  IOSTANDARD LVCMOS33 } [get_ports {leds_result[3]}]
set_property -dict { PACKAGE_PIN W18  IOSTANDARD LVCMOS33 } [get_ports {leds_result[4]}]
set_property -dict { PACKAGE_PIN U15  IOSTANDARD LVCMOS33 } [get_ports {leds_result[5]}]
set_property -dict { PACKAGE_PIN U14  IOSTANDARD LVCMOS33 } [get_ports {leds_result[6]}]
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33 } [get_ports {leds_result[7]}]

## LEDs for FSM State
set_property -dict { PACKAGE_PIN P1   IOSTANDARD LVCMOS33 } [get_ports {leds_state[0]}]
set_property -dict { PACKAGE_PIN L1   IOSTANDARD LVCMOS33 } [get_ports {leds_state[1]}]
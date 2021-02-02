## CMOD A7 board. Chip: xc7a35tcpg236-1

set_property PACKAGE_PIN L17 [get_ports GCLK_i]

set_property PACKAGE_PIN G17 [get_ports PMOD0[0]] ;# JA1
set_property PACKAGE_PIN G19 [get_ports PMOD0[1]] ;# JA2
set_property PACKAGE_PIN N18 [get_ports PMOD0[2]] ;# JA3
set_property PACKAGE_PIN L18 [get_ports PMOD0[3]] ;# JA4

set_property PACKAGE_PIN H17 [get_ports PMOD1[0]] ;# JA7
set_property PACKAGE_PIN H19 [get_ports PMOD1[1]] ;# JA8
set_property PACKAGE_PIN J19 [get_ports PMOD1[2]] ;# JA9
set_property PACKAGE_PIN K18 [get_ports PMOD1[3]] ;# JA10

set_property PACKAGE_PIN B18 [get_ports {BTN_i[1]}]
set_property PACKAGE_PIN A18 [get_ports {BTN_i[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports GCLK_i]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD0[0]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD0[1]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD0[2]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD0[3]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1[0]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1[1]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1[2]]
set_property IOSTANDARD LVCMOS33 [get_ports PMOD1[3]]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_i[0]}]

# Overriden by PLL constraints
# create_clock -period 83.330 -name clk12 [get_ports GCLK_i]

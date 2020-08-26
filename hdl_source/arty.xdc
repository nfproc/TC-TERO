# constraints for TERO-based TRNGs
# See COPYING file for license information.

set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];
create_clock -add -name tero_clk -period 3.70 -waveform {0 1.5} [get_pins { RNG/OUTBUF/O }];
set_clock_uncertainty 0.50 [get_clocks tero_clk]
set_clock_groups -name tero_async -asynchronous -group { sys_clk_pin } -group { tero_clk };

set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports { RST }];
set_property -dict { PACKAGE_PIN C9 IOSTANDARD LVCMOS33 } [get_ports { MODE[0] }]; 
set_property -dict { PACKAGE_PIN B9 IOSTANDARD LVCMOS33 } [get_ports { MODE[1] }]; 
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports { TXD }]; 

set_property -dict { PACKAGE_PIN A8 IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; 
set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; 
set_property -dict { PACKAGE_PIN C10 IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; 
set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports { SW[3] }]; 

set_property -dict { PACKAGE_PIN G6 IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; 
set_property -dict { PACKAGE_PIN G3 IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; 
set_property -dict { PACKAGE_PIN J3 IOSTANDARD LVCMOS33 } [get_ports { LED[2] }]; 
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports { LED[3] }]; 
set_property -dict { PACKAGE_PIN H5 IOSTANDARD LVCMOS33 } [get_ports { LED[4] }]; 
set_property -dict { PACKAGE_PIN J5 IOSTANDARD LVCMOS33 } [get_ports { LED[5] }]; 
set_property -dict { PACKAGE_PIN T9 IOSTANDARD LVCMOS33 } [get_ports { LED[6] }]; 
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { LED[7] }]; 

TC-TERO: Three-path Configurable Transition Effect Ring Oscillator
==================================================================

Abstract
--------

This repository contains HDL source codes (written in Verilog) and
Ruby scripts to evaluate a true random number generator (TRNG) based
on the following article:

> Naoki Fujieda, On the feasibility of TERO-based true random number
> generator on Xilinx FPGAs, 30th International Conference on
> Field-Programmable Logic and Applications (FPL 2020), accepted as
> short paper (08/2020).

The repository is organized by three directories as follows.

- `hdl_source`: HDL source codes written in Verilog
- `scripts`: Ruby scripts to collect and evaluate generated random numbers
- `reference`: sample files for scripts

The author synthesized the HDL sources by Xilinx Vivado 2019.1 and 2019.2.
The target board is Digilent <a href="https://reference.digilentinc.com/reference/programmable-logic/arty/start">Arty</a> (<a href="https://reference.digilentinc.com/reference/programmable-logic/arty-a7/start">Arty A7-35</a>),
which includes an Artix-7 XC7A35T FPGA.

The author ran the Ruby scripts by <a href="https://rubyinstaller.org/">Ruby 2.6.5-1-x64 with MSYS2 (RubyInstaller)</a>
on Windows 10. One of the scripts (serial_read.rb) requires the <a href="https://rubygems.org/gems/serialport/versions/1.3.1">SerialPort gem</a>.
It might not work correctly on some machines. In this case, try an
alternative script written in Python.

-----------------------------------------------------------------------

hdl_source directory
--------------------
The `hdl_source` directory contains the HDL source codes of the TRNG
(and a constraint file).
Their hierarchical relation is as follows.

- *top.v* (tero_top)
  - *rng.v* (tero_rng): a TERO-based TRNG (TERO and its controller)
    - *tero.v* (tero_loop): TERO w/o configuration functionality
    - *c_tero.v* (c_tero_loop): Configurable TERO (FPL 2019)
    - *tc_tero.v* (tc_tero_loop): TC-TERO (Proposed)
  - *seripara.v* (seripara): Serial-Parallel conversion circuit
  - *uart.v* (uartsender): UART data sender
    - *fifo.v* (fifo)
- *arty.xdc*: Constraint file for Arty (Arty A7-35)

To synthesize the circuit, make a Vivado project targeting Arty,
add *.v as design sources, add arty.xdc as a constraint,
and follow an ordinary logic synthesis flow.

Since the baud rate of the UART sender is set to 3,000,000 bps,
the baud rate of a terminal emulator (such as Tera Term) must be
configured as well.
If no buttons on the board are pressed, you will see a series of
hexadecimal numbers.

After confirming that the circuit looks working well, collection
of data and evaluation will be conducted by various scripts.
Please refer to the "Usage of the board" and "How to evaluate TRNGs"
sections.

scripts directory
-----------------
The `scripts` directory is a collection of Ruby scripts for
evaluation of TRNGs.

### serial_read.rb
It reads a fixed amount of data from a serial port and save them to a file.
- Argument 1: Name of output file
- Argument 2: the number of bytes to be read

> ruby serial_read.rb out.dat 100000000

-> read 1 MB of data from a serial port and write them to out.dat

Before using this script, the PORT constant must be modified according to
the environment. The constant will be COM?? in Windows and /dev/ttyS?? in
Unix-like OS (?? is the port number).

The required amount of data varies with the mode of the circuit and the
test to be conducted.
Approximately 2 MB of data are required to conduct the test procedure B
of AIS-31. Set it to 16777216 or 1048576 if the circuit runs on the
parameter searching mode of 20 bits or 16 bits, respectively.

### hex_param_dist.rb
It extracts parameters that (probably) give counter values with similar
average and standard deviation to the specified values.

- Argument 1: A data file collected with the parameter searching mode
- Argument 2: Target average value
- Argument 3: Target standard deviation value

See the "How to evaluate TRNGs" section for details.

### 8b_graph.rb
It graphically displays the distribution of the number of times the bytes
0x00 - 0xff appear in a file.

- Argument 1: A data file collected with the counter mode

### 8b_distribution.rb
It outputs the distribution of the number of times the bytes 0x00 - 0xff
appear in a file to a CSV file.

- Argument 1: A data file collected with the counter mode
- Argument 2: An output CSV file

> ruby 8b_distribution.rb out.dat out.csv

### ais_test.rb
It examines a data file as a random bit sequence with statistical tests
defined in AIS-31. It finally outputs whether the data statistically
unbiased (PASS) or not (FAIL).

- Argument 1: Type of test (usually A or B)
- Argument 2: A data file collected with the TRNG mode

> ruby ais_test.rb B out.dat

reference directory
-------------------

The `reference` directory contains a (part of) sample data file
collected with the parameter searching mode.

-----------------------------------------------------------------------

Usage of the board
------------------

The circuit uses push buttons (BTN), toggle switches (SW), LEDs, and serial
communication (USB-UART) of the Arty board in the following ways.

- Push buttons: reset and mode selection
  - BTN0: reset button
  - BTN1, BTN2: mode selection button
- Toggle switches: used for parameter set up
- LEDs: current parameter indicator
  - Red LEDs: indicate specific four bits of current parameter
  - Green LEDs: indicate which part of parameter is displayed by red LEDs
    - no LEDs are lit: 19-16th bits
    - LD3 is lit: 15-12th bits
    - LD2 is lit: 11-8th bits
    - LD1 is lit: 7-4th bits
    - LD0 is lit: 3-0th bits
- Serial communication: sending data to PC (3,000,000 bps)

The mode is determined when the reset is negated (BTN0 is released),
according to the buttons BTN1 and BTN2.
The value '1' and '0' stands for pressed and released, respectively.

### BTN1 = 0, BTN2 = 0: Parameter Searching Mode (20 bits)

In this mode, 4096 counter values are generated for each of 2<sup>20</sup>
parameters of TC-TERO.
Assume the values C<sub>0</sub>, C<sub>1</sub>, ..., and C<sub>4095</sub>.
The circuit outputs Σ<sub>i=0</sub><sup>4095</sup>C<sub>i</sub> and
Σ<sub>i=0</sub><sup>4095</sup>C<sub>i</sub><sup>2</sup>.
It also outputs whether the counter is saturated at 0xff.

The output for each parameter is formatted as 16-digit hexadecimal number.

- 63rd bit (MSB): 1 if (and only if) 0xff exists in C<sub>i</sub>
- 62-32nd bits: sum of C<sub>i</sub>
- 31st-0th bits: square sum of C<sub>i</sub>

The script hex_param_dist.rb calculates the average and standard deviation
from this data. Since the required number of counter values is 2<sup>32</sup>
in total, this mode takes 30-60 minutes.

### BTN1 = 0, BTN2 = 1: Parameter Searching Mode (16 bits)

The same procedure as above for each of 2<sup>16</sup> parameters.
This mode is used to evaluate the Configurable TERO.

### BTN1 = 1, BTN2 = 0: Counter Mode

In this mode, the circuit continuously outputs counter values using a
fixed parameter.

Four bits of parameter is set up by toggle switches at once, in order
from MSBs to LSBs. When BTN1 is pressed, the current part of parameter
is determined.
After all of the 20 bits of parameter is determined, the circuit starts
to output counter values.

### BTN1 = 1, BTN2 = 1: TRNG Mode

In this mode, the circuit continuously outputs the LSB of counter values
using a fixed parameter. If a proper parameter is used, the output will
be a random bit sequence.

-----------------------------------------------------------------------

How to evaluate TRNG
--------------------

Since a proper parameter varies with device and location, the parameter
searching mode is used at first.

1. Program the circuit to the FPGA.
2. Keep pressing the reset button (BTN0).
3. Launch command prompt, move to the `scripts` directory, and enter the following command.
>     ruby serial_read.rb count.dat 16777216

4. Release the reset button (BTN0).

This mode takes 30-60 minutes to complete.
The output is saved to count.dat in the `scripts` directory.

5. Then, to search for a proper parameter, enter the following command.

>     ruby hex_param_dist.rb count.dat 112 7

This gives candidates of parameters, where the average and standard
deviation of the counter values were similar to 112 and 7, respectively.

For reference, when this scripts applies to X4Y16.dat in the `reference`
directory, the following output is obtained.

>     $ ruby hex_param_dist.rb ../reference/X4Y16.dat 112 7
>     ## ID =      19 (00013), avg = 124.16, std =   6.51
>     ## ID =      31 (0001f), avg = 114.72, std =   6.27
>     ## ID =      97 (00061), avg = 114.66, std =   6.18
>     ## ID =     297 (00129), avg = 112.38, std =   5.58
>     ## ID =     413 (0019d), avg = 111.92, std =   5.80
>     ## ID =     817 (00331), avg = 112.45, std =   6.26
>     ## ID =    4512 (011a0), avg = 111.92, std =   6.67
>     ## ID =   33004 (080ec), avg = 111.85, std =   6.94

Write down the hexadecimal value of the lastly displayed ID (parameter).
The counter mode (or TRNG mode) is used with that parameter.

6. Press the reset button (BTN0) and mode selection button (BTN1).
7. Release BTN0 while pressing BTN1 and then release BTN1.
   Only LD4 will be lit.
8. Enter the following command (modify the file name and length if needed).

>     ruby serial_read.rb data.bin 1000000

9. Set the toggle switches according to the most significant 4 bits of
   parameter.
   In the above example (0x<b>0</b>80ec), turn off all of the switches (0x0).
10. Press BTN1. The green LED will be turned off and the determined
    (part of) parameter will be shown by the red LEDs.
11. Set up the rest of parameter in a similar way. In the above example...
    - Turn on SW3 (0x8) and press BTN1.
    - Turn off SW3 (0x0) and press BTN1.
    - Turn on SW3, SW2, and SW1 (0xe) and press BTN1.
    - Turn off SW1 (0xc) and press BTN1.
12. The circuit will start to operate.
    When the specified number of bytes are received, the script launched
    in the step 8 will be ended.
13. Analyze the obtained data using scripts.
    For example, to see the distribution of the counter values, enter the
    following command. You will see a mountain-shaped distribution.

>     ruby 8b_graph.rb data.bi

-----------------------------------------------------------------------

Copyright
---------

All of the files in the `hdl_source` and `scripts` directories are
developed by <a href="https://aitech.ac.jp/~dslab/nf/index.en.html">Naoki FUJIEDA</a>.
They are licensed under the New BSD license.
See the COPYING file for more information.

Copyright (C) 2019-2020 Naoki FUJIEDA. All rights reserved.
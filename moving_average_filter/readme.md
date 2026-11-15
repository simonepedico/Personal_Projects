# Moving Average Filter

**A modular VHDL implementation of a moving-average filter**

Authors: Davide Piatti, Simone Pedico.

[Full report](Moving_average_filter.pdf) · [Design sources](vhdl/design/) · [Testbenches](vhdl/tb/)

## Overview

This project implements a digital moving-average filter using a delayed sample stream and a running sum.

For a window containing N samples, the intended computation is:

```text
s[n] = s[n-1] + x[n] - x[n-N]
y[n] = s[n] / N
```

The architecture combines a FIFO, arithmetic logic, an accumulator and a division stage. The window length is expressed as a power of two, allowing division through bit selection.

## Project contents

| Path | Purpose |
| --- | --- |
| `Moving_average_filter.pdf` | Project report. |
| `vhdl/design/` | Filter implementation and supporting components. |
| `vhdl/tb/` | Component testbenches and file-based simulation utilities. |

## Architecture

| Source | Role |
| --- | --- |
| `filter_ma.vhd` | Top-level filter and component interconnections. |
| `fifo.vhd` | Delayed sample stream. |
| `multiadder.vhd` | Arithmetic update for the running sum. |
| `accumulator.vhd` | Registered accumulation stage. |
| `divide_by.vhd` | Division stage implemented through bit selection. |
| `COUNTER.vhd` | Additional counter source. |

The top-level filter instantiates the FIFO, multiadder, accumulator and divider.

### Interface and parameters

| Name | Description |
| --- | --- |
| `Nbf` | Input sample width. |
| `log2NFIFOf` | Base-2 logarithm of the intended filter window length. |
| `clk` | Clock input. |
| `rst` | Reset input. |
| `en` | Enable input. |
| `datain` | Signed input of width `Nbf`. |
| `dataout` | Signed output of width `Nbf + log2NFIFOf`. |

The supplied `tb_filter_ma` uses `Nbf = 7`, `log2NFIFOf = 7` and 2,560 input samples. These settings correspond to a nominal 128-sample window and a 14-bit output bus.

## Running a simulation

1. Create a project in a VHDL simulator.
2. Add the files in `vhdl/design/` as design sources.
3. Add the files in `vhdl/tb/` as simulation sources.
4. Select `tb_filter_ma` as the simulation top level.
5. Provide `mysignal.txt` in the simulator's working directory.
6. Run the simulation and inspect the waveforms and generated output file.

The input file is not included in the repository. The filter testbench reads 2,560 lines, each containing a 7-bit binary sample interpreted as a signed value.

The testbench writes 14-bit binary output samples to:

```text
output_results_mdm_TEST.txt
```

Its clock period is 20 ns. Reset is asserted and enable is deasserted during the first 100 ns.

## Simulation notes

- Input reading starts at time zero, before reset is released. Account for this timing when aligning input and output samples.
- The clock process continues indefinitely. Use an explicit simulation stop time.
- The sources use IEEE logic, numeric and text-I/O packages; configure the simulator accordingly.
- The repository includes source files rather than a complete simulator project or an automated build script.

### Signed arithmetic

Although the interfaces use signed types, `divide_by.vhd` fills the upper output bits with zeros after selecting the shifted bits. This differs from a sign-extending arithmetic right shift for negative values.

Check this behavior before interpreting the implementation as a general signed moving-average filter. The report and waveform inspection should be used alongside the source code when validating arithmetic and latency.

## References

- [Project report](Moving_average_filter.pdf)
- [Top-level filter](vhdl/design/filter_ma.vhd)
- [Filter testbench](vhdl/tb/tb_filter_ma.vhd)

# Unpacker

Software unpacker for preliminary ETROC data format. The software requires the use of the PyCall Julia library.

``` shell
import Pkg; Pkg.add("PyCall"); Pkg.add("Crayons"); Pkg.add("Plots"); Pkg.add("YAML")`
```


This package can create random hit data for the ETROC emulator data format specified [here](https://gitlab.cern.ch/cms-etl-electronics/etroc-emulator/-/blob/master/ETROC%20emulator%20version%201/ETROC_Emulator_20210825.pdf),
and can subsequently unpack it to reconstruct hits on the 16x16 sensor.

An example hex dump of ETROC data from the emulator v1 is [here](https://gitlab.cern.ch/cms-etl-electronics/module_test_sw/-/blob/master/output/dump.txt).

![](docs/etroc_dataformat.png)

## Examples

A simple unpacker of ETROC emulator data can be run with
```
julia read_dump.jl
```

The output shows the overall event count and a hit map of the first event.
It should look something like this:
```
Number of Events: 143
Number of filler words: 0
Hit matrix of event 1 after hex dump:
Map of hits:
X  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  X  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
O  O  O  O  O  O  O  O  O  O  O  O  O  O  O  O
```
`read_dump.jl` will also make heatmaps of the Time Over Threshold (TOT) for each pixel in a single event, like so:
![](docs/TOT.png)
It will also plot a heatmap of hits in each pixel for the entire hex dump:
![](docs/hit_heatmap.png)


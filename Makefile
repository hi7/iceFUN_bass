# Project setup
PROJ      = bass
DEVICE    = 8k

# Files
FILES = bass.v

.PHONY: bass clean burn

bass:
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -json $(PROJ).json" $(FILES)
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack $(PROJ).asc $(PROJ).bin

burn:
	iceFUNprog $(PROJ).bin

clean:
	rm *.asc *.bin *blif

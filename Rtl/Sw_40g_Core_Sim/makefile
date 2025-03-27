# /*////////////////////////////////////////////////////////////////////////////////////////////// 
# +--+--+---+-+---+----+
# |  |  |   | /   |    |
# |  |--|   --    |    |
# |  |  |   | \   ---- |
# |--+--+---+-+--------+
# Module Name:makefile
# Provider:HuKaiLong
# Creat Time:2025-02-07 22:20:19
# Target Platform:
# Function Description: 
# //////////////////////////////////////////////////////////////////////////////////////////////*/
# Initialize the variable
TOP_LEVEL_NAME ?= RapidIO_Ctrl_Top_Tb

# Directories
LOG_FILE = test.log

# Libraries
SECUREIP_LIB     = /opt/questaVivado_Lib/secureip
UNISIM_LIB       = /opt/questaVivado_Lib/unisim
UNIMACRO_LIB     = /opt/questaVivado_Lib/unimacro
UNIFAST_LIB      = /opt/questaVivado_Lib/unifast
UNIMACRO_VER_LIB = /opt/questaVivado_Lib/unimacro_ver
UNIFAST_VER_LIB  = /opt/questaVivado_Lib/unifast_ver
UNISIMS_VER_LIB  = /opt/questaVivado_Lib/unisims_ver
SIMPRIMS_VER_LIB = /opt/questaVivado_Lib/simprims_ver
XPM_LIB          = /opt/questaVivado_Lib/xpm
XILINX_VIP_LIB   = /opt/questaVivado_Lib/xilinx_vip

# Default target
all: compile elaborate run

# Compile the design files in correct order
compile:
	@echo "[exec] compile"
	vlib work
	vmap work
	vlog  -work  work  -incr -O0  "./../*.v"
	vlog  -incr  -O0   -sv        "./../*.sv"
	vlog  -work  work  -incr -O0  "./testbentch/*.v"
	vlog  -incr  -O0   -sv        "./testbentch/*.sv"

# Elaborate the top level design with novopt option
elaborate:
	@echo "[exec] elaborate"
	vmap work work
	vsim -c -voptargs=+acc -t ps -l $(LOG_FILE) -L work -L $(SECUREIP_LIB) -L $(UNIMACRO_LIB) -L $(UNIFAST_LIB) -L $(UNIMACRO_VER_LIB) -L $(UNIFAST_VER_LIB) -L $(UNISIMS_VER_LIB) -L $(UNISIM_LIB) -L $(SIMPRIMS_VER_LIB) -L $(XPM_LIB) -L $(XILINX_VIP_LIB) work.$(TOP_LEVEL_NAME) work.glbl 

# Run the simulation
run:
	@echo "[exec] run"
	vsim -c -do "run -all; quit" -l $(LOG_FILE) -wlf waveform.wlf

# Rerun the simulation
rerun: compile
	@echo "[exec] rerun"
	make elaborate
	make run

# Print out user command line aliases
help:
	@echo "List Of Command Line Aliases"
	@echo
	@echo "make compile              -- Compile the design files in correct order"
	@echo
	@echo "make elaborate            -- Elaborate the top level design"
	@echo
	@echo "make run                  -- Run the simulation"
	@echo
	@echo "make rerun                -- Rerun the simulation"
	@echo
	@echo "TOP_LEVEL_NAME            -- Top level module name."
	@echo
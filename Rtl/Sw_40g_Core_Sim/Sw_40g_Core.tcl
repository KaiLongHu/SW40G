#---------------------------------------------
#Auto-generated simulation script

#---------------------------------------------
# Initialize the variable

if ![info exists TOP_LEVEL_NAME] {
 set TOP_LEVEL_NAME "Sw_40g_Core_Tb"
}

#----------------------------------------------
# Compile the design files in correct order
alias com {
echo "\[exec\] com"

vlib work
vmap work

vlog  -work  work  -incr -O0  "./../*.v"
vlog  -incr  -O0   -sv        "./../*.sv"
vlog  -incr  -O0   -sv        "./../axis/*.sv"
vlog  -incr  -O0   -sv        "./../axis/sync/*.sv"
# 
vlog  -work  work  -incr -O0  "./testbentch/*.v"
vlog  -incr  -O0   -sv        "./testbentch/*.sv"

}

# --------------------------------------------------
# Elaborate the top level design with novopt option
alias lbd {
echo "\[exec\] lbd"
set secureip               "/opt/questaVivado_Lib/secureip"
set unisim                 "/opt/questaVivado_Lib/unisim"
set unimacro               "/opt/questaVivado_Lib/unimacro"
set unifast                "/opt/questaVivado_Lib/unifast"
set unimacro_ver           "/opt/questaVivado_Lib/unimacro_ver"
set unifast_ver            "/opt/questaVivado_Lib/unifast_ver"
set unisims_ver            "/opt/questaVivado_Lib/unisims_ver"
set simprims_ver           "/opt/questaVivado_Lib/simprims_ver"
set xpm                    "/opt/questaVivado_Lib/xpm"
set xilinx_vip             "/opt/questaVivado_Lib/xilinx_vip"

vmap work work
# vsim  -t ps -l test.log   -L work -L $secureip -L $unimacro -L $unifast -L $unimacro_ver -L $unifast_ver -L $unisims_ver -L $unisim -L $simprims_ver -L $xpm -L $xilinx_vip work.$TOP_LEVEL_NAME work.glbl
vsim  -voptargs=+acc -t ps -l test.log   -L work -L $secureip -L $unimacro -L $unifast -L $unimacro_ver -L $unifast_ver -L $unisims_ver -L $unisim -L $simprims_ver -L $xpm -L $xilinx_vip work.$TOP_LEVEL_NAME work.glbl
}




alias re {
echo "\[exec\] re"
com
restart
run -all
echo "Rerun Simulation"
}


# ----------------------------------------
#Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "lbd                           -- elaborate the top level design"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
}
h

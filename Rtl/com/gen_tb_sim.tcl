#!/usr/bin/env tcl
######################################################################
#
#  Generate TB simulate  environment for HDL File
#
#
#  Author: liyuan
#
#
#
########################################################################
########################################################################

# You must set these vars

#global set

#Define simulate environment name
set env_name  "DataStatisMem"

#Define complie tool
#altera or xilinx 
set com_tool  "altera"

# verilog vhdl mix
set com_language "verilog"

#Define Modelsim Path

set modelsim_path "C:/modeltech64_10.0b/win64/"

#Define ALtera Quartus Eda Library Install Path

set Quartus_Lib_Path  "E:/altera/15.0/quartus/eda/sim_lib"

#Define Xilinx Vivado Eda Library Install Path
set Vivado_Lib_Path   "C:/Xilinx/Vivado/2016.3/data"

#Define DUT Top File name 
set DUT_Top "DataStatisInfoMem.v"

#########################################################################

#Define bat file
set env_name_temp1 $env_name
set sim_file_bat [append env_name_temp1 ".bat"]

#Define do file
set env_name_temp2 $env_name
set sim_file_do  [append env_name_temp2 ".do"]

#Define TCL file
set env_name_temp3 $env_name
set sim_file_tcl   [append env_name_temp3 ".tcl"]

set env_name_temp4 $env_name
set TOP_LEVEL_NAME [append env_name_temp4 "_Tb"]

set sim_tb_file  $TOP_LEVEL_NAME.sv

#Build Simulate folder

set sim_folder_name [append env_name "_sim"]


if {[file exists $sim_folder_name]} {
	puts "Simulate Folder has been exist....."
} else {
	puts "Building New Simulate folder...."
  file mkdir $sim_folder_name
}

set modelsim_path [append modelsim_path "vsim.exe"]

set testTB  "testbentch"

#Enter Simulate folder
cd ./$sim_folder_name

#########################################################################
#Create .bat file

set  file_bat_id    [open $sim_file_bat w+]
set  Path_len       [string length $modelsim_path]
puts "$Path_len"

#while {$Path_len > 0} {
#	incr Path_len -1
#	puts "$Path_len"
#	
#	set return_char [string index $modelsim_path $Path_len]
#	if {[string compare $return_char "\\"] == 0} {
#		puts "$Path_len"
#	}
#}

set temp {}

for {set i 0} {$i<$Path_len} {incr i 1} {
	set return_char [string index $modelsim_path $i]
	if {[string compare $return_char "/"] == 0} {
    set temp [concat $temp $i] 
  }
}

puts "$temp"

#incr Path_len -1
#puts "end_index = $Path_len"

set list_end [llength $temp]
incr list_end -2

puts "list_end = $list_end"
set start_ptr 0
set end_ptr   [lindex $temp $list_end]
set modelsim_install_path [string range $modelsim_path $start_ptr $end_ptr]
puts "$modelsim_install_path"

#foreach a_index $temp {
#	
#	puts "cycle $a_index"
#	
#	if {$a_index == [lindex $temp 0]} {
#		set start_ptr 0	
#		set end_ptr   [incr a_index -1]
#		set get_string [concat $get_string [string range $modelsim_path $start_ptr $end_ptr]]
#		puts "$start_ptr"
#	  puts "$end_ptr"
#	} elseif {$a_index == [lindex $temp $list_end]} {
#		set start_ptr $end_ptr 
#		set end_ptr   [incr a_index -1]
#		set get_string [concat $get_string [string range $modelsim_path $start_ptr $end_ptr]]
#    puts "$start_ptr"
#	  puts "$end_ptr"
#	  
#		set start_ptr  [incr a_index 2]
#		set end_ptr    $Path_len
#		set get_string [concat $get_string [string range $modelsim_path $start_ptr $end_ptr]]
#	  puts "$start_ptr"
#	  puts "$end_ptr"
#
#  } else {
#    set start_ptr $end_ptr 
#		set end_ptr   [incr a_index -1]
#		set get_string [concat $get_string [string range $modelsim_path $start_ptr $end_ptr]]
#		puts "$start_ptr"
#	  puts "$end_ptr"
#  }
  
	#puts "$get_string"
	
	#set end_ptr   [incr a_index  2]
#}


puts $file_bat_id ""
puts $file_bat_id "@ECHO OFF"
puts $file_bat_id ""
puts $file_bat_id "SET vsim=$modelsim_path"
puts $file_bat_id ""
puts $file_bat_id "%vsim% -do $sim_file_do"
puts $file_bat_id "@pause"

close $file_bat_id
#########################################################################
# Create compilation libraries

set path_temp1 $modelsim_install_path
set ALTERA_SIM_LIB_PATH [append path_temp1 "examples/altra_sim"]

set path_temp2 $modelsim_install_path
set XILINX_SIM_LIB_PATH [append path_temp2 "examples/vivadoLib2014"]

proc create_simLib_fold {path} {if {![file isdirectory $path]} {file mkdir $path}}
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }


if {[string compare $com_tool "altera"] == 0} {
	puts "com_tool is $com_tool ..."
  create_simLib_fold     $ALTERA_SIM_LIB_PATH
  #verilog lib
  ensure_lib             $ALTERA_SIM_LIB_PATH/220model_ver/
  vmap      220model_ver $ALTERA_SIM_LIB_PATH/220model_ver/
  ensure_lib             $ALTERA_SIM_LIB_PATH/altera_lnsim_ver/
  vmap      altera_lnsim_ver $ALTERA_SIM_LIB_PATH/altera_lnsim_ver/ 
  ensure_lib             $ALTERA_SIM_LIB_PATH/altera_mf_ver/
  vmap      altera_mf_ver $ALTERA_SIM_LIB_PATH/altera_mf_ver/  
  ensure_lib             $ALTERA_SIM_LIB_PATH/altera_primitives_ver/
  vmap      altera_primitives_ver $ALTERA_SIM_LIB_PATH/altera_primitives_ver/  
  #VHDL lib  
  ensure_lib             $ALTERA_SIM_LIB_PATH/220model/
  vmap      220model     $ALTERA_SIM_LIB_PATH/220model/
  ensure_lib             $ALTERA_SIM_LIB_PATH/altera_lnsim/
  vmap      altera_lnsim     $ALTERA_SIM_LIB_PATH/altera_lnsim/ 
  ensure_lib             $ALTERA_SIM_LIB_PATH/altera_mf/
  vmap      altera_mf     $ALTERA_SIM_LIB_PATH/altera_mf/  
  ensure_lib             $ALTERA_SIM_LIB_PATH/altera_primitives/
  vmap      altera_primitives    $ALTERA_SIM_LIB_PATH/altera_primitives/      
 } 

if {[string compare $com_tool "xilinx"] == 0} {
	puts "com_tool is $com_tool ..."
 	create_simLib_fold     $XILINX_SIM_LIB_PATH
 	ensure_lib             $XILINX_SIM_LIB_PATH/secureip/
 	vmap       secureip    $XILINX_SIM_LIB_PATH/secureip/
 	
 	ensure_lib                 $XILINX_SIM_LIB_PATH/simprims_ver/
 	vmap       simprims_ver    $XILINX_SIM_LIB_PATH/simprims_ver/
 	
 	ensure_lib                 $XILINX_SIM_LIB_PATH/unifast_ver/
 	vmap       unifast_ver     $XILINX_SIM_LIB_PATH/unifast_ver/
 	
 	ensure_lib                  $XILINX_SIM_LIB_PATH/unimacro_ver/
 	vmap       unimacro_ver     $XILINX_SIM_LIB_PATH/unimacro_ver/
 	
 	ensure_lib                  $XILINX_SIM_LIB_PATH/unisims_ver/
 	vmap       unisims_ver      $XILINX_SIM_LIB_PATH/unisims_ver/
 	
 	ensure_lib                     $XILINX_SIM_LIB_PATH/xilinxcorelib_ver/
 	vmap       xilinxcorelib_ver   $XILINX_SIM_LIB_PATH/xilinxcorelib_ver/
 	
}


alias dev_com {
	echo "\[exec\] dev_com"
	if {[string compare $com_tool "altera"] == 0} {
		echo "Compile Altera Sim Lib..."
		#verilog
		vlog      "$Quartus_Lib_Path/220model.v"               -work  220model_ver
		vlog  -sv "$Quartus_Lib_Path/altera_lnsim.sv"          -work  altera_lnsim_ver
		vlog      "$Quartus_Lib_Path/altera_mf.v"              -work  altera_mf_ver
		vlog      "$Quartus_Lib_Path/altera_primitives.v"      -work  altera_primitives_ver
		
		#vhdl
		vcom      "$Quartus_Lib_Path/220pack.vhd"              -work  220model
		vcom      "$Quartus_Lib_Path/220model.vhd"             -work  220model 
		
		vcom      "$Quartus_Lib_Path/altera_lnsim_components.vhd" -work  altera_lnsim
		
		vcom      "$Quartus_Lib_Path/altera_mf_components.vhd"    -work  altera_mf
		vcom      "$Quartus_Lib_Path/altera_mf.vhd"               -work  altera_mf
		
		vcom      "$Quartus_Lib_Path/altera_primitives_components.vhd"    -work  altera_primitives
		vcom      "$Quartus_Lib_Path/altera_primitives.vhd"               -work  altera_primitives          
	} elseif {[string compare $com_tool "xilinx"] == 0} {
		echo "Please Compile Xilinx Sim Lib in Vivado..."
	}
}

#########################################################################
#Create .do file
set file_do_id    [open $sim_file_do w+]

puts $file_do_id "#---------------------------------------------"
puts $file_do_id "#Auto-generated simulation script"
puts $file_do_id ""
puts $file_do_id "#---------------------------------------------"
puts $file_do_id ""
puts $file_do_id "vlib work"
puts $file_do_id "vmap work work"
puts $file_do_id ""
puts $file_do_id ""
puts $file_do_id "if \{\[file exists $sim_file_tcl\]\} \{"
puts $file_do_id "source  $sim_file_tcl"
puts $file_do_id ""
puts $file_do_id "\} else \{"
puts $file_do_id "error \"The $sim_file_tcl script does not exist. Please generate the example design RTL and simulation scripts. See ../../README.txt for help.\""
puts $file_do_id "\}"


close $file_do_id

#########################################################################
#Create .tcl file
set file_tcl_id [open $sim_file_tcl w+]

puts $file_tcl_id "#---------------------------------------------"
puts $file_tcl_id "#Auto-generated simulation script"
puts $file_tcl_id ""
puts $file_tcl_id "#---------------------------------------------"
puts $file_tcl_id "# Initialize the variable"
puts $file_tcl_id ""
puts $file_tcl_id "if !\[info exists TOP_LEVEL_NAME\] \{"
puts $file_tcl_id " set TOP_LEVEL_NAME \"$TOP_LEVEL_NAME\""
puts $file_tcl_id "}"
puts $file_tcl_id ""
puts $file_tcl_id "#----------------------------------------------"
puts $file_tcl_id "# Compile the design files in correct order"
puts $file_tcl_id "alias com \{"
puts $file_tcl_id "echo \"\\\[exec\\\] com\""
puts $file_tcl_id ""
puts $file_tcl_id "vlib work"
puts $file_tcl_id "vmap work"
puts $file_tcl_id ""
puts $file_tcl_id "vlog  -work  work  -incr -O0  \"./../\*.v\""
puts $file_tcl_id "vcom                          \"./../\*.vhd\""
puts $file_tcl_id ""
puts $file_tcl_id "vlog  -work  work  -incr -O0  \"./testbentch/sys_reset_gen.v\""
puts $file_tcl_id "vlog  -work  work  -incr -O0  \"./testbentch/sys_clk_gen.v\""
puts $file_tcl_id "vlog  -incr  -O0   -sv        \"./testbentch/$TOP_LEVEL_NAME.sv\""
puts $file_tcl_id ""
puts $file_tcl_id "\}"
puts $file_tcl_id ""
puts $file_tcl_id "# --------------------------------------------------"
puts $file_tcl_id "# Elaborate the top level design with novopt option"
puts $file_tcl_id "alias lbd \{"
puts $file_tcl_id "echo \"\\\[exec\\\] lbd\""

if {[string compare $com_tool "altera"] == 0} {
	puts $file_tcl_id "set 220model_ver              \"$ALTERA_SIM_LIB_PATH/220model_ver\""
	puts $file_tcl_id "set altera_lnsim_ver          \"$ALTERA_SIM_LIB_PATH/altera_lnsim_ver\""
  puts $file_tcl_id "set altera_mf_ver             \"$ALTERA_SIM_LIB_PATH/altera_mf_ver\""
  puts $file_tcl_id "set altera_primitives_ver     \"$ALTERA_SIM_LIB_PATH/altera_primitives_ver\""
  puts $file_tcl_id "set 220model                  \"$ALTERA_SIM_LIB_PATH/220model\""
  puts $file_tcl_id "set altera_lnsim              \"$ALTERA_SIM_LIB_PATH/altera_lnsim\""
  puts $file_tcl_id "set altera_mf                 \"$ALTERA_SIM_LIB_PATH/altera_mf\""
  puts $file_tcl_id "set altera_primitives         \"$ALTERA_SIM_LIB_PATH/altera_primitives\"" 
  
  if {[string compare $com_language "verilog"] == 0} {
  	puts $file_tcl_id ""
  	puts $file_tcl_id "vmap work work"
  	puts $file_tcl_id "vsim -novopt -t ps -l test.log -L work -L \$220model_ver -L \$altera_lnsim_ver -L \$altera_mf_ver -L \$altera_primitives_ver  \$TOP_LEVEL_NAME"
  } elseif {[string compare $com_language "mix"] == 0} {
  	puts $file_tcl_id ""
  	puts $file_tcl_id "vmap work work"
  	puts $file_tcl_id "vsim -novopt -t ps -l test.log -L work -L \$220model_ver -L \$altera_lnsim_ver -L \$altera_mf_ver -L \$altera_primitives_ver  -L \$220model -L \$altera_lnsim -L \$altera_mf -L \$altera_primitives \$TOP_LEVEL_NAME"
  }
  
} elseif {[string compare $com_tool "xilinx"] == 0} {
	  puts $file_tcl_id "set secureip      \"$XILINX_SIM_LIB_PATH/secureip\""
    puts $file_tcl_id "set simprims_ver  \"$XILINX_SIM_LIB_PATH/simprims_ver\""
	  puts $file_tcl_id "set unifast_ver   \"$XILINX_SIM_LIB_PATH/unifast_ver\""
	  puts $file_tcl_id "set unimacro_ver  \"$XILINX_SIM_LIB_PATH/unimacro_ver\""
	  puts $file_tcl_id "set unisims_ver   \"$XILINX_SIM_LIB_PATH/unisims_ver\""
	  puts $file_tcl_id "vmap work work"
	  puts $file_tcl_id "vsim notimingchecks -novopt -L work  -L \$secureip   -L \$simprims_ver   -L \$unifast_ver   -L \$unimacro_ver   -L \$unisims_ver -L \$xilinxcorelib_ver work.$TOP_LEVEL_NAME"
	  }


puts $file_tcl_id "}"
puts $file_tcl_id ""
puts $file_tcl_id "# ----------------------------------------"
puts $file_tcl_id "#Print out user commmand line aliases"
puts $file_tcl_id "alias h \{"
puts $file_tcl_id "  echo \"List Of Command Line Aliases\""
puts $file_tcl_id "  echo"
puts $file_tcl_id "  echo \"com                           -- Compile the design files in correct order\""
puts $file_tcl_id "  echo"
puts $file_tcl_id "  echo \"lbd                           -- elaborate the top level design\""
puts $file_tcl_id "  echo"
puts $file_tcl_id "  echo \"TOP_LEVEL_NAME                -- Top level module name.\""
puts $file_tcl_id "  echo"
puts $file_tcl_id "\}"
puts $file_tcl_id "h"

close $file_tcl_id
#########################################################################
#Now create  testbetch foider
create_simLib_fold $testTB


cd $testTB

proc my_ver_head { file_id file_name dev_name def_tool} {
   puts $file_id  "/****************************************************************"
   puts $file_id  "*Company:  CETC54"
   puts $file_id  "*Engineer: liyuan"
   puts $file_id  ""
   
   set systemTime [clock seconds]
   puts $file_id  [clock format $systemTime -format {*Create Date   : %A, the %d of %B, %Y  %H:%M:%S}]
   puts $file_id  "*Design Name   :"
   puts $file_id  "*Module Name   : $file_name"
   puts $file_id  "*Project Name  :"
   puts $file_id  "*Target Devices: $dev_name"
   puts $file_id  "*Tool versions : $def_tool"
   puts $file_id  "*Description   :  "
   puts $file_id  "*Revision:     : 1.0.0"
   puts $file_id  "*Revision 0.01 - File Created"
   puts $file_id  "*Additional Comments: "
   puts $file_id  "*Modification Record :"
   puts $file_id  "****************************************************************/"
}

#-----------------------------------------------------------------------------------
proc read_dut_file { file_r_id file_name file_w_id} {
	
	if {[string match "*.sv" $file_name]} {
	set temp_name [string trimright $file_name "v"]
  set temp_name [string trimright $temp_name "s"]
  set temp_name [string trimright $temp_name "."]	
  } else {
	set temp_name [string trimright $file_name "v"]
  set temp_name [string trimright $temp_name "."]
  }
  
  puts "temp_name = $temp_name"
  
  set temp_list {}
  set temp {}
  
  while {[gets $file_r_id line] != -1} {
   if {[regexp {inout|input|output} $line match]} {
     
     puts "$line"
     
     if {[string compare [lindex $line 0] $match] == 0} {
      if {[lsearch $line  *\]] == -1} {
       puts "match = $match" 
       set list_len [llength $line]
       incr list_len -1
       puts "list_len = $list_len"
       set temp  [list $match 0 [string trimright [lindex $line $list_len] ","]] 
       set temp_list [concat "$temp_list" "{$temp}"]
       puts "$temp_list"
      } else {
       puts "match = $match"
       set list_len [llength $line]
       incr list_len -1
       puts "list_len = $list_len"
       set temp [list $match [lindex $line [lsearch $line  *\]]] [string trimright [lindex $line $list_len] ","]]
       set temp_list [concat "$temp_list" "{$temp}"]
       puts "temp= [lindex $temp 1]"
      }
     } 
   }
  }
  
  puts  $file_w_id "//DUT Inst signal Define"
  puts  $file_w_id ""
  foreach var_list $temp_list {
   #puts "var_list = $var_list"
   if {[lindex $var_list 1] == 0} {
    puts  $file_w_id "bit [lindex $var_list 2]\;"
   } else {
    puts  $file_w_id "bit [lindex $var_list 1] [lindex $var_list 2]\;"
   }
  } 
  puts  $file_w_id "//--------------------------------------------"
  puts  $file_w_id "//DUT INST Define"
  puts  $file_w_id ""
  puts  $file_w_id "$temp_name  $temp_name\_inst\("
  set   len  [llength $temp_list]
  set   end  [llength $temp_list]
  incr  end  -1
  
  for {set x 0} {$x<$len} {incr x} {
    #puts "x = $x"
    if {$x == $end} {
      puts  $file_w_id "  \.[lindex [lindex $temp_list $x] 2]\([lindex [lindex $temp_list $x] 2]\)"
    } else {
      puts  $file_w_id "  \.[lindex [lindex $temp_list $x] 2]\([lindex [lindex $temp_list $x] 2]\),"
    }
  } 

  
  puts  $file_w_id "\)\;"
  puts  $file_w_id "//--------------------------------------------"
}
#--------------------------------------------------------------------------------
#Create Gen clk file 

set gen_clk_file "sys_clk_gen.v"
set file_gen_clk_id [open $gen_clk_file w+]

my_ver_head $file_gen_clk_id $gen_clk_file $com_tool $com_tool

puts $file_gen_clk_id "\`timescale 1ns/1ns"
puts $file_gen_clk_id "module sys_clk_gen #\("
puts $file_gen_clk_id " parameter"
puts $file_gen_clk_id " CLK_FREQUENCE = ,  //Mhz"
puts $file_gen_clk_id " CLK_PHASE     =    //ns"
puts $file_gen_clk_id "\)\("
puts $file_gen_clk_id " output wire clk"
puts $file_gen_clk_id "\);"
puts $file_gen_clk_id "/******************************************/"
puts $file_gen_clk_id "localparam TIME_UNIT = 1000.000;"
puts $file_gen_clk_id "localparam CLK_CYCLE = TIME_UNIT/CLK_FREQUENCE;"
puts $file_gen_clk_id "/******************************************/"
puts $file_gen_clk_id "reg clk_reg;"
puts $file_gen_clk_id ""
puts $file_gen_clk_id "/******************************************/"
puts $file_gen_clk_id "initial begin"
puts $file_gen_clk_id " clk_reg = 1'b0;"
puts $file_gen_clk_id " #(CLK_PHASE);"
puts $file_gen_clk_id " forever begin"
puts $file_gen_clk_id "  #(CLK_CYCLE/2) clk_reg = ~clk_reg;"
puts $file_gen_clk_id " end"
puts $file_gen_clk_id "end"
puts $file_gen_clk_id "/******************************************/"
puts $file_gen_clk_id "assign clk = clk_reg;"
puts $file_gen_clk_id "/******************************************/"
puts $file_gen_clk_id "endmodule"
close $file_gen_clk_id
#--------------------------------------------------------------------------------
#Create Gen reset file 
set gen_rst_file "sys_reset_gen.v"
set file_gen_rst_id [open $gen_rst_file w+]

my_ver_head $file_gen_rst_id $gen_rst_file $com_tool $com_tool

puts $file_gen_rst_id "\`timescale 1ns/1ns"
puts $file_gen_rst_id "module sys_reset_gen #\("
puts $file_gen_rst_id " parameter"
puts $file_gen_rst_id " RST_TIME  = ,//ns"
puts $file_gen_rst_id " RST_LEVEL = //0 or 1"
puts $file_gen_rst_id "\)\("
puts $file_gen_rst_id " output reg reset"
puts $file_gen_rst_id "\);"
puts $file_gen_rst_id "/******************************************/"
puts $file_gen_rst_id "initial begin"
puts $file_gen_rst_id " reset = RST_LEVEL;"
puts $file_gen_rst_id " #(RST_TIME) reset = (!RST_LEVEL);"
puts $file_gen_rst_id "end"
puts $file_gen_rst_id "/******************************************/"
puts $file_gen_rst_id "endmodule"
close $file_gen_rst_id
#--------------------------------------------------------------------------------
#Create testbentch top file
set file_tb_id [open $sim_tb_file w+]

my_ver_head $file_tb_id $sim_tb_file $com_tool $com_tool

puts $file_tb_id "\`timescale 1ns/1ns"
puts $file_tb_id "module $TOP_LEVEL_NAME\(\);"
puts $file_tb_id ""
puts $file_tb_id "//--------------------------------------------"
puts $file_tb_id "//Frequence Define"
puts $file_tb_id "localparam  CLK_FREQUENCE =  ;//MHz"
puts $file_tb_id "localparam  CLK_PHASE      =  ; //ns"
puts $file_tb_id "localparam  RST_TIME = ; //ns"
puts $file_tb_id "//-------------------------------------------"





if {[file exist "./../../$DUT_Top"]} {
	set file_read_id  [open  "./../../$DUT_Top" r]
  read_dut_file $file_read_id $DUT_Top $file_tb_id
  puts  $file_tb_id "//Clk signal Define"
  puts  $file_tb_id ""
  puts  $file_tb_id " sys_clk_gen #("
  puts  $file_tb_id "  .CLK_FREQUENCE(CLK_FREQUENCE),"
  puts  $file_tb_id "  .CLK_PHASE(CLK_PHASE)"
  puts  $file_tb_id " )sys_clk_gen_inst("
  puts  $file_tb_id "  .clk()"
  puts  $file_tb_id " );"
  puts  $file_tb_id ""
  puts  $file_tb_id "//------------------------------------------"
  puts  $file_tb_id "//rst signal Define"
  puts  $file_tb_id ""
  puts  $file_tb_id " sys_reset_gen #("
  puts  $file_tb_id "  .RST_TIME(RST_TIME),"
  puts  $file_tb_id "  .RST_LEVEL(0)"
  puts  $file_tb_id " )sys_reset_gen_inst("
  puts  $file_tb_id "  .reset()"
  puts  $file_tb_id " );"
  puts  $file_tb_id ""
  puts  $file_tb_id "//-------------------------------------------"
  puts  $file_tb_id "//task define"
  puts  $file_tb_id ""
  puts  $file_tb_id ""
  puts  $file_tb_id "//-------------------------------------------"
  puts  $file_tb_id "//Main Program"
  puts  $file_tb_id "initial begin"
  puts  $file_tb_id ""
  puts  $file_tb_id "end"
  puts  $file_tb_id "//--------------------------------------------"
  puts  $file_tb_id ""
  puts  $file_tb_id "endmodule"
}


close $file_tb_id

#-----------------------------------------------------------------------
#Print out user commmand line aliases
#
alias h {
	echo "List Of Command Line Aliases and Var"
	echo 
	echo "dev_com    --  Compile Simulate Library"
	echo 
	echo "env_name   --  environment name (You must define)"
	echo 
	echo "com_tool   --  Device name"
	echo
	echo "com_language -- Verilog or VHDL or Mix"
	echo
}
h
#-----------------------------------------------------------------------
if {![file exist "./../../$DUT_Top"]} {
	echo "The DUT file doesn't exist, please check the correct Path..."
}
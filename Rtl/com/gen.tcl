 #!/usr/bin/env tcl
######################################################################
#
#  Generate verilog file for HDL edit
#
#
#  Author: liyuan
#
#
#
########################################################################
########################################################################
#global set 

#Define Author
set def_author "liyuan"

#Define Tool versions
set def_tool "Quartus II 15.0" 


# Define Device Family here
set dev_name "C5"

#Define Verilog File name here
set file_name  "Glb_Rst_Gen.v"





###################################################################
#Read DUT file and Generate TestBentch File
###################################################################

#verilog File Head Temple
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
   puts $file_id  "*****************************************************************/"
}


######################################################################################
#Gnerate Verilog HDL Model File


set temp_name $file_name

if {[string match "*.sv" $file_name]} {
	set module_name [string trimright $temp_name "v"]
  set module_name [string trimright $module_name "s"]
  set module_name [string trimright $module_name "."]	
} else {
	set module_name [string trimright $temp_name "v"]
  set module_name [string trimright $module_name "."]	
}


alias genrtl {
 echo "\[exec\] genrtl"
 set file_id [open $file_name w+]

 my_ver_head $file_id $file_name $dev_name $def_tool

puts $file_id ""
puts $file_id ""
puts $file_id "// synopsys translate_off"
puts $file_id "`timescale 1ns/1ns"
puts $file_id "// synopsys translate_on"



 puts $file_id "module $module_name ("
 puts $file_id ""
 puts $file_id ""
 puts $file_id ");"
 puts $file_id ""
 puts $file_id "///////////////////////////////Signal Define/////////////////////////////////"
 puts $file_id ""
 puts $file_id "" 
 puts $file_id "/////////////////////////////////////////////////////////////////////////////"


puts $file_id ""
puts $file_id "/////////////////////////////////////////////////////////////////////////////"
puts $file_id "endmodule"
close $file_id
 
 echo "Genrating \"$file_name\" completed!!!"

}

# ---------------------------------------------------------------------
alias geninst {
  echo "\[exec\] geninst"
  
  if {![file isdirectory "./rtl_bb"]} {[file mkdir "./rtl_bb"]}
  cd ./rtl_bb
  
  set  file_inst_name  $module_name\_bb.v
  puts "$file_inst_name"
  set  file_inst_w_id [open $file_inst_name w+]
  puts $file_inst_w_id "//------------------------------------------------------"
  puts $file_inst_w_id "//Auto Generate File: used for wire connect and sim"
  puts $file_inst_w_id "//------------------------------------------------------"
  puts $file_inst_w_id ""
  
  set temp_list {}
  set temp {}
  
  if {[file exist "./../$file_name"]} {
    set file_r_id [open  "./../$file_name" r]
    while {[gets $file_r_id line] != -1} {
     if {[regexp {inout|input|output} $line match]} {
      if {[string compare [lindex $line 0] $match] == 0} {
      if {[lsearch $line  *\]] == -1} {
       #puts "match = $match" 
       set list_len [llength $line]
       incr list_len -1
       #puts "list_len = $list_len"
       set temp  [list $match 0 [string trimright [lindex $line $list_len] ","]] 
       set temp_list [concat "$temp_list" "{$temp}"]
       #puts "$temp_list"
      } else {
       #puts "match = $match"
       set list_len [llength $line]
       incr list_len -1
       #puts "list_len = $list_len"
       set temp [list $match [lindex $line [lsearch $line  *\]]] [string trimright [lindex $line $list_len] ","]]
       set temp_list [concat "$temp_list" "{$temp}"]
       #puts "temp= [lindex $temp 1]"
      }
    }
   }
   }
  } 
  puts  $file_inst_w_id "//DUT Inst signal Define"
  foreach var_list $temp_list {
   if {[lindex $var_list 1] == 0} {
    puts  $file_inst_w_id "wire [lindex $var_list 2]\;"
   } else {
    puts  $file_inst_w_id "wire [lindex $var_list 1] [lindex $var_list 2]\;"
   }
  } 
  
  puts  $file_inst_w_id ""
  puts  $file_inst_w_id "//-----------------------------------------------"
  puts  $file_inst_w_id "//Rtl instation define"
  puts  $file_inst_w_id ""
  
  puts  $file_inst_w_id "$module_name  $module_name\_inst\("
  set   len  [llength $temp_list]
  set   end  [llength $temp_list]
  incr  end  -1
  
  for {set x 0} {$x<$len} {incr x} {
    #puts "x = $x"
    if {$x == $end} {
      puts  $file_inst_w_id "  \.[lindex [lindex $temp_list $x] 2]\([lindex [lindex $temp_list $x] 2]\)"
    } else {
      puts  $file_inst_w_id "  \.[lindex [lindex $temp_list $x] 2]\([lindex [lindex $temp_list $x] 2]\),"
    }
  } 
  
  
  puts  $file_inst_w_id "\)\;"
  puts  $file_inst_w_id "//--------------------------------------------"
  
  close $file_inst_w_id
}


#-----------------------------------------------------------------------
#Print out user commmand line aliases
#
alias h {
	echo "List Of Command Line Aliases and Var"
	echo
	echo "genrtl     --  Commend: Generate Rtl file" 
	echo
	echo "geninst    --  Commend: Generate Instation and port signal define file(used for connect and sim)"
	echo 
	echo "file_name   --  verilog file name(*.v) eg. set file_name *.v"
	echo
	echo "dev_name    --  fpga device name"
	echo
	echo "def_tool    --  Quartus or vivado"
}
h



 








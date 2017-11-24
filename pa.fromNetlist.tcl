
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name computer -dir "C:/Users/321yy/Desktop/yyf/Tsinghua/code/computer/project4/Computer-16bit/planAhead_run_2" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/321yy/Desktop/yyf/Tsinghua/code/computer/project4/Computer-16bit/CPU_cs.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/321yy/Desktop/yyf/Tsinghua/code/computer/project4/Computer-16bit} }
set_property target_constrs_file "CPU.ucf" [current_fileset -constrset]
add_files [list {CPU.ucf}] -fileset [get_property constrset [current_run]]
link_design

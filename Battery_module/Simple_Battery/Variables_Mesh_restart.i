##################################################################
###################    Mesh           #######################
##################################################################
[Mesh]
  file = '../../Restart_files/Full_power_simple/Main_out_Battery0.e'
[]
##################################################################
###################    Variables           #######################
##################################################################
[Variables]
  [T_battery]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'T_battery'
  []
  [T_gas]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    type = MooseVariableFVReal
    initial_from_file_var = 'T_gas'
  []
[]


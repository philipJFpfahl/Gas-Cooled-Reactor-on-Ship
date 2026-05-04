##################################################################
###################    Variables           #######################
##################################################################
[Variables]
  [T_battery]
    family = SCALAR
    order = FIRST
    initial_condition = ${initial_T_battery}
  []
  [T_gas]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    type = MooseVariableFVReal
    initial_condition = ${initial_gas_temperature}
  []
[]

##################################################################
###################    Mesh           #######################
##################################################################
[Mesh]
  [./gen_mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0.0
    xmax = ${L_pipe}
    nx = 100
  [../]
[]

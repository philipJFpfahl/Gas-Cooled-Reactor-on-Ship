################################################################################
# Includes the variables and the mesh in the system.
################################################################################
[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
    initial_condition = ${initial_power}
  []
  [C1]
    family = SCALAR
    order = FIRST
    initial_condition = ${fparse initial_power*beta1/lambda1/Lambda}
  []
  [C2]
    family = SCALAR
    order = FIRST
    initial_condition = ${fparse initial_power*beta2/lambda2/Lambda}
  []
  [C3]
    family = SCALAR
    order = FIRST
    initial_condition = ${fparse initial_power*beta3/lambda3/Lambda}
  []
  [C4]
    family = SCALAR
    order = FIRST
    initial_condition = ${fparse initial_power*beta4/lambda4/Lambda}
  []
  [C5]
    family = SCALAR
    order = FIRST
    initial_condition = ${fparse initial_power*beta5/lambda5/Lambda}
  []
  [C6]
    family = SCALAR
    order = FIRST
    initial_condition = ${fparse initial_power*beta6/lambda6/Lambda}
  []
  [T_reactor]
    family = SCALAR
    order = FIRST
    initial_condition =${fparse Reactor_refference_temperature-1}
  []
[]

################################################################################
# Meshing 
################################################################################
[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 1
    ny = 1
    xmin = 0
    xmax = 1
    ymin = 0
    ymax = 1
    show_info = false
  []
[]

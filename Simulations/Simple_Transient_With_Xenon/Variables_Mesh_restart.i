################################################################################
# Includes the variables and the mesh for a restart of the system.
################################################################################
[Mesh]
  file = '../../Restart_files/Full_power_simple/Main_out.e'
[]

[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
      initial_from_file_var = 'power_scalar'
  []
  [C1]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'C1'
  []
  [C2]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'C2'
  []
  [C3]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'C3'
  []
  [C4]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'C4'
  []
  [C5]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'C5'
  []
  [C6]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'C6'
  []
  [T_reactor]
    family = SCALAR
    order = FIRST
    initial_from_file_var = 'T_reactor'
  []
[]


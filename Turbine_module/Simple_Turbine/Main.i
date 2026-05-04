##################################################################
###################    He-Properties    #######################
##################################################################
!include "../../Parameter/TH_parameter.py"

################################################################################
# Load physics 
################################################################################
!include "Turbine.i"
!include "Pump.i"

################################################################################
# Meshing 
# dummy sim
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
[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
    initial_condition = 1 
  []
[]

[Outputs]
  csv = true
  exodus  = false
[]

[ScalarKernels]
    [LHSPower]
      type = ODETimeDerivative
      variable = power_scalar
    []
[]
[Executioner]
  type = Transient
  dt = 1e9
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_abs_tol = 2.5e-10
  nl_rel_tol = 2.5e-10
  l_max_its = 200
[]

[Postprocessors]
 [Turbine_power]
   type = ParsedPostprocessor 
   expression = '(T_from_battery-T_to_battery)*cp_r*mass_flow_rate_secondary'
   constant_expressions = ' ${fparse cp_r}'
   constant_names = 'cp_r'
   pp_names = 'T_from_battery T_to_battery mass_flow_rate_secondary'
   execute_on = 'INITIAL  TIMESTEP_END '
 []
[]

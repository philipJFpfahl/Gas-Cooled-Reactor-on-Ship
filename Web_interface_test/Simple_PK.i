################################################################################
# Properties 
################################################################################
beta = 600
lambda = 1
LAMBDA = 1e-4

################################################################################
# Meshing 
################################################################################
[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 3
    ny = 3
    xmin = 0
    xmax = 1
    ymin = 0
    ymax = 1
    show_info = false
  []
[]

[Problem]
    kernel_coverage_check=false
    #allow_initial_conditions_with_restart = true
[]


################################################################################
# Variable now changes over time 
################################################################################
[Variables]
  [power_scalar]
    family = SCALAR
    order = FIRST
    initial_condition = 1
  []
  [C]
    family = SCALAR
    order = FIRST
    initial_condition = 6000000 
  []
[]

[ScalarKernels]
################################################################################
# add the right hand side of the Power equation 
################################################################################
  [LHSPower]
    type = ODETimeDerivative
    variable = power_scalar
  []
  [RHSPower]
    type = ParsedODEKernel
    variable = power_scalar
    coupled_variables = 'C'
    expression = '-(rho_T + rho_insertion-beta)/LAMBDA*power_scalar-lambda * C'
    constant_expressions = '${fparse beta} ${fparse LAMBDA} ${fparse lambda}'
    constant_names = 'beta LAMBDA lambda'
    postprocessors = 'rho_insertion rho_T'
  []
  [LHSC]
    type = ODETimeDerivative
    variable = C
  []
  [RHSC]
    type = ParsedODEKernel
    variable = C
    coupled_variables = 'power_scalar'
    expression = '-beta/LAMBDA*power_scalar + lambda*C'
    constant_expressions = '${fparse beta} ${fparse LAMBDA} ${fparse lambda}'
    constant_names = 'beta LAMBDA lambda'
  []
[]


#[AuxVariables]
#  [T]
#      family = MONOMIAL
#      order = CONSTANT
#      fv = true
#      initial_from_file_var = 'T'
#  []
#  [T_ref]
#      family = MONOMIAL
#      order = CONSTANT
#      fv = true
#      initial_from_file_var = 'T'
#  []
#[]



[Executioner]
  type = Transient
  dt = 0.01
  end_time = 10
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_abs_tol = 1e-11
  nl_rel_tol = 1e-11
  l_max_its = 200
[]

[Outputs]
  exodus = true
  csv = true   
[]



[Controls]
  [web_control]
    type = WebServerControl
    port = 6000
    #address = '127.0.0.1'
    initial_client_timeout = 600
    client_timeout = 600
  []
[]

[Postprocessors]
  [rho_T]
    type = ParsedPostprocessor
    expression = '0'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []

  [rho_insertion]
    type = ConstantPostprocessor
    value = '0'
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
  [t]
    type = FunctionValuePostprocessor
    function = 't'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []

  [power]                    # Expose power for plotting / querying
    type = ScalarVariable
    variable = power_scalar
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]


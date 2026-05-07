################################################################################
# Variable  
################################################################################

[ScalarKernels]
    [LHSPower]
      type = ODETimeDerivative
      variable = power_scalar
    []
    [RHSPower]
      type = ParsedODEKernel
      variable = power_scalar
      expression = '-(rho_controll-beta)/Lambda*power_scalar'
      constant_expressions = '${fparse beta} ${fparse Lambda} '
      constant_names = 'beta Lambda'
      postprocessors = 'rho_controll'
    []
    [RHSPower_DNP_Source_1]
      type = ParsedODEKernel
      variable = power_scalar
      coupled_variables = 'C1'
      expression = '-lambda1*C1'
      constant_expressions = '${lambda1}'
      constant_names = 'lambda1'
    []
    [RHSPower_DNP_Source_2]
      type = ParsedODEKernel
      variable = power_scalar
      coupled_variables = 'C2'
      expression = '-lambda2*C2'
      constant_expressions = '${lambda2}'
      constant_names = 'lambda2'
    []
    [RHSPower_DNP_Source_3]
      type = ParsedODEKernel
      variable = power_scalar
      coupled_variables = 'C3'
      expression = '-lambda3*C3'
      constant_expressions = '${lambda3}'
      constant_names = 'lambda3'
    []
    [RHSPower_DNP_Source_4]
      type = ParsedODEKernel
      variable = power_scalar
      coupled_variables = 'C4'
      expression = '-lambda4*C4'
      constant_expressions = '${lambda4}'
      constant_names = 'lambda4'
    []
    [RHSPower_DNP_Source_5]
      type = ParsedODEKernel
      variable = power_scalar
      coupled_variables = 'C5'
      expression = '-lambda5*C5'
      constant_expressions = '${lambda5}'
      constant_names = 'lambda5'
    []
    [RHSPower_DNP_Source_6]
      type = ParsedODEKernel
      variable = power_scalar
      coupled_variables = 'C6'
      expression = '-lambda6*C6'
      constant_expressions = '${lambda6}'
      constant_names = 'lambda6'
    []

    [LHSC1]
      type = ODETimeDerivative
      variable = C1
    []
    [RHSC1]
      type = ParsedODEKernel
      variable = C1
      coupled_variables = 'power_scalar'
      expression = '-beta1/Lambda*power_scalar + lambda1*C1'
      constant_expressions = '${fparse beta1} ${fparse Lambda} ${fparse lambda1}'
      constant_names = 'beta1 Lambda lambda1'
    []

    [LHSC2]
      type = ODETimeDerivative
      variable = C2
    []
    [RHSC2]
      type = ParsedODEKernel
      variable = C2
      coupled_variables = 'power_scalar'
      expression = '-beta2/Lambda*power_scalar + lambda2*C2'
      constant_expressions = '${fparse beta2} ${fparse Lambda} ${fparse lambda2}'
      constant_names = 'beta2 Lambda lambda2'
    []

    [LHSC3]
      type = ODETimeDerivative
      variable = C3
    []
    [RHSC3]
      type = ParsedODEKernel
      variable = C3
      coupled_variables = 'power_scalar'
      expression = '-beta3/Lambda*power_scalar + lambda3*C3'
      constant_expressions = '${fparse beta3} ${fparse Lambda} ${fparse lambda3}'
      constant_names = 'beta3 Lambda lambda3'
    []

    [LHSC4]
      type = ODETimeDerivative
      variable = C4
    []
    [RHSC4]
      type = ParsedODEKernel
      variable = C4
      coupled_variables = 'power_scalar'
      expression = '-beta4/Lambda*power_scalar + lambda4*C4'
      constant_expressions = '${fparse beta4} ${fparse Lambda} ${fparse lambda4}'
      constant_names = 'beta4 Lambda lambda4'
    []

    [LHSC5]
      type = ODETimeDerivative
      variable = C5
    []
    [RHSC5]
      type = ParsedODEKernel
      variable = C5
      coupled_variables = 'power_scalar'
      expression = '-beta5/Lambda*power_scalar + lambda5*C5'
      constant_expressions = '${fparse beta5} ${fparse Lambda} ${fparse lambda5}'
      constant_names = 'beta5 Lambda lambda5'
    []

    [LHSC6]
      type = ODETimeDerivative
      variable = C6
    []
    [RHSC6]
      type = ParsedODEKernel
      variable = C6
      coupled_variables = 'power_scalar'
      expression = '-beta6/Lambda*power_scalar + lambda6*C6'
      constant_expressions = '${fparse beta6} ${fparse Lambda} ${fparse lambda6}'
      constant_names = 'beta6 Lambda lambda6'
    []
[]

[Postprocessors]
  [t]
    type = FunctionValuePostprocessor
    function = 't'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [power]                    # Expose power for plotting / querying
    type = ScalarVariable
    variable = power_scalar
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

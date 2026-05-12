################################################################################
# Includes Xenon development and the reactivity feedback from it  
################################################################################

################################################################################
# Parameters  
################################################################################
!include "../../Parameter/Xenon_parameter.py"

[ScalarKernels]
    [LHSIodine]
      type = ODETimeDerivative
      variable = Iodine_scalar
    []
    [RHSIodine_1]
      type = ParsedODEKernel
      variable = Iodine_scalar
      expression = '-(gamma_I * Sigma_f * power_to_flux * power_scalar )'
      constant_expressions = '${fparse gamma_I}  ${fparse Sigma_f}  ${fparse power_to_flux}'
      constant_names = 'gamma_I Sigma_f power_to_flux '
      coupled_variables = 'power_scalar'
    []
    [RHSIodine_2]
      type = ParsedODEKernel
      variable = Iodine_scalar
      expression = '-( - lambda_I * Iodine_scalar)'
      constant_expressions = '${fparse lambda_I}'
      constant_names = ' lambda_I'
    []

    [LHSXenon]
      type = ODETimeDerivative
      variable = Xenon_scalar
    []
    [RHSXenon_1]
      type = ParsedODEKernel
      variable = Xenon_scalar
      expression = '-(gamma_X * Sigma_f * power_to_flux * power_scalar )'
      constant_expressions = '${fparse gamma_X}  ${fparse Sigma_f}  ${fparse power_to_flux}'
      constant_names = 'gamma_X Sigma_f power_to_flux '
      coupled_variables = 'power_scalar'
    []
    [RHSXenon_2]
      type = ParsedODEKernel
      variable = Xenon_scalar
      expression = '-( - lambda_X * Xenon_scalar)'
      constant_expressions = '${fparse lambda_X}'
      constant_names = ' lambda_X'
    []
    [RHSXenon_3]
      type = ParsedODEKernel
      variable = Xenon_scalar
      coupled_variables = 'power_scalar'
      expression = '-( - sigma_aX * power_to_flux * power_scalar * Xenon_scalar)'
      constant_expressions = '${fparse sigma_aX}    ${fparse power_to_flux}'
      constant_names = 'sigma_aX  power_to_flux '
    []
   [RHSPower_Xenon_feedback]
     type = ParsedODEKernel
     variable = power_scalar
     coupled_variables = 'Xenon_scalar'
     expression = ' Xenon_scalar * sigma_aX*power_scalar*1e5 /Sigma_a/Lambda'
     constant_expressions = ' ${fparse sigma_aX} ${fparse Sigma_a} ${fparse Lambda}'
     constant_names = ' sigma_aX Sigma_a Lambda'
   []
[]

[Postprocessors]
  [Xenon]                    # Expose for plotting / querying
    type = ScalarVariable
    variable = Xenon_scalar
    execute_on = 'INITIAL TIMESTEP_END'
  []
 [rho_Xe]
  type = ParsedPostprocessor
  expression = ' Xenon * sigma_aX /Sigma_a*1e5'
  pp_names = 'Xenon'
  constant_expressions = ' ${fparse sigma_aX} ${fparse Sigma_a}'
  constant_names = ' sigma_aX Sigma_a'
  execute_on = 'INITIAL TIMESTEP_END'
 []
[]

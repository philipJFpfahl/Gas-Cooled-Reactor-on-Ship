################################################################################
# Parameters  
################################################################################
!include "../../Parameter/TH_parameter.py"

[ScalarKernels]
    [LHS_graphite_time]
      type = ODETimeDerivative
      variable = T_reactor
    []
    [RHS_graphite_reactor]
      type = ParsedODEKernel
      variable = T_reactor
      expression = '-(power - cp_r*mass_flow_rate_primary*(T_outlet-T_inlet))/Cr'
      constant_expressions = '${fparse Cr} ${fparse cp_r}  '
      constant_names = 'Cr cp_r'
      postprocessors = 'power mass_flow_rate_primary T_outlet T_inlet'
    []
   [RHSPower_feedback]
     type = ParsedODEKernel
     variable = power_scalar
     expression = '-(rho_T)/Lambda*power_scalar'
     constant_expressions = '${fparse beta} ${fparse Lambda} '
     constant_names = 'beta Lambda'
     postprocessors = 'rho_T'
   []
[]

################################################################################
# Calc temperature  
################################################################################
[Postprocessors]
 [Energy_graphite]
   type = ParsedPostprocessor 
   execute_on = 'initial timestep_end'
   expression = '(T_reactor_pp- T_refference+1) * Cr'
   pp_names = 'T_reactor_pp T_refference'
  constant_names = 'Cr'
  constant_expressions = '${fparse Cr}'
 []
 [rho_T]
  type = ParsedPostprocessor
  expression = 'alpha*(T_reactor_pp-T_refference)'
  pp_names = 'T_reactor_pp T_refference'
  constant_names = 'alpha'
  constant_expressions = '${alpha}'
  execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_refference]
   type = ConstantPostprocessor
   value = ${Reactor_refference_temperature}
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_outlet]
   type = ParsedPostprocessor 
   expression = 'T_reactor_pp + (T_inlet - T_reactor_pp)*exp(-Ar_core/mass_flow_rate_primary/cp_r)'
   constant_expressions = '${fparse Ar_core} ${fparse cp_r}'
   constant_names = 'Ar_core cp_r '
   pp_names = 'T_inlet T_reactor_pp mass_flow_rate_primary'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_reactor_pp]
    type = ScalarVariable
    variable = T_reactor
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
[]

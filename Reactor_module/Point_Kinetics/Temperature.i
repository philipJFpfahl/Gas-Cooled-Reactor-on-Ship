################################################################################
# Parameters  
################################################################################
!include "../../Parameter/TH_parameter.py"

################################################################################
# add feedback kernel  
################################################################################

[ScalarKernels]
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
 [rho_T]
  type = ParsedPostprocessor
  expression = 'alpha*(T_reactor-T_refference)'
  pp_names = 'T_reactor T_refference'
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
   expression = 'T_inlet + power/mass_flow_rate_primary/cp_r'
   pp_names = 'T_inlet power mass_flow_rate_primary'
  constant_names = ' cp_r'
  constant_expressions = '${cp_r}'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_reactor]
   type = ParsedPostprocessor 
   expression = '(T_inlet + T_outlet)/2'
   pp_names = 'T_inlet T_outlet'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
[]

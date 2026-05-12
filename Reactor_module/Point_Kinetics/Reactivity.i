################################################################################
# Includes a Postprocessors for reactivity control. 
################################################################################
[Postprocessors]
  [rho_controll]
    type = ConstantPostprocessor
    value = '0'
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

################################################################################
# Includes a Postprocessor to control the primary mass flow rate 
################################################################################
[Postprocessors]
  [mass_flow_rate_primary]
    type = Receiver
    default = ${initial_mass_flow_rate_primary} 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

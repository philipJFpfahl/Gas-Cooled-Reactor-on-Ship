[Postprocessors]
 [mass_flow_rate_secondary]
    type = Receiver
    default = ${initial_mass_flow_rate_secondary} 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
[]

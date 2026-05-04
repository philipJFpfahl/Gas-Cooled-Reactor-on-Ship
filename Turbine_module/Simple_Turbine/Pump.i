[Postprocessors]
 [mass_flow_rate_secondary]
    type = Receiver
    default = ${mass_flow_rate_secondary} 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
[]

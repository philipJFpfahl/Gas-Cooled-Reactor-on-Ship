[Postprocessors]
  [mass_flow_rate_primary]
    type = Receiver
    default = ${mass_flow_rate_reactor} 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

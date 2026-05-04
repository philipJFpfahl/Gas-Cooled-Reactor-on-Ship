epsilon = 0.5 # total efficiency

[Postprocessors]
 [T_from_battery]
    type = Receiver
    default = 850 
   execute_on = 'INITIAL TIMESTEP_BEGIN '
 []
 [Power_demand]
    type = Receiver
    default = 7e7 
   execute_on = 'INITIAL  TIMESTEP_END'
 []
 [T_to_battery]
   type = ParsedPostprocessor 
   #expression = 'T_from_battery*(1-epsilon)'
   expression = '(T_from_battery- (Power_demand)/(epsilon*mass_flow_rate_secondary*cp_r))'
   constant_expressions = '${fparse epsilon} ${fparse cp_r}'
   constant_names = 'epsilon cp_r'
   pp_names = 'T_from_battery Power_demand  mass_flow_rate_secondary'
   execute_on = 'INITIAL TIMESTEP_BEGIN'
 []
[]

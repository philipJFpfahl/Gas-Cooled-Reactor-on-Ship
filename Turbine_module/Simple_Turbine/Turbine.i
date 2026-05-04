
[Postprocessors]
 [T_to_battery]
   type = ParsedPostprocessor 
   #expression = 'T_from_battery*(1-epsilon)'
   expression = '(T_from_battery- (Power_demand)/(epsilon*mass_flow_rate_secondary*cp_r))'
   constant_expressions = '${fparse epsilon} ${fparse cp_r}'
   constant_names = 'epsilon cp_r'
   pp_names = 'T_from_battery Power_demand  mass_flow_rate_secondary'
   execute_on = 'INITIAL TIMESTEP_BEGIN'
 []
 [Turbine_power]
   type = ParsedPostprocessor 
   expression = '(T_from_battery-T_to_battery)*cp_r*mass_flow_rate_secondary'
   constant_expressions = ' ${fparse cp_r}'
   constant_names = 'cp_r'
   pp_names = 'T_from_battery T_to_battery mass_flow_rate_secondary'
   execute_on = 'INITIAL  TIMESTEP_END '
 []
[]

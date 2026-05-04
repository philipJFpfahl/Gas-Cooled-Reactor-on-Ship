[ScalarKernels]
    [LHS_Battery_time]
      type = ODETimeDerivative
      variable = T_battery
    []
    [RHS_Battery_reactor]
      type = ParsedODEKernel
      variable = T_battery
      expression = '-cp_r*mass_flow_rate_primary*(T_pipe_outlet-T_to_reactor)/Cb'
      constant_expressions = '${fparse Cb} ${fparse cp_r}  '
      constant_names = 'Cb cp_r'
      postprocessors = 'T_pipe_outlet T_to_reactor mass_flow_rate_primary'
    []
    [RHS_Battery_turbine]
      type = ParsedODEKernel
      variable = T_battery
      expression = '-cp_r*mass_flow_rate_secondary*(T_from_turbine-T_to_turbine)/Cb'
      constant_expressions = '${fparse Cb} ${fparse cp_r} ${fparse mass_flow_rate_reactor}'
      constant_names = 'Cb cp_r mass_flow_rate_secondary'
      postprocessors = 'T_from_turbine T_to_turbine '
    []
[]

[Postprocessors]
  [T_battery_pp]                    # Expose battery for plotting / querying
    type = ScalarVariable
    variable = T_battery
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
 [T_to_reactor]
   type = ParsedPostprocessor 
   expression = 'T_battery_pp + (T_pipe_outlet - T_battery_pp)*exp(-Ar_R/mass_flow_rate_primary/cp_r)'
   constant_expressions = '${fparse Ar_R} ${fparse cp_r}'
   constant_names = 'Ar_R cp_r '
   pp_names = 'T_pipe_outlet T_battery_pp mass_flow_rate_primary'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_from_turbine]
    type = Receiver
    default = 425 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [mass_flow_rate_secondary]
    type = Receiver
    default = '${mass_flow_rate_reactor}' 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_to_turbine]
 #TODO Update these values for the secondary side
   type = ParsedPostprocessor 
   expression = 'T_battery_pp+ (T_from_turbine - T_battery_pp)*exp(-Ar_T/mass_flow_rate_primary/cp_r)'
   constant_expressions = '${fparse Ar_R} ${fparse cp_r}'
   constant_names = 'Ar_T cp_r '
   pp_names = 'T_from_turbine T_battery_pp mass_flow_rate_primary'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [Power_to_turbine]
 #TODO: change the inlet temp currently set at 500
 # change the MFR currently set at 10
   type = ParsedPostprocessor 
   expression = '(T_to_turbine-T_from_turbine)*cp_r*mass_flow_rate_secondary'
   constant_expressions = '${fparse cp_r} '
   constant_names = 'cp_r'
   pp_names = 'T_to_turbine T_from_turbine mass_flow_rate_secondary'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [Energy_to_turbine]
   type = TimeIntegratedPostprocessor
   value = Power_to_turbine
   execute_on = 'initial timestep_end'
   #time_integration_scheme = 'trapezoidal-rule'
 []
[]

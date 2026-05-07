################################################################################
# Load physics 
################################################################################
!include "Pipes.i"
!include "Battery.i"
!include "Pump.i"
##################################################################
###################          Properties    #######################
##################################################################
!include "../../Parameter/TH_parameter.py"

##################################################################
###################    Variables           #######################
##################################################################
#!include "Variables_Mesh.i"
!include "Variables_Mesh_restart.i"

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  dt = 1e9
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_abs_tol = 2.5e-10
  nl_rel_tol = 2.5e-10
  l_max_its = 200
#steady_state_detection = true
#steady_state_tolerance = 1e-10
[]

[Outputs]
  csv = true
time_step_interval = 100
  #exodus  = true
[]

[Postprocessors]
 [Cb_battery]
   type = ParsedPostprocessor 
   execute_on = 'initial timestep_end'
   expression = 'initial_Cb'
   constant_names = ' initial_Cb'
   constant_expressions = '${initial_Cb}'
 []
 [Energy_battery]
   type = ParsedPostprocessor 
   execute_on = 'initial timestep_end'
   expression = '(T_battery_pp- initial_T_battery) *  Cb_battery'
   pp_names = 'T_battery_pp Cb_battery'
  constant_names = 'initial_T_battery'
  constant_expressions = '${initial_T_battery} '
 []
  [average_gas_temperature]
    type = ElementAverageValue
    variable = T_gas
   execute_on = 'initial timestep_end'
  []
 [Energy_Gas]
   type = ParsedPostprocessor 
   execute_on = 'initial timestep_end'
   expression = '(average_gas_temperature - initial_gas_temperature)*mass_flow_rate_primary*cp_r'
   constant_expressions = '${fparse initial_gas_temperature} ${fparse cp_r}'
   constant_names = 'initial_gas_temperature cp_r '
   pp_names = 'average_gas_temperature T_pipe_outlet T_battery_pp mass_flow_rate_primary'
 []
[]

[MultiApps]
    [Turbine]
      type = TransientMultiApp
      input_files = "../../Turbine_module/Simple_Turbine/Main.i"
      execute_on= "timestep_end "
      sub_cycling = false
    []
[]

[Transfers]
    [push_T_to_turbine]
        type = MultiAppPostprocessorTransfer
        to_multi_app = Turbine 
        from_postprocessor = T_to_turbine
        to_postprocessor = T_from_battery
        execute_on= "timestep_end initial"
    [] 
    [pull_T_from_turbine]
        type = MultiAppPostprocessorTransfer
        from_multi_app = Turbine 
        from_postprocessor = T_to_battery
        to_postprocessor = T_from_turbine
        execute_on= "timestep_end initial"
        reduction_type = average
    [] 
    [pull_mass_flow_from_turbine]
        type = MultiAppPostprocessorTransfer
        from_multi_app = Turbine 
        from_postprocessor = mass_flow_rate_secondary
        to_postprocessor = mass_flow_rate_secondary
        execute_on= "timestep_end initial"
        reduction_type = average
    [] 
[]

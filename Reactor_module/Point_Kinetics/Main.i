################################################################################
# Load Kinetics Parameters  
################################################################################
!include "../../Parameter/Kinetics_parameter.py"

################################################################################
# Load physics 
################################################################################
!include "Simple_PK.i"
!include "Temperature.i"
!include "Reactivity.i"

##################################################################
###################    Variables           #######################
##################################################################
!include "Variables_Mesh.i"

################################################################################
# Execution parameters 
################################################################################

[Problem]
    kernel_coverage_check=false
    #allow_initial_conditions_with_restart = true
[]
[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Transient
  ##end_time = 30
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_abs_tol = 2.5e-10
  nl_rel_tol = 2.5e-10
  l_max_its = 200
steady_state_detection = true
steady_state_tolerance = 1e-6
 dt  =1   
 # [TimeStepper]
 #   type = IterationAdaptiveDT
 #   dt = 0.01
 #   optimal_iterations = 20
 #   iteration_window = 2
 #   growth_factor = 1.01
 #   cutback_factor = 0.8
 # []
 # dt_max = 2e4
[]

[Outputs]
  csv = true
  exodus  = false
[]

#[Controls]
#  [web_control]
#    type = WebServerControl
#    port = 6000
#    address = '127.0.0.1'
#    initial_client_timeout = 600
#    client_timeout = 600
#  []
#[]

[MultiApps]
    [Battery]
      type = TransientMultiApp
      input_files = "../../Battery_module/Simple_Battery/Main.i"
      execute_on= "timestep_end "
      sub_cycling = false
    []
[]

[Transfers]
    [push_T_outlet_to_battery]
        type = MultiAppPostprocessorTransfer
        to_multi_app = Battery 
        from_postprocessor = T_outlet
        to_postprocessor = T_pipe_inlet
        execute_on= "timestep_end initial"
    [] 
    [pull_MFR_from_battery]
        type = MultiAppPostprocessorTransfer
        from_multi_app = Battery 
        to_postprocessor = mass_flow_rate_primary 
        from_postprocessor = mass_flow_rate_primary
        execute_on= "timestep_end initial"
        reduction_type = average
    [] 
    [pull_T_inlet_from_battery]
        type = MultiAppPostprocessorTransfer
        from_multi_app = Battery 
        to_postprocessor = T_inlet 
        from_postprocessor = T_to_reactor
        execute_on= "timestep_end initial"
        reduction_type = average
    [] 
    [pull_T_battery_from_battery]
        type = MultiAppPostprocessorTransfer
        from_multi_app = Battery 
        to_postprocessor = T_battery 
        from_postprocessor = T_battery_pp
        execute_on= "timestep_end initial"
        reduction_type = average
    [] 
[]

[Postprocessors]
  [mass_flow_rate_primary]
    type = Receiver
    default = ${mass_flow_rate_reactor} 
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
 [Produced_energy]
   type = TimeIntegratedPostprocessor
   value = power
   execute_on = 'initial timestep_end'
   #time_integration_scheme = 'trapezoidal-rule'
 []
 [Power_outlet]
   type = ParsedPostprocessor 
   expression = '(T_outlet-T_inlet)*mass_flow_rate_primary*cp_r'
   pp_names = 'T_outlet T_inlet mass_flow_rate_primary'
  constant_names = ' cp_r'
  constant_expressions = '${cp_r}'
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [Outlet_energy]
   type = TimeIntegratedPostprocessor
   value = Power_outlet
   execute_on = 'initial timestep_end'
   #time_integration_scheme = 'trapezoidal-rule'
 []
 [T_battery]
    type = Receiver
    default = 1000
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [T_inlet]
    type = Receiver
    default = ${Reactor_inlet_temperature}
   execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
 []
 [Energy_reactor]
   type = ParsedPostprocessor 
   execute_on = 'initial timestep_end'
   expression = '(T_reactor_pp-  Reactor_refference_temperature) * Cr'
   pp_names = 'T_reactor_pp'
  constant_names = 'Reactor_refference_temperature Cr'
  constant_expressions = '${ Reactor_refference_temperature} ${Cr}'
 []
[]

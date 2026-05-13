################################################################################
# Load Kinetics Parameters  
################################################################################
!include "../../Parameter/Kinetics_parameter.py"

################################################################################
# Load physics 
################################################################################
!include "../../Reactor_module/Point_Kinetics/Simple_PK.i"
!include "../../Reactor_module/Point_Kinetics/Temperature.i"
!include "Reactivity.i"
!include "../../Reactor_module/Point_Kinetics/Xenon.i"

##################################################################
###################    Variables           #######################
##################################################################
#!include "../../Reactor_module/Point_Kinetics/Variables_Mesh.i"
!include "Variables_Mesh_restart.i"

################################################################################
# Execution parameters 
################################################################################

[Problem]
    kernel_coverage_check=false
    allow_initial_conditions_with_restart = true
[]
[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_abs_tol = 2.5e-10
  nl_rel_tol = 2.5e-10
  l_max_its = 200
  steady_state_detection = true
  steady_state_tolerance = 1e-6
  dt  = 10   
  #end_time = 6000
  #[TimeStepper]
  #  type = IterationAdaptiveDT
  #  dt = 0.01
  #  optimal_iterations = 20
  #  iteration_window = 2
  #  growth_factor = 1.01
  #  cutback_factor = 0.8
  #[]
  dt_max = 2e3
[]

[Outputs]
  csv = true
  time_step_interval = 1
  exodus = True
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


[Postprocessors]
  [mass_flow_rate_primary]
    type = Receiver
    default = ${initial_mass_flow_rate_primary} 
   execute_on = 'INITIAL TIMESTEP_END'
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
   execute_on = 'INITIAL TIMESTEP_END'
 []
 [Outlet_energy]
   type = TimeIntegratedPostprocessor
   value = Power_outlet
   execute_on = 'initial timestep_end'
   #time_integration_scheme = 'trapezoidal-rule'
 []
 [T_battery]
    type = Receiver
    default = ${initial_T_battery}
    execute_on = 'INITIAL TIMESTEP_END'
 []
 [T_inlet]
    type = Receiver
    default = ${Reactor_inlet_temperature}
   execute_on = 'INITIAL TIMESTEP_END'
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

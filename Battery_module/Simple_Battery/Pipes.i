
[GlobalParams]
  advected_interp_method = 'upwind'
[]


[FVKernels]
  [Time_T_gas]
    type = FVTimeKernel
    variable =T_gas
  []
  [advectionT]
    type = FVAdvection
    variable =T_gas
    velocity = '${velocity_pipes} 0 0'
    force_boundary_execution = true
  []
[]

[FVBCs]
  [left_T]
    type = FVFunctorDirichletBC
    boundary = 'left'
    functor = 'T_pipe_inlet'
    variable =T_gas
  []
[]


[Postprocessors]
 [T_pipe_inlet]
    type = Receiver
    default = ${initial_T_from_reactor}
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
  [T_pipe_outlet]
    type = PointValue
    point = '${L_pipe} 0 0'
    variable =T_gas 
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

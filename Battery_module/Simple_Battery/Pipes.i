
velocity_pipes= ${fparse L_pipe/circulation_time}
[GlobalParams]
  advected_interp_method = 'upwind'
[]

[Mesh]
  [./gen_mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0.0
    xmax = ${L_pipe}
    nx = 100
  [../]
[]

[Variables]
  [T_gas]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    type = MooseVariableFVReal
    initial_condition = ${initial_gas_temperature}
  []
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
    default = 1190
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
  [T_pipe_outlet]
    type = PointValue
    point = '${L_pipe} 0 0'
    variable =T_gas 
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END'
  []
[]

##################################################################
###################  Reactor PARAMETERS    #######################
##################################################################
initial_power = 15e6
Cr = 2.2e7# J/K  heat capacity of the reactor with a volum
initial_mass_flow_rate_primary = 50 # kg/s somehow adjusted to have some ~ 100K rise in the core
cp_r = 5193 # J/kg-K (CO2 at 25C)
Ar_core = 100000 #guess? effective area
Reactor_inlet_temperature = 600
Reactor_refference_temperature = 1000.0

##################################################################
###################    PIPES PARAMETERS    #######################
##################################################################
L_pipe=10.0
circulation_time=10.0
velocity_pipes= 1 # L_pipe/circulation_time

##################################################################
###################    BATTERY PARAMETERS    #####################
##################################################################
initial_T_from_reactor = 877
initial_T_battery = 696.3 # K
initial_gas_temperature = 877.1 # K
initial_Cb = 1e9 #' J/K  heat capacity of the battery (15 MWh run the turbine at full power for 1 hour with 50K temperature decrease)
Ar_R = 100000 #guess? effective area
Ar_T = 100000 #guess? effective area


##################################################################
###################    TURBINE PARAMETERS    #####################
##################################################################
initial_mass_flow_rate_secondary = 100 # kg/s somehow adjusted to have some ~ 100K rise in the core
initial_T_from_turbine = 531.4
initial_T_to_turbine = 560.2
initial_power_demand = 7.5e6
epsilon = 0.5 # total efficiency

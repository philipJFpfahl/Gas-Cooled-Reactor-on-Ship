Cr = 2.2e7# J/K  heat capacity of the reactor with a volum

cp_r = 5193 # J/kg-K (CO2 at 25C)
mass_flow_rate_reactor = 50 # kg/s somehow adjusted to have some ~ 100K rise in the core
mass_flow_rate_secondary = 100 # kg/s somehow adjusted to have some ~ 100K rise in the core

Ar_R = 100000 #guess?
Ar_T = 100000 #guess?
Ar_core = 100000 #guess?

##################################################################
###################    PIPES PARAMETERS    #######################
##################################################################
L_pipe=10.0
circulation_time=10.0
velocity_pipes= 1 # L_pipe/circulation_time

##################################################################
###################    BATTERY PARAMETERS    #####################
##################################################################
initial_T_battery = 900. # K
initial_gas_temperature = 1100. # K
Cb = 1e7#9 J/K  heat capacity of the battery (15 MWh run the turbine at full power for 1 hour with 50K temperature decrease)

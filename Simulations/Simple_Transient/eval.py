import pandas as pd
import matplotlib.pyplot as plt
import sys


# Load CSV
df = pd.read_csv("Main_out.csv")
df_battery = pd.read_csv("Main_out_Battery0.csv") 
df_turbine = pd.read_csv("Main_out_Battery0_Turbine0.csv") 

# Convert time column to datetime

################################################################################
# Plot parameters over time  
################################################################################

fig, ax_left = plt.subplots()
y_columns=["T_battery","T_inlet","T_outlet","T_reactor","T_refference"]
for col in y_columns:
    if col not in df.columns:
        raise ValueError(f"Column '{col}' not found in CSV")
    ax_left.plot(df["time"], df[col], label=col)
ax_left.plot(df_turbine["time"], df_turbine["T_to_battery"], label="T_to_battery")
ax_left.plot(df_turbine["time"], df_turbine["T_from_battery"], label="T_from_battery")
ax_left.set_ylabel("time")
ax_left.set_ylabel("Temperature [K]")

ax_right = ax_left.twinx()
ax_right.plot(
    df["time"],
    df["power"],
    linestyle="--",
    label="power"
    )
ax_right.plot(
    df_turbine["time"],
    df_turbine["Power_demand"],
    linestyle="--",
    label="power demand"
    )
ax_right.set_ylabel("Power")

plt.grid()

    # Combine legends
handles, labels = ax_left.get_legend_handles_labels()
h2, l2 = ax_right.get_legend_handles_labels()
handles += h2
labels += l2

ax_left.legend(handles, labels, loc="best")
plt.tight_layout()
plt.show()


plt.plot(df["time"], df["rho_T"], label="T_to_battery")
plt.show()

################################################################################
# Plot Energy balance over time  
################################################################################

fig, ax_left = plt.subplots()
ax_left.plot(df["time"], df["Produced_energy"] , label="Reactor_energy")
ax_left.plot(df_battery["time"], df_battery["Energy_to_turbine"] , label="Turbine_energy")
ax_left.plot(df_battery["time"],  df_battery["Energy_battery"] , label="Energy_battery")
ax_left.plot(df["time"], df["Energy_graphite"], label="Energy_graphite")
ax_left.plot(df_battery["time"],   df_battery["Energy_Gas"], label="Energy_gas")

ax_left.plot(df["time"], df_battery["Energy_Gas"] + df_battery["Energy_battery"] + df_battery["Energy_to_turbine"] , label="System_energy")
ax_left.set_ylabel("time")
ax_left.set_ylabel("Energy [J]")


plt.grid()
ax_left.legend()
plt.tight_layout()
plt.show()

################################################################################
# Plot Energy loss over time  
################################################################################

fig, ax_left = plt.subplots()
ax_left.plot(df["time"], (df["Produced_energy"]-(df_battery["Energy_Gas"] + df_battery["Energy_battery"] + df_battery["Energy_to_turbine"])), label="Missing_energy")
ax_left.plot(df["time"], (df["Produced_energy"]-(df_battery["Energy_Gas"] + df_battery["Energy_battery"] + df_turbine["Rejected_energy_turbine"])), label="Missing_energy")
ax_left.set_ylabel("time")

plt.grid()
ax_left.legend()
plt.tight_layout()
plt.show()

import pandas as pd
import matplotlib.pyplot as plt
import sys


# Load CSV
df = pd.read_csv("Main_out.csv")

# Convert time column to datetime

# Plot

fig, ax_left = plt.subplots()
y_columns=["T_battery","T_inlet","T_outlet","T_reactor","T_refference"]
for col in y_columns:
    if col not in df.columns:
        raise ValueError(f"Column '{col}' not found in CSV")
    ax_left.plot(df["time"], df[col], label=col)
ax_left.set_ylabel("time")
ax_left.set_ylabel("Temperature [K]")

ax_right = ax_left.twinx()
ax_right.plot(
    df["time"],
    df["power"],
    linestyle="--",
    label="power"
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

df_battery = pd.read_csv("Main_out_Battery0.csv") 

fig, ax_left = plt.subplots()
ax_left.plot(df["time"], df["Produced_energy"] , label="Reactor_energy")
ax_left.plot(df_battery["time"], df_battery["Energy_to_turbine"] , label="Turbine_energy")
ax_left.plot(df_battery["time"], df_battery["Energy_Gas"] + df_battery["Energy_battery"] , label="Energy_stored")

ax_left.plot(df["time"], df_battery["Energy_Gas"] + df_battery["Energy_battery"] + df_battery["Energy_to_turbine"] , label="System_energy")
ax_left.set_ylabel("time")
ax_left.set_ylabel("Energy [J]")


plt.grid()
ax_left.legend()
plt.tight_layout()
plt.show()


fig, ax_left = plt.subplots()
ax_left.plot(df["time"], df["Produced_energy"]-(df_battery["Energy_Gas"] + df_battery["Energy_battery"] + df_battery["Energy_to_turbine"] ) , label="Missing_energy")

ax_left.set_ylabel("time")


plt.grid()
ax_left.legend()
plt.tight_layout()
plt.show()

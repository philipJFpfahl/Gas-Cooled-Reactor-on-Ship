import pandas as pd
import matplotlib.pyplot as plt
import sys


# Load CSV
#path = "data/10000000.0_"
path = ""
df = pd.read_csv(path + "Main_out.csv")

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
ax_left.set_ylabel("Temperature (K)")

ax_right = ax_left.twinx()
ax_right.plot(
    df["time"],
    df["power"]*1e-6,
    linewidth= 2,
    color = "black",
    label="power"
    )
ax_right.set_ylabel("Power (MW)")
ax_left.set_xlabel("time (s)")

plt.grid()

    # Combine legends
handles, labels = ax_left.get_legend_handles_labels()
h2, l2 = ax_right.get_legend_handles_labels()
handles += h2
labels += l2

box = ax_left.get_position()
ax_left.set_position([box.x0, box.y0, box.width * 0.8, box.height])

# Put a legend to the right of the current axis
ax_left.legend(loc='center left', bbox_to_anchor=(1.02, 0.8))
plt.tight_layout()
plt.show()


plt.plot(df["time"], df["rho_T"], label="T_to_battery")
plt.plot(df["time"], df["rho_Xe"], label="T_to_battery")
plt.show()

plt.plot(df["time"], df["Xenon"], label="T_to_battery")
plt.plot(df["time"], df["Iodine_scalar"], label="T_to_battery")
plt.show()


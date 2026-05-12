import numpy as np
import matplotlib.pyplot as plt

MOOSE_APP = "/home/philip-pfahl/NTNU/MOOSE/Squirrel/squirrel-opt"          # path to your MOOSE executable
INPUT_FILE = "Main.i"                 # MOOSE input file
CB_VALUES = [1e5,1e6,1e7,1e8,1e9]  # <-- define your Cb list here



power_data = []
for cb in CB_VALUES:
    data = np.loadtxt("data/%s_Main_out.csv"%cb, skiprows=1, delimiter=",")
    data = data.T
    power_data = data[12]*1e-6
    plt.plot(data[0], power_data, label = "battery size= %s"%cb)

data = np.loadtxt("data/100000.0_Main_out_Battery0_Turbine0.csv", skiprows=1, delimiter=",")
data = data.T
plt.plot(data[0], data[1]*1e-6, "--", label = "load")
plt.grid()
plt.legend()
plt.ylabel("Power (MW)")
plt.xlabel("Time (s)")
plt.show()

for cb in CB_VALUES:
    data = np.loadtxt("data/%s_Main_out.csv"%cb, skiprows=1, delimiter=",")
    data = data.T
    power_data = data[13]
    plt.plot(data[0], power_data, label = "battery size= %s"%cb)

plt.grid()
plt.legend()
plt.ylabel("reactivity (pcm)")
plt.xlabel("Time (s)")
plt.show()


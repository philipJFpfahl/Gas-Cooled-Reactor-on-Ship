import subprocess
import sys
from pathlib import Path
import os
# --- Configuration ---
MOOSE_APP = "/home/philip-pfahl/NTNU/MOOSE/Squirrel/squirrel-opt"          # path to your MOOSE executable
INPUT_FILE = "Main.i"                 # MOOSE input file
CB_VALUES = [1e4,1e5,1e6,1e7,1e8,1e9,1e10]  # <-- define your Cb list here
N_CORES = 4                           # MPI ranks (set to 1 for serial)
# ---------------------

def run_cb(cb):
    cb_str = str(cb)
    print(f"\n{'='*50}")
    print(f"  Running Cb = {cb_str}")
    print(f"{'='*50}")

    # Build the MOOSE command
    cmd = MOOSE_APP+" -i "+ INPUT_FILE+" -n--threads=4 " +" -w " + " MultiApps/Battery/cli_args='Postprocessors/Cb_battery/expression='%s' '"%cb
    print(cmd)
    print(f"{'='*50}")
    os.system(cmd)


    # Move all Main_out* files to {cb_str}_Main_out*
    os.system("mv Main_out.csv data/%s_Main_out.csv"%cb )
    os.system("mv Main_out_Battery0.csv data/%s_Main_out_Battery0.csv"%cb )
    os.system("mv Main_out_Battery0_Turbine0.csv data/%s_Main_out_Battery0_Turbine0.csv"%cb )
    return True


def main():
    for cb in CB_VALUES:
        run_cb(cb)


if __name__ == "__main__":
    main()

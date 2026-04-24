import pytest
import numpy as np
import matplotlib.pyplot as plt


def P(t, rho, beta, Lambda, lam):
    return rho / (rho - beta) * np.exp((rho - beta) * t / Lambda) - beta / (
        rho - beta
    ) * np.exp(-lam * rho * t / (rho - beta))

def step_func(t, state):
    return 10


rho = 10
beta = 600
Lambda = 1e-4
lam = 1
t = np.linspace(0, 10, 1000)
y = P(t, rho, beta, Lambda, lam)
moose = np.loadtxt("Main_out.csv", delimiter=",", skiprows=1)
moose = moose.T


plt.plot(t, y)
plt.plot(moose[0], moose[-1])
plt.xlabel("Time (s)")
plt.ylabel("Power (W)")
plt.show()

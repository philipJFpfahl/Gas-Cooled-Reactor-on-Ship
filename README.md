This is a simple model for the gas-cooled reactor. It is used to have a working system.
https://github.com/ijs-f8/Research-Reactor-Simulator
The model is taken from: 
[[Application of the Method of Manufactured Solutions to a Close-Coupled Gas-Cooled Reactor and Brayton Cycle Power System.pdf]]
and
[[Transient simulation of the USNC Pylon using a rapid multiphysics model.pdf]]

An extra battery model is added. 

TODO: 
- [x] Move all variables into Main.i for restart ✅ 2026-05-07
![[Pasted image 20260325142648.png]]

And the turbine side is simplified. 

![[Pasted image 20260325160529.png|682]]

# TODO


# Reactor
![[Pasted image 20260326094400.png]]

Total core power	15 MWth
Primary mass flow rate	30 kg/s
Primary circulation time = 10s
Core inlet temperature	890 K
Core outlet temperature	1190 K
The core volume is $7\times 10 ^6$ cm$³$.
Heat capacity core = $2.2 \times 10 ^7$ J/K
Control drum speed nominal = 50 pcm/s 
Control drum speed accident = 300 pcm/s 

Heat capacity of the Battery = $1 \times 10 ^9$ J/K  heat capacity of the battery (15 MWh run the turbine at full power for 1 hour with 50K temperature decrease)

## Reactor Dynamics


The reactor module takes 2 inputs. The controlled movement and the inlet temperature.
The power evolution of the reactor is modeled with the PKE:

$$
\frac{d P(t)}{dt} = \frac{\rho-\beta}{\Lambda} P(t) + \sum_i \lambda_i C_i
$$

With the corresponding DNP Groups:

$$
\frac{d C_i(t)}{dt} = \frac{\beta}{\Lambda} P(t) -  \lambda_i C_i 
$$

The reactivity is calculated from temperature feedback, Xenon feedback, and the drum configuration.
so that 

$$\rho = \rho_{cr}+\rho_{T}+\rho_{Xe} $$

with

$$
\rho_{T} = - \alpha (T(t)_{reactor}-T_{ref})
$$

With the reactor temperature $T(t)_{reactor} = (T(t)_{Rin}+T(t)_{Rout})/2$ and the reference temperature $T_{ref}$.

$$
\rho_{Xe} = - \alpha \frac{Xe \sigma^{Xe}_a}{\Sigma_a}
$$

- [ ] add control_rods
and the control rods being Sigmoidal:

$$
\rho_{cr} = 4000/(1+exp(-x10))-2000
$$

 with the steady state at the control rod position $x = 0$

- [ ] add Xenon
The Xenon concentration $Xe$ is calculated using the flux

$$
\Phi = \frac{P}{\Sigma_f Q_{fission}}
$$

and the usual:

$$
\frac{d I(t)}{dt} = \gamma_I \Sigma_f \Phi -\lambda_i I(t)
$$

$$
\frac{d Xe(t)}{dt} = \gamma_X \Sigma_f \Phi +\lambda_i I(t) - \lambda_x Xe(t)- \sigma_a^X \Phi Xe(t)
$$

| $\beta$ | $\beta_1$ | $\beta_2$ | $\beta_3$ | $\beta_4$ | $\beta_5$ | $\beta_6$ | $\Lambda$ |     |
| ------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --- |
| 670.1   | 23.44     | 121       | 115       | 258.8     | 107       | 44.86     | 0.000432  |     |


| $\lambda_1$ s$^{-1}$ | $\lambda_2$s$^{-1}$ | $\lambda_3$s$^{-1}$ | $\lambda_4$s$^{-1}$ | $\lambda_5$s$^{-1}$ | $\lambda_6$s$^{-1}$ | $\alpha$ pcm/K |
| -------------------- | ------------------- | ------------------- | ------------------- | ------------------- | ------------------- | -------------- |
| 0.01334              | 0.03273             | 0.1208              | 0.3029              | 0.8501              | 2.855               | -1.21          |


## Temperature balance 

The coolant is assumed to be in compressible. In a more advanced model, it should be adjusted.

The entire power of the reactor is assumed to be dumped into a graphite block, that then heats the colant gas. At some point, it might be interesting to model this at higher fidelity radiative cooling.


The change in reactor temperature is given by

$$
C_R \frac{d T_R}{dt} = Power-\dot Q_{colant}
$$
with the heat transported by the coolant beeing:
$$
\dot Q_{colant} = \dot m_R c_R (T_{Rout}-T_{Rin})
$$
In this model, the change in coolant temperature:

$$
T_{Rout} = T_R +(T_{Rin}-T_R) \exp\left[-\frac{A_{core}}{\dot m_R c_R}\right]
$$
with the specific heat capacity of the reactor coolant of $c_R$ and the reactor coolant mass flow rate $\dot m_R$.

Since we know the nominal power and we want to have a temperature rise of $55$ K the $c_R \dot m_R$ = 300000 J/Ks

# Battery

The battery is a thermal battery. The exact composition is unknown.
Scenarios like loss of battery fluid could be simulated in the future.

The change in temperature is given by

$$
C_B \frac{d T_B}{dt} = \dot Q_{in}-\dot Q_{out}
$$

With the heat capacity of the battery $C_B$

To run the ship at full power for 1h the battery needs to have 15MWh or $5.4 \times 10^{10}$ J.  
The operational $\Delta T$ is assumed to be 50K. The heat capacity is therefore $1.08 × 10^9$ J/K. Or just $1. × 10^9$

The heat flow into the battery is the difference of the in and outlet temperature (incopressible). So that 

$$
\dot Q_{in} = \dot m_R c_R (T_{Rout}-T_{Rin})
$$

And

$$
\dot Q_{out} = \dot m_T c_T (T_{Bout}-T_{Bin})
$$

with the specific heat capacity of the turbine working fluid of $c_T$ and the reactor coolant mass flow rate $\dot m_T$. 

Therefore the temperature change is:
$$
\frac{d T_B}{dt} = \frac{\dot Q_{in}-\dot Q_{out}}{C_b}= \frac{\dot m_R c_R (T_{Rout}-T_{Rin})-\dot m_T c_T (T_{Bout}-T_{Bin})}{C_b}
$$

With the NTU method, we estimate the heat transfer from the gas to the battery. 

$$
T_{Rin} = T_B +(T_{Rout}-T_B) \exp\left[-\frac{A_R}{\dot m_R c_R}\right]
$$

In the same way, we calculate the outlet temperature on the Turbine side.

$$
T_{Bout} = T_B +(T_{Bin}-T_B) \exp\left[-\frac{A_T}{\dot m_T c_T}\right]
$$

# Turbine
Since this is so simple it is included in the battery module.
- [x] add turbine ✅ 2026-04-29
 For a given power demand $W$ we calculate an outlet temperature:

 
 $$
 T_{out } = T_{in} -\frac{W}{\dot m c_p \epsilon}
$$

- [ ] Todo add flexible $\epsilon$
we can calculate $\epsilon$ with the Carnot efficiency:

$$
\epsilon = \eta \left (1-\frac{T_c}{T_h} \right )
$$
Where the hot temperature comes form the battery and the cold temperature is some fixed value.
### Old Turbine
the Isentropic outlet temperature for ideal gases:
$$
Tout,s= T_{\text{in}} \left( \frac{P_{\text{out}}}{P_{\text{in}}} \right)^{\frac{\gamma-1}{\gamma}} = T_{\text{in}} \zeta
$$
with ratio of specific heats $\gamma$.
Actual:
$$
T_{\text{out}}​=T_{\text{in}}​−\eta(T_{\text{in}}​−T_{\text{out,s}}​) = T_{\text{in}}​−\eta(T_{\text{in}}​−T_{\text{in}} * \zeta) = T_{\text{in}}(1-\eta(1-\zeta))
$$
$$
= T_{\text{in}}(1-\epsilon) , \text{with}\space  \space \epsilon = \eta(1-\zeta)=\eta(1-\left( \frac{P_{\text{out}}}{P_{\text{in}}} \right)^{\frac{\gamma-1}{\gamma}})
$$
Power: 
$$
\dot{W} = \dot{m} c_p (T_{\text{in}} - T_{\text{out}})=  \dot{m} c_p (T_{\text{in}} -  T_{\text{in}}(1-\epsilon)) = \dot{m} c_p T_{\text{in}} (1 - 1-\epsilon) = \dot{m} c_p T_{\text{in}} \epsilon
$$
Since we want a more or less constant in and outlet temperature we will adjust the MFR according to:
$$
\dot{m} c_p =  \frac{\dot{W}}{(T_{\text{in}} - T_{\text{out}})}=\frac{\dot W}{T_{\text{in}} \epsilon}
$$

With 
$$
\frac{P_{out}}{P_{in}} = 2000
$$
and 
$$
\gamma = 1.2 (Co2 @ 1000)
$$
the Isentropic ratio between the outlet and inlet temperature is then 
$$
\zeta = 0.281727
$$
with an  isentropic efficiency of  ​$\eta=0.8$. $\epsilon = 0.502$ Or just 50%
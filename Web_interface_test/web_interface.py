import time
import requests
import streamlit as st
import matplotlib.pyplot as plt

BASE_URL = "http://127.0.0.1:6000"

st.set_page_config(page_title="MOOSE Power Monitor", layout="centered")
st.title("MOOSE Reactor Power Monitor")

# Session state
if "initialized" not in st.session_state:
    st.session_state.initialized = False
if "power_history" not in st.session_state:
    st.session_state.power_history = []
if "step" not in st.session_state:
    st.session_state.step = 0


def wait_until_waiting():
    while True:
        r = requests.get(f"{BASE_URL}/waiting")

        # 400 = control not initialized yet → keep waiting
        if r.status_code == 400:
            time.sleep(0.2)
            continue

        r.raise_for_status()
        data = r.json()

        if data.get("waiting", False):
            return data.get("execute_on_flag")

        time.sleep(0.2)


def initialize():
    print("Initializing WebServerControl…")
    payload = {
        "host": "127.0.0.1",
        "user": "streamlit",
        "name": "streamlit-client"
    }
    r = requests.post(
        f"{BASE_URL}/initialize",
        json=payload
    )
    r.raise_for_status()
    st.session_state.initialized = True


def get_power():
    r = requests.post(
        f"{BASE_URL}/get/postprocessor",
        json={"name": "power"}
    )
    r.raise_for_status()
    return r.json()["value"]


def continue_execution():
    r = requests.get(f"{BASE_URL}/continue")
    r.raise_for_status()


def set_rho_insertion(value):
    r = requests.post(
        f"{BASE_URL}/set/controllable",
        json={
            "name": "Postprocessor/rho_insertion/value",
            "type": "Real",
            "value": float(value)
        }
    )
    r.raise_for_status()
# --- UI ---

if not st.session_state.initialized:
    st.info("Waiting for MOOSE and initializing control…")
    initialize()
    st.success("WebServerControl initialized")

st.markdown("---")

if st.button("Advance one step"):
    with st.spinner("Advancing simulation…"):
        wait_until_waiting()
        power = get_power()
        st.session_state.power_history.append(power)
        st.session_state.step += 1
        continue_execution()

if st.session_state.power_history:
    fig, ax = plt.subplots()
    ax.plot(st.session_state.power_history, marker="o")
    ax.set_xlabel("Step")
    ax.set_ylabel("Power")
    ax.set_title("Reactor Power")
    st.pyplot(fig)

st.caption(f"Steps executed: {st.session_state.step}")

st.markdown("### Reactivity control")

rho_value = st.slider(
    "ρ insertion",
    min_value=-100.0,
    max_value=100.0,
    value=0.0,
    step=1.0,
)

if st.button("Apply ρ insertion"):
    with st.spinner("Applying reactivity insertion…"):
        wait_until_waiting()
        set_rho_insertion(rho_value)
    st.success(f"ρ insertion set to {rho_value:.4f}")

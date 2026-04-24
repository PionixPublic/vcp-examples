# Pionix Virtual Charger Park (VCP) Examples

[![Visit PIONIX VCP](https://img.shields.io/badge/Visit-PIONIX%20VCP-blue?style=for-the-badge&logo=google-cloud)](https://www.pionix.com/products/virtual-charger-park)
[![EVerest Documentation](https://img.shields.io/badge/EVerest-Documentation-green?style=for-the-badge&logo=github)](https://everest.github.io)

This repository contains practical examples and automation tools for the **Pionix Virtual Charger Park (VCP)**. VCP allows you to spin up massive virtual charger fleets running the full **EVerest** stack in the cloud, enabling realistic **OCPP load testing** and **CSMS validation** without physical hardware.

## 🚀 Quick Start: Run in Google Colab

The fastest way to experiment with the VCP API is via our interactive notebooks:

-   **Load Test Example** [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/PionixPublic/vcp-examples/blob/main/notebooks/01-asynchronous-load-test-example.ipynb)
    Learn how to use `aiohttp` to simultaneously authorize, plug in, and start charging on multiple VCP instances.
-   **Configuration Generator** [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/PionixPublic/vcp-examples/blob/main/notebooks/02-vcp-configuration-generator.ipynb)
    Programmatically generate CSV templates for bulk-creating a diverse fleet of virtual chargers.

---

## 🛠️ Local Development

For running examples locally or developing your own tools:

### 1. Environment Setup
- **Nix (Recommended)**: Run `nix develop` for a reproducible shell.
- **VS Code**: Open in **DevContainers** for a fully pre-configured environment (Python, Docker, ngrok).

### 2. Local CSMS (SteVe)
To connect the Virtual Charger Park to a local backend:
1.  `git submodule update --init --recursive`
2.  `./start-steve.sh` (Exposes SteVe via **ngrok**)
3.  Configure your VCP dashboard using the provided ngrok URL.

---

## 📖 Key Concepts
-   **VCP**: A cloud-based fleet of virtual chargers running the open-source **EVerest** stack.
-   **VCP API**: The interface at `vcp.pionix.com` used to simulate physical interactions (plugging in, swiping RFIDs).

## 📂 Project Structure
-   `notebooks/`: Load testing and configuration examples.
-   `steve/`: **SteVe** OCPP Central System submodule.
-   `start-steve.sh`: Automation script to start SteVe and expose it via ngrok.

---

## 🔍 About EV Charging Simulation & Load Testing

**Pionix Virtual Charger Park (VCP)** is a professional-grade **EV charging station simulator** designed for high-scale **OCPP load testing** and **CSMS software validation**. By utilizing the **EVerest open-source charging stack**, VCP provides a 1:1 digital twin of real-world charging behavior in a cloud-native environment.

### Why use VCP for your EV charging project?
- **OCPP Compliance**: Test your Central System against **OCPP 1.6** and **OCPP 2.0.1** scenarios.
- **Asynchronous Load Testing**: Simulate hundreds of concurrent charging sessions.
- **EVerest Integration**: Experience the industry-standard charging stack used in commercial hardware.
- **Hardware-in-the-Loop (HIL) Alternative**: Reduce costs by validating software logic in a virtual park before deploying to physical test rigs.

For more information on how to optimize your EV charging infrastructure, visit the [PIONIX Official Website](https://www.pionix.com/products/virtual-charger-park).

# Pionix Virtual Charger Park (VCP) Examples

This repository contains examples and tools for working with the **Pionix Virtual Charger Park (VCP)**. VCP is a powerful platform for spinning up virtual charger infrastructure running the full **EVerest** stack in the cloud, allowing for realistic testing of CSMS (Charging Station Management Systems) without physical hardware.

## 🚀 Overview

The examples in this repo demonstrate how to:
1.  **Deploy a local CSMS**: Using the **SteVe** submodule and exposing it via **ngrok**.
2.  **Run Load Tests**: Using Python and `asyncio` to simulate complex charging scenarios across a large fleet of virtual chargers.

## 🛠️ Project Structure

-   `steve/`: A submodule containing the **SteVe** OCPP Central System.
-   `notebooks/`: Jupyter notebooks with asynchronous load testing examples.
-   `start-steve.sh`: A helper script to start SteVe via Docker Compose and expose it via ngrok.
-   `flake.nix`: Nix flake for a reproducible development environment.

## 🏁 Getting Started

### 1. Development Environment
This project supports two ways to set up the development environment:

#### Option A: Nix (Recommended)
If you have Nix installed with flakes enabled, simply run:
```bash
nix develop
```

#### Option B: VS Code DevContainers
If you prefer Docker, you can open this project in [VS Code DevContainers](https://code.visualstudio.com/docs/devcontainers/containers). This will automatically set up:
- Python 3.12 with all dependencies.
- Docker-in-Docker support (to run SteVe).
- ngrok pre-installed.
- Recommended VS Code extensions (Jupyter, Python, Docker).

---

### 2. Setting up the CSMS (SteVe)
To connect the Virtual Charger Park to a local backend, you can use the included SteVe setup.

1.  Initialize the submodule:
    ```bash
    git submodule update --init --recursive
    ```
2.  Start SteVe:
    ```bash
    ./start-steve.sh
    ```
    The script will check for dependencies, start Docker Compose, and provide you with a public **ngrok URL**.

3.  Configure VCP: Use the ngrok URL as the **Central System URL** in your VCP dashboard.

### 3. Running Examples
The notebooks in the `notebooks/` directory provide code for managing a park of virtual chargers.

-   **[01-asynchronous-load-test-example.ipynb](notebooks/01-asynchronous-load-test-example.ipynb)** [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/PionixPublic/vcp-examples/blob/main/notebooks/01-asynchronous-load-test-example.ipynb): Demonstrates how to use `aiohttp` to simultaneously authorize, plug in, and start charging on multiple VCP instances.
-   **[02-vcp-configuration-generator.ipynb](notebooks/02-vcp-configuration-generator.ipynb)** [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/PionixPublic/vcp-examples/blob/main/notebooks/02-vcp-configuration-generator.ipynb): Shows how to programmatically generate CSV configuration templates for bulk-creating a diverse fleet of virtual chargers.

## 📖 Key Concepts

-   **Virtual Charger Park (VCP)**: A collection of virtual chargers representing a real-world site.
-   **VCP API**: The cloud API (at `vcp.pionix.com`) used to interact with the chargers (simulating plug-in, RFID swipes, etc.).
-   **EVerest**: The open-source charging stack running inside each virtual charger.

## 🔗 Resources

-   [Pionix Official Website](https://pionix.com)
-   [EVerest Project](https://everest.github.io)

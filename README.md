# ASIO Custom Debian Repository

This repository provides custom packages, including both **open-source (main)** and **proprietary (closed-source)** applications, for Debian-based systems (like Debian, Ubuntu, and Raspberry Pi OS).

## Installation

To securely add the ASIO repository to your system, run the following single command in your terminal. This script will automatically download the necessary GPG key and configure your APT sources.

### Single-Line Installation Command

```bash
curl -faSl https://raw.githubusercontent.com/CyberHuman-bot/asio-install/refs/heads/main/install.sh | sudo bash

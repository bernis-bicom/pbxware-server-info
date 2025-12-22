# pbxware-server-tools

A collection of lightweight shell scripts designed for diagnosing and monitoring **PBXware** servers. These tools help administrators quickly assess telephony status, disk health, and system performance either locally or remotely.

## Tools Overview

### 1. `server_info` (Remote Diagnostics)
A wrapper script that connects to a PBXware server via SSH and runs comprehensive diagnostics.

*   **Usage**: `./server_info <ip_address>`
*   **Default Port**: 2020 (Standard for PBXware SSH)
*   **Requirements**: SSH access to the target server.

### 2. `server_info.sh` (Local Diagnostics)
The core diagnostic script intended to be run directly on the PBXware host.

*   **Usage**: `bash server_info.sh`
*   **Requirements**: Root or sufficient privileges to run Asterisk commands and access `/opt` directories.

---

## Key Features

### 📞 Telephony Status
- **PJSIP Endpoints**: Detailed listing of device states.
- **Breakdown**: Automatic categorization of Online vs. Offline Extensions.
- **Trunk Monitoring**: detection of active trunks and outbound registrations.

### 💾 Storage & Disk Health
- **Folder Analysis**: Tracks sizes of critical directories:
    - `/opt/pbxware/`
    - `/opt/backup/`
    - Monitor & Voicemail spools
    - MySQL database folders
- **Large File Hunting**: Automatically identifies the **Top 10 largest files** in `/opt/pbxware` (skipping virtual filesystems like `/proc`) to help clear disk space quickly.
- **Capacity**: Standard `df -h` integration.

### 🌐 Network & System
- **NAT Detection**: compares local IPs against public IP (via `ip.bernis.dev`) to determine if the server is behind a firewall/NAT.
- **Memory**: Reports memory usage in GB.
- **Crontab**: Lists root crontab entries for scheduled task verification.

---

## Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/pbxware-server-tools.git
   cd pbxware-server-tools
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x server_info server_info.sh
   ```

## Prerequisites
- `bash` (Version 4.0+)
- `curl` (Required for Public IP detection)
- `asterisk` (PBXware environment)

---

## License
MIT (or your preferred license)

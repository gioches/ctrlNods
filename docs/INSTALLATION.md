# ctrlNods Installation Guide

## Prerequisites

- Bash 4.0+
- SQLite3
- Network tools (ping, nmap, netstat)
- Cassandra nodetool access
- Root privileges for tmpfs setup

## Quick Installation

```bash
# 1. Clone repository
git clone https://github.com/gioches/ctrlNods.git
cd ctrlNods

# 2. Run installation script (when available)
sudo ./install.sh

# 3. Configure monitoring settings
sudo nano /opt/ctrlNods/config/monitoring.conf

# 4. Start monitoring service
sudo systemctl start ctrlnods
sudo systemctl enable ctrlnods

# 5. Verify installation
./bin/status-check.sh
```

## Manual Installation

Complete installation procedures will be provided with the script release.

## Integration with ctrlClus

To enable web-based cluster visualization, install [ctrlClus Dashboard](https://github.com/gioches/ctrlClus):

```bash
# On your web server
git clone https://github.com/gioches/ctrlClus.git
cd ctrlClus
# Follow ctrlClus installation guide
```

## Support

- 📖 [Main Documentation](../README.md)
- 🔗 [ctrlClus Web Dashboard](https://github.com/gioches/ctrlClus)
- 🐛 [Report Issues](https://github.com/gioches/ctrlNods/issues)
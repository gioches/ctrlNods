# Setup Scripts

This directory contains initialization and maintenance scripts for ctrlNods monitoring agents.

## Scripts (to be added)

- `00_POSTreboot.sh` - RAM disk initialization and system recovery
- `01_updatefs.sh` - Log rotation and filesystem maintenance
- `02_syncDB.sh` - Central database synchronization

## Installation

Scripts will be added in future updates. Each script includes:
- Comprehensive error handling
- Logging integration
- Configuration validation
- Service restart capabilities

## Usage

```bash
# After installation, setup scripts are typically run as:
sudo ./setup/00_POSTreboot.sh
./setup/01_updatefs.sh
./setup/02_syncDB.sh
```

**Note**: Complete scripts will be available in the next release.
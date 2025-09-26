# Core Components

This directory contains the main application logic and operational scripts for ctrlNods monitoring agents.

## Core Scripts

### Application Logic
- **`M_chk.sh`** - Main monitoring coordinator that orchestrates checks across all monitored nodes
- **`M_config.sh`** - Configuration management and environment setup
- **`M_control.sh`** - Core monitoring logic with SQLite database integration and state management
- **`M_lib_schedule.sh`** - Scheduling library for monitoring intervals
- **`M_config_plugin.sh`** - Plugin configuration management

### Setup & Deployment
- **`00_POSTreboot.sh`** - Post-reboot initialization and RAM disk setup
- **`200_setup.sh`** - Complete system setup and configuration (10KB+ comprehensive script)
- **`210_mkconfig.sh`** - Dynamic configuration file generation
- **`250_deploy.sh`** - Deployment automation and file distribution

### Data Export & Synchronization
- **`500_exp.sh`** - Data export functionality
- **`500_expnuovi.sh`** - Enhanced export for new data formats
- **`520_send.sh`** - Data transmission to central servers
- **`550_updatefs.sh`** - Filesystem maintenance and updates

### Specialized Monitoring
- **`cassandra_disk_monitor.sh`** - Dedicated Cassandra disk I/O monitoring (10KB+ advanced script)

## Architecture

The core components provide:
- **Real-time monitoring coordination** across multiple nodes via `M_chk.sh`
- **SQLite database integration** for local data storage in `/opt/ramdisk/log/data.sqlite`
- **State change tracking** with parent-child event correlation
- **RAM disk operations** for high-performance monitoring data
- **Automated deployment** and configuration management
- **Data synchronization** to central monitoring systems

## Key Features

- **Node-to-node monitoring** - Monitors other cluster nodes via IP arrays
- **Service state correlation** - Tracks state changes and durations
- **Performance threshold monitoring** - Configurable alerts based on metrics
- **Enterprise deployment** - Production-ready with comprehensive error handling
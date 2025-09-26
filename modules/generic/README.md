# Generic System Monitoring Modules

This directory contains system-level monitoring scripts that work across different platforms and services.

## Available Monitoring Scripts

### **`S_DISK.sh`** - Disk I/O Performance Monitoring
**Purpose**: Measures disk write performance using 100MB test files
**Implementation**:
- Creates 100MB test files using `dd` command
- Measures write time in milliseconds using high-precision timestamps
- **Threshold**: Alerts if write time exceeds 1300ms (1.3 seconds)
- **Integration**: Uses RAM disk configuration from `/opt/ramdisk/M_config.sh`
- **Output**: Performance metrics stored via `M_control.sh` state engine

### **`S_PING.sh`** - Network Connectivity Monitoring
**Purpose**: Tests network reachability between cluster nodes
**Implementation**:
- Monitors connectivity to configured destination IPs from `DEST_IP` array
- Integrated with main monitoring loop in `M_chk.sh`
- **State tracking**: Records UP/DOWN status changes with timestamps

### **`S_NMAP.sh`** - Service Port Monitoring
**Purpose**: Checks critical service port availability
**Implementation**:
- Monitors essential Cassandra ports (7001 SSL, 7199 JMX, 9042 CQL)
- **Integration**: Called from main coordinator `M_chk.sh`
- **State correlation**: Works with control engine for service availability tracking

## Architecture

Each module follows the ctrlNods framework:
- **Configuration sourcing**: `source /opt/ramdisk/M_config.sh`
- **Result processing**: `source /opt/ramdisk/M_control.sh`
- **State management**: Binary result (0=FAIL, 1=OK)
- **Message handling**: Separate OK/KO messages for different states
- **Performance focus**: Optimized for RAM disk operations

## Key Features

- **High-precision timing** - Nanosecond accuracy for performance measurements
- **Configurable thresholds** - Customizable alert levels per environment
- **State correlation** - Parent-child event tracking for duration analysis
- **Production hardened** - Handles edge cases and error conditions
- **Zero-dependency** - Uses only standard Linux tools (dd, ping, nmap)

## Integration Points

- **Main coordinator**: Called by `M_chk.sh` in monitoring loops
- **Configuration**: Inherits settings from global config
- **Database**: Results stored in SQLite via control engine
- **Alerting**: Integrates with central notification system
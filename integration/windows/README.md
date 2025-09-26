# Windows Integration for ctrlNods Data Transfer

This directory contains Windows-specific tools for transferring JSON monitoring data from ctrlNods agents to ctrlClus web dashboard when Linux nodes cannot access the internet directly.

## Transfer Architecture

ctrlNods provides **two alternative methods** for JSON data transfer:

### Method 1: Direct Internet Access (Linux)
**When nodes can navigate to internet:**
- Uses `520_send.sh` script on Linux nodes
- Direct HTTP POST to ctrlClus web server
- Automatic and seamless

### Method 2: Windows Bridge (No Internet Access)
**When nodes are isolated from internet:**
- Windows VM/machine acts as data bridge
- Uses PuTTY tools (plink, pscp) for SSH/SCP transfer
- **File**: `get_json.bat` (this directory)

## get_json.bat - Multi-Node Data Collector

### Purpose
Automated script to collect JSON data from multiple Cassandra nodes via SSH and prepare for ctrlClus upload.

### Key Features

**Multi-IP Processing**:
- Processes multiple nodes in sequence: `10.10.10.1` through `10.10.10.8`
- Configurable IP list for different cluster topologies
- Individual file naming: `data_1.json`, `data_2.json`, etc.

**Advanced Workflow**:
1. **Export Trigger**: Executes `/opt/ramdisk/500_exp.sh` on remote node via plink
2. **Data Transfer**: Downloads `/opt/ramdisk/exp/exp_tutto.json` via pscp
3. **Local Storage**: Saves to `C:\Users\user\Desktop\ctrlNods\DATAFILE\`
4. **Logging**: Comprehensive logs in `C:\Users\user\Desktop\ctrlNods\LOGS\`

### Configuration

```batch
REM Update these variables for your environment
set LINUX_USER=user
set PASSWORD=password
set REMOTE_FILE=/opt/ramdisk/exp/exp_tutto.json
set BASE_LOCAL_FOLDER=C:\Users\user\Desktop\ctrlNods\DATAFILE
set LOG_FOLDER=C:\Users\user\Desktop\ctrlNods\LOGS
set IP_LIST=10.10.10.1 10.10.10.2 10.10.10.3 10.10.10.4 10.10.10.5 10.10.10.6 10.10.10.7 10.10.10.8
```

### Prerequisites

**PuTTY Tools Required**:
- `plink.exe` - SSH client for command execution
- `pscp.exe` - SCP client for file transfer
- Location: `C:\Users\user\Desktop\ctrlNods\`

**Directory Structure**:
```
C:\Users\user\Desktop\ctrlNods\
├── get_json.bat          # This script
├── plink.exe             # SSH client
├── pscp.exe              # SCP client
├── DATAFILE\             # Downloaded JSON files
│   ├── data_1.json
│   ├── data_2.json
│   └── ...
└── LOGS\                 # Transfer logs
    ├── plink_1_timestamp.log
    ├── pscp_1_timestamp.log
    └── ...
```

### Execution Process

**Per-Node Workflow**:
1. **SSH Connection**: Tests connectivity and accepts host keys
2. **Export Execution**: Runs `500_exp.sh` to generate fresh JSON export
3. **File Transfer**: Downloads exported JSON via SCP
4. **Validation**: Checks file size and logs results
5. **Timestamping**: All operations timestamped for audit trail

**Error Handling**:
- Individual node failures don't stop processing
- Detailed logging for troubleshooting
- File size validation ensures transfer integrity

## Integration with ctrlClus

After collecting data with `get_json.bat`, files can be uploaded to ctrlClus:

**Option 1: Manual Upload**
- Access ctrlClus web interface
- Use upload form with authentication token

**Option 2: Automated Upload** (add to script)
```batch
REM Upload to ctrlClus after successful transfer
curl -X POST -F "token=YOUR_TOKEN" -F "files[]=@%LOCAL_FILE%" http://your-ctrlclus-server/upload_FILE.php
```

## Production Usage

**NEXI Payment Systems (2022)**:
- Used in isolated payment processing environment
- Bridges air-gapped Cassandra nodes to monitoring infrastructure
- Processes 8-node cluster data collection

**PosteItaliane (2025)**:
- Deployed in secure postal service infrastructure
- Handles multi-datacenter data aggregation
- Supports regulated environment compliance

## Security Considerations

- SSH credentials in script (consider key-based auth)
- Network segmentation compliance
- Audit logging for compliance requirements
- File integrity validation
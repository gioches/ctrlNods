# Binary Components & Database Schema

This directory contains essential binaries and database schema for ctrlNods monitoring operations.

## Required Binaries

**System Monitoring Tools:**
- **`dd`** (54KB) - High-performance disk I/O testing utility
- **`ping`** (34KB) - Network connectivity testing
- **`nmap`** (3.1MB) - Service port monitoring and availability checks

**SQLite Database Components:**
- **`sqlite3`** (1.2MB) - Main SQLite database engine
- **`sqlite3_analyzer`** (2.5MB) - Database analysis and optimization tool
- **`sqldiff`** (636KB) - Database comparison and diff utility

## Database Schema

### Core Monitoring Table: `monitor`

```sql
CREATE TABLE monitor (
    id INTEGER PRIMARY KEY,     -- Unique event identifier
    sync INTEGER,               -- Synchronization flag (0=pending, 1=synced)
    cluster INTEGER,            -- Cluster identifier
    now DATETIME,               -- Event timestamp
    service TEXT,               -- Service name (DISK, PING, NMAP, HINTS, etc.)
    FROM_IP TEXT,               -- Source node IP address
    FROM_MC TEXT,               -- Source node machine identifier
    TO_IP TEXT,                 -- Target node IP (for connectivity checks)
    TO_MC TEXT,                 -- Target node machine identifier
    state INTEGER,              -- Service state (0=FAIL, 1=OK)
    message TEXT,               -- Detailed message or metric value
    idpadre INTEGER,            -- Parent event ID for correlation
    durata INTEGER              -- Event duration in minutes
);
```

### Performance Indexes

```sql
CREATE INDEX indice_now ON monitor (now);   -- Time-based queries
CREATE INDEX indice_sync ON monitor (sync); -- Synchronization status
```

## Database Architecture

**Location**: `/opt/ramdisk/log/data.sqlite`

**Key Features**:
- **State correlation**: `idpadre` field links related events
- **Duration tracking**: Calculates time between state changes
- **Sync management**: Tracks which events need central synchronization
- **Multi-service support**: Handles all monitoring modules uniformly

**Event Flow**:
1. **State detection** - Monitoring scripts detect service state changes
2. **Parent lookup** - System finds previous opposite state via `idpadre` correlation
3. **Duration calculation** - Calculates time difference between state changes
4. **Local storage** - Event stored in tmpfs SQLite database
5. **Sync flagging** - Marked for central database synchronization

## tmpfs Resilience Design

**Critical Design Feature**: All operations occur in `/opt/ramdisk` (tmpfs)

### Disk Freeze Protection

**Problem Solved**: Traditional monitoring systems fail when disk I/O freezes occur
**Solution**: Complete RAM-based operation

**Architecture Benefits**:
- ✅ **Monitoring continues** even during disk freeze events
- ✅ **Database writes** never blocked by disk I/O issues
- ✅ **Service detection** remains operational during storage failures
- ✅ **State correlation** functions independently of disk health

**Implementation Details**:
```bash
# All scripts source configuration from RAM
source /opt/ramdisk/M_config.sh

# Database operations use RAM-based SQLite
/opt/ramdisk/bin/sqlite3 /opt/ramdisk/log/data.sqlite

# Even binaries executed from RAM disk
$dir_bin/dd if=/dev/zero of=/opt/ctrlNods/testfile_100MB
```

### Recovery & Synchronization

**Data Persistence Strategy**:
- **During normal operation**: Periodic sync to central MongoDB
- **After disk recovery**: Automatic catch-up synchronization
- **Critical events**: Priority sync for immediate alerting

**Enterprise Reliability**:
- **Zero monitoring gaps** during infrastructure issues
- **Continuous alerting** capability during disk failures
- **Production validated** in NEXI and PosteItaliane environments
# Cassandra-Specific Monitoring Modules

This directory contains specialized monitoring scripts designed specifically for Apache Cassandra database clusters.

## Available Cassandra Monitoring Scripts

### **`S_HINTS.sh`** - Hints File Monitoring & Analysis
**Purpose**: Monitors Cassandra hints accumulation for cluster health assessment

**Advanced Implementation** (1.7KB production script):
- **Directory scanning**: Monitors `/var/lib/cassandra/hints` for hints files
- **Pattern matching**: Extracts timestamps from hints file names using regex `hints-*-[0-9]{13}-*.db`
- **Timestamp validation**: Validates 13-digit millisecond timestamps
- **File analysis**: Counts hints files and tracks creation times
- **State correlation**: Integrates with ctrlNods state engine

**Key Features**:
- **File enumeration**: Automatic detection of all hints files
- **Timestamp extraction**: Precise parsing of millisecond timestamps from filenames
- **Data aggregation**: Collects dates, keyspace information, and file counts
- **Error handling**: Validates timestamp format and handles malformed filenames
- **Production hardened**: Designed for continuous operation in enterprise environments

**Technical Details**:
```bash
# File pattern detection
HINTS_FILES=("$HINTS_DIR"/hints-*)

# Timestamp extraction with validation
TIMESTAMP=$(echo "$FILE" | sed -E 's/.*-([0-9]{13})-.*\.db/\1/')
if [[ ! "$TIMESTAMP" =~ ^[0-9]{13}$ ]]; then
    echo "Errore: Il file $FILE non contiene un timestamp valido."
    continue
fi
```

**Integration Points**:
- **Configuration**: Uses global ctrlNods configuration framework
- **State management**: Reports results through `M_control.sh`
- **Alert system**: Triggers notifications based on hints accumulation thresholds
- **Database logging**: Results stored in local SQLite database

## Architecture

Cassandra modules follow enterprise monitoring patterns:
- **Service identification**: Each script defines unique `SERVICE` identifier
- **State reporting**: Binary result system (0=CRITICAL, 1=OK)
- **Message system**: Separate OK/KO messages for different scenarios
- **Production logging**: Detailed execution traces for debugging

## Enterprise Validation

**Production Environments**:
- **NEXI Payment Systems** (2022+) - Financial transaction processing infrastructure
- **PosteItaliane** (2025+) - National postal service database monitoring
- **24/7 Operation** - Continuous monitoring in mission-critical systems

**Key Capabilities**:
- **Zero-downtime monitoring** - Non-intrusive hints file analysis
- **Regex-based parsing** - Robust filename pattern matching
- **Error resilience** - Handles corrupted or malformed hints files
- **Performance optimized** - Minimal system impact during monitoring

## Future Expansion

The architecture supports additional Cassandra monitoring modules:
- Query performance analysis
- Thread pool monitoring
- Cluster state tracking
- Memory and GC analysis
- Large partition detection

**Current Status**: Production-ready hints monitoring with enterprise validation
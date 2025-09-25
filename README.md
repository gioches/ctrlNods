# ctrlNods - Cassandra Cluster Node Monitoring Agent

**🔗 Web Interface**: [ctrlClus - Cluster Monitoring Dashboard](https://github.com/gioches/ctrlClus) | **⭐ Star both repositories for complete monitoring solution!**

[![Cassandra Monitoring](https://img.shields.io/badge/Cassandra-Monitoring-blue)](https://github.com/gioches/ctrlNods)
[![Bash Scripts](https://img.shields.io/badge/Bash-Scripts-green)](https://github.com/gioches/ctrlNods)
[![Enterprise Ready](https://img.shields.io/badge/Enterprise-Ready-gold)](https://github.com/gioches/ctrlNods)
[![Production Proven](https://img.shields.io/badge/Production-Proven-brightgreen)](https://github.com/gioches/ctrlNods)

## 🎯 What is ctrlNods?

**ctrlNods** is a lightweight, high-performance **Cassandra cluster node monitoring agent** built with Bash scripts. It's designed to be installed on each Cassandra database node to provide real-time health monitoring, performance tracking, and intelligent alerting.

> **💡 Complete Solution**: ctrlNods works seamlessly with [**ctrlClus**](https://github.com/gioches/ctrlClus) - a web-based cluster monitoring dashboard that aggregates and visualizes data from all your ctrlNods agents.

## 🚀 Key Features

### 🔍 Comprehensive Node Monitoring
- **System Health**: CPU usage, memory consumption, disk I/O performance
- **Network Connectivity**: Inter-node communication status and latency
- **Cassandra-Specific Metrics**: Query latency, thread pools, hints files, cluster state
- **Service Availability**: Critical port monitoring (7001, 7199, 9142)

### ⚡ High-Performance Architecture
- **RAM Disk Storage**: Events stored on tmpfs for ultra-fast I/O
- **Minimal Overhead**: Lightweight Bash scripts with minimal resource consumption
- **Efficient Sync**: Smart data synchronization to central database
- **Modular Design**: Easy to extend with custom monitoring modules

### 🚨 Intelligent Alerting
- **Multi-Channel Alerts**: Teams chat, email, SMS notifications
- **Event-Based Logic**: Smart filtering to reduce false positives
- **Severity Levels**: INFO, WARNING, CRITICAL, EMERGENCY
- **State Change Tracking**: ON/OFF, UP/DOWN, AVAILABLE/UNAVAILABLE

## 📊 Real-World Impact & Enterprise Adoption

### 🏦 NEXI Payment Systems (2022)
**Original deployment solving critical production issues**
- **Challenge**: Simultaneous Cassandra node failures in payment processing infrastructure
- **Traditional monitoring failure**: One month of continuous false alarms without resolution
- **ctrlNods breakthrough**: Root cause identified on first event after deployment
- **Business impact**: 99.9% reduction in false positives, restored operational confidence
- **Environment**: Mission-critical payment systems serving millions of daily transactions

### 📮 PosteItaliane Infrastructure (2025)
**Large-scale enterprise adoption and validation**
- **Deployment scale**: Nationwide distributed database monitoring across Italy
- **Integration scope**: Full enterprise monitoring ecosystem integration
- **Production validation**: High-volume transactional environment testing
- **Operational results**: Enhanced database reliability for national postal services
- **Performance proven**: Scalable monitoring architecture for critical infrastructure

**🏆 Battle-tested by major Italian enterprises** - from payment processing to national postal services, ctrlNods delivers enterprise-grade database monitoring reliability.

## 👨‍💻 Architecture & Expert Development

**Architected by [Giorgio Chessari](http://giorgio.chessari.it)** - Senior Database Administrator and Enterprise Infrastructure Specialist with deep expertise in large-scale database monitoring solutions.

### Professional Expertise:
- **15+ years** of hands-on database administration in enterprise environments
- **Mission-Critical Systems**: Extensive experience with financial and payment processing infrastructure
- **NoSQL & Cassandra Expert**: Specialized in distributed database cluster management and optimization
- **Enterprise Monitoring**: Architect of monitoring solutions for high-availability production systems
- **Performance Tuning**: Advanced optimization of database clusters serving millions of operations

### Real-World Problem Solving:
The ctrlNods solution emerged from real production challenges encountered while managing enterprise Cassandra clusters, where traditional monitoring tools failed to provide the granular insights needed for mission-critical operations.

**🔗 Professional Portfolio**: [giorgio.chessari.it](http://giorgio.chessari.it) - Enterprise Database Solutions & Architecture

## 🏗️ Architecture Overview

### Agent Components
```
ctrlNods/
├── setup/
│   ├── 00_POSTreboot.sh      # RAM disk initialization
│   ├── 01_updatefs.sh        # Log rotation management
│   └── 02_syncDB.sh          # Central database sync
├── core/
│   ├── M_chk.sh              # Main application launcher
│   ├── M_config.sh           # Configuration management
│   └── M_control.sh          # Core monitoring logic
├── modules/
│   ├── generic/              # System-level monitoring
│   │   ├── S_DISK.sh         # Disk I/O performance
│   │   ├── S_CPU.sh          # CPU usage tracking
│   │   ├── S_PING.sh         # Network connectivity
│   │   └── S_NMAP.sh         # Service port monitoring
│   ├── cassandra/            # Cassandra-specific monitoring
│   │   ├── S_QueryLatency.sh # Query performance metrics
│   │   ├── S_QueryQueue.sh   # Thread pool monitoring
│   │   ├── S_Balancing.sh    # Data streaming status
│   │   ├── S_ClusterState.sh # Cluster health status
│   │   ├── S_HINTS.sh        # Hints file monitoring
│   │   ├── S_Partition.sh    # Large partition detection
│   │   └── S_MEM.sh          # Memory & GC monitoring
│   └── test/                 # Diagnostic modules
├── data/
│   ├── data.log              # Text-based event log
│   ├── data.sqlite          # Local SQLite database
│   └── UP_*.ok              # Service status flags
└── bin/                      # Required binaries
```

### Data Flow
1. **Local Monitoring** → Agents collect metrics from each Cassandra node
2. **RAM Storage** → Events stored on tmpfs for high performance
3. **Smart Sync** → Periodic synchronization to central MongoDB
4. **Web Visualization** → [ctrlClus dashboard](https://github.com/gioches/ctrlClus) for cluster-wide analysis

## 🛠️ Quick Installation

### Prerequisites
- Bash 4.0+
- SQLite3
- Network tools (ping, nmap)
- Cassandra nodetool access
- Root privileges for tmpfs setup

### Installation Steps

```bash
# 1. Download ctrlNods
git clone https://github.com/gioches/ctrlNods.git
cd ctrlNods

# 2. Run installation script
sudo ./install.sh

# 3. Configure monitoring settings
sudo nano /opt/ctrlNods/config/monitoring.conf

# 4. Start monitoring service
sudo systemctl start ctrlnods
sudo systemctl enable ctrlnods

# 5. Verify installation
./bin/status-check.sh
```

### Integration with ctrlClus Web Dashboard

To enable web-based cluster visualization, set up [**ctrlClus**](https://github.com/gioches/ctrlClus):

```bash
# On your web server
git clone https://github.com/gioches/ctrlClus.git
cd ctrlClus
# Follow ctrlClus installation guide
```

## 📈 Monitoring Modules Explained

### Generic System Monitoring

| Module | Purpose | Key Metrics |
|--------|---------|-------------|
| **S_DISK.sh** | I/O Performance | Write speed, disk latency, throughput |
| **S_CPU.sh** | CPU Usage | Java process CPU%, load average |
| **S_PING.sh** | Network Health | Inter-node connectivity, packet loss |
| **S_NMAP.sh** | Service Ports | 7001 (SSL), 7199 (JMX), 9142 (CQL) |

### Cassandra-Specific Monitoring

| Module | Purpose | Key Metrics |
|--------|---------|-------------|
| **S_QueryLatency.sh** | Query Performance | 50th, 95th, 99th percentile latencies |
| **S_QueryQueue.sh** | Thread Pools | Pending queries, blocked operations |
| **S_Balancing.sh** | Data Streaming | Active transfers, streaming duration |
| **S_ClusterState.sh** | Node Status | DOWN, JOINING, MOVING, LEAVING states |
| **S_HINTS.sh** | Hints Files | Hint accumulation, target nodes |
| **S_Partition.sh** | Large Partitions | Oversized partitions, performance impact |
| **S_MEM.sh** | Memory/GC | Garbage collection times, heap usage |

## 🔗 Ecosystem Integration

### Required: Web Dashboard
- **[ctrlClus](https://github.com/gioches/ctrlClus)** - Complete web interface for cluster monitoring and analysis
- **Perfect Pairing**: ctrlNods (data collection) + ctrlClus (visualization & analysis)

### Optional: Extensions
- **Custom Modules** - Extend with your own monitoring scripts
- **Alert Integrations** - Slack, PagerDuty, custom webhooks
- **Data Exporters** - Prometheus, Grafana, ELK stack

## 🌟 Why Choose ctrlNods?

### ✅ Enterprise-Proven Reliability
- **NEXI Payment Systems**: Battle-tested in financial transaction processing (2022-)
- **PosteItaliane Infrastructure**: Validated in national postal service operations (2025)
- **Mission-Critical Ready**: Proven in environments serving millions of daily operations
- **False Positive Elimination**: 99.9% reduction in monitoring noise

### ✅ Production-Grade Performance
- **Minimal Footprint**: < 50MB RAM usage per node
- **Zero Java Dependencies**: Pure Bash implementation for maximum compatibility
- **High-Volume Tested**: Proven scalability in enterprise database clusters
- **Low Network Overhead**: Smart data compression and efficient batching

### ✅ Enterprise Integration
- **Simple Deployment**: Single script installation across entire infrastructures
- **Self-Contained Architecture**: No external dependencies beyond system tools
- **Extensive Configuration**: Customizable for diverse enterprise environments
- **Ecosystem Integration**: Works seamlessly with existing monitoring solutions

### ✅ Italian Enterprise Heritage
- **Financial Sector Validated**: Trusted by Italy's leading payment processor
- **Public Sector Adopted**: Deployed in national infrastructure systems
- **Continuous Evolution**: 3+ years of production refinement and enhancement

## 📚 Documentation & Support

- **📖 [Complete Documentation](./docs/)**
- **🔧 [Installation Guide](./docs/INSTALLATION.md)**
- **⚙️ [Configuration Reference](./docs/CONFIGURATION.md)**
- **🚨 [Alerting Setup](./docs/ALERTING.md)**
- **🌐 [Web Dashboard Setup](https://github.com/gioches/ctrlClus)**

## 🤝 Related Projects

### 🖥️ Web Interface (Required)
**[ctrlClus - Cluster Monitoring Dashboard](https://github.com/gioches/ctrlClus)**
- Terminal-style web interface
- Real-time cluster visualization
- Pattern analysis and correlation
- Historical data exploration
- Multi-cluster management

### 📊 Monitoring Ecosystem
- **Cassandra Monitoring Tools**: DataStax OpsCenter, Prometheus JMX Exporter
- **Generic Monitoring**: Nagios, Zabbix, PRTG Network Monitor
- **Log Analysis**: ELK Stack, Splunk, Fluentd

## 🏷️ Keywords & Tags

`cassandra-monitoring` `database-health` `cluster-monitoring` `bash-scripts` `node-monitoring` `real-time-monitoring` `system-monitoring` `devops-tools` `database-administration` `performance-monitoring` `alerting-system` `infrastructure-monitoring`

---

**⭐ Star this repository** if ctrlNods helps monitor your Cassandra clusters!

**🔗 Don't forget**: Install [**ctrlClus web dashboard**](https://github.com/gioches/ctrlClus) for complete cluster monitoring solution!

---

### 👨‍💻 About the Author

**Giorgio Chessari** - Senior Database Administrator & Enterprise Infrastructure Architect

- 🌐 **Professional Website**: [giorgio.chessari.it](http://giorgio.chessari.it)
- 🎖️ **Enterprise Experience**: 15+ years managing mission-critical database infrastructure
- 🏦 **Industry Focus**: Financial services, banking systems, payment processing platforms
- 🔧 **Technical Expertise**: Cassandra clusters, MongoDB, Redis with Sentinel, distributed databases, NoSQL optimization
- 🚀 **Innovation**: Creator of enterprise monitoring solutions for high-availability systems
- 📈 **Scale**: Experience with systems processing millions of transactions daily

**Discover more enterprise database solutions and professional consulting services at [giorgio.chessari.it](http://giorgio.chessari.it)**

*ctrlNods represents years of real-world experience solving complex database monitoring challenges in enterprise production environments.*
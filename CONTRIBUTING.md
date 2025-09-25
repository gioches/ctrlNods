# Contributing to ctrlNods

We welcome contributions to ctrlNods monitoring agents! This project powers critical infrastructure monitoring in production environments, so we appreciate careful, well-tested contributions.

## 🚀 Quick Start

1. **⭐ Star the repository** if you find it useful
2. **🍴 Fork the repository** to your GitHub account
3. **📝 Create an issue** to discuss your ideas before coding
4. **🔧 Submit pull requests** with your improvements

## 🎯 Areas for Contribution

### 🔧 Core Scripts (Coming Soon)
- Bash monitoring modules for Cassandra
- System health checks
- Alert system integrations
- Performance optimizations

### 📊 Monitoring Modules
- New Cassandra metrics
- Additional database support
- Custom alert logic
- Integration with other tools

### 📚 Documentation
- Installation guides for different distributions
- Configuration examples
- Troubleshooting guides
- Integration tutorials

## 🐛 Reporting Issues

Found a bug or have a feature request?

1. **Search existing issues** to avoid duplicates
2. **Provide detailed information**:
   - Operating system and distribution
   - Bash version
   - Cassandra version and configuration
   - Steps to reproduce
   - Log files and error messages

## 💡 Feature Requests

We're interested in ideas that enhance enterprise monitoring capabilities:

1. **Align with production requirements** - this runs on critical infrastructure
2. **Consider performance impact** - monitoring should be lightweight
3. **Think about scalability** - deployments can be hundreds of nodes
4. **Provide real-world use cases**

## 🔧 Development Setup

```bash
# 1. Fork and clone
git clone https://github.com/YOUR-USERNAME/ctrlNods.git
cd ctrlNods

# 2. Review the architecture
# - setup/ - Initialization scripts
# - core/ - Main application logic
# - modules/ - Monitoring components
# - docs/ - Documentation

# 3. Set up test environment
# Install Cassandra for testing
# Set up MongoDB for data storage (see ctrlClus setup)
```

## 📋 Pull Request Process

1. **Create a feature branch**: `git checkout -b feature/monitoring-improvement`
2. **Follow bash best practices**:
   - Use proper error handling
   - Include comprehensive logging
   - Test on multiple distributions
   - Document configuration options
3. **Test thoroughly** in development environment
4. **Update documentation**
5. **Submit PR** with detailed description

## 🏢 Enterprise Production Requirements

This monitoring system is battle-tested in:
- **NEXI Payment Systems** (2022+) - Financial transaction processing
- **PosteItaliane** (2025+) - National postal infrastructure

**Critical Requirements:**
- **Zero downtime deployment**
- **Minimal resource usage** (< 50MB RAM per node)
- **Reliable alerting** (99.9% accuracy)
- **Enterprise security** (no credential exposure)
- **24/7 operation** capability

## 🧪 Testing Guidelines

- **Unit tests** for individual modules
- **Integration tests** with Cassandra
- **Performance tests** for resource usage
- **Stress tests** for high-load scenarios
- **Security tests** for credential handling

## 🔗 Integration with ctrlClus

Remember that ctrlNods works with the [ctrlClus web dashboard](https://github.com/gioches/ctrlClus):
- Data format compatibility
- Upload mechanism consistency
- Authentication token management

## 📞 Getting Help

- 💬 **GitHub Discussions** for architecture questions
- 🐛 **GitHub Issues** for bugs and features
- 🌐 **Professional consulting** at [giorgio.chessari.it](http://giorgio.chessari.it)
- 📖 **Documentation** in `/docs/` directory

## 🏆 Recognition

Contributors will be:
- Added to project contributors
- Mentioned in release notes
- Credited in documentation
- Potentially invited to enterprise deployments feedback

## ⏳ Roadmap

**Phase 1** (Current): Documentation and structure
**Phase 2** (Next): Complete Bash monitoring scripts
**Phase 3** (Future): Additional database support, cloud integrations

**Your contributions help power mission-critical infrastructure!** 🚀
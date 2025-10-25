# VeighNa Tech Stack & Architecture Guide

## 📋 Overview

**VeighNa** is a Python-based quantitative trading platform designed for professional traders. It provides a comprehensive framework for developing, backtesting, and deploying trading strategies across multiple asset classes.

**Version:** 4.1.0  
**License:** MIT  
**Python Support:** 3.10, 3.11, 3.12, 3.13

---

## 🏗️ Architecture

VeighNa follows a **modular, event-driven architecture** with three main layers:

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer (Frontend)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Desktop UI  │  │   Web UI     │  │  No UI Mode  │  │
│  │  (PySide6)   │  │ (WebTrader)  │  │  (Headless)  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                  Core Engine Layer                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ MainEngine   │  │ EventEngine  │  │  OmsEngine   │  │
│  │ (Orchestr.)  │  │ (Pub/Sub)    │  │ (Order Mgmt) │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│              Gateway & App Layer (Backend)               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Gateways    │  │  Strategy    │  │  Data Mgmt   │  │
│  │  (Brokers)   │  │  Engines     │  │  (Database)  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Core Components

1. **MainEngine** (`vnpy.trader.engine.MainEngine`)
   - Central orchestrator for the entire platform
   - Manages gateways, engines, and apps
   - Coordinates data flow between components

2. **EventEngine** (`vnpy.event.EventEngine`)
   - Event-driven message bus using publish-subscribe pattern
   - Handles real-time data distribution (ticks, orders, trades, positions)
   - Decouples components for scalability

3. **OmsEngine** (Order Management System)
   - Manages orders, positions, accounts, and contracts
   - Provides data caching and retrieval
   - Handles order routing and execution

---

## 🛠️ Tech Stack

### Frontend Technologies

#### 1. **Desktop UI (Primary Interface)**
- **Framework:** PySide6 6.8.2.1 (Qt for Python)
- **Charts:** pyqtgraph 0.13.7+
- **Theme:** qdarkstyle 3.2.3+
- **Type:** Native desktop application (cross-platform)

**How to Launch:**
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
```

**Access:** 
- Runs as a **local desktop application** (not web-based)
- Opens a native window on your display
- No URL/port - it's a GUI application like any desktop software

**Features:**
- Real-time market data monitoring
- Order placement and management
- Position and account tracking
- Strategy management interface
- Chart visualization
- Multi-monitor support

#### 2. **Web UI (Optional - WebTrader Module)**
- **Module:** `vnpy_webtrader` (separate package)
- **Backend:** REST API + WebSocket
- **Type:** Browser-based interface

**Installation:**
```bash
pip install vnpy_webtrader
```

**Configuration:**
- Default REST API Port: Configurable (typically 8080 or 8888)
- Default WebSocket Port: Configurable (typically 8081 or 8889)
- Access URL: `http://localhost:<port>` (after starting the server)

**Note:** WebTrader is a separate module that needs to be installed and configured. It's not included in the base installation.

#### 3. **No UI Mode (Headless)**
- **Type:** Background service/daemon
- **Use Case:** Production deployments, automated trading
- **Example:** `/home/kiyansh/project/vnpy/examples/no_ui/run.py`

**How to Run:**
```bash
cd /home/kiyansh/project/vnpy/examples/no_ui
python3 run.py
```

---

### Backend Technologies

#### Core Framework
```toml
Python >= 3.10
├── Event System
│   └── vnpy.event (Custom event engine)
├── Data Processing
│   ├── numpy >= 2.2.3
│   ├── pandas >= 2.2.3
│   └── polars >= 1.26.0 (for AI module)
├── Technical Analysis
│   └── ta-lib >= 0.6.4 (C library + Python wrapper)
├── Networking
│   ├── pyzmq >= 26.3.0 (ZeroMQ for RPC)
│   └── REST/WebSocket (in gateway implementations)
└── Visualization
    └── plotly >= 6.0.0
```

#### Database Support
VeighNa supports multiple database backends for storing historical data:

- **SQLite** (default, no setup required)
- **MySQL**
- **PostgreSQL**
- **MongoDB**
- **InfluxDB** (for time-series data)

**Configuration:** Edit `~/.vnpy/vt_setting.json`

#### AI/ML Stack (vnpy.alpha module)
```python
# Machine Learning
├── scikit-learn >= 1.6.1
├── lightgbm >= 4.6.0
├── torch >= 2.6.0 (PyTorch)
├── scipy >= 1.15.2
└── alphalens-reloaded >= 0.4.5

# Data Processing
├── polars >= 1.26.0
└── pyarrow >= 19.0.1
```

---

## 🔌 Gateway Architecture (Broker Connections)

Gateways are adapter modules that connect VeighNa to various brokers and exchanges:

```python
# Example: CTP Gateway (Chinese Futures)
from vnpy_ctp import CtpGateway

main_engine.add_gateway(CtpGateway)

# Connect to broker
ctp_setting = {
    "用户名": "your_username",
    "密码": "your_password",
    "经纪商代码": "broker_code",
    "交易服务器": "tcp://server:port",
    "行情服务器": "tcp://server:port",
}
main_engine.connect(ctp_setting, "CTP")
```

### Available Gateways

**Domestic Markets (China):**
- CTP, Mini, SOPT (Futures & Options)
- XTP, TORA, HFT (Stocks & ETF Options)
- And 20+ more...

**International Markets:**
- Interactive Brokers (Global)
- Esunny 9.0 (Global Futures)
- Direct Futures

**Data Providers:**
- RQData (Real-time market data)
- XtQuant (Multi-market data)

---

## 📦 Application Modules (Apps)

Apps are plug-in modules that provide specific trading functionality:

### Strategy Engines
1. **CTA Strategy** (`vnpy_ctastrategy`)
   - Commodity Trading Advisor strategies
   - Trend following, mean reversion
   - Fine-grained order control

2. **Portfolio Strategy** (`vnpy_portfoliostrategy`)
   - Multi-asset strategies
   - Alpha strategies, statistical arbitrage
   - Backtesting support

3. **Spread Trading** (`vnpy_spreadtrading`)
   - Custom spread creation
   - Semi-auto and full-auto trading

4. **Option Master** (`vnpy_optionmaster`)
   - Option pricing models
   - Greeks calculation
   - Volatility surface

### Backtesting
- **CTA Backtester** (`vnpy_ctabacktester`)
- **Portfolio Backtester** (built into portfolio strategy)

### Utilities
- **Data Manager** (`vnpy_datamanager`) - Historical data management
- **Data Recorder** (`vnpy_datarecorder`) - Real-time data recording
- **Chart Wizard** (`vnpy_chartwizard`) - K-line charts
- **Algo Trading** (`vnpy_algotrading`) - TWAP, VWAP, Iceberg orders
- **Risk Manager** (`vnpy_riskmanager`) - Pre-trade risk controls
- **Paper Account** (`vnpy_paperaccount`) - Simulated trading

---

## 🌐 Distributed Architecture (RPC)

VeighNa supports distributed deployments using ZeroMQ:

```python
# Server Process
from vnpy.rpc import RpcServer

server = RpcServer()
server.start(
    rep_address="tcp://*:2014",  # Request-Reply port
    pub_address="tcp://*:4102"   # Publish-Subscribe port
)

# Client Process
from vnpy.rpc import RpcClient

client = RpcClient()
client.start(
    req_address="tcp://localhost:2014",
    sub_address="tcp://localhost:4102"
)
```

**Use Cases:**
- Separate UI and trading engine processes
- Multiple clients connecting to one trading server
- Load distribution across machines

---

## 🚀 How to Access the UI

### Option 1: Desktop UI (Recommended)

```bash
# Navigate to the trader example
cd /home/kiyansh/project/vnpy/examples/veighna_trader

# Run the application
python3 run.py
```

**What happens:**
- A native desktop window opens on your screen
- No browser, no URL, no port number
- Direct GUI application like Microsoft Word or Excel

**Login/Authentication:**
- VeighNa itself has **no login system**
- Authentication happens at the **gateway level** (broker credentials)
- Configure broker credentials in the "Connect" dialog within the UI

### Option 2: Web UI (Requires Additional Setup)

```bash
# Install web trader module
pip install vnpy_webtrader

# Configure and run (example)
# You'll need to create a custom run script
# that starts the WebTrader app
```

**Access:**
- Open browser: `http://localhost:<configured_port>`
- Default ports vary (check module documentation)

### Option 3: No UI (Programmatic)

```bash
cd /home/kiyansh/project/vnpy/examples/no_ui
python3 run.py
```

**Access:**
- No UI at all
- Runs as a background service
- Monitor via logs or custom monitoring tools

---

## 🔐 Authentication & Security

### No Built-in User Management
VeighNa is a **framework**, not a SaaS platform:
- No user accounts or login system in VeighNa itself
- Authentication is handled by your **broker/exchange**
- You provide broker credentials to connect gateways

### Broker Authentication Flow
```python
# Example: Connecting to a broker
gateway_setting = {
    "username": "your_broker_username",
    "password": "your_broker_password",
    "broker_id": "broker_code",
    "td_address": "tcp://trading.server:port",
    "md_address": "tcp://market.server:port",
}

# This connects to the broker's servers
main_engine.connect(gateway_setting, "GatewayName")
```

### Security Best Practices
1. **Store credentials securely** (use environment variables or encrypted config)
2. **Use VPN** when connecting to broker servers
3. **Enable risk management** module for pre-trade checks
4. **Run in isolated environment** (Docker, VM)
5. **Monitor logs** for suspicious activity

---

## 📊 Data Flow

```
Exchange/Broker
      ↓
   Gateway (vnpy_xxx)
      ↓
  EventEngine (Pub/Sub)
      ↓
  ┌─────────┬─────────┬─────────┐
  ↓         ↓         ↓         ↓
OmsEngine  UI    Strategy   DataRecorder
```

**Event Types:**
- `EVENT_TICK` - Market data updates
- `EVENT_ORDER` - Order status changes
- `EVENT_TRADE` - Trade executions
- `EVENT_POSITION` - Position updates
- `EVENT_ACCOUNT` - Account balance updates
- `EVENT_LOG` - System logs

---

## 🧪 Development Workflow

### 1. Strategy Development
```python
from vnpy_ctastrategy import CtaTemplate

class MyStrategy(CtaTemplate):
    def on_init(self):
        """Initialize strategy"""
        self.write_log("Strategy initialized")
    
    def on_start(self):
        """Start strategy"""
        self.write_log("Strategy started")
    
    def on_tick(self, tick):
        """Process tick data"""
        if tick.last_price > self.entry_price:
            self.buy(tick.last_price, 1)
```

### 2. Backtesting
```python
# Use Jupyter Notebook or GUI
from vnpy_ctabacktester import BacktestingEngine

engine = BacktestingEngine()
engine.set_parameters(...)
engine.add_strategy(MyStrategy, {})
engine.run_backtesting()
engine.show_chart()
```

### 3. Paper Trading
```python
# Test with simulated account
main_engine.add_app(PaperAccountApp)
```

### 4. Live Trading
```python
# Connect to real broker
main_engine.connect(real_broker_settings, "CTP")
```

---

## 📁 Project Structure

```
/home/kiyansh/project/vnpy/
├── vnpy/                      # Core framework
│   ├── trader/                # Trading engine
│   │   ├── engine.py          # MainEngine, OmsEngine
│   │   ├── gateway.py         # Gateway base class
│   │   ├── ui/                # Desktop UI components
│   │   └── database.py        # Database interfaces
│   ├── event/                 # Event engine
│   ├── rpc/                   # RPC client/server
│   ├── chart/                 # Charting components
│   └── alpha/                 # AI/ML module
├── examples/                  # Example scripts
│   ├── veighna_trader/        # Desktop UI launcher
│   ├── no_ui/                 # Headless mode
│   ├── cta_backtesting/       # Backtesting examples
│   └── alpha_research/        # ML research notebooks
├── docs/                      # Documentation
├── install.sh                 # Installation script
└── pyproject.toml             # Project configuration
```

---

## 🔧 Configuration Files

### Main Config: `~/.vnpy/vt_setting.json`
```json
{
    "font.family": "Arial",
    "font.size": 12,
    "log.active": true,
    "log.level": 20,
    "log.console": true,
    "log.file": true,
    "database.driver": "sqlite",
    "database.database": "database.db"
}
```

### Gateway Configs: `~/.vnpy/connect_xxx.json`
```json
{
    "用户名": "your_username",
    "密码": "your_password",
    "经纪商代码": "9999",
    "交易服务器": "tcp://180.168.146.187:10130",
    "行情服务器": "tcp://180.168.146.187:10131"
}
```

---

## 🎯 Quick Start Guide

### 1. Install VeighNa
```bash
cd /home/kiyansh/project/vnpy
bash install.sh python3.13
```

### 2. Install Gateway (Example: CTP)
```bash
pip install vnpy_ctp
```

### 3. Launch Desktop UI
```bash
cd examples/veighna_trader
python3 run.py
```

### 4. Configure Gateway
- Click "System" → "Connect" in the UI
- Select gateway (e.g., CTP)
- Enter broker credentials
- Click "Connect"

### 5. Start Trading
- View market data in "行情" (Quotes) panel
- Place orders in "交易" (Trading) panel
- Monitor positions in "持仓" (Positions) panel

---

## 📚 Additional Resources

- **Official Website:** https://www.vnpy.com
- **Documentation:** https://www.vnpy.com/docs
- **Forum:** https://www.vnpy.com/forum
- **GitHub:** https://github.com/vnpy/vnpy
- **Community:** WeChat groups (scan QR in README)

---

## 🆘 Common Questions

### Q: Where is the login page?
**A:** There is no login page. VeighNa is a desktop application framework, not a web service. Authentication happens when you connect to your broker.

### Q: What port does VeighNa run on?
**A:** The desktop UI doesn't use ports - it's a native application. Only the WebTrader module (optional) uses HTTP/WebSocket ports.

### Q: How do I access VeighNa remotely?
**A:** Use the RPC module to run the trading engine on a server and connect clients remotely, or use the WebTrader module for browser access.

### Q: Is there a demo account?
**A:** VeighNa doesn't provide demo accounts. Use the Paper Account module for local simulation, or contact your broker for demo credentials.

### Q: Can I run multiple strategies simultaneously?
**A:** Yes! Each strategy app (CTA, Portfolio, etc.) can run multiple strategy instances concurrently.

---

## 📝 Summary

**VeighNa is:**
- ✅ A Python trading framework (not a web app)
- ✅ Desktop-first with optional web interface
- ✅ Event-driven and modular architecture
- ✅ Broker-agnostic (supports 50+ gateways)
- ✅ Suitable for retail and institutional traders

**To access the UI:**
- Run `python3 examples/veighna_trader/run.py`
- A desktop window will open (no URL needed)
- Connect to your broker via the UI
- Start trading!

**Tech Stack Summary:**
- **Frontend:** PySide6 (Qt), pyqtgraph, qdarkstyle
- **Backend:** Python 3.10+, numpy, pandas, ta-lib
- **Database:** SQLite/MySQL/PostgreSQL/MongoDB
- **Networking:** ZeroMQ (RPC), REST/WebSocket (optional)
- **AI/ML:** scikit-learn, LightGBM, PyTorch

---

*Generated for VeighNa 4.1.0 - Last Updated: 2025*
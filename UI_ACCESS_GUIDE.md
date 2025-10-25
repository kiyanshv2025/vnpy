# VeighNa UI Access Guide

## 🎯 Quick Answer: How to Access VeighNa

**VeighNa is a DESKTOP APPLICATION, not a web service.**

```bash
# Just run this:
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py

# A window will open on your screen - no URL needed!
```

---

## 📊 Interface Comparison Table

| Feature | Desktop UI | Web UI | No UI |
|---------|-----------|--------|-------|
| **Type** | Native GUI | Browser-based | Headless |
| **Framework** | PySide6 (Qt) | REST + WebSocket | Python only |
| **Installation** | ✅ Included | ❌ Requires `vnpy_webtrader` | ✅ Included |
| **Access Method** | Run Python script | Open browser URL | Background process |
| **URL/Port** | ❌ None (desktop app) | ✅ http://localhost:port | ❌ None |
| **Login Page** | ❌ No login | ⚠️ Depends on setup | ❌ No login |
| **Remote Access** | ❌ Local only | ✅ Yes (via network) | ⚠️ Via RPC |
| **Performance** | ⭐⭐⭐⭐⭐ Fast | ⭐⭐⭐⭐ Good | ⭐⭐⭐⭐⭐ Fast |
| **Ease of Use** | ⭐⭐⭐⭐⭐ Easy | ⭐⭐⭐ Moderate | ⭐⭐ Advanced |
| **Best For** | Local trading | Remote access | Production bots |
| **Recommended** | ✅ Yes (default) | ⚠️ Special cases | ⚠️ Advanced users |

---

## 🖥️ Option 1: Desktop UI (Recommended)

### What It Is
A native desktop application that runs directly on your computer, similar to:
- Microsoft Word
- Excel
- Any desktop software

### How to Launch
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
```

### What Happens
1. Python starts the application
2. A window opens on your screen
3. You see the trading interface immediately
4. No browser, no URL, no port number

### Access Details
- **URL:** None (it's not a web app)
- **Port:** None (it's not a server)
- **Login:** None (authenticate at broker level)
- **Address:** N/A (runs locally)

### Screenshot Description
```
┌─────────────────────────────────────────────────────────────┐
│ VeighNa Trader 社区版 - 4.1.0        [_] [□] [X]            │
├──────────┬──────────────────────────────────────────────────┤
│ System ▼ │ Function ▼ │ Help ▼                              │
├──────────┴──────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌────────────────────────────────────┐   │
│  │  Trading    │  │  Market Data (行情)                 │   │
│  │  ─────────  │  │  ┌──────────────────────────────┐  │   │
│  │  Symbol:    │  │  │Symbol │Price │Vol │Time      │  │   │
│  │  [rb2505  ] │  │  │rb2505 │3450  │100 │14:30:25  │  │   │
│  │             │  │  │au2506 │520.5 │50  │14:30:26  │  │   │
│  │  Direction: │  │  └──────────────────────────────┘  │   │
│  │  ○ Long     │  │                                     │   │
│  │  ○ Short    │  │  Orders (委托)                      │   │
│  │             │  │  ┌──────────────────────────────┐  │   │
│  │  Price:     │  │  │OrderID│Symbol│Status        │  │   │
│  │  [3450    ] │  │  │       │      │              │  │   │
│  │             │  │  └──────────────────────────────┘  │   │
│  │  Volume:    │  │                                     │   │
│  │  [1       ] │  │  Trades (成交)                      │   │
│  │             │  │  ┌──────────────────────────────┐  │   │
│  │  [  Buy   ] │  │  │TradeID│Symbol│Price │Volume │  │   │
│  │  [  Sell  ] │  │  │       │      │      │       │  │   │
│  │             │  │  └──────────────────────────────┘  │   │
│  └─────────────┘  └────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Positions (持仓) │ Accounts (资金) │ Logs (日志)     │   │
│  │ ┌────────────────────────────────────────────────┐  │   │
│  │ │Symbol │Direction│Volume│AvgPrice│PnL         │  │   │
│  │ │rb2505 │Long     │1     │3450    │+150.00     │  │   │
│  │ └────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

### Pros & Cons
✅ **Pros:**
- Fast and responsive
- Full feature set
- No network latency
- Secure (local only)
- Easy to use

❌ **Cons:**
- Must be at your computer
- Can't access remotely
- Requires display/monitor

---

## 🌐 Option 2: Web UI (Optional)

### What It Is
A browser-based interface that runs as a web server, similar to:
- Gmail
- Trading platforms like TradingView
- Any web application

### How to Set Up
```bash
# 1. Install the web trader module
pip install vnpy_webtrader

# 2. Create a run script (example)
from vnpy.event import EventEngine
from vnpy.trader.engine import MainEngine
from vnpy_webtrader import WebTraderApp

event_engine = EventEngine()
main_engine = MainEngine(event_engine)

# Add gateways and configure...
main_engine.add_app(WebTraderApp)

# Start the web server
# (Configuration depends on module version)
```

### How to Access
```
http://localhost:8080  (or your configured port)
```

### Access Details
- **URL:** `http://localhost:<port>` or `http://<server-ip>:<port>`
- **Port:** Configurable (default: 8080 for HTTP, 8081 for WebSocket)
- **Login:** Depends on your configuration
- **Address:** Can be accessed from any device on the network

### Architecture
```
┌─────────────────┐
│  Your Browser   │
│  (Chrome/Edge)  │
└────────┬────────┘
         │ HTTP/WebSocket
         ↓
┌─────────────────┐
│  Web Server     │
│  (vnpy_webtrader)│
│  Port: 8080     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  MainEngine     │
│  EventEngine    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Gateway        │
│  (Broker)       │
└─────────────────┘
```

### Pros & Cons
✅ **Pros:**
- Access from anywhere
- Works on mobile devices
- Multiple users can connect
- No desktop software needed

❌ **Cons:**
- Requires extra setup
- Network latency
- Security considerations
- Not included by default

---

## 🤖 Option 3: No UI (Headless)

### What It Is
A background service with no interface, similar to:
- System daemons
- Cron jobs
- Background services

### How to Run
```bash
cd /home/kiyansh/project/vnpy/examples/no_ui
python3 run.py
```

### What Happens
1. Python starts the trading engine
2. No window opens
3. Runs in the background
4. Logs to file or console

### Access Details
- **URL:** None
- **Port:** None (unless you add RPC)
- **Login:** None
- **Interface:** None (monitor via logs)

### Monitoring
```bash
# View logs
tail -f ~/.vnpy/logs/vnpy.log

# Or use custom monitoring
# (You need to implement this yourself)
```

### Pros & Cons
✅ **Pros:**
- Minimal resource usage
- Runs on servers without GUI
- Perfect for automation
- Production-ready

❌ **Cons:**
- No visual interface
- Harder to debug
- Requires programming knowledge
- Not beginner-friendly

---

## 🔐 Authentication & Login

### Important: VeighNa Has NO Built-in Login System

VeighNa is a **framework**, not a SaaS platform. There is:
- ❌ No user registration
- ❌ No login page
- ❌ No password management
- ❌ No user accounts

### Where Authentication Happens

**At the Broker Level:**

```python
# Example: Connecting to CTP broker
gateway_setting = {
    "用户名": "your_broker_username",      # ← Broker credentials
    "密码": "your_broker_password",        # ← Broker credentials
    "经纪商代码": "9999",
    "交易服务器": "tcp://server:port",
    "行情服务器": "tcp://server:port",
}

# This authenticates with the BROKER, not VeighNa
main_engine.connect(gateway_setting, "CTP")
```

### Authentication Flow

```
┌──────────────┐
│  VeighNa UI  │  (No login required)
└──────┬───────┘
       │
       │ User clicks "Connect"
       ↓
┌──────────────┐
│   Gateway    │  (Sends credentials)
└──────┬───────┘
       │
       │ TCP/IP Connection
       ↓
┌──────────────┐
│ Broker Server│  (Validates credentials)
└──────┬───────┘
       │
       │ Success/Failure
       ↓
┌──────────────┐
│  VeighNa UI  │  (Shows connection status)
└──────────────┘
```

### If You Need User Management

If you're building a multi-user system, you need to implement it yourself:

**Option A: Add authentication to WebTrader**
```python
# Implement your own login system
# - User database (SQLite/PostgreSQL)
# - Session management
# - JWT tokens
# - Role-based access control
```

**Option B: Use reverse proxy**
```nginx
# nginx with basic auth
location / {
    auth_basic "VeighNa Access";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://localhost:8080;
}
```

**Option C: VPN/SSH tunnel**
```bash
# Secure access via SSH tunnel
ssh -L 8080:localhost:8080 user@server
```

---

## 🚀 Quick Start Commands

### Desktop UI (Easiest)
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
```

### Web UI (Advanced)
```bash
# Install module
pip install vnpy_webtrader

# Create custom run script
# (See vnpy_webtrader documentation)

# Access via browser
# http://localhost:8080
```

### No UI (Expert)
```bash
cd /home/kiyansh/project/vnpy/examples/no_ui
python3 run.py
```

---

## 🔧 Customizing the Desktop UI

### Modify the Run Script

Edit `/home/kiyansh/project/vnpy/examples/veighna_trader/run.py`:

```python
from vnpy.event import EventEngine
from vnpy.trader.engine import MainEngine
from vnpy.trader.ui import MainWindow, create_qapp

# Add your gateways
from vnpy_ctp import CtpGateway
from vnpy_ib import IbGateway  # Add more gateways

# Add your apps
from vnpy_ctastrategy import CtaStrategyApp
from vnpy_datamanager import DataManagerApp
# Add more apps...

def main():
    qapp = create_qapp()
    
    event_engine = EventEngine()
    main_engine = MainEngine(event_engine)
    
    # Add gateways
    main_engine.add_gateway(CtpGateway)
    main_engine.add_gateway(IbGateway)  # Add more
    
    # Add apps
    main_engine.add_app(CtaStrategyApp)
    main_engine.add_app(DataManagerApp)
    # Add more apps...
    
    # Create and show main window
    main_window = MainWindow(main_engine, event_engine)
    main_window.showMaximized()
    
    qapp.exec()

if __name__ == "__main__":
    main()
```

---

## 📊 Comparison: VeighNa vs Other Platforms

| Platform | Type | Access | Login | Best For |
|----------|------|--------|-------|----------|
| **VeighNa** | Desktop/Framework | Local GUI | No | Developers, Quants |
| **TradingView** | Web | Browser | Yes | Retail traders |
| **MetaTrader** | Desktop | Local GUI | Broker | Forex traders |
| **Interactive Brokers TWS** | Desktop | Local GUI | Yes | Professional traders |
| **QuantConnect** | Web | Browser | Yes | Cloud backtesting |
| **Zipline** | Framework | Code only | No | Python developers |

---

## 🆘 Troubleshooting

### "I can't find the login page"
**Answer:** There is no login page. VeighNa is a desktop application framework, not a web service.

### "What's the URL to access VeighNa?"
**Answer:** There is no URL for the desktop UI. Run `python3 run.py` and a window opens.

### "How do I access VeighNa from my phone?"
**Answer:** Install and configure the `vnpy_webtrader` module, then access via browser.

### "Where do I enter my username and password?"
**Answer:** In the UI, go to System → Connect, select your broker gateway, and enter credentials.

### "Can multiple people use VeighNa at the same time?"
**Answer:** 
- Desktop UI: One user per instance
- Web UI: Multiple users can connect to one server
- No UI: Use RPC for distributed access

---

## 📚 Additional Resources

### Documentation
- Full tech stack: `/home/kiyansh/project/vnpy/TECHSTACK_AND_ARCHITECTURE.md`
- Quick start: `/home/kiyansh/project/vnpy/QUICK_START.md`
- Official docs: https://www.vnpy.com/docs

### Examples
- Desktop UI: `/home/kiyansh/project/vnpy/examples/veighna_trader/`
- No UI: `/home/kiyansh/project/vnpy/examples/no_ui/`
- Backtesting: `/home/kiyansh/project/vnpy/examples/cta_backtesting/`

### Community
- Forum: https://www.vnpy.com/forum
- GitHub: https://github.com/vnpy/vnpy
- Issues: https://github.com/vnpy/vnpy/issues

---

## ✅ Summary

### To Access VeighNa:

**Desktop UI (Recommended):**
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
# A window opens - no URL needed!
```

**Web UI (Optional):**
```bash
pip install vnpy_webtrader
# Configure and run
# Access: http://localhost:8080
```

**No UI (Advanced):**
```bash
cd /home/kiyansh/project/vnpy/examples/no_ui
python3 run.py
# Runs in background
```

### Key Points:
1. ✅ VeighNa is primarily a **desktop application**
2. ✅ No built-in login system - authenticate at **broker level**
3. ✅ Web UI is **optional** and requires extra setup
4. ✅ Desktop UI has **no URL or port** - it's a native app
5. ✅ Perfect for **local trading** and **strategy development**

---

*Now you know exactly how to access VeighNa! 🎉*
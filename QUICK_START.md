# VeighNa Quick Start Guide

## 🎯 TL;DR - How to Access the UI

```bash
# 1. Navigate to the trader example
cd /home/kiyansh/project/vnpy/examples/veighna_trader

# 2. Run the application
python3 run.py

# 3. A desktop window will open automatically
# No browser, no URL, no port - it's a native GUI application!
```

---

## 🖥️ Understanding VeighNa's Interface Options

### Option 1: Desktop UI (Default & Recommended) ⭐

**What it is:**
- Native desktop application (like Microsoft Word or Excel)
- Built with PySide6 (Qt framework)
- Runs directly on your computer

**How to launch:**
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
```

**What you'll see:**
```
┌─────────────────────────────────────────────────────────┐
│ VeighNa Trader 社区版 - 4.1.0                            │
├─────────────┬───────────────────────────────────────────┤
│   Trading   │  Market Data (行情)                       │
│   Panel     │  ┌─────────────────────────────────────┐ │
│  ┌────────┐ │  │ Symbol  | Price  | Volume | Time   │ │
│  │ Symbol │ │  │ rb2505  | 3450   | 1000   | 10:30  │ │
│  │ Price  │ │  │ au2506  | 520.5  | 500    | 10:31  │ │
│  │ Volume │ │  └─────────────────────────────────────┘ │
│  │ [Buy]  │ │                                           │
│  │ [Sell] │ │  Orders (委托) | Active (活动)            │
│  └────────┘ │  ┌─────────────────────────────────────┐ │
│             │  │ Order ID | Symbol | Status          │ │
│             │  └─────────────────────────────────────┘ │
├─────────────┴───────────────────────────────────────────┤
│ Positions (持仓) | Accounts (资金) | Logs (日志)        │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Symbol | Direction | Volume | PnL                   │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

**No login required!** 
- VeighNa itself has no authentication
- You authenticate when connecting to your broker

---

### Option 2: Web UI (Optional - Requires Extra Setup)

**What it is:**
- Browser-based interface
- Requires installing `vnpy_webtrader` module
- Runs as a web server

**How to set up:**
```bash
# 1. Install the web trader module
pip install vnpy_webtrader

# 2. Create a run script (example)
# You'll need to configure the WebTrader app
# and specify ports (typically 8080 for HTTP, 8081 for WebSocket)

# 3. Access via browser
# http://localhost:8080 (or your configured port)
```

**When to use:**
- Need remote access via browser
- Running on a server without display
- Want to access from mobile devices

---

### Option 3: No UI (Headless Mode)

**What it is:**
- Background service with no interface
- For automated/production trading
- Monitor via logs

**How to run:**
```bash
cd /home/kiyansh/project/vnpy/examples/no_ui
python3 run.py
```

**When to use:**
- Production deployments
- Automated trading bots
- Server environments without GUI

---

## 🔌 Connecting to a Broker

### Step 1: Install Gateway Module

```bash
# Example: CTP (Chinese Futures)
pip install vnpy_ctp

# Example: Interactive Brokers (Global)
pip install vnpy_ib

# Example: XTP (Chinese Stocks)
pip install vnpy_xtp
```

### Step 2: Configure Gateway in UI

1. Launch VeighNa desktop UI
2. Click **"System"** → **"Connect"** in menu bar
3. Select your gateway (e.g., "CTP")
4. Fill in broker credentials:
   ```
   Username: your_broker_username
   Password: your_broker_password
   Broker ID: 9999 (example)
   Trading Server: tcp://180.168.146.187:10130
   Market Server: tcp://180.168.146.187:10131
   ```
5. Click **"Connect"**

### Step 3: Verify Connection

- Check **"Logs"** panel for connection status
- Market data should appear in **"Market Data"** panel
- Account info should appear in **"Accounts"** panel

---

## 📊 Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     YOUR COMPUTER                        │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         VeighNa Desktop Application             │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐     │    │
│  │  │   UI     │  │ Strategy │  │   Data   │     │    │
│  │  │ (PySide6)│  │  Engine  │  │ Recorder │     │    │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘     │    │
│  │       └─────────────┼─────────────┘            │    │
│  │                     ↓                           │    │
│  │            ┌────────────────┐                   │    │
│  │            │  MainEngine    │                   │    │
│  │            │  EventEngine   │                   │    │
│  │            └────────┬───────┘                   │    │
│  │                     ↓                           │    │
│  │            ┌────────────────┐                   │    │
│  │            │    Gateway     │                   │    │
│  │            │  (CTP/IB/XTP)  │                   │    │
│  │            └────────┬───────┘                   │    │
│  └─────────────────────┼────────────────────────────┘    │
│                        ↓                                 │
└────────────────────────┼─────────────────────────────────┘
                         ↓
              ┌──────────────────┐
              │  Internet/VPN    │
              └──────────┬───────┘
                         ↓
         ┌───────────────────────────────┐
         │   Broker/Exchange Servers     │
         │  (Trading & Market Data)      │
         └───────────────────────────────┘
```

---

## 🎓 Learning Path

### 1. **Beginner: Explore the UI**
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
```
- Familiarize yourself with the interface
- Explore different panels (Market, Orders, Positions)
- Try the demo mode (Paper Account)

### 2. **Intermediate: Connect to Broker**
- Install a gateway module
- Configure broker credentials
- Connect and view live market data
- Place test orders (small size!)

### 3. **Advanced: Develop Strategies**
```python
# Create a simple CTA strategy
from vnpy_ctastrategy import CtaTemplate

class MyStrategy(CtaTemplate):
    def on_tick(self, tick):
        # Your trading logic here
        pass
```

### 4. **Expert: Backtest & Optimize**
- Use Jupyter notebooks in `examples/cta_backtesting/`
- Backtest your strategies
- Optimize parameters
- Deploy to live trading

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

### Gateway Config: `~/.vnpy/connect_ctp.json`
```json
{
    "用户名": "your_username",
    "密码": "your_password",
    "经纪商代码": "9999",
    "交易服务器": "tcp://180.168.146.187:10130",
    "行情服务器": "tcp://180.168.146.187:10131",
    "产品名称": "",
    "授权编码": ""
}
```

**Location:** These files are created automatically in `~/.vnpy/` directory

---

## 🚨 Common Issues & Solutions

### Issue 1: "No module named 'vnpy'"
**Solution:**
```bash
cd /home/kiyansh/project/vnpy
pip install -e .
```

### Issue 2: "No module named 'vnpy_ctp'"
**Solution:**
```bash
pip install vnpy_ctp
```

### Issue 3: Desktop UI doesn't open
**Solution:**
```bash
# Check if PySide6 is installed
python3 -c "import PySide6; print(PySide6.__version__)"

# If not, install it
pip install PySide6==6.8.2.1
```

### Issue 4: "Cannot connect to broker"
**Solution:**
- Verify broker credentials
- Check network connection
- Ensure broker servers are accessible (may need VPN)
- Check broker server addresses are correct

### Issue 5: "Permission denied" when running
**Solution:**
```bash
# Make sure you have write permissions to ~/.vnpy/
mkdir -p ~/.vnpy
chmod 755 ~/.vnpy
```

---

## 📦 Essential Modules to Install

### Core (Already Installed)
```bash
pip install vnpy  # Core framework
```

### Gateways (Choose based on your broker)
```bash
# Chinese Futures
pip install vnpy_ctp

# Chinese Stocks
pip install vnpy_xtp

# Global Markets
pip install vnpy_ib

# Simulation/Testing
pip install vnpy_paperaccount
```

### Strategy Apps
```bash
# CTA Strategies
pip install vnpy_ctastrategy
pip install vnpy_ctabacktester

# Portfolio Strategies
pip install vnpy_portfoliostrategy

# Data Management
pip install vnpy_datamanager
pip install vnpy_datarecorder
```

### Utilities
```bash
# Charting
pip install vnpy_chartwizard

# Algorithmic Trading
pip install vnpy_algotrading

# Risk Management
pip install vnpy_riskmanager
```

---

## 🎯 Your First Trading Session

### Step-by-Step Guide

**1. Launch VeighNa**
```bash
cd /home/kiyansh/project/vnpy/examples/veighna_trader
python3 run.py
```

**2. Connect to Broker**
- Menu: System → Connect
- Select gateway (e.g., CTP)
- Enter credentials
- Click Connect

**3. Subscribe to Market Data**
- In "Trading" panel, enter symbol (e.g., "rb2505")
- Market data will appear in "Market Data" panel

**4. Place an Order**
- In "Trading" panel:
  - Symbol: rb2505
  - Direction: Buy/Sell
  - Price: 3450
  - Volume: 1
- Click "Buy" or "Sell"

**5. Monitor Execution**
- Check "Orders" panel for order status
- Check "Trades" panel for filled orders
- Check "Positions" panel for current positions

**6. Close Position**
- In "Trading" panel, select opposite direction
- Enter same volume
- Click to close

---

## 📚 Next Steps

### Learn More
1. Read full documentation: `/home/kiyansh/project/vnpy/TECHSTACK_AND_ARCHITECTURE.md`
2. Explore examples: `/home/kiyansh/project/vnpy/examples/`
3. Check official docs: https://www.vnpy.com/docs

### Join Community
- Official Forum: https://www.vnpy.com/forum
- GitHub Issues: https://github.com/vnpy/vnpy/issues
- WeChat Groups: Scan QR code in README.md

### Develop Strategies
1. Study example strategies in `examples/cta_backtesting/`
2. Read strategy development guide
3. Backtest your strategies
4. Paper trade before going live
5. Start with small positions

---

## ⚠️ Important Reminders

1. **VeighNa is a framework, not a broker**
   - You need a broker account to trade
   - VeighNa just connects to your broker

2. **No built-in authentication**
   - VeighNa doesn't have user accounts
   - Authentication is at the broker level

3. **Desktop-first design**
   - Primary interface is desktop GUI
   - Web interface is optional and requires extra setup

4. **Risk management is crucial**
   - Always use stop losses
   - Start with small positions
   - Test thoroughly before live trading
   - Use the Risk Manager module

5. **Keep credentials secure**
   - Don't commit credentials to git
   - Use environment variables
   - Encrypt sensitive config files

---

## 🎉 You're Ready!

You now know:
- ✅ How to launch VeighNa (desktop UI)
- ✅ How to connect to a broker
- ✅ How to place orders
- ✅ The architecture and tech stack
- ✅ Where to find help

**Start trading responsibly and good luck! 🚀**

---

*For detailed technical information, see: TECHSTACK_AND_ARCHITECTURE.md*
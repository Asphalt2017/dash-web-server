# Web Dashboard CLI Guide

## 🚀 Running the Dashboard

### Default Mode (Production)
```bash
python -m web-dashboard.app
# Starts on: http://0.0.0.0:8100 (debug: false)
```

### Development Mode
```bash
# Enable debug with hot reload
python -m web-dashboard.app --debug

# Custom port
python -m web-dashboard.app --debug --port 8050

# Custom host
python -m web-dashboard.app --host localhost --port 9000
```

### With YAML Configuration
```bash
# Use config file
python -m web-dashboard.app --setting config.yaml

# With overrides
python -m web-dashboard.app --setting config.yaml --debug --port 8200
```

### Using Environment Variables
```bash
# Set config file path
export DASH_SETTING=/path/to/config.yaml
python -m web-dashboard.app

# Set port
export DASH_PORT=9000
python -m web-dashboard.app

# Set debug mode
export DASH_DEBUG=true
python -m web-dashboard.app

# Inline
DASH_PORT=8100 DASH_DEBUG=true python -m web-dashboard.app
```

## 📋 Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--debug` | Enable debug mode with hot reload | `false` |
| `--no-debug` | Explicitly disable debug mode | - |
| `--port PORT` | Port to listen on | `8100` |
| `--host HOST` | Host to bind to | From settings |
| `--setting PATH` | Path to YAML config file | - |

## 🔄 Configuration Priority

Settings are loaded with the following priority (highest to lowest):

1. **Command line arguments** (`--debug`, `--port`, etc.)
2. **Environment variables** (`DASH_PORT`, `DASH_DEBUG`)
3. **YAML config file** (from `--setting` or `DASH_SETTING`)
4. **Default values** (in settings/dashboard.py)

### Example Priority Flow

```bash
# config.yaml has port: 8100, debug: false
# DASH_PORT=9000 is set
# --port 8200 is provided

python -m web-dashboard.app --setting config.yaml --port 8200

# Result: port=8200 (CLI wins)
```

## 📝 YAML Configuration Example

Create `config.yaml`:

```yaml
# Backend
backend_url: http://localhost:8000
api_version: v1

# Server
debug: false
host: 0.0.0.0
port: 8100

# Timeouts
health_check_timeout: 5.0
analyze_timeout: 30.0

# Image settings
max_image_size_mb: 10
supported_formats:
  - jpg
  - jpeg
  - png
  - webp

# App settings
enable_cors: true
log_level: INFO
```

Then run:
```bash
python -m web-dashboard.app --setting config.yaml
```

## 🐳 Docker Usage

The CLI arguments work in Docker too:

### Development
```bash
docker-compose run --rm \
  -p 8100:8100 \
  dashboard \
  python -m web-dashboard.app --debug --port 8100
```

### With Config File
```bash
docker-compose run --rm \
  -p 8100:8100 \
  -v $(pwd)/config.yaml:/app/config.yaml \
  dashboard \
  python -m web-dashboard.app --setting /app/config.yaml
```

## 🧪 Testing Different Configurations

### Scenario 1: Local Development
```bash
# Quick start with debug
python -m web-dashboard.app --debug --port 8050
```

### Scenario 2: Testing with Remote Backend
```yaml
# remote-backend.yaml
backend_url: https://api.example.com
debug: true
port: 8100
```

```bash
python -m web-dashboard.app --setting remote-backend.yaml
```

### Scenario 3: Production-like Testing
```bash
# No debug, production port
python -m web-dashboard.app --no-debug --port 8080
```

### Scenario 4: Environment Override
```bash
# Use staging backend via env var
export DASH_BACKEND_URL=https://staging-api.example.com
python -m web-dashboard.app --debug
```

## 📊 Startup Output

When you run the dashboard, you'll see:

```
============================================================
🏋️  Gym AI Helper - Web Dashboard
============================================================
Backend API:  http://localhost:8000
Host:         0.0.0.0
Port:         8100
Debug mode:   False
API endpoint: http://localhost:8000/api/v1/analyze
============================================================

✨ Dashboard starting at: http://0.0.0.0:8100
```

## 🔍 Troubleshooting

### Port Already in Use
```bash
# Try different port
python -m web-dashboard.app --port 8101
```

### Can't Find Module
```bash
# Make sure you're in project root
cd /path/to/gym_ai
python -m web-dashboard.app
```

### YAML File Not Found
```bash
# Use absolute path
python -m web-dashboard.app --setting /full/path/to/config.yaml

# Or relative from project root
python -m web-dashboard.app --setting web-dashboard/config.yaml
```

### Backend Connection Issues
```bash
# Override backend URL
python -m web-dashboard.app --setting <(echo "backend_url: http://localhost:8000")
```

## 💡 Development Workflow

### Daily Development
```bash
# Morning: Start with debug
python -m web-dashboard.app --debug --port 8050

# Code changes auto-reload (debug mode)
# Edit files in pages/, templates/, etc.

# Evening: Test production mode
python -m web-dashboard.app --no-debug
```

### Testing Multiple Backends
```bash
# Terminal 1: Local backend
python -m web-dashboard.app --debug --port 8050

# Terminal 2: Staging backend
DASH_BACKEND_URL=https://staging.api python -m web-dashboard.app --debug --port 8051

# Terminal 3: Production backend (view only)
DASH_BACKEND_URL=https://prod.api python -m web-dashboard.app --port 8052
```

## 🎯 Quick Reference

```bash
# Development (most common)
python -m web-dashboard.app --debug

# Production
python -m web-dashboard.app

# Custom config
python -m web-dashboard.app --setting config.yaml

# All options
python -m web-dashboard.app --debug --port 8100 --host 0.0.0.0 --setting config.yaml

# Help
python -m web-dashboard.app --help
```

## 🔗 Integration with Backend

Make sure backend is running first:

```bash
# Terminal 1: Start backend
cd backend
python -m app.main

# Terminal 2: Start dashboard
cd ..
python -m web-dashboard.app --debug
```

Or use the split services approach:

```bash
# Start services (postgres, redis, ollama)
./scripts/services.sh start

# Start backend
./scripts/dev.sh start

# Start dashboard separately
cd web-dashboard
python -m web-dashboard.app --debug --port 8100
```

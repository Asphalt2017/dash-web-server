# Web Dashboard Architecture

## 📊 Modular Structure

```
web-dashboard/
│
├── 📄 app.py                    # Entry point - App initialization
│   ├── Creates Dash app
│   ├── Loads layout from pages/
│   ├── Registers callbacks
│   └── Starts server
│
├── 🎨 assets/                   # Static assets (auto-loaded by Dash)
│   └── custom.css              # Custom styles, animations
│
├── 📱 pages/                    # Page layouts and interactions
│   ├── __init__.py
│   ├── main_page.py            # Main dashboard layout structure
│   └── callbacks.py            # Interactive callbacks (health, upload, analyze)
│
├── 🎭 templates/                # Reusable UI components
│   ├── __init__.py
│   ├── upload_card.py          # Image upload interface
│   ├── preview_card.py         # Image preview display
│   ├── results_card.py         # Analysis results card
│   └── health_status.py        # Backend health alerts
│
├── 🔧 tools/                    # Specialized functionality
│   ├── __init__.py
│   └── api_client.py           # Backend API communication
│       ├── check_backend_health()
│       └── analyze_image_api()
│
├── 🛠️  utils/                   # General utilities
│   ├── __init__.py
│   ├── config.py               # Configuration management
│   │   ├── BACKEND_URL
│   │   ├── API_ENDPOINT
│   │   └── Timeouts
│   └── image.py                # Image processing
│       ├── decode_base64_image()
│       └── validate_image()
│
└── 🌍 locales/                  # Internationalization
    ├── __init__.py
    └── en.py                   # English translations
        └── get_text()
```

## 🔄 Data Flow

```
User Action
    ↓
Dashboard (app.py)
    ↓
Callbacks (pages/callbacks.py)
    ↓
┌─────────────────┬─────────────────┐
│                 │                 │
Tools             Utils            Templates
(api_client.py)   (image.py)       (results_card.py)
│                 │                 │
└─────────────────┴─────────────────┘
    ↓
Backend API
    ↓
Response Processing
    ↓
UI Update (templates)
```

## 📦 Module Responsibilities

### **app.py** - Application Entry
- Initialize Dash app
- Load external stylesheets
- Set main layout
- Register all callbacks
- Start development server

### **pages/** - Page Structure
- **main_page.py**: Layout composition
  - Header, health status, upload/preview, results, footer
- **callbacks.py**: User interactions
  - Health check callback
  - Image upload preview callback
  - Analysis request callback

### **templates/** - UI Components
- **upload_card**: File upload interface with drag-drop
- **preview_card**: Image preview container
- **results_card**: Detailed analysis results display
- **health_status**: Dynamic health alerts

### **tools/** - Business Logic
- **api_client**: Backend communication
  - Health endpoint wrapper
  - Analysis endpoint wrapper
  - Error handling and timeouts

### **utils/** - Helper Functions
- **config**: Environment configuration
  - Backend URL management
  - Timeout settings
  - Debug mode handling
- **image**: Image utilities
  - Base64 decoding
  - Image validation
  - Size checks

### **locales/** - Translations
- **en.py**: English text strings
- Ready for additional languages
- Centralized text management

### **assets/** - Static Files
- **custom.css**: Styles, animations, responsive design
- Automatically loaded by Dash
- Theme customization

## 🎯 Benefits of Modular Architecture

### **Maintainability**
✅ Each module has single responsibility
✅ Easy to locate and fix bugs
✅ Clear file organization

### **Reusability**
✅ Components can be used across pages
✅ Utils shared across modules
✅ Templates reduce code duplication

### **Scalability**
✅ Easy to add new pages
✅ Simple to extend functionality
✅ Clean separation of concerns

### **Testing**
✅ Each module can be tested independently
✅ Mock dependencies easily
✅ Clear testing boundaries

### **Collaboration**
✅ Multiple developers can work simultaneously
✅ Reduced merge conflicts
✅ Clear ownership boundaries

## 🔌 Integration Points

### Backend API
```python
from tools.api_client import check_backend_health, analyze_image_api
```

### Configuration
```python
from utils.config import BACKEND_URL, API_ENDPOINT
```

### Image Processing
```python
from utils.image import decode_base64_image, validate_image
```

### UI Components
```python
from templates import create_upload_card, create_results_card
```

### Translations
```python
from locales import get_text
```

## 🚀 Quick Start

### Run Dashboard
```bash
python app.py
```

### Add New Component
```bash
# 1. Create template
echo 'def create_my_card(): ...' > templates/my_card.py

# 2. Import in page
# pages/main_page.py
from templates.my_card import create_my_card

# 3. Add to layout
layout = dbc.Container([
    create_my_card(),
    ...
])
```

### Add New API Endpoint
```bash
# 1. Add function in tools/api_client.py
def call_new_endpoint(data):
    response = httpx.post(NEW_ENDPOINT, json=data)
    return response.json()

# 2. Import in callback
from tools.api_client import call_new_endpoint

# 3. Use in callback
@app.callback(...)
def my_callback():
    result = call_new_endpoint(data)
    ...
```

## 📚 Code Examples

### Creating a New Page

```python
# pages/history_page.py
from dash import html
import dash_bootstrap_components as dbc

def create_history_layout():
    return dbc.Container([
        html.H2("Analysis History"),
        html.Div(id="history-content")
    ])
```

### Adding a Callback

```python
# pages/callbacks.py
@app.callback(
    Output("history-content", "children"),
    Input("load-history-btn", "n_clicks")
)
def load_history(n_clicks):
    if not n_clicks:
        return []
    
    # Fetch history from API
    from tools.api_client import get_history
    history = get_history()
    
    # Format results
    return create_history_table(history)
```

### Using Configuration

```python
# utils/config.py
import os

CUSTOM_TIMEOUT = int(os.getenv("CUSTOM_TIMEOUT", "60"))

def get_config():
    return {
        'timeout': CUSTOM_TIMEOUT,
        ...
    }
```

## 🔍 Debugging Tips

### Check Module Imports
```python
# Test imports
python -c "from pages.main_page import create_main_layout; print('OK')"
python -c "from tools.api_client import check_backend_health; print('OK')"
```

### Debug Callbacks
```python
# Enable debug mode
export DASH_DEBUG=true
python app.py
```

### Test Components Individually
```python
# Test a template
python -c "
from templates.results_card import create_results_card
data = {'equipment_name': 'Test', 'confidence': 0.9, ...}
card = create_results_card(data)
print(card)
"
```

---

**Next Steps:**
1. Test the modular dashboard: `python web-dashboard/app.py`
2. Add new pages in `pages/`
3. Create reusable components in `templates/`
4. Extend API client in `tools/api_client.py`
5. Add translations in `locales/`

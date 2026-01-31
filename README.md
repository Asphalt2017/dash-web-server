# Test Dashboard

Dash-based web interface for testing the Gym AI Helper backend API.

## Project Structure

```
web-dashboard/
├── dash-server/          # Main application code
│   ├── app.py           # Application entry point
│   ├── pages/           # Page layouts
│   ├── templates/       # Reusable UI components
│   ├── settings/        # Configuration management
│   ├── tools/           # API client utilities
│   ├── utils/           # Helper functions
│   ├── locales/         # Internationalization
│   └── assets/          # Static assets (CSS)
├── tests/               # Test suite
├── requirements.txt     # Production dependencies
├── dev-requirements.txt # Development dependencies
├── pyproject.toml       # Tool configurations
├── Dockerfile           # Container image
└── config.example.yaml  # Configuration template
```

## Features

- **Image Upload**: Drag-and-drop or click to upload gym equipment images
- **Real-time Preview**: See uploaded image before analysis
- **Health Check**: Monitor backend API and AI provider status
- **Analysis Results**: View equipment name, muscles worked, instructions, and video links
- **Performance Metrics**: See processing time and cache status

## Running the Dashboard

### Using Docker (Recommended)

```bash
# From project root
docker-compose up dashboard

# Access at http://localhost:8050
```

### Local Development

```bash
# Create virtual environment (requires Python 3.13+)
python3.13 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set backend URL
export BACKEND_URL=http://localhost:8000

# Run dashboard
python -m dash-server.app
# Or with options:
python -m dash-server.app --debug --port 8100
```

### Development Setup with Pre-commit

```bash
# Install development dependencies (includes pre-commit)
pip install -r dev-requirements.txt

# Install pre-commit hooks
pre-commit install

# (Optional) Run pre-commit on all files
pre-commit run --all-files
```

## Configuration

### Environment Variables

```bash
# Backend API URL
BACKEND_URL=http://backend:8000

# Enable/disable debug mode
DASH_DEBUG=true
```

### Docker Configuration

The dashboard is pre-configured in `docker-compose.yml`:

```yaml
dashboard:
  build: ./test-dashboard
  environment:
    - BACKEND_URL=http://backend:8000
  ports:
    - "8050:8050"
  depends_on:
    - backend
```

## Usage Guide

### 1. Check Health Status

The dashboard automatically checks backend health on load. You should see:
- **Green**: Backend and AI provider are healthy
- **Yellow**: Backend running but AI provider degraded
- **Red**: Cannot connect to backend

### 2. Upload Image

**Option A: Drag and Drop**
- Drag an image file from your computer
- Drop it in the upload area

**Option B: File Selector**
- Click "Select an Image"
- Choose file from file browser

**Supported Formats**: JPG, JPEG, PNG, WebP  
**Maximum Size**: 10MB (configured in backend)

### 3. Preview Image

After upload, the image preview appears on the right side. Verify it's the correct image before analysis.

### 4. Analyze

Click the **"Analyze Image"** button. The dashboard will:
1. Send image to backend API
2. Show loading spinner
3. Display results when complete

### 5. View Results

The results card shows:
- **Equipment Name**: Identified equipment
- **Category**: Primary muscle group
- **Confidence**: AI confidence score (0-100%)
- **Muscles Worked**: List of targeted muscles
- **Instructions**: Step-by-step usage guide
- **Common Mistakes**: Form errors to avoid
- **Tutorial Videos**: Links to instructional content
- **Cache Status**: Whether result came from cache
- **Processing Time**: API response time in milliseconds

## API Integration

The dashboard communicates with these backend endpoints:

### Health Check
```
GET /api/v1/health
```
Returns backend and AI provider status.

### Image Analysis
```
POST /api/v1/analyze
Content-Type: multipart/form-data

{
  "image": <file>
}
```

Returns equipment analysis with instructions.

## Troubleshooting

### Backend Connection Failed

**Symptom**: Red alert showing "Cannot connect to backend"

**Solutions**:
1. Verify backend is running:
   ```bash
   docker-compose ps backend
   ```

2. Check backend logs:
   ```bash
   docker-compose logs backend
   ```

3. Verify `BACKEND_URL` is correct:
   ```bash
   docker-compose exec dashboard env | grep BACKEND_URL
   ```

### Image Upload Fails

**Symptom**: Error after clicking "Analyze Image"

**Solutions**:
1. Check image file size (must be < 10MB)
2. Verify image format (JPG, PNG, WebP only)
3. Check backend logs for validation errors

### Slow Analysis

**Symptom**: Long processing time (>10 seconds)

**Possible Causes**:
- First request (AI model loading)
- Using CLIP/LLaVA without GPU
- Large image requiring preprocessing
- OpenAI API rate limits

**Solutions**:
1. Wait for model to load (first request)
2. Enable GPU for CLIP/LLaVA:
   ```yaml
   # docker-compose.yml
   backend:
     deploy:
       resources:
         reservations:
           devices:
             - capabilities: [gpu]
   ```

### Results Not Displaying

**Symptom**: Loading spinner doesn't stop

**Solutions**:
1. Check browser console for JavaScript errors
2. Verify backend returned valid JSON
3. Increase timeout in `app.py`:
   ```python
   response = httpx.post(API_ENDPOINT, files=files, timeout=60.0)
   ```

## Customization

### Change Theme

Edit `app.py` to use different Bootstrap theme:

```python
app = dash.Dash(
    __name__,
    external_stylesheets=[dbc.themes.DARKLY],  # or FLATLY, CERULEAN, etc.
    title="Gym AI Helper"
)
```

### Add Custom Styling

Create `assets/custom.css`:

```css
.custom-header {
    background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    border-radius: 10px;
}
```

Dash automatically loads files from `assets/` directory.

### Modify Layout

The layout is defined in `app.py` using Dash Bootstrap Components. Key sections:

- **Header**: Title and description
- **Health Status**: API connectivity indicator  
- **Upload Section**: File upload and analyze button
- **Preview Section**: Image preview
- **Results Section**: Analysis output

## Development Tips

### Enable Hot Reload

```bash
DASH_DEBUG=true python app.py
```

Changes to `app.py` will automatically reload the app.

### Test with Sample Images

Download sample gym equipment images:

```bash
mkdir -p test-images
wget -O test-images/bench_press.jpg "https://example.com/bench.jpg"
```

### Mock Backend Responses

For testing without backend, modify the `analyze_image` callback to return mock data:

```python
# Mock response for testing
mock_data = {
    "equipment_name": "Test Equipment",
    "category": "chest",
    "confidence": 0.95,
    ...
}
return create_results_card(mock_data), ""
```

## Production Deployment

### Security Considerations

1. **Disable Debug Mode**:
   ```bash
   DASH_DEBUG=false
   ```

2. **Add Authentication** (optional):
   ```python
   import dash_auth
   
   VALID_USERNAME_PASSWORD_PAIRS = {
       'admin': 'secure_password'
   }
   
   auth = dash_auth.BasicAuth(
       app,
       VALID_USERNAME_PASSWORD_PAIRS
   )
   ```

3. **Use HTTPS**:
   Deploy behind reverse proxy (Nginx/Caddy) with SSL certificate.

4. **Rate Limiting**:
   Implement rate limiting to prevent abuse.

### Performance Optimization

1. **Enable Caching**:
   ```python
   from flask_caching import Cache
   
   cache = Cache(app.server, config={
       'CACHE_TYPE': 'redis',
       'CACHE_REDIS_URL': 'redis://redis:6379'
   })
   ```

2. **Optimize Images**:
   Compress uploaded images before sending to backend.

3. **Use CDN**:
   Serve static assets (CSS, JS) from CDN.

## Support

For issues or questions:
- Check backend logs: `docker-compose logs backend`
- Check dashboard logs: `docker-compose logs dashboard`
- Review [main documentation](../README.md)

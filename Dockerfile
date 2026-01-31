FROM python:3.13-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY dash-server/ ./dash-server/
COPY config.example.yaml .

# Expose port
EXPOSE 8050

# Run dash app
CMD ["python", "-m", "dash-server.app"]

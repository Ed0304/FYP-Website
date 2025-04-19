# Use a minimal Python base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Prevent Python from generating .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies (optional: customize for Mongo or others)
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir absl-py==2.1.0
RUN pip install --no-cache-dir addict==2.4.0
# Add each dependency as a separate line for debugging
RUN pip install --no-cache-dir aiofiles==23.2.1
# Continue with the rest of your dependencies

# Copy app files
COPY . .

# Set the port for Cloud Run
EXPOSE 8080

# Run the app with Gunicorn (recommended for production)
# Replace 'main:app' if your entry point is different
CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]
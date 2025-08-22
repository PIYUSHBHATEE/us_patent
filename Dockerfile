# Use Python 3.13 slim image as base
FROM python:3.13-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv for dependency management via pip
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Copy source code
COPY src/ ./src/

# Install Python dependencies using uv
RUN uv sync --frozen

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app
USER app

# Expose port (if needed for future HTTP transport)
EXPOSE 8000

# Set the default command
CMD ["uv", "run", "patent-mcp-server"]

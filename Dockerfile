# ===== Stage 1: Build Stage =====
FROM python:3.12-slim AS build

# Set work directory
WORKDIR /app

# Copy requirements first (caching dependencies)
COPY requirements.txt .

# Install build dependencies
RUN pip install --upgrade pip \
    && pip install --user -r requirements.txt

# Copy the rest of the app
COPY . .

# ===== Stage 2: Production Stage =====
FROM python:3.12-slim

WORKDIR /app

# Copy only installed packages from build stage
COPY --from=build /root/.local /root/.local
# Copy app source code
COPY --from=build /app /app

# Add local bin to PATH
ENV PATH=/root/.local/bin:$PATH

# Expose port (if your app runs a server)
EXPOSE 8000

# Command to run the app
CMD ["python", "app.py"]

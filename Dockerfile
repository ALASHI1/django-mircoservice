FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project code
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Copy and set permissions for the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Create a non-root user
RUN useradd -m celeryuser
RUN chown -R celeryuser:celeryuser /app

# Switch to the non-root user
USER celeryuser

# Set default command to run entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
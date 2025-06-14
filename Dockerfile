# Gunakan image Python ringan
FROM python:3.9-slim

WORKDIR /app

# Salin dan install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Salin kode aplikasi
COPY app.py .

# Expose port 5000
EXPOSE 5000

# Jalankan Flask app
CMD ["python", "app.py"]

FROM python:slim

# NOTE: Fixed typo PHTHONUNBUFFERED -> PYTHONUNBUFFERED
ENV PYTHONDONTWRITEBYTECODE = 1 \
    PYTHONUNBUFFERED = 1

WORKDIR /app

# CORRECTED: apt-get commands are fixed
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*
    
COPY . .

RUN pip install --no-cache-dir -e . 

# NOTE: This line runs your training pipeline *during* the build. 
# Ensure this is intentional, as it saves the model inside the image.
RUN python pipeline/training_pipleline.py

EXPOSE 5000

CMD ["python", "application.py"]
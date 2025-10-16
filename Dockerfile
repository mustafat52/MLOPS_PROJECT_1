FROM python:3.10-slim

# NOTE: Fixed typo PHTHONUNBUFFERED -> PYTHONUNBUFFERED
ENV PYTHONDONTWRITEBYTECODE = 1 \
    PYTHONUNBUFFERED = 1

WORKDIR /app

# CORRECTED: apt-get commands are fixed
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git curl libgomp1 \

    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*
    
COPY . .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -e . 
# NOTE: This line runs your training pipeline *during* the build. 
# Ensure this is intentional, as it saves the model inside the image.
RUN --mount=type=secret,id=gcp-credentials \
    export GOOGLE_APPLICATION_CREDENTIALS=/run/secrets/gcp-credentials && \
    python pipeline/training_pipeline.py

EXPOSE 5000

CMD ["python", "application.py"]






# # FROM python:3.10-slim


# # ENV PYTHONDONTWRITEBYTECODE=1 

# # PYTHONUNBUFFERED=1

# # WORKDIR /app

# # RUN apt-get update && apt-get install -y --no-install-recommends 

# # build-essential 

# # cmake 

# # git 

# # curl 

# # libgomp1 

# # && apt-get clean 

# # && rm -rf /var/lib/apt/lists/*

# # Copy all local code and the existing empty artifacts folders
# # COPY . .

# # Install Python dependencies
# # RUN pip install --no-cache-dir -e .

# # --- CRITICAL NEW STEP: DATA INGESTION ---
# # 1. Create a staging directory for the raw file.
# # RUN mkdir -p data_ingestion

# # 2. Download the original raw data file from your GCS bucket into the container.
# # Bucket: mlops_hotel_reservation_52, File: Hotel_Reservations.csv
# # RUN gsutil cp gs://mlops_hotel_reservation_52/Hotel_Reservations.csv data_ingestion/Hotel_Reservations.csv

# # NOTE: This line runs your training pipeline during the build.
# # RUN python pipeline/training_pipeline.py

# # EXPOSE 5000

# # CMD ["python", "application.py"]



# FROM python:3.10-slim

# # Configuration and Environment Variables
# ENV PYTHONDONTWRITEBYTECODE=1 \
#     PYTHONUNBUFFERED=1

# WORKDIR /app

# # Install System Dependencies 
# # These are necessary for building many scientific Python packages (like LightGBM)
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     build-essential \
#     cmake \
#     git \
#     curl \
#     libgomp1 && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # Copy all local code and the empty artifacts folder
# COPY . .

# # Install Python dependencies from setup.py
# RUN pip install --no-cache-dir -e .

# # --- CRITICAL NEW STEP: DATA INGESTION (PATH CORRECTION APPLIED) ---

# # 1. Create the exact directory structure expected by your training pipeline.
# RUN mkdir -p artifacts/raw

# # 2. Download the raw data from GCS directly to the expected path.
# #    We assume the pipeline expects the file to be named 'train.csv'.
# RUN gsutil cp gs://mlops_hotel_reservation_52/Hotel_Reservations.csv artifacts/raw/train.csv

# # This step now runs the full pipeline, generating the model and processed artifacts.
# RUN python pipeline/training_pipeline.py

# EXPOSE 5000

# CMD ["python", "application.py"]


# FROM python:3.10-slim

# # Configuration and Environment Variables
# ENV PYTHONDONTWRITEBYTECODE=1 \
#     PYTHONUNBUFFERED=1

# # --- ARGUMENTS MUST BE DEFINED EARLY ---
# ARG GCP_PROJECT_ID
# ARG GOOGLE_APPLICATION_CREDENTIALS_PATH 
# # ----------------------------------------

# WORKDIR /app

# # 1. Install System Dependencies
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     build-essential \
#     cmake \
#     git \
#     curl \
#     libgomp1 && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # 2. Copy all local code
# COPY . .

# # 3. Install Python dependencies
# RUN pip install --no-cache-dir -e .

# # --- CRITICAL FIX: EXPLICIT AUTHENTICATION & PATH ---

# # 4. Set the environment variable expected by the Google auth library (from Jenkins ARG)
# ENV GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS_PATH

# # 5. Create the artifact directory
# RUN mkdir -p artifacts/raw

# # 6. Download the raw data from GCS using the Python client.
# #    FIX: Explicitly pass the project ID (GCP_PROJECT_ID) to the Client() constructor 
# #    and rely on the GOOGLE_APPLICATION_CREDENTIALS ENV variable.
# RUN python -c "from google.cloud import storage; client = storage.Client(project='$GCP_PROJECT_ID'); bucket = client.bucket('mlops_hotel_reservation_52'); blob = bucket.blob('Hotel_Reservations.csv'); blob.download_to_filename('artifacts/raw/train.csv')"

# # 7. Run the full pipeline
# RUN python pipeline/training_pipeline.py

# EXPOSE 5000

# CMD ["python", "application.py"]
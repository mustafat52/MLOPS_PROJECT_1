FROM python:slim

ENV PYTHONDONTWRITEBYTECODE = 1 \
    PHTHONUNBUFFERED = 1

WORKDIR /app

RUN apt-get upadte && apt-get-install -y --no-install -recommends \
    libgomp1 \
    && apt-get-clean \ 
    && rm -rf /var/lib/apt/list/*
    
COPY . .

RUN pip install --no-cache-dir -e . 

RUN python pipeline/training_pipleline.py

EXPOSE 5000

CMD ["python", "application.py"]

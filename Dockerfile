FROM python:3.10 AS main

WORKDIR /app

# Install pandoc and netcat with retry
RUN apt-get update -o Acquire::Retries=3 && \
    apt-get install -y --no-install-recommends \
        pandoc \
        netcat-openbsd \
        libgl1-mesa-glx \
        libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download NLTK data
RUN python -m nltk.downloader -d /app/nltk_data punkt_tab averaged_perceptron_tagger
ENV NLTK_DATA=/app/nltk_data

ENV SCARF_NO_ANALYTICS=true

COPY . .

CMD ["python", "main.py"]

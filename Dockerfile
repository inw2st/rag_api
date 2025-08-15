# RAG API Render용 Dockerfile

FROM python:3.10-slim AS main

WORKDIR /app

# 필수 패키지 설치
RUN apt-get update -o Acquire::Retries=3 && \
    apt-get install -y --no-install-recommends \
        pandoc \
        netcat-openbsd \
        libgl1 \
        libglib2.0-0 \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# requirements 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# NLTK 데이터 다운로드
RUN python -m nltk.downloader -d /app/nltk_data punkt averaged_perceptron_tagger
ENV NLTK_DATA=/app/nltk_data

# Unstructured analytics 끄기
ENV SCARF_NO_ANALYTICS=true

# 소스 복사
COPY . .

# 컨테이너 시작 커맨드
CMD ["python", "main.py"]

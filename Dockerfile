# syntax=docker/dockerfile:1.7
FROM python:3.11-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

RUN useradd -u 10001 -m appuser
WORKDIR /app

COPY api/requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-compile --no-cache-dir -r requirements.txt

COPY api/ ./
USER appuser
EXPOSE 8080
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]

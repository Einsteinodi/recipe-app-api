FROM python:3.9-alpine3.13

LABEL maintainer="einsteinodi"

ENV PYTHONUNBUFFERED=1

# Install system dependencies needed for Python venv and pip
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    python3-dev \
    py3-virtualenv \
    build-base \
    && python3 -m ensurepip

# Copy the requirements file and app
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set working directory
WORKDIR /app

# Install dependencies

ARG DEV=false
RUN python3 -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV="true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser -D django-user

# Add virtual environment to PATH
ENV PATH="/py/bin:$PATH"

# Expose port 8000
EXPOSE 8000

# Use non-root user
USER django-user

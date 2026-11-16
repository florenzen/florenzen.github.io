FROM mcr.microsoft.com/devcontainers/base:trixie

RUN apt-get update && \
    apt-get install -y --no-install-recommends gh python3 python3-venv && \
    rm -rf /var/lib/apt/lists/*

COPY requirements-dev.txt /tmp/requirements-dev.txt
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements-dev.txt && \
    rm /tmp/requirements-dev.txt
ENV PATH=/opt/venv/bin:$PATH

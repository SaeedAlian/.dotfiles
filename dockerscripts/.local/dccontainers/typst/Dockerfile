FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash curl ca-certificates \
    build-essential pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN if ! command -v cargo >/dev/null 2>&1; then \
        echo "Installing Rust (cargo)..."; \
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y ; \
    else \
        echo "Cargo already installed"; \
    fi && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> /etc/profile && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> /root/.bashrc

ENV PATH="/root/.cargo/bin:${PATH}"

RUN if ! command -v typst >/dev/null 2>&1; then \
        echo "Installing typst-cli using cargo..."; \
        cd /root && \
        cargo new dummy_project >/dev/null 2>&1 || true && \
        cd dummy_project && \
        cargo install typst-cli ; \
    else \
        echo "typst-cli already installed"; \
    fi

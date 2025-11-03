FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    texlive texlive-xetex lmodern texlive-science \
    texlive-fonts-recommended texlive-latex-recommended \
    texlive-lang-arabic fonts-noto-core fonts-noto-extra \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

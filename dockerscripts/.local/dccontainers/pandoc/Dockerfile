FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-noto-core fonts-noto-extra \
    pandoc texlive lmodern texlive-xetex \
    texlive-fonts-recommended texlive-latex-recommended \
    texlive-lang-arabic texlive-science \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

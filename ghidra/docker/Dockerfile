FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -------------------------
# Install dependencies, build tools, JDK 21
# -------------------------
RUN apt-get update && apt-get install -y \
    gcc-x86-64-linux-gnu \
    wget \
    unzip \
    openjdk-21-jdk \
    python3 \
    python3-pip \
    build-essential \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

#Set QEMU version
ENV QEMU_CPU=x86_64

# -------------------------
# Install Ghidra
# -------------------------
ENV GHIDRA_VERSION=11.4.2
ENV GHIDRA_BUILD=ghidra_11.4.2_PUBLIC
ENV GHIDRA_ZIP=ghidra_11.4.2_PUBLIC_20250826.zip

# wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.2_build/ghidra_11.4.2_PUBLIC_20250826.zip \ For x86_64

RUN wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.2_build/ghidra_11.4.2_PUBLIC_20250826.zip \
    && unzip ghidra_11.4.2_PUBLIC_20250826.zip -d /opt \
    && mv /opt/${GHIDRA_BUILD} /opt/ghidra \
    && rm ghidra_11.4.2_PUBLIC_20250826.zip

ENV PATH="/opt/ghidra/support:${PATH}"

# -------------------------
# Copy Source Code & Scripts
# -------------------------
WORKDIR /src
COPY vul_examples.c /src/
COPY scripts/ /opt/ghidra/scripts/
RUN chmod -R +x /opt/ghidra/scripts

# -------------------------
# Compile all C files automatically
# -------------------------
RUN mkdir -p /binaries \
    && x86_64-linux-gnu-gcc /src/vul_examples.c -o /binaries/vul_examples_linux64


# -------------------------
# Entry Point for Automated Ghidra Processing
# -------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

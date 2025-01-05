# Base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONIOENCODING=utf8 \
    PATH="/root/.local/bin:$PATH" \
    PLAYWRIGHT_CHROMIUM_USE_HEADLESS_NEW=1 \
    PW_TEST_SCREENSHOT_NO_FONTS_READY=1

# Install required packages and clean up to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    git pipx tor build-essential ffmpeg libavcodec-extra python3-venv python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy and prepare the AIL-Framework
WORKDIR /opt/ail-framework
COPY ./ail-framework/ /opt/ail-framework

# Modify scripts to remove sudo and make apt-get non-interactive
RUN sed -i "s|sudo||g" installing_deps.sh var/www/update_thirdparty.sh && \
    sed -i "s|apt-get|apt-get -y|g" installing_deps.sh var/www/update_thirdparty.sh

# Compile and configure AIL-Framework
RUN ./installing_deps.sh && \
    sed -i "s|host = 127.0.0.1|host = 0.0.0.0|g" configs/core.cfg

# Clone and prepare Lacus and Valkey
RUN git clone https://github.com/ail-project/lacus.git /opt/ail-framework/lacus && \
    git clone https://github.com/valkey-io/valkey.git /opt/ail-framework/valkey

# Compile Valkey
WORKDIR /opt/ail-framework/valkey
RUN git checkout 8.0 && make

# Configure and install Lacus dependencies
WORKDIR /opt/ail-framework/lacus
RUN cp config/logging.json.sample config/logging.json && \
    pipx install poetry && \
    poetry install && \
    poetry run playwright install && \
    poetry run playwright install-deps && \
    echo "LACUS_HOME=$(pwd)" >> .env

# Install patches for PlaywrightCapture
COPY patches/ /opt/ail-framework/patches/
RUN package_path=$(poetry run python3 -c "import playwrightcapture; print(playwrightcapture.__file__.rsplit('/', 1)[0])") && \
    cp "$package_path/capture.py" "$package_path/capture.py.bak" && \
    cp /opt/ail-framework/patches/capture.py "$package_path/capture.py"

# Update the LAUNCH script
WORKDIR /opt/ail-framework
RUN echo "service tor start" >> bin/LAUNCH.sh && \
    find / -type f -name "activate" -exec grep -q lacus {} \; -exec echo "source {}" >> bin/LAUNCH.sh \; 2>/dev/null && \
    echo "cd lacus/ && poetry run start" >> bin/LAUNCH.sh && \
    echo "read x" >> bin/LAUNCH.sh

# Expose port and set entrypoint
EXPOSE 7000
ENTRYPOINT ["/bin/bash", "bin/LAUNCH.sh"]

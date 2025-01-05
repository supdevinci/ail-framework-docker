
# AIL-Framework Docker Setup

## Description
This repository provides a ready-to-use Docker environment for **AIL-Framework**, an open-source project for online data analysis and crawling, designed for cybersecurity researchers and analysts. The Docker setup simplifies deployment, ensures consistency, and includes volume mappings for data persistence.

---

## Features
- **Simplified Setup:** Automated configuration with `docker-compose.yml` and Dockerfile.
- **Persistent Storage:** Volume mappings to retain critical data between container restarts.
- **Interactive Access:** Default `/bin/bash` command for manual operation if needed.
- **Customizable:** Easily rename the Docker image or adjust configuration files.
- **Secure Access:** Port mapping ensures that services are accessible locally.

---

## Requirements
- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Hardware Requirements**:
  - Disk Space: ~20GB for Docker image
  - Memory: Minimum 6GB RAM

---

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/supdevinci/ail-framework-docker.git
cd ail-framework-docker
```

### 2. Launch the Script
```bash
chmod +x ail_framework.sh
./ail_framework.sh --setup
```

---

## Usage

### Script Options
The `ail_framework.sh` script provides several options to manage the AIL-Framework Docker container:

- `--help`: Displays help information and useful links.
- `--setup`: Sets up the environment, builds the Docker image, and starts the container.
- `--start`: Starts the Docker container if it's already built.
- `--reset-password`: Resets the admin password for AIL-Framework.
- `--stop`: Stops and removes the Docker container.

Example usage:
```bash
# Display help information
./ail_framework.sh --help

# Set up the environment
./ail_framework.sh --setup

# Start the container
./ail_framework.sh --start

# Reset the admin password
./ail_framework.sh --reset-password

# Stop the container
./ail_framework.sh --stop
```

### Access the AIL-Framework UI
Open your browser and navigate to:
- **AIL-Framework UI**: [https://127.0.0.1:7000](https://127.0.0.1:7000)

### Access the Lacus Crawler Configuration
- **Lacus URL**: [http://127.0.0.1:7100](http://127.0.0.1:7100)

### Tor Proxy Settings
- **Tor Proxy**: `socks5://127.0.0.1:9050`

### Reset Admin Password
If you need to reset the admin password:
```bash
./ail_framework.sh --reset-password
```

### Stop the Container
To stop and remove the container:
```bash
./ail_framework.sh --stop
```

---

## Configuration Details

### Volumes
The following directories are mapped to ensure data persistence:
- `./Volumes/CRAWLED_SCREENSHOT/` → `/opt/ail-framework/CRAWLED_SCREENSHOT`
- `./Volumes/PASTES/` → `/opt/ail-framework/PASTES`
- `./Volumes/DATA_KVROCKS/` → `/opt/ail-framework/DATA_KVROCKS`
- `./Volumes/indexdir/` → `/opt/ail-framework/indexdir`
- `./Volumes/HASHS/` → `/opt/ail-framework/HASHS`
- `./Volumes/logs/` → `/opt/ail-framework/logs`

### Ports
- **7000**: Exposed for the AIL-Framework UI on `127.0.0.1`.

### Environment Variables
- `DEBIAN_FRONTEND=noninteractive`: Suppresses interactive prompts during package installation.
- `PYTHONIOENCODING=utf8`: Ensures consistent Unicode handling for Python.

---

## Customizing the Image Name
The Docker image is defined as `ail-framework:latest`. To rename it:
1. Edit the `image` field in `docker-compose.yml`:
   ```yaml
   image: my-custom-ail:1.0
   ```
2. Rebuild the image:
   ```bash
   docker compose build
   ```

3. Launch the installation:
   ```bash
   chmod +x ail_framework.sh
   ./ail_framework.sh --setup
   ```

---

## License
This project is licensed under the [MIT License](LICENSE).

---

## Useful Links
- **AIL-Framework Repository**: [AIL GitHub](https://github.com/ail-project/ail-framework)
- **Official Documentation**: [AIL Documentation](https://ail-project.github.io)

---

## Contribution
Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

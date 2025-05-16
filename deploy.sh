#!/bin/bash

set -e

# CONFIGURE THESE
REPO_URL="https://github.com/Ajay-1510/Sonarqube-and-trivy.git"
APP_NAME="static-web-app"
DOCKER_IMAGE="static-web-app-image"

# 1. Clone project
echo "[+] Cloning GitHub repository..."
git clone "$REPO_URL" "$APP_NAME"
cd "$APP_NAME"

# 2. Run SonarQube analysis
echo "[+] Running SonarQube analysis..."
if ! command -v sonar-scanner &> /dev/null; then
    echo "Installing SonarQube scanner..."
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
    unzip sonar-scanner-cli-*.zip
    export PATH="$PWD/sonar-scanner-*/bin:$PATH"
fi
sonar-scanner

# 3. Build Docker image
echo "[+] Building Docker image..."
docker build -t "$DOCKER_IMAGE" .

# 4. Scan image with Trivy
echo "[+] Scanning Docker image with Trivy..."
if ! command -v trivy &> /dev/null; then
    echo "Installing Trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
fi
./trivy image --exit-code 1 --severity CRITICAL,HIGH "$DOCKER_IMAGE"

# 5. Deploy container
echo "[+] Running Docker container..."
docker run -d -p 8080:80 --name "$APP_NAME" "$DOCKER_IMAGE"

echo "[✔] Application deployed at http://localhost:8080"

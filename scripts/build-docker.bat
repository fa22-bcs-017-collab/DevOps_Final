@echo off
echo 🐳 Building Docker Image...

set /p DOCKER_USERNAME="Enter your Docker Hub username: "

echo.
echo 🔨 Building image...
docker build -t cloud-pipeline-app .

echo.
echo 🏷️ Tagging image...
docker tag cloud-pipeline-app %DOCKER_USERNAME%/cloud-pipeline-app:latest

echo.
echo 📤 Pushing to Docker Hub...
docker push %DOCKER_USERNAME%/cloud-pipeline-app:latest

echo.
echo ✅ Docker image built and pushed successfully!
echo Image: %DOCKER_USERNAME%/cloud-pipeline-app:latest
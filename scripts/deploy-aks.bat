@echo off
echo ☁️ Deploying to Azure AKS...

set /p RESOURCE_GROUP="Enter resource group name (default: cloud-pipeline-rg): "
if "%RESOURCE_GROUP%"=="" set RESOURCE_GROUP=cloud-pipeline-rg

set /p CLUSTER_NAME="Enter AKS cluster name (default: cloud-pipeline-aks): "
if "%CLUSTER_NAME%"=="" set CLUSTER_NAME=cloud-pipeline-aks

set /p DOCKER_USERNAME="Enter your Docker Hub username: "

echo.
echo 🏗️ Creating resource group...
az group create --name %RESOURCE_GROUP% --location eastus

echo.
echo 🚀 Creating AKS cluster...
az aks create --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME% --node-count 2 --enable-addons monitoring --generate-ssh-keys

echo.
echo 🔗 Getting AKS credentials...
az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME%

echo.
echo 📝 Updating Kubernetes manifests...
powershell -Command "(Get-Content k8s\app-deployment.yaml) -replace '\[YOUR_DOCKERHUB_USERNAME\]', '%DOCKER_USERNAME%' | Set-Content k8s\app-deployment.yaml"

echo.
echo 🚀 Deploying to Kubernetes...
kubectl apply -f k8s/

echo.
echo ⏳ Waiting for deployment...
kubectl wait --for=condition=available --timeout=300s deployment/cloud-pipeline-app -n cloud-pipeline

echo.
echo 🌍 Getting external IP...
kubectl get services -n cloud-pipeline

echo.
echo ✅ Deployment completed!
echo Run 'kubectl get services -n cloud-pipeline' to get the external IP
@echo off
echo ========================================
echo   Azure AKS Deployment Script
echo ========================================
echo.

REM Set variables
set RESOURCE_GROUP=cloud-pipeline-rg
set CLUSTER_NAME=cloud-pipeline-aks
set LOCATION=eastus
set NODE_COUNT=2

echo Step 1: Creating Resource Group...
az group create --name %RESOURCE_GROUP% --location %LOCATION%
if %errorlevel% neq 0 (
    echo Failed to create resource group
    exit /b 1
)

echo.
echo Step 2: Creating AKS Cluster...
echo This may take 5-10 minutes...
az aks create ^
    --resource-group %RESOURCE_GROUP% ^
    --name %CLUSTER_NAME% ^
    --node-count %NODE_COUNT% ^
    --enable-addons monitoring ^
    --generate-ssh-keys ^
    --node-vm-size Standard_B2s

if %errorlevel% neq 0 (
    echo Failed to create AKS cluster
    exit /b 1
)

echo.
echo Step 3: Getting AKS credentials...
az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME%

echo.
echo Step 4: Deploying application to AKS...
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/app-deployment.yaml

echo.
echo Step 5: Waiting for deployment to complete...
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n cloud-pipeline
kubectl wait --for=condition=available --timeout=300s deployment/cloud-pipeline-app -n cloud-pipeline

echo.
echo Step 6: Getting service information...
kubectl get services -n cloud-pipeline

echo.
echo ========================================
echo   Deployment Complete!
echo ========================================
echo.
echo To get the external IP address, run:
echo kubectl get service cloud-pipeline-service -n cloud-pipeline
echo.
echo To check pod status, run:
echo kubectl get pods -n cloud-pipeline
echo.
echo To view logs, run:
echo kubectl logs -l app=cloud-pipeline-app -n cloud-pipeline
echo ========================================
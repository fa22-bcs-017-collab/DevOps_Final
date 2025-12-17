# Azure AKS Deployment Script
# Prerequisites: Azure CLI installed and logged in

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = "taskmanager-rg",
    
    [Parameter(Mandatory=$false)]
    [string]$ClusterName = "taskmanager-aks-cluster",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$false)]
    [string]$DockerUsername = $env:DOCKER_USERNAME
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Azure AKS Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Azure CLI is installed
Write-Host "1. Checking Azure CLI..." -ForegroundColor Yellow
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Azure CLI is not installed. Please install it first." -ForegroundColor Red
    Write-Host "Download from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Azure CLI is installed" -ForegroundColor Green

# Check if logged in to Azure
Write-Host ""
Write-Host "2. Checking Azure login status..." -ForegroundColor Yellow
$account = az account show 2>$null
if (-not $account) {
    Write-Host "❌ Not logged in to Azure. Logging in..." -ForegroundColor Red
    az login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Azure login failed" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Already logged in to Azure" -ForegroundColor Green
}

# Create resource group
Write-Host ""
Write-Host "3. Creating resource group '$ResourceGroup'..." -ForegroundColor Yellow
az group create --name $ResourceGroup --location $Location
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Resource group created/verified" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create resource group" -ForegroundColor Red
    exit 1
}

# Create AKS cluster
Write-Host ""
Write-Host "4. Creating AKS cluster '$ClusterName'..." -ForegroundColor Yellow
Write-Host "   This may take 10-15 minutes..." -ForegroundColor Cyan
az aks create `
    --resource-group $ResourceGroup `
    --name $ClusterName `
    --node-count 2 `
    --node-vm-size Standard_B2s `
    --enable-addons monitoring `
    --generate-ssh-keys `
    --network-plugin azure `
    --network-policy azure `
    --load-balancer-sku standard `
    --vm-set-type VirtualMachineScaleSets `
    --enable-cluster-autoscaler `
    --min-count 1 `
    --max-count 3

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ AKS cluster created successfully" -ForegroundColor Green
} else {
    Write-Host "⚠️ AKS cluster may already exist or creation encountered issues" -ForegroundColor Yellow
}

# Get AKS credentials
Write-Host ""
Write-Host "5. Getting AKS credentials..." -ForegroundColor Yellow
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName --overwrite-existing
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ AKS credentials configured" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to get AKS credentials" -ForegroundColor Red
    exit 1
}

# Verify kubectl connection
Write-Host ""
Write-Host "6. Verifying kubectl connection..." -ForegroundColor Yellow
kubectl cluster-info
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Connected to AKS cluster" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to connect to AKS cluster" -ForegroundColor Red
    exit 1
}

# Create namespace
Write-Host ""
Write-Host "7. Creating Kubernetes namespace..." -ForegroundColor Yellow
kubectl create namespace taskmanager --dry-run=client -o yaml | kubectl apply -f -
Write-Host "✅ Namespace created/verified" -ForegroundColor Green

# Create Docker Hub secret (if credentials provided)
if ($DockerUsername) {
    Write-Host ""
    Write-Host "8. Creating Docker Hub secret..." -ForegroundColor Yellow
    $dockerPassword = Read-Host "Enter Docker Hub password/token" -AsSecureString
    $dockerPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($dockerPassword)
    )
    
    kubectl create secret docker-registry dockerhub-secret `
        --docker-server=docker.io `
        --docker-username=$DockerUsername `
        --docker-password=$dockerPasswordPlain `
        --namespace=taskmanager `
        --dry-run=client -o yaml | kubectl apply -f -
    
    Write-Host "✅ Docker Hub secret created" -ForegroundColor Green
}

# Deploy application
Write-Host ""
Write-Host "9. Deploying application to AKS..." -ForegroundColor Yellow
kubectl apply -f k8s/ -n taskmanager

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Application deployed successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    exit 1
}

# Wait for pods to be ready
Write-Host ""
Write-Host "10. Waiting for pods to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod --all -n taskmanager --timeout=300s

# Get deployment status
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pods:" -ForegroundColor Yellow
kubectl get pods -n taskmanager
Write-Host ""
Write-Host "Services:" -ForegroundColor Yellow
kubectl get svc -n taskmanager
Write-Host ""
Write-Host "Deployments:" -ForegroundColor Yellow
kubectl get deployments -n taskmanager

# Get LoadBalancer IP
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Application Access" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Waiting for LoadBalancer IP assignment..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
$externalIP = ""

while ($attempt -lt $maxAttempts -and $externalIP -eq "") {
    Start-Sleep -Seconds 10
    $externalIP = kubectl get svc frontend-service -n taskmanager -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
    $attempt++
    Write-Host "Attempt $attempt/$maxAttempts..." -ForegroundColor Cyan
}

if ($externalIP) {
    Write-Host ""
    Write-Host "✅ Application is accessible at:" -ForegroundColor Green
    Write-Host "   http://$externalIP" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📝 Save this information for your submission!" -ForegroundColor Yellow
} else {
    Write-Host "⚠️ LoadBalancer IP not assigned yet. Run this command later:" -ForegroundColor Yellow
    Write-Host "   kubectl get svc frontend-service -n taskmanager" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. Take screenshots of:" -ForegroundColor Yellow
Write-Host "   - kubectl get pods -n taskmanager" -ForegroundColor Cyan
Write-Host "   - kubectl get svc -n taskmanager" -ForegroundColor Cyan
Write-Host "   - The running application in your browser" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. To view logs: kubectl logs <pod-name> -n taskmanager" -ForegroundColor Yellow
Write-Host "3. To delete deployment: kubectl delete namespace taskmanager" -ForegroundColor Yellow
Write-Host "4. To delete AKS cluster: az aks delete -g $ResourceGroup -n $ClusterName" -ForegroundColor Yellow
Write-Host ""
Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green

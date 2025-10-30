@echo off
echo ========================================
echo   Azure AKS Cleanup Script
echo ========================================
echo.
echo WARNING: This will delete all Azure resources!
echo.
set /p confirm="Are you sure you want to delete all resources? (y/N): "
if /i not "%confirm%"=="y" (
    echo Cleanup cancelled.
    exit /b 0
)

echo.
echo Step 1: Deleting Kubernetes resources...
kubectl delete namespace cloud-pipeline --ignore-not-found=true

echo.
echo Step 2: Deleting AKS cluster and resource group...
echo This may take a few minutes...
az group delete --name cloud-pipeline-rg --yes --no-wait

echo.
echo Cleanup initiated. Resources will be deleted in the background.
echo You can check the status in the Azure portal.
echo ========================================
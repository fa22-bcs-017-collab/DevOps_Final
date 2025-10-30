@echo off
echo ========================================
echo   Azure AKS Status Check
echo ========================================
echo.

echo Checking AKS cluster status...
az aks show --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --query "provisioningState" -o tsv

echo.
echo Checking Kubernetes pods...
kubectl get pods -n cloud-pipeline

echo.
echo Checking services...
kubectl get services -n cloud-pipeline

echo.
echo Checking deployments...
kubectl get deployments -n cloud-pipeline

echo.
echo Getting external IP address...
kubectl get service cloud-pipeline-service -n cloud-pipeline -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

echo.
echo.
echo ========================================
echo   Application URLs
echo ========================================
for /f %%i in ('kubectl get service cloud-pipeline-service -n cloud-pipeline -o jsonpath^="{.status.loadBalancer.ingress[0].ip}"') do (
    if not "%%i"=="" (
        echo Frontend: http://%%i
        echo API: http://%%i/api/tasks
        echo Health: http://%%i/health
    ) else (
        echo External IP not yet assigned. Please wait a few minutes and run this script again.
    )
)
echo ========================================
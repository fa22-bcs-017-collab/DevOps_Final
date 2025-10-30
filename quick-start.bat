@echo off
echo 🚀 Cloud Deployment Pipeline - Quick Start
echo ==========================================

echo.
echo Choose deployment option:
echo 1. Local Development
echo 2. Docker Build & Test
echo 3. Azure AKS Deployment
echo 4. Complete Pipeline (All Steps)
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto local
if "%choice%"=="2" goto docker
if "%choice%"=="3" goto aks
if "%choice%"=="4" goto complete
goto invalid

:local
echo.
echo 🏠 Starting Local Development...
call scripts\deploy-local.bat
goto end

:docker
echo.
echo 🐳 Building Docker Image...
call scripts\build-docker.bat
goto end

:aks
echo.
echo ☁️ Deploying to Azure AKS...
call scripts\deploy-aks.bat
goto end

:complete
echo.
echo 🔄 Running Complete Pipeline...
echo.
echo Step 1: Local Development Test
call scripts\deploy-local.bat
timeout /t 10
echo.
echo Step 2: Docker Build
call scripts\build-docker.bat
echo.
echo Step 3: Azure AKS Deployment
call scripts\deploy-aks.bat
goto end

:invalid
echo.
echo ❌ Invalid choice. Please run the script again.
goto end

:end
echo.
echo ✅ Deployment process completed!
echo.
echo 📚 For detailed instructions, see:
echo    - README.md
echo    - DEPLOYMENT-GUIDE.md
echo    - DEPLOYMENT-SUMMARY.md
echo.
pause
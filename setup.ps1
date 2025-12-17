# DevOps Final Project Setup Script
# This script helps set up the complete environment

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('all', 'docker', 'aks', 'ansible', 'selenium')]
    [string]$Component = 'all'
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DevOps Final Project Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

function Test-CommandExists {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    }
    catch {
        return $false
    }
}

function Setup-Docker {
    Write-Host "Setting up Docker environment..." -ForegroundColor Yellow
    
    if (-not (Test-CommandExists docker)) {
        Write-Host "❌ Docker is not installed" -ForegroundColor Red
        Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "✅ Docker is installed" -ForegroundColor Green
    docker --version
    
    Write-Host "`nBuilding Docker images..." -ForegroundColor Yellow
    
    # Build images
    docker build -t taskmanager-frontend:latest -f Dockerfile.frontend .
    docker build -t taskmanager-backend:latest -f Dockerfile.backend .
    docker build -t taskmanager-database:latest -f Dockerfile.database .
    
    Write-Host "`n✅ Docker images built successfully" -ForegroundColor Green
    docker images | Select-String "taskmanager"
    
    Write-Host "`nStarting application with Docker Compose..." -ForegroundColor Yellow
    docker-compose up -d
    
    Write-Host "`nWaiting for services to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    Write-Host "`nContainer Status:" -ForegroundColor Yellow
    docker-compose ps
    
    Write-Host "`n✅ Application is running at http://localhost" -ForegroundColor Green
    return $true
}

function Setup-AKS {
    Write-Host "Setting up Azure Kubernetes Service..." -ForegroundColor Yellow
    
    if (-not (Test-CommandExists az)) {
        Write-Host "❌ Azure CLI is not installed" -ForegroundColor Red
        Write-Host "Please install from: https://docs.microsoft.com/cli/azure/install-azure-cli" -ForegroundColor Yellow
        return $false
    }
    
    if (-not (Test-CommandExists kubectl)) {
        Write-Host "❌ kubectl is not installed" -ForegroundColor Red
        Write-Host "Installing kubectl..." -ForegroundColor Yellow
        az aks install-cli
    }
    
    Write-Host "✅ Azure CLI and kubectl are ready" -ForegroundColor Green
    
    Write-Host "`nRunning AKS deployment script..." -ForegroundColor Yellow
    .\scripts\deploy-to-aks.ps1
    
    return $true
}

function Setup-Ansible {
    Write-Host "Setting up Ansible environment..." -ForegroundColor Yellow
    
    # Check if running on Windows
    if ($IsWindows -or $env:OS -match "Windows") {
        Write-Host "⚠️ Ansible is best run on Linux/WSL" -ForegroundColor Yellow
        Write-Host "For Windows, consider using:" -ForegroundColor Cyan
        Write-Host "  1. WSL (Windows Subsystem for Linux)" -ForegroundColor White
        Write-Host "  2. Docker container with Ansible" -ForegroundColor White
        Write-Host "  3. Azure Cloud Shell" -ForegroundColor White
        
        $response = Read-Host "`nDo you want to test Ansible in Docker container? (y/n)"
        if ($response -eq 'y') {
            Write-Host "`nRunning Ansible in Docker container..." -ForegroundColor Yellow
            docker run --rm -it `
                -v ${PWD}/ansible:/ansible `
                -w /ansible `
                cytopia/ansible:latest `
                ansible-playbook playbook.yml --syntax-check
            
            Write-Host "`n✅ Ansible playbook syntax is valid" -ForegroundColor Green
        }
    }
    else {
        # Linux/Mac
        if (-not (Test-CommandExists ansible)) {
            Write-Host "Installing Ansible..." -ForegroundColor Yellow
            if (Test-CommandExists apt-get) {
                sudo apt-get update
                sudo apt-get install -y ansible
            }
            elseif (Test-CommandExists brew) {
                brew install ansible
            }
        }
        
        Write-Host "✅ Ansible is ready" -ForegroundColor Green
        ansible --version
        
        Write-Host "`nTesting Ansible playbook..." -ForegroundColor Yellow
        cd ansible
        ansible-playbook playbook.yml --syntax-check
        Write-Host "✅ Ansible playbook syntax is valid" -ForegroundColor Green
        cd ..
    }
    
    return $true
}

function Setup-Selenium {
    Write-Host "Setting up Selenium tests..." -ForegroundColor Yellow
    
    if (-not (Test-CommandExists node)) {
        Write-Host "❌ Node.js is not installed" -ForegroundColor Red
        Write-Host "Please install from: https://nodejs.org/" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "✅ Node.js is installed" -ForegroundColor Green
    node --version
    npm --version
    
    Write-Host "`nInstalling Selenium dependencies..." -ForegroundColor Yellow
    cd selenium
    npm install
    
    Write-Host "`n✅ Selenium environment is ready" -ForegroundColor Green
    Write-Host "Run tests with: npm test" -ForegroundColor Cyan
    cd ..
    
    return $true
}

function Show-Summary {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  Setup Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Quick Start Commands:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Local Development (Docker):" -ForegroundColor Cyan
    Write-Host "  docker-compose up -d          # Start all services" -ForegroundColor White
    Write-Host "  docker-compose ps             # Check status" -ForegroundColor White
    Write-Host "  docker-compose logs -f        # View logs" -ForegroundColor White
    Write-Host "  http://localhost              # Access application" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Run Tests:" -ForegroundColor Cyan
    Write-Host "  npm test                      # Backend tests" -ForegroundColor White
    Write-Host "  cd selenium && npm test       # Selenium tests" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Deploy to AKS:" -ForegroundColor Cyan
    Write-Host "  .\scripts\deploy-to-aks.ps1  # Full AKS deployment" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Run Ansible:" -ForegroundColor Cyan
    Write-Host "  cd ansible" -ForegroundColor White
    Write-Host "  ansible-playbook playbook.yml -i hosts.ini" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Review SUBMISSION-GUIDE.md for complete instructions" -ForegroundColor White
    Write-Host "2. Take screenshots for each section" -ForegroundColor White
    Write-Host "3. Configure CI/CD pipeline secrets" -ForegroundColor White
    Write-Host "4. Deploy to Azure AKS" -ForegroundColor White
    Write-Host "5. Run all tests" -ForegroundColor White
    Write-Host ""
}

# Main execution
Write-Host "Component to setup: $Component" -ForegroundColor Cyan
Write-Host ""

$success = $true

switch ($Component) {
    'docker' {
        $success = Setup-Docker
    }
    'aks' {
        $success = Setup-AKS
    }
    'ansible' {
        $success = Setup-Ansible
    }
    'selenium' {
        $success = Setup-Selenium
    }
    'all' {
        Write-Host "Setting up all components..." -ForegroundColor Yellow
        Write-Host ""
        
        # Install Node.js dependencies first
        if (Test-Path "package.json") {
            Write-Host "Installing Node.js dependencies..." -ForegroundColor Yellow
            npm install
            Write-Host "✅ Dependencies installed" -ForegroundColor Green
        }
        
        # Setup Docker
        Write-Host "`n--- Docker Setup ---" -ForegroundColor Magenta
        Setup-Docker
        
        # Setup Selenium
        Write-Host "`n--- Selenium Setup ---" -ForegroundColor Magenta
        Setup-Selenium
        
        # Setup Ansible
        Write-Host "`n--- Ansible Setup ---" -ForegroundColor Magenta
        Setup-Ansible
        
        # AKS setup is optional and interactive
        Write-Host "`n--- Azure AKS Setup ---" -ForegroundColor Magenta
        $aksResponse = Read-Host "Do you want to deploy to Azure AKS now? (y/n)"
        if ($aksResponse -eq 'y') {
            Setup-AKS
        }
        else {
            Write-Host "⚠️ Skipping AKS setup. Run later with: .\setup.ps1 -Component aks" -ForegroundColor Yellow
        }
    }
}

Show-Summary

if ($success) {
    Write-Host "✅ Setup completed successfully!" -ForegroundColor Green
}
else {
    Write-Host "⚠️ Setup completed with some warnings" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "For detailed instructions, see SUBMISSION-GUIDE.md" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

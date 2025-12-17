# DevOps Final Project - Complete Submission Guide

## 📋 Project Overview
**Task Manager Application** - A full-stack 3-tier application demonstrating complete DevOps practices including containerization, CI/CD automation, Kubernetes deployment, configuration management, and automated testing.

---

## 🏗️ Architecture

### Three-Tier Application Structure:
- **Frontend**: Nginx-served static HTML/CSS/JS
- **Backend**: Node.js + Express REST API
- **Database**: MongoDB with persistent storage

---

## 📦 SECTION A: CONTAINERIZATION (10 Marks)

### ✅ Task A1: Docker Images

#### Files Created:
1. **Dockerfile.frontend** - Nginx-based frontend container
2. **Dockerfile.backend** - Node.js backend container
3. **Dockerfile.database** - MongoDB with initialization script

#### Build Commands:
```bash
# Build Frontend
docker build -t taskmanager-frontend:latest -f Dockerfile.frontend .

# Build Backend
docker build -t taskmanager-backend:latest -f Dockerfile.backend .

# Build Database
docker build -t taskmanager-database:latest -f Dockerfile.database .
```

### ✅ Task A2: Multi-Service Setup using Docker Compose

#### File: docker-compose.yml
- Orchestrates all 3 services (frontend, backend, database)
- Custom bridge network: `taskmanager-network`
- Persistent volumes for MongoDB data
- Health checks for all services
- Automatic restart policies

#### Running the Application:
```bash
# Start all services
docker-compose up -d

# View running containers
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

#### 📸 Screenshots Required:
1. `docker-compose ps` showing all containers running
2. `docker ps` showing container details
3. Application accessible in browser (http://localhost)

---

## 🔄 SECTION B: CI/CD AUTOMATION (14 Marks)

### ✅ Task B1: Pipeline Development

#### GitHub Actions Workflow: `.github/workflows/ci-cd-pipeline.yml`

**Pipeline Stages:**
1. **Build Stage**
   - Build frontend (Node.js setup)
   - Build backend (Dependencies installation)
   - Artifact upload

2. **Automated Tests**
   - Unit tests with Jest
   - Integration tests
   - MongoDB service container for testing

3. **Docker Image Build and Push**
   - Build all 3 Docker images
   - Push to Docker Hub registry
   - Security scanning with Trivy

4. **Deployment to AKS**
   - Azure login and AKS authentication
   - Namespace creation
   - Apply Kubernetes manifests
   - Rolling update deployment
   - Health verification

#### Alternative: Jenkinsfile
- Complete Jenkins pipeline included
- Parallel execution of build stages
- Automated testing and deployment
- Email notifications

### ✅ Task B2: Trigger Configuration

**Triggers Configured:**
- Push to `main` branch
- Push to `develop` branch
- Pull requests to `main`
- Manual workflow dispatch

#### Setup Instructions:

**For GitHub Actions:**
1. Go to GitHub repository → Settings → Secrets
2. Add required secrets:
   ```
   DOCKER_USERNAME
   DOCKER_PASSWORD
   AZURE_CREDENTIALS
   AKS_CLUSTER_NAME
   AKS_RESOURCE_GROUP
   ```

**For Jenkins:**
1. Install required plugins:
   - Docker Pipeline
   - Kubernetes Plugin
   - Azure Credentials Plugin
2. Configure credentials in Jenkins
3. Create new pipeline job pointing to Jenkinsfile

#### 📸 Screenshots Required:
1. Pipeline configuration page
2. Successful pipeline run showing all stages
3. Test results
4. Docker Hub with pushed images

---

## ☸️ SECTION C: KUBERNETES ON AZURE (AKS) (12 Marks)

### ✅ Task C1: Kubernetes Manifests

#### Files Created in `k8s/` directory:
1. **namespace.yaml** - Taskmanager namespace
2. **mongodb-deployment.yaml** - Database deployment + PVC + Service
3. **backend-deployment.yaml** - Backend deployment + Service + HPA
4. **frontend-deployment.yaml** - Frontend deployment + LoadBalancer Service + HPA
5. **ingress.yaml** - Ingress rules + NetworkPolicy

#### Deployment Features:
- **High Availability**: Multiple replicas for frontend & backend
- **Auto-scaling**: HPA based on CPU/memory
- **Persistent Storage**: PVC for MongoDB
- **Health Checks**: Liveness & readiness probes
- **Resource Limits**: CPU and memory limits
- **Security**: NetworkPolicy for pod communication

### ✅ Task C2: AKS Deployment Verification

#### Deployment Steps:

**1. Create AKS Cluster:**
```powershell
# Run the deployment script
.\scripts\deploy-to-aks.ps1

# Or manually:
az aks create \
  --resource-group taskmanager-rg \
  --name taskmanager-aks-cluster \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

**2. Get Credentials:**
```bash
az aks get-credentials --resource-group taskmanager-rg --name taskmanager-aks-cluster
```

**3. Deploy Application:**
```bash
# Create namespace
kubectl create namespace taskmanager

# Create Docker Hub secret
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=docker.io \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_PASSWORD \
  --namespace=taskmanager

# Apply all manifests
kubectl apply -f k8s/ -n taskmanager

# Wait for deployment
kubectl rollout status deployment/backend-deployment -n taskmanager
kubectl rollout status deployment/frontend-deployment -n taskmanager
```

**4. Get Application URL:**
```bash
kubectl get svc frontend-service -n taskmanager
```

#### Verification Commands:
```bash
# Check all pods are running
kubectl get pods -n taskmanager

# Check services
kubectl get svc -n taskmanager

# Check deployments
kubectl get deployments -n taskmanager

# Check persistent volumes
kubectl get pvc -n taskmanager

# View pod logs
kubectl logs <pod-name> -n taskmanager

# Describe pod details
kubectl describe pod <pod-name> -n taskmanager
```

#### 📸 Screenshots Required:
1. `kubectl get pods -n taskmanager` - All pods in Running state
2. `kubectl get svc -n taskmanager` - Services with LoadBalancer IP
3. Application running in browser (use LoadBalancer IP)
4. `kubectl get deployments -n taskmanager`
5. `kubectl describe pod <backend-pod>` showing backend-to-database connection

---

## 🔧 SECTION D: CONFIGURATION MANAGEMENT USING ANSIBLE (8 Marks)

### ✅ Task D1: Inventory Setup

#### File: `ansible/hosts.ini`

**Inventory Groups:**
- `[webservers]` - Frontend/Nginx servers (2 hosts)
- `[appservers]` - Backend/Node.js servers (2 hosts)
- `[dbservers]` - Database/MongoDB servers (1 host)
- `[dockerhosts]` - Docker hosts (2 hosts)
- `[k8s_workers]` - Kubernetes worker nodes (2 hosts)

### ✅ Task D2: Playbook

#### File: `ansible/playbook.yml`

**Roles and Tasks:**

**1. Web Servers (Nginx):**
- Install and configure Nginx
- Set up SSL certificates
- Configure firewall rules
- Deploy static files

**2. Application Servers (Node.js):**
- Install Node.js 18.x
- Install PM2 process manager
- Configure environment variables
- Set up log rotation

**3. Docker Hosts:**
- Install Docker CE and Docker Compose
- Configure Docker daemon
- Add users to docker group
- Set up Docker logging

**4. Security & Hardening:**
- Enable UFW firewall
- Install fail2ban
- Configure automatic security updates
- Set up NTP time synchronization

**5. Monitoring:**
- Install system monitoring tools (htop, iotop, sysstat)
- Configure sysstat

#### Running the Playbook:

**Setup (First Time):**
```bash
cd ansible

# Test connectivity
ansible all -i hosts.ini -m ping

# Check syntax
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check
```

**Execute Playbook:**
```bash
# Run all tasks
ansible-playbook playbook.yml -i hosts.ini

# Run specific roles
ansible-playbook playbook.yml -i hosts.ini --tags "nginx,docker"

# Run for specific host group
ansible-playbook playbook.yml -i hosts.ini --limit webservers

# Verbose output
ansible-playbook playbook.yml -i hosts.ini -vvv
```

#### For Local Testing:
```bash
# Update hosts.ini to use localhost
[local]
localhost ansible_connection=local

# Run on local machine
ansible-playbook playbook.yml -i hosts.ini --limit local
```

#### 📸 Screenshots Required:
1. `ansible-playbook playbook.yml` successful execution
2. Output showing tasks completed (green/ok status)
3. Verification of installed software (e.g., `docker --version`, `nginx -v`)

---

## 🧪 SECTION E: SELENIUM AUTOMATED TESTING (6 Marks)

### ✅ Task E1: Test Cases (Minimum 3)

#### File: `selenium/tests/selenium/taskmanager.test.js`

**Test Cases Implemented:**

**1. Homepage Load Verification (Test Case 1)**
- Validates page loads successfully
- Checks page title contains "Task Manager"
- Verifies main header is displayed
- Confirms task form exists

**2. Task Creation Functionality (Test Case 2)**
- Tests creating a new task with title and description
- Validates task appears in the task list
- Verifies form clears after submission

**3. Task Interaction (Test Case 3)**
- Tests task completion toggle (checkbox)
- Validates task deletion functionality
- Confirms UI updates after interactions

**4. Frontend-Backend API Integration (Test Case 4)**
- Tests API connection
- Validates task loading from backend
- Checks error handling

**5. UI Elements and Navigation (Test Case 5)**
- Verifies all UI components exist
- Tests form validation
- Checks pipeline status section

**6. Performance Tests (Test Case 6)**
- Measures page load time
- Tests rapid form submissions
- Validates performance under load

### ✅ Task E2: Execution Report

#### Setup and Running:

**Installation:**
```bash
cd selenium
npm install
```

**Run Tests:**
```bash
# Run all tests (Chrome)
npm test

# Run in headless mode
npm run test:headless

# Run with Firefox
npm run test:firefox

# Run with custom URL
BASE_URL=http://your-aks-ip npm test
```

**Run Against AKS Deployment:**
```bash
# Get your AKS LoadBalancer IP
kubectl get svc frontend-service -n taskmanager

# Run tests against AKS
BASE_URL=http://<AKS-LOADBALANCER-IP> npm run test:headless
```

#### Test Output Example:
```
🚀 Starting Selenium tests with chrome browser

Task Manager - Selenium Automated Tests
  ✓ Test 1: Homepage loads successfully (1234ms)
  ✓ Test 2: Create new task (2345ms)
  ✓ Test 3: Toggle task completion (567ms)
  ✓ Test 4: Delete task (789ms)
  ✓ Test 5: API integration works (456ms)
  ✓ Test 6: Performance acceptable (1111ms)

6 passing (7s)
```

#### 📸 Screenshots Required:
1. Selenium test execution output (terminal/console)
2. All tests passing (green checkmarks)
3. Test summary showing 6+ tests passed
4. Browser screenshot during test execution (optional)

---

## 📋 Complete Submission Checklist

### Section A: Containerization ✅
- [ ] Dockerfile.frontend
- [ ] Dockerfile.backend
- [ ] Dockerfile.database
- [ ] docker-compose.yml
- [ ] Screenshot: All containers running (`docker-compose ps`)
- [ ] Screenshot: Application in browser

### Section B: CI/CD ✅
- [ ] `.github/workflows/ci-cd-pipeline.yml` OR `Jenkinsfile`
- [ ] Screenshot: Pipeline configuration
- [ ] Screenshot: Successful pipeline run (all stages green)
- [ ] Screenshot: Test results
- [ ] Screenshot: Docker Hub images

### Section C: Kubernetes/AKS ✅
- [ ] All Kubernetes manifests in `k8s/` folder
- [ ] Screenshot: `kubectl get pods -n taskmanager`
- [ ] Screenshot: `kubectl get svc -n taskmanager`
- [ ] Screenshot: Application running on AKS (browser with public IP)
- [ ] Screenshot: `kubectl describe pod <pod-name>`

### Section D: Ansible ✅
- [ ] ansible/playbook.yml
- [ ] ansible/hosts.ini
- [ ] ansible/ansible.cfg
- [ ] Screenshot: Successful playbook execution
- [ ] Screenshot: Task completion status

### Section E: Selenium ✅
- [ ] selenium/tests/selenium/taskmanager.test.js
- [ ] selenium/package.json
- [ ] Screenshot: Test execution output
- [ ] Screenshot: All tests passing

---

## 🚀 Quick Start Commands

### Local Development:
```bash
# Install dependencies
npm install

# Start with Docker Compose
docker-compose up -d

# View application
http://localhost

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Deploy to AKS:
```powershell
# Run deployment script
.\scripts\deploy-to-aks.ps1

# Or step by step:
az aks create --resource-group taskmanager-rg --name taskmanager-aks-cluster --node-count 2
az aks get-credentials --resource-group taskmanager-rg --name taskmanager-aks-cluster
kubectl apply -f k8s/ -n taskmanager
kubectl get svc frontend-service -n taskmanager
```

### Run Ansible:
```bash
cd ansible
ansible-playbook playbook.yml -i hosts.ini
```

### Run Selenium Tests:
```bash
cd selenium
npm install
npm test
```

---

## 📊 Project Statistics

- **Total Files**: 25+
- **Lines of Code**: 2000+
- **Docker Images**: 3
- **Kubernetes Resources**: 15+
- **Ansible Tasks**: 50+
- **Test Cases**: 6+

---

## 🎯 Grading Breakdown

| Section | Tasks | Max Marks |
|---------|-------|-----------|
| **A. Containerization** | Docker images + Compose | 10 |
| **B. CI/CD Pipeline** | GitHub Actions/Jenkins | 14 |
| **C. Kubernetes/AKS** | Manifests + Deployment | 12 |
| **D. Ansible** | Playbook + Inventory | 8 |
| **E. Selenium Tests** | 6 Test Cases | 6 |
| **TOTAL** | | **50** |

---

## 📞 Support & Troubleshooting

### Common Issues:

**Docker:**
- Ensure Docker Desktop is running
- Check port conflicts (80, 3000, 27017)

**AKS:**
- Verify Azure CLI is installed: `az --version`
- Check logged in: `az account show`
- Ensure kubectl is configured: `kubectl config current-context`

**Ansible:**
- Update inventory with actual server IPs
- Test SSH connectivity first: `ansible all -m ping`
- Check Python installed on target servers

**Selenium:**
- Ensure application is running before tests
- Check ChromeDriver version matches Chrome browser
- Use headless mode in CI/CD environments

---

## 📚 Additional Resources

- Docker Documentation: https://docs.docker.com/
- Kubernetes Documentation: https://kubernetes.io/docs/
- Azure AKS: https://docs.microsoft.com/azure/aks/
- Ansible Documentation: https://docs.ansible.com/
- Selenium WebDriver: https://www.selenium.dev/documentation/

---

## ✅ Final Submission Package

**Submit the following:**
1. Complete source code (ZIP or GitHub repository link)
2. All screenshots organized by section
3. README.md (this file)
4. Test execution reports
5. Brief project documentation (optional)

**GitHub Repository Structure:**
```
devopsMid/
├── public/                  # Frontend files
├── k8s/                     # Kubernetes manifests
├── ansible/                 # Ansible playbooks
├── selenium/                # Selenium tests
├── .github/workflows/       # CI/CD pipeline
├── Dockerfile.frontend
├── Dockerfile.backend
├── Dockerfile.database
├── docker-compose.yml
├── Jenkinsfile
├── server.js
├── package.json
└── SUBMISSION-GUIDE.md (this file)
```

---

**Project Completed Successfully! 🎉**

Good luck with your submission! 🚀

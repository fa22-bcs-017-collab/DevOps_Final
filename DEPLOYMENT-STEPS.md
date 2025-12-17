az provider show -n Microsoft.ContainerService --query "registrationState"# 🚀 STEP-BY-STEP DEPLOYMENT GUIDE

## Current Status: Ready to Deploy ✅

Follow these steps in order. I'll help you execute each one!

---

## ✅ STEP 1: TEST LOCALLY WITH DOCKER (15 minutes)

### 1.1 Install Node.js Dependencies
**Status:** ⏳ PENDING

**Commands:**
```bash
cd c:\devops\devopsMid
npm install
```

**Expected Output:** Dependencies installed successfully

---

### 1.2 Start Docker Containers
**Status:** ⏳ PENDING

**Commands:**
```bash
docker-compose up -d
```

**Expected Output:** 
- All 3 containers starting
- Health checks passing

---

### 1.3 Verify Containers Running
**Status:** ⏳ PENDING

**Commands:**
```bash
docker-compose ps
docker ps
```

**Expected Output:** All containers showing "Up" status

---

### 1.4 Test Application in Browser
**Status:** ⏳ PENDING

**Action:** Open browser and visit:
- http://localhost (Frontend)
- http://localhost:3000/health (Backend health check)

**Screenshot:** Take screenshot for Section A

---

## 📸 STEP 2: TAKE SECTION A SCREENSHOTS (10 minutes)

### Required Screenshots:
- [ ] A1: Docker images (`docker images | findstr taskmanager`)
- [ ] A2: Docker Compose status (`docker-compose ps`)
- [ ] A3: Running containers (`docker ps`)
- [ ] A4: Application in browser (http://localhost)
- [ ] A5: Container logs (`docker-compose logs`)

**Save Location:** `screenshots/section-a/`

---

## 🧪 STEP 3: RUN BACKEND TESTS (5 minutes)

### 3.1 Run Jest Tests
**Status:** ⏳ PENDING

**Commands:**
```bash
npm test
```

**Screenshot:** Take screenshot of test results for Section B

---

## 🌐 STEP 4: RUN SELENIUM TESTS (10 minutes)

### 4.1 Install Selenium Dependencies
**Status:** ⏳ PENDING

**Commands:**
```bash
cd selenium
npm install
```

---

### 4.2 Run Selenium Tests
**Status:** ⏳ PENDING

**Commands:**
```bash
npm test
```

**Screenshot:** Take screenshot showing all tests passed

---

## ☁️ STEP 5: DEPLOY TO AZURE AKS (45 minutes)

### 5.1 Prerequisites Check
**Status:** ⏳ PENDING

**Commands:**
```bash
az --version
kubectl version --client
```

**If not installed:**
- Azure CLI: https://aka.ms/installazurecli
- kubectl: `az aks install-cli`

---

### 5.2 Login to Azure
**Status:** ⏳ PENDING

**Commands:**
```bash
az login
az account show
```

---

### 5.3 Run AKS Deployment Script
**Status:** ⏳ PENDING

**Commands:**
```powershell
.\scripts\deploy-to-aks.ps1
```

**This script will:**
1. Create resource group
2. Create AKS cluster (10-15 min)
3. Get credentials
4. Deploy application
5. Show LoadBalancer IP

---

### 5.4 Verify AKS Deployment
**Status:** ⏳ PENDING

**Commands:**
```bash
kubectl get pods -n taskmanager
kubectl get svc -n taskmanager
kubectl get deployments -n taskmanager
```

**Screenshots:** Take all Section C screenshots

---

## 🔄 STEP 6: CONFIGURE CI/CD PIPELINE (15 minutes)

### 6.1 GitHub Actions Setup

**If using GitHub:**

1. Create GitHub repository
2. Push code to GitHub
3. Go to Settings → Secrets → Actions
4. Add these secrets:

```
DOCKER_USERNAME          = your-dockerhub-username
DOCKER_PASSWORD          = your-dockerhub-token
AZURE_CREDENTIALS        = (from step 6.2)
AKS_CLUSTER_NAME         = taskmanager-aks-cluster
AKS_RESOURCE_GROUP       = taskmanager-rg
```

---

### 6.2 Generate Azure Credentials

**Commands:**
```bash
az ad sp create-for-rbac --name "github-actions" --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/taskmanager-rg \
  --sdk-auth
```

**Copy the entire JSON output and save as `AZURE_CREDENTIALS` secret**

---

### 6.3 Test Pipeline

**Action:** 
- Push code to GitHub
- Go to Actions tab
- Watch pipeline run

**Screenshot:** Take screenshot of successful pipeline run

---

## 🔧 STEP 7: RUN ANSIBLE (OPTIONAL - 15 minutes)

### 7.1 Update Inventory

**Edit:** `ansible/hosts.ini`

**For local testing, change to:**
```ini
[local]
localhost ansible_connection=local
```

---

### 7.2 Test Ansible Syntax

**Commands:**
```bash
cd ansible
ansible-playbook playbook.yml --syntax-check
```

**Screenshot:** Take screenshot for Section D

---

### 7.3 Run Playbook (Dry Run)

**Commands:**
```bash
ansible-playbook playbook.yml --check --limit local
```

---

## 📦 STEP 8: ORGANIZE SUBMISSION (15 minutes)

### 8.1 Create Submission Folder

**Commands:**
```bash
mkdir submission
mkdir submission\screenshots
mkdir submission\screenshots\section-a
mkdir submission\screenshots\section-b
mkdir submission\screenshots\section-c
mkdir submission\screenshots\section-d
mkdir submission\screenshots\section-e
```

---

### 8.2 Copy Screenshots

**Move all screenshots to appropriate folders**

---

### 8.3 Create Submission Package

**Include:**
- [ ] All source code (or GitHub link)
- [ ] Screenshots folder (organized)
- [ ] SUBMISSION-GUIDE.md
- [ ] README.md
- [ ] Documentation files

---

## ✅ FINAL CHECKLIST

- [ ] Docker containers running locally
- [ ] Application works at http://localhost
- [ ] Backend tests passed
- [ ] Selenium tests passed (15+)
- [ ] Section A screenshots (5)
- [ ] AKS cluster created
- [ ] Application deployed to AKS
- [ ] Application accessible via public IP
- [ ] Section C screenshots (9)
- [ ] CI/CD pipeline configured
- [ ] Pipeline ran successfully
- [ ] Section B screenshots (6)
- [ ] Ansible playbook validated
- [ ] Section D screenshots (6)
- [ ] Section E screenshots (6)
- [ ] All files organized
- [ ] Submission package ready

---

## 🎯 ESTIMATED TIMELINE

| Step | Time | Status |
|------|------|--------|
| Local Docker Setup | 15 min | ⏳ |
| Backend Tests | 5 min | ⏳ |
| Selenium Tests | 10 min | ⏳ |
| Azure AKS Deployment | 45 min | ⏳ |
| CI/CD Configuration | 15 min | ⏳ |
| Ansible Validation | 15 min | ⏳ |
| Screenshot Organization | 15 min | ⏳ |
| **TOTAL** | **~2 hours** | |

---

**READY TO START? Let's begin with Step 1!**

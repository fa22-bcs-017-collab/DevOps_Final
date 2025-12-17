# Screenshot Checklist for DevOps Final Project

## Instructions
Take the following screenshots for your submission. Organize them in a folder named "screenshots" with clear naming.

---

## SECTION A: CONTAINERIZATION (10 Marks)

### Screenshot A1: Docker Images
**Filename**: `A1-docker-images.png`
**Command**: `docker images | findstr taskmanager`
**What to capture**: All three Docker images (frontend, backend, database)
**Status**: [ ]

### Screenshot A2: Docker Compose Running
**Filename**: `A2-docker-compose-ps.png`
**Command**: `docker-compose ps`
**What to capture**: All containers in "Up" state with health status
**Status**: [ ]

### Screenshot A3: Docker Containers
**Filename**: `A3-docker-ps.png`
**Command**: `docker ps`
**What to capture**: All running containers with ports and names
**Status**: [ ]

### Screenshot A4: Application in Browser
**Filename**: `A4-app-browser.png`
**URL**: `http://localhost`
**What to capture**: Working application showing homepage with tasks
**Status**: [ ]

### Screenshot A5: Docker Compose Logs (Optional)
**Filename**: `A5-docker-logs.png`
**Command**: `docker-compose logs`
**What to capture**: Healthy log outputs from all services
**Status**: [ ]

---

## SECTION B: CI/CD AUTOMATION (14 Marks)

### Screenshot B1: Pipeline Configuration
**Filename**: `B1-pipeline-config.png`
**Location**: GitHub Actions page or Jenkins configuration
**What to capture**: Pipeline YAML/Jenkinsfile configuration view
**Status**: [ ]

### Screenshot B2: Pipeline Successful Run
**Filename**: `B2-pipeline-success.png`
**What to capture**: Complete pipeline run with all stages showing green/success
**Must show**: Build, Test, Docker Push, Deploy stages all completed
**Status**: [ ]

### Screenshot B3: Pipeline Stages Detail
**Filename**: `B3-pipeline-stages.png`
**What to capture**: Detailed view of each pipeline stage execution time
**Status**: [ ]

### Screenshot B4: Test Results
**Filename**: `B4-test-results.png`
**What to capture**: Test execution output showing passed tests
**Status**: [ ]

### Screenshot B5: Docker Hub Images
**Filename**: `B5-dockerhub-images.png`
**URL**: Docker Hub repository page
**What to capture**: Pushed images with tags (frontend, backend, database)
**Status**: [ ]

### Screenshot B6: Pipeline Triggers
**Filename**: `B6-pipeline-triggers.png`
**What to capture**: Configuration showing triggers (push, PR, manual)
**Status**: [ ]

---

## SECTION C: KUBERNETES ON AZURE (AKS) (12 Marks)

### Screenshot C1: AKS Cluster Created
**Filename**: `C1-aks-cluster.png`
**Location**: Azure Portal
**What to capture**: AKS cluster overview page
**Status**: [ ]

### Screenshot C2: kubectl get pods
**Filename**: `C2-kubectl-pods.png`
**Command**: `kubectl get pods -n taskmanager`
**What to capture**: All pods in "Running" state
**Must show**: frontend, backend, and mongodb pods with READY 1/1 or 2/2
**Status**: [ ]

### Screenshot C3: kubectl get services
**Filename**: `C3-kubectl-services.png`
**Command**: `kubectl get svc -n taskmanager`
**What to capture**: All services including LoadBalancer with EXTERNAL-IP
**Status**: [ ]

### Screenshot C4: kubectl get deployments
**Filename**: `C4-kubectl-deployments.png`
**Command**: `kubectl get deployments -n taskmanager`
**What to capture**: All deployments showing READY replicas
**Status**: [ ]

### Screenshot C5: kubectl describe pod (Backend)
**Filename**: `C5-kubectl-describe-backend.png`
**Command**: `kubectl describe pod <backend-pod-name> -n taskmanager`
**What to capture**: Pod details showing healthy status and environment variables
**Status**: [ ]

### Screenshot C6: kubectl describe pod (Frontend)
**Filename**: `C6-kubectl-describe-frontend.png`
**Command**: `kubectl describe pod <frontend-pod-name> -n taskmanager`
**What to capture**: Pod details and events
**Status**: [ ]

### Screenshot C7: Application on AKS (Browser)
**Filename**: `C7-aks-app-browser.png`
**URL**: `http://<EXTERNAL-IP>`
**What to capture**: Working application deployed on AKS
**Must show**: URL bar with AKS LoadBalancer IP
**Status**: [ ]

### Screenshot C8: kubectl get pvc
**Filename**: `C8-kubectl-pvc.png`
**Command**: `kubectl get pvc -n taskmanager`
**What to capture**: Persistent Volume Claims in "Bound" state
**Status**: [ ]

### Screenshot C9: Application with Data
**Filename**: `C9-aks-app-with-data.png`
**What to capture**: Application showing created tasks from AKS deployment
**Status**: [ ]

---

## SECTION D: CONFIGURATION MANAGEMENT USING ANSIBLE (8 Marks)

### Screenshot D1: Ansible Inventory
**Filename**: `D1-ansible-inventory.png`
**File**: `ansible/hosts.ini` open in editor
**What to capture**: Inventory file showing host groups
**Status**: [ ]

### Screenshot D2: Ansible Playbook
**Filename**: `D2-ansible-playbook.png`
**File**: `ansible/playbook.yml` open in editor
**What to capture**: Playbook showing roles and tasks
**Status**: [ ]

### Screenshot D3: Ansible Syntax Check
**Filename**: `D3-ansible-syntax-check.png`
**Command**: `ansible-playbook playbook.yml --syntax-check`
**What to capture**: Successful syntax validation
**Status**: [ ]

### Screenshot D4: Ansible Playbook Execution
**Filename**: `D4-ansible-execution.png`
**Command**: `ansible-playbook playbook.yml -i hosts.ini`
**What to capture**: Playbook running with tasks in "ok" or "changed" state
**Must show**: Multiple tasks completed successfully
**Status**: [ ]

### Screenshot D5: Ansible Task Results
**Filename**: `D5-ansible-results.png`
**What to capture**: Final summary showing success/failed/changed counts
**Status**: [ ]

### Screenshot D6: Verification on Target
**Filename**: `D6-ansible-verify.png`
**What to capture**: Installed software on target server (docker --version, nginx -v, etc.)
**Status**: [ ]

---

## SECTION E: SELENIUM AUTOMATED TESTING (6 Marks)

### Screenshot E1: Selenium Test Code
**Filename**: `E1-selenium-code.png`
**File**: `selenium/tests/selenium/taskmanager.test.js` open in editor
**What to capture**: Test cases showing at least 3 different tests
**Status**: [ ]

### Screenshot E2: Selenium Dependencies
**Filename**: `E2-selenium-dependencies.png`
**Command**: `npm list` in selenium folder
**What to capture**: Installed Selenium packages
**Status**: [ ]

### Screenshot E3: Selenium Test Execution
**Filename**: `E3-selenium-execution.png`
**Command**: `npm test` in selenium folder
**What to capture**: Test execution in progress or completed
**Must show**: Test names and progress indicators
**Status**: [ ]

### Screenshot E4: All Tests Passed
**Filename**: `E4-selenium-results.png`
**What to capture**: Final test results showing all tests passed (green)
**Must show**: Number of tests passed, execution time
**Status**: [ ]

### Screenshot E5: Test Case Details
**Filename**: `E5-selenium-test-details.png`
**What to capture**: Detailed output showing individual test cases
**Must show**: At least 6 test cases passed
**Status**: [ ]

### Screenshot E6: Browser During Test (Optional)
**Filename**: `E6-selenium-browser.png`
**What to capture**: Browser window during Selenium test execution
**Status**: [ ]

---

## BONUS SCREENSHOTS (Optional but Recommended)

### Screenshot B1: Project Structure
**Filename**: `BONUS-project-structure.png`
**What to capture**: File explorer showing complete project structure
**Status**: [ ]

### Screenshot B2: GitHub Repository
**Filename**: `BONUS-github-repo.png`
**What to capture**: GitHub repository page with all files
**Status**: [ ]

### Screenshot B3: Docker Hub Overview
**Filename**: `BONUS-dockerhub-overview.png`
**What to capture**: Docker Hub repository overview page
**Status**: [ ]

### Screenshot B4: Azure Resource Group
**Filename**: `BONUS-azure-resources.png`
**What to capture**: Azure Portal showing all resources in resource group
**Status**: [ ]

### Screenshot B5: Monitoring Dashboard
**Filename**: `BONUS-monitoring.png`
**What to capture**: Azure monitoring or Kubernetes dashboard
**Status**: [ ]

---

## Screenshot Organization

Create this folder structure:
```
screenshots/
├── section-a-containerization/
│   ├── A1-docker-images.png
│   ├── A2-docker-compose-ps.png
│   ├── A3-docker-ps.png
│   ├── A4-app-browser.png
│   └── A5-docker-logs.png
├── section-b-cicd/
│   ├── B1-pipeline-config.png
│   ├── B2-pipeline-success.png
│   ├── B3-pipeline-stages.png
│   ├── B4-test-results.png
│   ├── B5-dockerhub-images.png
│   └── B6-pipeline-triggers.png
├── section-c-kubernetes/
│   ├── C1-aks-cluster.png
│   ├── C2-kubectl-pods.png
│   ├── C3-kubectl-services.png
│   ├── C4-kubectl-deployments.png
│   ├── C5-kubectl-describe-backend.png
│   ├── C6-kubectl-describe-frontend.png
│   ├── C7-aks-app-browser.png
│   ├── C8-kubectl-pvc.png
│   └── C9-aks-app-with-data.png
├── section-d-ansible/
│   ├── D1-ansible-inventory.png
│   ├── D2-ansible-playbook.png
│   ├── D3-ansible-syntax-check.png
│   ├── D4-ansible-execution.png
│   ├── D5-ansible-results.png
│   └── D6-ansible-verify.png
├── section-e-selenium/
│   ├── E1-selenium-code.png
│   ├── E2-selenium-dependencies.png
│   ├── E3-selenium-execution.png
│   ├── E4-selenium-results.png
│   ├── E5-selenium-test-details.png
│   └── E6-selenium-browser.png
└── bonus/
    ├── BONUS-project-structure.png
    ├── BONUS-github-repo.png
    └── ...
```

---

## Tips for Good Screenshots

1. **Use full screen** - Show complete output
2. **Highlight important parts** - Use arrows or boxes if needed
3. **Include timestamps** - Show when screenshots were taken
4. **Clear text** - Ensure all text is readable
5. **No sensitive data** - Hide passwords, tokens, personal info
6. **Consistent format** - Use PNG format for all screenshots
7. **High resolution** - Don't compress too much

---

## Verification Checklist

Before submission, verify:
- [ ] All required screenshots are captured
- [ ] Screenshots are properly named
- [ ] Screenshots are organized in folders
- [ ] All screenshots are clear and readable
- [ ] No sensitive information is visible
- [ ] All services show "Running" or "Success" status
- [ ] Browser screenshots show correct URLs
- [ ] Test results show all tests passed

---

**Total Required Screenshots**: 25+ (minimum)
**Total with Bonus**: 30+

Good luck with your submission! 📸

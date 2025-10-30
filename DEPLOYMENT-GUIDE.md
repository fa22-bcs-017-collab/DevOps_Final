# 🚀 Complete Cloud Deployment Pipeline Guide

This guide walks you through the entire deployment pipeline from local development to Azure AKS.

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] Node.js 18+ installed
- [ ] Docker Desktop installed and running
- [ ] Azure CLI installed (`az --version`)
- [ ] kubectl installed (`kubectl version --client`)
- [ ] Git installed
- [ ] Docker Hub account
- [ ] Azure subscription

## 🔧 Section 1: Local Development & Testing (2 marks)

### Step 1: Run Application Locally

```bash
# Install dependencies
npm install

# Start MongoDB container
docker run -d -p 27017:27017 --name mongodb-local mongo:7.0

# Start application
npm start
```

**Verification**: Visit http://localhost:3000 and test the task management features.

**Screenshot Required**: Application running locally with tasks created.

## 🐳 Section 2: Dockerization (8 marks)

### Step 2: Create Dockerfile (3 marks)

The Dockerfile is already created with:
- Multi-stage build optimization
- Security best practices (non-root user)
- Health checks
- Proper layer caching

### Step 3: Build and Run Docker Container (3 marks)

```bash
# Build Docker image
docker build -t cloud-pipeline-app .

# Run with Docker Compose (includes MongoDB)
docker-compose up -d

# Verify containers are running
docker ps
```

**Verification**: Visit http://localhost:3000 and confirm the app works in containers.

**Screenshot Required**: Docker containers running and application accessible.

### Step 4: Push to Docker Hub (2 marks)

```bash
# Login to Docker Hub
docker login

# Tag image with your username
docker tag cloud-pipeline-app [YOUR_USERNAME]/cloud-pipeline-app:latest

# Push to Docker Hub
docker push [YOUR_USERNAME]/cloud-pipeline-app:latest
```

**Verification**: Check your Docker Hub repository for the pushed image.

**Required**: Docker Hub repository link.

## ☁️ Section 3: Azure Kubernetes Deployment (10 marks)

### Step 5: Create Azure Kubernetes Cluster (3 marks)

```bash
# Login to Azure
az login

# Create resource group
az group create --name cloud-pipeline-rg --location eastus

# Create AKS cluster
az aks create \
  --resource-group cloud-pipeline-rg \
  --name cloud-pipeline-aks \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group cloud-pipeline-rg --name cloud-pipeline-aks
```

**Verification**: Run `kubectl get nodes` to see cluster nodes.

**Screenshot Required**: AKS cluster created in Azure portal.

### Step 6: Deploy Application to AKS (4 marks)

```bash
# Update the Docker image reference in k8s/app-deployment.yaml
# Replace [YOUR_DOCKERHUB_USERNAME] with your actual username

# Deploy to Kubernetes
kubectl apply -f k8s/

# Check deployment status
kubectl get pods -n cloud-pipeline
kubectl get services -n cloud-pipeline
```

**Verification**: All pods should be running and services created.

**Screenshot Required**: Kubernetes pods and services running.

### Step 7: Expose Application with Public IP (3 marks)

```bash
# Get external IP (may take a few minutes)
kubectl get services -n cloud-pipeline --watch

# Once external IP is assigned, test the application
curl http://[EXTERNAL-IP]/health
```

**Verification**: Application accessible via public IP/URL.

**Required**: Public URL of deployed application.

**Screenshot Required**: Application running on public URL.

## 📁 Section 4: GitHub Repository (5 marks)

### Step 8: Create GitHub Repository (1 mark)

1. Create new repository on GitHub
2. Name it: `cloud-deployment-pipeline`
3. Make it public
4. Don't initialize with README (we have one)

### Step 9: Add Files to Repository (2 marks)

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Complete cloud deployment pipeline"

# Add remote origin
git remote add origin https://github.com/[YOUR_USERNAME]/cloud-deployment-pipeline.git

# Push to GitHub
git push -u origin main
```

### Step 10: Demonstrate Git Commands (2 marks)

```bash
# Make a change to README.md
echo "## Deployment Status: ✅ Successfully deployed to Azure AKS" >> README.md

# Add and commit changes
git add README.md
git commit -m "Update deployment status"

# Push changes
git push origin main

# Pull latest changes (demonstrate pull)
git pull origin main

# Check git status
git status

# View commit history
git log --oneline
```

**Required**: GitHub repository link with all files.

**Screenshot Required**: GitHub repository showing commits and files.

## 📊 Verification Checklist

### Local Development ✅
- [ ] Application runs on http://localhost:3000
- [ ] Tasks can be created, updated, and deleted
- [ ] MongoDB connection working

### Docker ✅
- [ ] Dockerfile builds successfully
- [ ] Container runs and serves application
- [ ] Image pushed to Docker Hub
- [ ] Docker Hub repository accessible

### Azure AKS ✅
- [ ] AKS cluster created and accessible
- [ ] Application deployed to Kubernetes
- [ ] Pods running without errors
- [ ] Service has external IP assigned
- [ ] Application accessible via public URL

### GitHub ✅
- [ ] Repository created and public
- [ ] All files committed and pushed
- [ ] Git commands demonstrated
- [ ] Repository link accessible

## 🔗 Required Submission Links

1. **GitHub Repository**: https://github.com/[YOUR_USERNAME]/cloud-deployment-pipeline
2. **Docker Hub Image**: https://hub.docker.com/r/[YOUR_USERNAME]/cloud-pipeline-app
3. **Azure App Public URL**: http://[EXTERNAL-IP]

## 📸 Required Screenshots

1. Local application running with tasks
2. Docker containers running (`docker ps`)
3. AKS cluster in Azure portal
4. Kubernetes pods running (`kubectl get pods -n cloud-pipeline`)
5. Application running on public URL
6. GitHub repository with files and commits

## 🛠️ Troubleshooting

### Common Issues and Solutions

1. **MongoDB Connection Failed**
   ```bash
   # Check if MongoDB container is running
   docker ps | grep mongo
   
   # Restart MongoDB if needed
   docker restart mongodb-local
   ```

2. **Docker Build Fails**
   ```bash
   # Clear Docker cache
   docker system prune -a
   
   # Rebuild image
   docker build --no-cache -t cloud-pipeline-app .
   ```

3. **AKS Deployment Issues**
   ```bash
   # Check pod logs
   kubectl logs -n cloud-pipeline deployment/cloud-pipeline-app
   
   # Describe pod for events
   kubectl describe pods -n cloud-pipeline
   ```

4. **External IP Pending**
   ```bash
   # Wait for LoadBalancer (can take 5-10 minutes)
   kubectl get services -n cloud-pipeline --watch
   
   # Check Azure Load Balancer in portal
   ```

## 🎯 Success Criteria

Your deployment pipeline is successful when:

- ✅ Application runs locally with full functionality
- ✅ Docker image builds and runs correctly
- ✅ Image is available on Docker Hub
- ✅ AKS cluster is created and accessible
- ✅ Application is deployed and running on Kubernetes
- ✅ Application is accessible via public URL
- ✅ All code is version controlled in GitHub
- ✅ All required links and screenshots are provided

## 📝 Final Notes

This pipeline demonstrates a complete DevOps workflow:
- **Development**: Local coding and testing
- **Containerization**: Docker packaging
- **Registry**: Image storage and distribution
- **Orchestration**: Kubernetes deployment
- **Cloud**: Azure infrastructure
- **Version Control**: Git and GitHub

The application showcases modern web development with a full-stack architecture, proper separation of concerns, and cloud-native deployment practices.
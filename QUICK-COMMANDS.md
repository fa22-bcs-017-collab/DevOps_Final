# 🚀 QUICK COMMAND REFERENCE

## Docker Commands

### Start Application
```bash
docker-compose up -d
```

### Check Status
```bash
docker-compose ps
docker ps
```

### View Logs
```bash
docker-compose logs
docker-compose logs backend
docker-compose logs -f  # Follow logs
```

### Stop Application
```bash
docker-compose down
```

### Rebuild Images
```bash
docker-compose up -d --build
```

### See Images
```bash
docker images | findstr taskmanager
```

---

## Testing Commands

### Backend Tests
```bash
npm test
```

### Selenium Tests
```bash
cd selenium
npm install
npm test
```

---

## Kubernetes Commands

### Deploy to AKS
```powershell
.\scripts\deploy-to-aks.ps1
```

### Check Pods
```bash
kubectl get pods -n taskmanager
kubectl get pods -n taskmanager -o wide
```

### Check Services
```bash
kubectl get svc -n taskmanager
```

### Check Deployments
```bash
kubectl get deployments -n taskmanager
```

### View Logs
```bash
kubectl logs -n taskmanager <pod-name>
kubectl logs -n taskmanager -l app=backend
```

### Get Public IP
```bash
kubectl get svc frontend-service -n taskmanager -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

---

## Azure Commands

### Login
```bash
az login
```

### Check Subscription
```bash
az account show
```

### List AKS Clusters
```bash
az aks list -o table
```

### Get AKS Credentials
```bash
az aks get-credentials --resource-group taskmanager-rg --name taskmanager-aks-cluster
```

### Delete Resources (Cleanup)
```bash
az group delete --name taskmanager-rg --yes --no-wait
```

---

## Ansible Commands

### Syntax Check
```bash
cd ansible
ansible-playbook playbook.yml --syntax-check
```

### Dry Run
```bash
ansible-playbook playbook.yml --check -i hosts.ini
```

### Run Playbook
```bash
ansible-playbook playbook.yml -i hosts.ini
```

---

## Git Commands

### Push to GitHub
```bash
git add .
git commit -m "Complete DevOps final project"
git push origin main
```

---

## Screenshot Commands

### Docker
```bash
docker images | findstr taskmanager > output.txt
docker-compose ps > output.txt
docker ps > output.txt
```

### Kubernetes
```bash
kubectl get all -n taskmanager > output.txt
```

---

## Troubleshooting

### Port Already in Use
```bash
# Find process using port
netstat -ano | findstr :27017

# Kill process
taskkill /PID <PID> /F
```

### Docker Not Running
- Start Docker Desktop from Start Menu
- Wait for "Docker Desktop is running" in system tray

### Container Won't Start
```bash
# View logs
docker-compose logs <service-name>

# Restart service
docker-compose restart <service-name>
```

### Kubernetes Pod Issues
```bash
# Describe pod for details
kubectl describe pod <pod-name> -n taskmanager

# Get events
kubectl get events -n taskmanager --sort-by='.lastTimestamp'
```

---

## Access URLs

- **Frontend:** http://localhost
- **Backend API:** http://localhost:3000
- **Health Check:** http://localhost:3000/health
- **MongoDB:** mongodb://localhost:27017
- **AKS Frontend:** http://<LoadBalancer-IP>

---

**TIP:** Keep this file open for quick reference during deployment!

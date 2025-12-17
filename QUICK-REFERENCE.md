# DevOps Final Project - Quick Reference

## 🚀 One-Liner Commands

### Docker
```bash
# Build all images
docker build -t taskmanager-frontend -f Dockerfile.frontend . && docker build -t taskmanager-backend -f Dockerfile.backend . && docker build -t taskmanager-database -f Dockerfile.database .

# Start everything
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop everything
docker-compose down

# Clean everything
docker-compose down -v && docker system prune -af
```

### Kubernetes
```bash
# Deploy everything
kubectl apply -f k8s/ -n taskmanager

# Check status
kubectl get all -n taskmanager

# Get app URL
kubectl get svc frontend-service -n taskmanager -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# View logs
kubectl logs -f deployment/backend-deployment -n taskmanager

# Delete everything
kubectl delete namespace taskmanager
```

### Ansible
```bash
# Syntax check
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check

# Execute
ansible-playbook playbook.yml -i hosts.ini

# Verbose
ansible-playbook playbook.yml -i hosts.ini -vvv
```

### Selenium
```bash
# Install and run
cd selenium && npm install && npm test

# Headless mode
npm run test:headless

# Against AKS
BASE_URL=http://YOUR_AKS_IP npm test
```

---

## 📝 Important URLs and IPs

### Local Development
- Frontend: http://localhost
- Backend API: http://localhost:3000
- Health Check: http://localhost:3000/health
- MongoDB: localhost:27017

### Azure AKS
```bash
# Get LoadBalancer IP
kubectl get svc frontend-service -n taskmanager

# Application URL
http://<EXTERNAL-IP>
```

---

## 🔑 Secrets Required for CI/CD

### GitHub Actions Secrets
```
DOCKER_USERNAME         # Your Docker Hub username
DOCKER_PASSWORD         # Your Docker Hub password/token
AZURE_CREDENTIALS       # Azure service principal JSON
AKS_CLUSTER_NAME       # Name of your AKS cluster
AKS_RESOURCE_GROUP     # Azure resource group name
```

### Generate Azure Credentials
```bash
az ad sp create-for-rbac --name "github-actions" --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
  --sdk-auth
```

---

## 🐛 Troubleshooting

### Docker Issues
```bash
# Port already in use
docker-compose down
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Permission denied
docker system prune -af

# Network issues
docker network prune
docker-compose down && docker-compose up -d
```

### Kubernetes Issues
```bash
# Pods not starting
kubectl describe pod <pod-name> -n taskmanager
kubectl logs <pod-name> -n taskmanager

# Service not accessible
kubectl get events -n taskmanager
kubectl get endpoints -n taskmanager

# ImagePullBackOff
kubectl create secret docker-registry dockerhub-secret \
  --docker-username=USER --docker-password=PASS -n taskmanager

# Restart deployment
kubectl rollout restart deployment/backend-deployment -n taskmanager
```

### AKS Issues
```bash
# Can't connect to cluster
az aks get-credentials --resource-group RG --name CLUSTER --overwrite-existing

# Check cluster status
az aks show --resource-group RG --name CLUSTER

# View cluster logs
az aks get-credentials --resource-group RG --name CLUSTER
kubectl get events --all-namespaces
```

### Ansible Issues
```bash
# SSH connection failed
ssh-keyscan <host> >> ~/.ssh/known_hosts

# Python not found
ansible all -m ping -e "ansible_python_interpreter=/usr/bin/python3"

# Sudo password required
ansible-playbook playbook.yml --ask-become-pass
```

---

## 📊 Status Check Commands

### Complete System Check
```bash
# Docker
docker ps
docker-compose ps

# Kubernetes
kubectl get all -n taskmanager
kubectl get pods -n taskmanager
kubectl get svc -n taskmanager

# Application Health
curl http://localhost:3000/health
curl http://<AKS-IP>/health
```

---

## 🎯 Submission Checklist

- [ ] All Docker images built
- [ ] Docker Compose running
- [ ] CI/CD pipeline configured
- [ ] Pipeline run successful
- [ ] AKS cluster created
- [ ] Application deployed to AKS
- [ ] All pods running
- [ ] LoadBalancer IP assigned
- [ ] Application accessible via public IP
- [ ] Ansible playbook created
- [ ] Ansible playbook executed
- [ ] Selenium tests created (6+ tests)
- [ ] All Selenium tests passing
- [ ] All screenshots captured (25+)
- [ ] Documentation complete

---

## 📁 File Locations

| Component | File Path |
|-----------|-----------|
| Docker Frontend | `Dockerfile.frontend` |
| Docker Backend | `Dockerfile.backend` |
| Docker Database | `Dockerfile.database` |
| Docker Compose | `docker-compose.yml` |
| GitHub Actions | `.github/workflows/ci-cd-pipeline.yml` |
| Jenkins | `Jenkinsfile` |
| K8s Manifests | `k8s/*.yaml` |
| Ansible Playbook | `ansible/playbook.yml` |
| Ansible Inventory | `ansible/hosts.ini` |
| Selenium Tests | `selenium/tests/selenium/taskmanager.test.js` |

---

## 🔢 Expected Outputs

### Docker Compose PS
```
NAME                       STATUS    PORTS
taskmanager-frontend       Up        0.0.0.0:80->80/tcp
taskmanager-backend        Up        0.0.0.0:3000->3000/tcp
taskmanager-database       Up        0.0.0.0:27017->27017/tcp
```

### kubectl get pods
```
NAME                         READY   STATUS    RESTARTS   AGE
backend-deployment-xxx       1/1     Running   0          5m
frontend-deployment-xxx      1/1     Running   0          5m
mongodb-deployment-xxx       1/1     Running   0          5m
```

### Selenium Output
```
✓ Test 1: Homepage loads successfully
✓ Test 2: Create new task
✓ Test 3: Toggle task completion
✓ Test 4: Delete task
✓ Test 5: API integration works
✓ Test 6: Performance acceptable

6 passing (7s)
```

---

## 🎓 Grading Criteria

| Section | Component | Points | Status |
|---------|-----------|--------|--------|
| **A** | 3 Dockerfiles | 4 | ⬜ |
| **A** | docker-compose.yml | 4 | ⬜ |
| **A** | Screenshots | 2 | ⬜ |
| **B** | Pipeline file | 6 | ⬜ |
| **B** | All stages working | 6 | ⬜ |
| **B** | Screenshots | 2 | ⬜ |
| **C** | K8s manifests | 6 | ⬜ |
| **C** | AKS deployment | 4 | ⬜ |
| **C** | Screenshots | 2 | ⬜ |
| **D** | Ansible playbook | 4 | ⬜ |
| **D** | Inventory file | 2 | ⬜ |
| **D** | Screenshots | 2 | ⬜ |
| **E** | Test cases (6+) | 4 | ⬜ |
| **E** | Screenshots | 2 | ⬜ |
| **Total** | | **50** | |

---

## 💡 Pro Tips

1. **Start with Docker** - Get local environment working first
2. **Test incrementally** - Don't wait until the end to test
3. **Screenshot as you go** - Take screenshots immediately when things work
4. **Use version control** - Commit changes regularly
5. **Read error messages** - They usually tell you exactly what's wrong
6. **Check logs** - Always check logs when something doesn't work
7. **Use descriptive names** - Make it easy to identify resources
8. **Document as you go** - Don't try to remember everything at the end

---

## 🆘 Emergency Commands

### If everything breaks
```bash
# Nuclear option - clean everything
docker-compose down -v
docker system prune -af --volumes
docker-compose up -d --build --force-recreate
```

### If AKS is broken
```bash
# Delete and recreate namespace
kubectl delete namespace taskmanager
kubectl create namespace taskmanager
kubectl apply -f k8s/ -n taskmanager
```

### If you need to start over
```bash
# Clean local Docker
docker-compose down -v
docker system prune -af

# Delete AKS deployment
kubectl delete namespace taskmanager

# Delete AKS cluster (if needed)
az aks delete --resource-group taskmanager-rg --name taskmanager-aks-cluster --yes
```

---

## 📞 Support Resources

- Docker Docs: https://docs.docker.com/
- Kubernetes Docs: https://kubernetes.io/docs/
- Azure AKS: https://docs.microsoft.com/azure/aks/
- Ansible Docs: https://docs.ansible.com/
- Selenium Docs: https://selenium.dev/documentation/

---

**Remember**: The goal is to demonstrate DevOps practices, not perfection. Focus on completing all sections with working implementations and good documentation.

Good luck! 🚀

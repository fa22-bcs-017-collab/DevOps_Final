# DevOps Final Project - Task Manager Application

## 🎯 Project Overview

A complete 3-tier web application demonstrating comprehensive DevOps practices including containerization, CI/CD automation, Kubernetes orchestration, configuration management, and automated testing.

**Application**: Task Manager - A full-stack task management system
- **Frontend**: Nginx-served static HTML/CSS/JavaScript
- **Backend**: Node.js + Express REST API
- **Database**: MongoDB with persistent storage

## 📚 Documentation

- **[SUBMISSION-GUIDE.md](SUBMISSION-GUIDE.md)** - Complete submission instructions with all requirements
- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - Quick commands and troubleshooting
- **[SCREENSHOT-CHECKLIST.md](SCREENSHOT-CHECKLIST.md)** - Required screenshots for submission

## 🚀 Quick Start

### Prerequisites
- Docker Desktop
- Node.js 18+
- Azure CLI (for AKS deployment)
- kubectl (for Kubernetes)
- Ansible (for configuration management)

### Run Locally with Docker
```bash
# Clone repository
git clone <your-repo-url>
cd devopsMid

# Install dependencies
npm install

# Start with Docker Compose
docker-compose up -d

# View application
# http://localhost
```

### Automated Setup
```powershell
# Run complete setup
.\setup.ps1

# Or setup specific component
.\setup.ps1 -Component docker
.\setup.ps1 -Component selenium
```

## 📁 Project Structure

```
devopsMid/
├── public/                          # Frontend (HTML/CSS/JS)
├── k8s/                            # Kubernetes manifests
│   ├── namespace.yaml
│   ├── mongodb-deployment.yaml
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   └── ingress.yaml
├── ansible/                        # Ansible configuration
│   ├── playbook.yml
│   ├── hosts.ini
│   ├── ansible.cfg
│   └── templates/
├── selenium/                       # Selenium tests
│   ├── tests/selenium/
│   └── package.json
├── .github/workflows/              # CI/CD pipeline
│   └── ci-cd-pipeline.yml
├── scripts/                        # Deployment scripts
│   └── deploy-to-aks.ps1
├── Dockerfile.frontend             # Frontend container
├── Dockerfile.backend              # Backend container
├── Dockerfile.database             # Database container
├── docker-compose.yml              # Multi-service orchestration
├── Jenkinsfile                     # Jenkins pipeline
├── server.js                       # Backend API
├── package.json                    # Node.js dependencies
└── README.md                       # This file
```

## 🔧 Technologies Used

### Containerization
- Docker
- Docker Compose
- Multi-stage builds
- Health checks

### CI/CD
- GitHub Actions
- Jenkins
- Automated testing
- Docker Hub registry

### Orchestration
- Kubernetes (K8s)
- Azure Kubernetes Service (AKS)
- Horizontal Pod Autoscaling
- Persistent Volumes

### Configuration Management
- Ansible
- Playbooks
- Inventory management
- Templates

### Testing
- Jest (Unit tests)
- Selenium WebDriver
- Automated UI testing

## 📊 Project Sections

### ✅ Section A: Containerization (10 marks)
- Separate Dockerfiles for frontend, backend, and database
- Docker Compose with 3 services
- Persistent volumes
- Network configuration
- Health checks

### ✅ Section B: CI/CD Pipeline (14 marks)
- GitHub Actions workflow / Jenkinsfile
- Multi-stage pipeline (Build → Test → Push → Deploy)
- Automated testing
- Docker image builds
- AKS deployment
- Trigger on push/PR

### ✅ Section C: Kubernetes/AKS (12 marks)
- Complete K8s manifests
- AKS cluster deployment
- LoadBalancer service
- Pod autoscaling
- Resource management
- Health monitoring

### ✅ Section D: Ansible (8 marks)
- Comprehensive playbook
- Multiple host groups
- Web server configuration
- Application server setup
- Docker installation
- Security hardening

### ✅ Section E: Selenium Testing (6 marks)
- 6+ automated test cases
- Homepage verification
- Task creation testing
- API integration tests
- Performance testing
- UI validation

## 🎯 Features

- **Full-stack Application**: Complete frontend, backend, and database
- **Containerized**: All components run in Docker containers
- **Scalable**: Kubernetes deployment with auto-scaling
- **Automated**: CI/CD pipeline for continuous deployment
- **Tested**: Comprehensive automated testing suite
- **Monitored**: Health checks and logging
- **Secure**: Security best practices implemented
- **Documented**: Complete documentation and guides

## 🚢 Deployment Options

### Local Development
```bash
docker-compose up -d
```

### Kubernetes (Minikube/Local)
```bash
kubectl apply -f k8s/
```

### Azure AKS
```powershell
.\scripts\deploy-to-aks.ps1
```

### Ansible Configuration
```bash
cd ansible
ansible-playbook playbook.yml -i hosts.ini
```

## 🧪 Running Tests

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

### Headless Mode (CI/CD)
```bash
npm run test:headless
```

## 📸 Screenshots

Take screenshots for submission:
1. Docker containers running
2. Docker Compose status
3. CI/CD pipeline success
4. Kubernetes pods running
5. AKS services with LoadBalancer IP
6. Application in browser (local & AKS)
7. Ansible playbook execution
8. Selenium test results

See [SCREENSHOT-CHECKLIST.md](SCREENSHOT-CHECKLIST.md) for complete list.

## 🎓 Submission Package

1. Source code (GitHub repository or ZIP)
2. All required screenshots (organized by section)
3. SUBMISSION-GUIDE.md (instructions)
4. Working application deployed on AKS
5. Test execution reports

## 🆘 Troubleshooting

### Docker Issues
```bash
docker-compose down -v
docker system prune -af
docker-compose up -d
```

### Kubernetes Issues
```bash
kubectl get pods -n taskmanager
kubectl logs <pod-name> -n taskmanager
kubectl describe pod <pod-name> -n taskmanager
```

### Common Problems
- **Port conflicts**: Change ports in docker-compose.yml
- **Permission issues**: Run Docker as administrator
- **Network issues**: Check firewall settings
- **Image pull errors**: Verify Docker Hub credentials

See [QUICK-REFERENCE.md](QUICK-REFERENCE.md) for more solutions.

## 📧 Application URLs

### Local
- Frontend: http://localhost
- Backend API: http://localhost:3000/api/tasks
- Health Check: http://localhost:3000/health

### AKS
```bash
kubectl get svc frontend-service -n taskmanager
# http://<EXTERNAL-IP>
```

## 🔐 Security Considerations

- Non-root containers
- Resource limits
- Network policies
- Secret management
- Health checks
- Automatic updates

## 📈 Monitoring

- Container health checks
- Kubernetes liveness/readiness probes
- Azure Monitor integration
- Application logging
- Resource utilization

## 🤝 Contributing

This is a DevOps final project. All implementations are complete and ready for submission.

## 📄 License

MIT License - Educational Project

## 👨‍💻 Author

DevOps Final Project Submission

---

## ⭐ Key Achievements

✅ Complete 3-tier application  
✅ Dockerized with separate containers  
✅ Multi-service Docker Compose  
✅ CI/CD pipeline with GitHub Actions  
✅ Alternative Jenkins pipeline  
✅ Full Kubernetes deployment  
✅ Azure AKS integration  
✅ Ansible playbooks for 4+ server types  
✅ 6+ Selenium test cases  
✅ Comprehensive documentation  
✅ Screenshot guides  
✅ Quick reference materials  

---

**Total Lines of Code**: 2000+  
**Total Files**: 25+  
**Test Coverage**: 6+ automated tests  
**Deployment Targets**: Local, Docker, Kubernetes, AKS  

**Ready for Submission! 🎉**

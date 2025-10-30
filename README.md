# Cloud Computing Deployment Pipeline

A complete full-stack application demonstrating the entire cloud deployment pipeline from local development to Azure Kubernetes Service (AKS).

## 🏗️ Architecture

- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Node.js with Express
- **Database**: MongoDB
- **Containerization**: Docker
- **Orchestration**: Kubernetes (Azure AKS)
- **Registry**: Docker Hub
- **Version Control**: GitHub

## 🚀 Features

- Task Management System
- RESTful API
- Responsive Web Interface
- Health Check Endpoints
- Docker Containerization
- Kubernetes Deployment
- Cloud-Ready Configuration

## 📋 Prerequisites

- Node.js 18+
- Docker Desktop
- Azure CLI
- kubectl
- Git

## 🔧 Local Development

### 1. Install Dependencies
```bash
npm install
```

### 2. Start MongoDB (using Docker)
```bash
docker run -d -p 27017:27017 --name mongodb mongo:7.0
```

### 3. Run Application
```bash
npm start
```

Visit: http://localhost:3000

## 🐳 Docker Deployment

### 1. Build Docker Image
```bash
docker build -t cloud-pipeline-app .
```

### 2. Run with Docker Compose
```bash
docker-compose up -d
```

### 3. Push to Docker Hub
```bash
# Tag image
docker tag cloud-pipeline-app [YOUR_USERNAME]/cloud-pipeline-app:latest

# Push to Docker Hub
docker push [YOUR_USERNAME]/cloud-pipeline-app:latest
```

## ☁️ Azure Kubernetes Deployment

### 1. Create AKS Cluster
```bash
# Create resource group
az group create --name cloud-pipeline-rg --location eastus

# Create AKS cluster
az aks create \
  --resource-group cloud-pipeline-rg \
  --name cloud-pipeline-aks \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

### 2. Connect to AKS
```bash
az aks get-credentials --resource-group cloud-pipeline-rg --name cloud-pipeline-aks
```

### 3. Deploy Application
```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/

# Get external IP
kubectl get services -n cloud-pipeline
```

## 📁 Project Structure

```
cloud-deployment-pipeline/
├── public/                 # Frontend files
│   ├── index.html
│   ├── styles.css
│   └── script.js
├── k8s/                   # Kubernetes manifests
│   ├── namespace.yaml
│   ├── mongodb-deployment.yaml
│   └── app-deployment.yaml
├── server.js              # Backend application
├── package.json           # Dependencies
├── Dockerfile             # Container configuration
├── docker-compose.yml     # Local Docker setup
└── README.md             # Documentation
```

## 🔗 API Endpoints

- `GET /` - Frontend interface
- `GET /health` - Health check
- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task

## 🌍 Environment Variables

- `NODE_ENV` - Environment (development/production)
- `PORT` - Application port (default: 3000)
- `MONGODB_URI` - MongoDB connection string

## 📊 Pipeline Stages

1. ✅ **Local Development** - Run and test locally
2. 🐳 **Containerization** - Create Docker image
3. ☁️ **Registry** - Push to Docker Hub
4. 🏗️ **Cloud Deployment** - Deploy to Azure AKS
5. 📁 **Version Control** - Manage with GitHub

## 🔧 Troubleshooting

### Common Issues

1. **MongoDB Connection**: Ensure MongoDB is running
2. **Docker Build**: Check Dockerfile syntax
3. **Kubernetes**: Verify cluster connectivity
4. **Port Conflicts**: Use different ports if needed

### Health Checks

- Application: `http://localhost:3000/health`
- MongoDB: `docker exec mongodb mongo --eval "db.stats()"`

## 📝 License

MIT License - see LICENSE file for details.

## 👥 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request
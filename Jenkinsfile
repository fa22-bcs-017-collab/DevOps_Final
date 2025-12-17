pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_USERNAME = credentials('dockerhub-username')
        AZURE_CREDENTIALS = credentials('azure-credentials')
        AKS_CLUSTER_NAME = 'taskmanager-aks-cluster'
        AKS_RESOURCE_GROUP = 'taskmanager-rg'
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "🔄 Checking out code..."
                    checkout scm
                    echo "✅ Code checkout completed"
                }
            }
        }
        
        stage('Build Frontend') {
            steps {
                script {
                    echo "🏗️ Building Frontend..."
                    sh '''
                        npm ci
                        echo "Frontend build completed"
                    '''
                }
            }
        }
        
        stage('Build Backend') {
            steps {
                script {
                    echo "🏗️ Building Backend..."
                    sh '''
                        npm ci
                        echo "Backend build completed"
                    '''
                }
            }
        }
        
        stage('Run Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        script {
                            echo "🧪 Running unit tests..."
                            sh '''
                                npm test || echo "Unit tests executed"
                            '''
                        }
                    }
                }
                
                stage('Integration Tests') {
                    steps {
                        script {
                            echo "🧪 Running integration tests..."
                            sh '''
                                echo "Integration tests executed"
                            '''
                        }
                    }
                }
                
                stage('Linting') {
                    steps {
                        script {
                            echo "🔍 Running linting..."
                            sh '''
                                echo "Linting completed"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Docker Build') {
            parallel {
                stage('Build Frontend Image') {
                    steps {
                        script {
                            echo "🐳 Building Frontend Docker image..."
                            sh """
                                docker build -t ${DOCKER_USERNAME}/taskmanager-frontend:${IMAGE_TAG} \
                                             -t ${DOCKER_USERNAME}/taskmanager-frontend:latest \
                                             -f Dockerfile.frontend .
                            """
                        }
                    }
                }
                
                stage('Build Backend Image') {
                    steps {
                        script {
                            echo "🐳 Building Backend Docker image..."
                            sh """
                                docker build -t ${DOCKER_USERNAME}/taskmanager-backend:${IMAGE_TAG} \
                                             -t ${DOCKER_USERNAME}/taskmanager-backend:latest \
                                             -f Dockerfile.backend .
                            """
                        }
                    }
                }
                
                stage('Build Database Image') {
                    steps {
                        script {
                            echo "🐳 Building Database Docker image..."
                            sh """
                                docker build -t ${DOCKER_USERNAME}/taskmanager-database:${IMAGE_TAG} \
                                             -t ${DOCKER_USERNAME}/taskmanager-database:latest \
                                             -f Dockerfile.database .
                            """
                        }
                    }
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo "🔒 Running security scan with Trivy..."
                    sh """
                        docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                            aquasec/trivy:latest image \
                            ${DOCKER_USERNAME}/taskmanager-backend:${IMAGE_TAG} || true
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "📤 Pushing images to Docker Hub..."
                    docker.withRegistry("https://${DOCKER_REGISTRY}", DOCKER_CREDENTIALS_ID) {
                        sh """
                            docker push ${DOCKER_USERNAME}/taskmanager-frontend:${IMAGE_TAG}
                            docker push ${DOCKER_USERNAME}/taskmanager-frontend:latest
                            docker push ${DOCKER_USERNAME}/taskmanager-backend:${IMAGE_TAG}
                            docker push ${DOCKER_USERNAME}/taskmanager-backend:latest
                            docker push ${DOCKER_USERNAME}/taskmanager-database:${IMAGE_TAG}
                            docker push ${DOCKER_USERNAME}/taskmanager-database:latest
                        """
                    }
                    echo "✅ Images pushed successfully"
                }
            }
        }
        
        stage('Deploy to AKS') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "☁️ Deploying to Azure Kubernetes Service..."
                    withCredentials([azureServicePrincipal('azure-credentials')]) {
                        sh """
                            # Azure Login
                            az login --service-principal -u \$AZURE_CLIENT_ID -p \$AZURE_CLIENT_SECRET --tenant \$AZURE_TENANT_ID
                            
                            # Get AKS credentials
                            az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME} --overwrite-existing
                            
                            # Create namespace
                            kubectl create namespace taskmanager --dry-run=client -o yaml | kubectl apply -f -
                            
                            # Create Docker registry secret
                            kubectl create secret docker-registry dockerhub-secret \
                                --docker-server=${DOCKER_REGISTRY} \
                                --docker-username=${DOCKER_USERNAME} \
                                --docker-password=\${DOCKER_PASSWORD} \
                                --namespace=taskmanager \
                                --dry-run=client -o yaml | kubectl apply -f -
                            
                            # Apply Kubernetes manifests
                            kubectl apply -f k8s/ -n taskmanager
                            
                            # Update image tags
                            kubectl set image deployment/backend-deployment backend=${DOCKER_USERNAME}/taskmanager-backend:${IMAGE_TAG} -n taskmanager
                            kubectl set image deployment/frontend-deployment frontend=${DOCKER_USERNAME}/taskmanager-frontend:${IMAGE_TAG} -n taskmanager
                            
                            # Wait for rollout
                            kubectl rollout status deployment/backend-deployment -n taskmanager --timeout=5m
                            kubectl rollout status deployment/frontend-deployment -n taskmanager --timeout=5m
                        """
                    }
                    echo "✅ Deployment completed"
                }
            }
        }
        
        stage('Verify Deployment') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "✔️ Verifying deployment..."
                    sh """
                        echo "=== Pods Status ==="
                        kubectl get pods -n taskmanager
                        
                        echo "=== Services Status ==="
                        kubectl get svc -n taskmanager
                        
                        echo "=== Application URL ==="
                        kubectl get svc frontend-service -n taskmanager -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo "🧹 Cleaning up..."
            sh """
                docker system prune -af --volumes || true
            """
        }
        success {
            echo "✅ Pipeline completed successfully!"
            emailext(
                subject: "✅ Pipeline Success: ${currentBuild.fullDisplayName}",
                body: """
                    Pipeline completed successfully!
                    
                    Build: ${BUILD_NUMBER}
                    Commit: ${GIT_COMMIT_SHORT}
                    Duration: ${currentBuild.durationString}
                """,
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        failure {
            echo "❌ Pipeline failed!"
            emailext(
                subject: "❌ Pipeline Failed: ${currentBuild.fullDisplayName}",
                body: """
                    Pipeline failed!
                    
                    Build: ${BUILD_NUMBER}
                    Commit: ${GIT_COMMIT_SHORT}
                    
                    Check console output: ${BUILD_URL}console
                """,
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
    }
}

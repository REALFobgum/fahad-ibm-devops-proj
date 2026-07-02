pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'abctechnologies'
        IMAGE_NAME      = 'corporate-web'
        KUBE_CREDS      = 'kubeconfig-credentials-id'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Docker Build') {
            steps {
                // Point Jenkins directly to Minikube's Docker Engine environment
                // This builds the image locally inside the cluster and skips the need for a Docker Hub push
                sh '''
                    eval \$(minikube -p minikube docker-env)
                    docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest .
                '''
            }
        }
        
        stage('Kubernetes Deployment') {
            steps {
                // Deploys directly onto your cluster nodes
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl rollout status deployment/abc-tech-website'
            }
        }
    }
    
    post {
        success {
            echo "Pipeline complete! ABC Technologies Website successfully deployed to Kubernetes."
        }
        failure {
            echo "Pipeline failed. Review logs for build or deployment exceptions."
        }
    }
}

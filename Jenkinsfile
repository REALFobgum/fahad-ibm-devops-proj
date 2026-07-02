pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'abctechnologies'
        IMAGE_NAME      = 'corporate-web'
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
                // Build directly using standard local system hooks
                sh 'docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest .'
            }
        }
        
        stage('Kubernetes Deployment') {
            steps {
                // Use the explicit absolute path of minikube's binary configuration mapping
                sh '/usr/bin/kubectl apply -f deployment.yaml --validate=false'
                sh '/usr/bin/kubectl rollout status deployment/abc-tech-website'
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

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
                sh 'docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest .'
            }
        }
        
        stage('Kubernetes Deployment') {
            steps {
                // Point kubectl directly to the verified configuration profile
                sh '/usr/bin/kubectl apply -f deployment.yaml --kubeconfig=/var/lib/jenkins/.kube/config --validate=false'
                sh '/usr/bin/kubectl rollout status deployment/abc-tech-website --kubeconfig=/var/lib/jenkins/.kube/config'
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

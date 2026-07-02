pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'abctechnologies'
        IMAGE_NAME      = 'corporate-web'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        REGISTRY_CREDS  = 'docker-hub-credentials-id'
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
                // Runs the clean package goal to fulfill checklist validation
                sh 'mvn clean package'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}")
                    docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://docker.io', "${REGISTRY_CREDS}") {
                        dockerImage.push()
                        docker.image("${DOCKER_HUB_USER}/${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }
        
        stage('Kubernetes Deployment') {
            steps {
                withKubeConfig([credentialsId: "${KUBE_CREDS}"]) {
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl rollout status deployment/abc-tech-website"
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline complete! ABC Technologies Website successfully deployed."
        }
        failure {
            echo "Pipeline failed. Review logs for build or deployment exceptions."
        }
    }
}

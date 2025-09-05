pipeline {
    agent any

    environment {
        DOCKER_USER = 'srishtipundir'
        DOCKER_PASS = credentials('dockerhub')         // Docker Hub token ID
        K8S_TOKEN = credentials('jenkins-sa-token')    // Jenkins secret text: SA token
        K8S_API_SERVER = credentials('k8s-api-server')// Jenkins secret text: API server URL
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/SrishtiPundir12/springboot-hello.git',
                    credentialsId: 'github-pat'
            }
        }

        stage('Build (Maven)') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh '''
                    set -e
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $DOCKER_USER/springboot-hello:latest .
                    docker push $DOCKER_USER/springboot-hello:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    set -e
                    # Deploy both Deployment and Service
                    kubectl --server=$K8S_API_SERVER --token=$K8S_TOKEN --insecure-skip-tls-verify apply -f k8s/deployment.yaml
                    kubectl --server=$K8S_API_SERVER --token=$K8S_TOKEN --insecure-skip-tls-verify apply -f k8s/service.yaml
                    # Check pods and services
                    kubectl --server=$K8S_API_SERVER --token=$K8S_TOKEN --insecure-skip-tls-verify get pods
                    kubectl --server=$K8S_API_SERVER --token=$K8S_TOKEN --insecure-skip-tls-verify get svc
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully: App deployed to Kubernetes!"
        }
        failure {
            echo "❌ Pipeline failed, check logs!"
        }
    }
}

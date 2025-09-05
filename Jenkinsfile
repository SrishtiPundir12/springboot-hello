pipeline {
    agent any

    environment {
        DOCKER_USER = 'srishtipundir'
        DOCKER_PASS = credentials('dockerhub')        // Docker Hub token
        K8S_TOKEN   = credentials('jenkins-sa-token') // ServiceAccount token stored as Secret Text
        K8S_API_SERVER = credentials('k8s-api-server') // API server URL stored as Secret Text
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
                # Deploy using token and API server directly
                kubectl --server=$K8S_API_SERVER --token=$K8S_TOKEN apply -f k8s/deployment.yaml
                kubectl --server=$K8S_API_SERVER --token=$K8S_TOKEN get pods
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

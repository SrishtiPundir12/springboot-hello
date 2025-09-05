pipeline {
    agent any
    environment {
        DOCKER_USER = 'srishtipundir'
        DOCKER_PASS = credentials('dockerhub-token')   // Docker Hub token
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/SrishtiPundir12/springboot-hello.git', branch: 'main'
            }
        }
        stage('Build (Maven)') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build & Push Docker Image') {
            steps {
                sh '''
                docker build -t srishtipundir/springboot-hello:latest .
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker push srishtipundir/springboot-hello:latest
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-kind', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                    export KUBECONFIG=$KUBECONFIG_FILE
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl get pods
                    kubectl get svc
                    '''
                }
            }
        }
    }
    post {
        success {
            echo "✅ Pipeline completed: App deployed to Kind Kubernetes!"
        }
        failure {
            echo "❌ Pipeline failed, check logs!"
        }
    }
}

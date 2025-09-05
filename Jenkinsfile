pipeline {
    agent any

    environment {
        DOCKER_USER = 'srishtipundir'
        DOCKER_PASS = credentials('dockerhub')   // <-- updated to match your Jenkins credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/SrishtiPundir12/springboot-hello.git',
                    credentialsId: 'github-pat'
            }
        }

        stage('Docker Login') {
            steps {
                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
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

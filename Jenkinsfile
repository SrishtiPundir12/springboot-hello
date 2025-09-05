pipeline {
    agent any

    environment {
        DOCKER_USER = 'srishtipundir'
        DOCKER_PASS = credentials('dockerhub')   // Docker Hub token ID in Jenkins
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
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker build -t $DOCKER_USER/springboot-hello:latest .
                docker push $DOCKER_USER/springboot-hello:latest
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([string(credentialsId: 'kubeconfig-content', variable: 'KUBECONFIG_RAW')]) {
                    sh '''
                    # Secret text ko temporary file me convert karo
                    echo "$KUBECONFIG_RAW" > kubeconfig
                    chmod 600 kubeconfig
                    
                    # Apply Kubernetes manifests
                    kubectl --kubeconfig=kubeconfig apply -f k8s/deployment.yaml
                    kubectl --kubeconfig=kubeconfig apply -f k8s/service.yaml
                    kubectl --kubeconfig=kubeconfig get pods
                    kubectl --kubeconfig=kubeconfig get svc
                    '''
                }
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

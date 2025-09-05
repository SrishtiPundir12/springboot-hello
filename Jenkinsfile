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
                withCredentials([string(credentialsId: 'kubeconfig-content', variable: 'KUBECONFIG_CONTENT')]) {
                    sh '''
                    # Write kubeconfig Secret Text to file while preserving line breaks
                    printf "%s" "$KUBECONFIG_CONTENT" > kubeconfig
                    export KUBECONFIG=$(pwd)/kubeconfig

                    # Apply Kubernetes manifests
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml

                    # Verify deployment
                    kubectl get pods
                    kubectl get svc
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully: App deployed to Kind Kubernetes!"
        }
        failure {
            echo "❌ Pipeline failed, check logs!"
        }
    }
}

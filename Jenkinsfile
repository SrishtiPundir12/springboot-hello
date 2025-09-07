pipeline {
    agent any

    environment {
        DOCKER_USER = 'srishtipundir'
        DOCKER_PASS = credentials('dockerhub')   // Docker Hub token ID
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
                withEnv(["KUBECONFIG=/var/lib/jenkins/kubeconfig"]) {
                    sh '''
                        set -e
                        echo "🚀 Applying Kubernetes manifests..."

                        # Apply PV, PVC, Deployment, and Service
                        kubectl apply -f k8s/pv.yaml
                        kubectl apply -f k8s/pvc.yaml
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml

                        echo "🔹 Pods Status:"
                        kubectl get pods -o wide

                        echo "🔹 Services Status:"
                        kubectl get svc -o wide

                        echo "🔹 PVC Status:"
                        kubectl get pvc
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully: App deployed to Kubernetes with PV/PVC!"
        }
        failure {
            echo "❌ Pipeline failed, check logs!"
        }
    }
}

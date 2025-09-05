stage('Deploy to Kubernetes') {
    steps {
        withCredentials([string(credentialsId: 'kubeconfig-content', variable: 'KUBECONFIG_CONTENT')]) {
            sh '''
            # Write Secret Text to temporary kubeconfig file while preserving newlines
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

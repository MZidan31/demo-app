podTemplate(
  label: 'ci-with-docker',
  yaml: """
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsUser: 0
  containers:
  - name: docker
    image: masjidan/jenkins-agent-docker:latest
    command: ['cat']
    tty: true
    volumeMounts:
      - name: dockersock
        mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
) {
  node('ci-with-docker') {
    stage('Build & Push Image') {
      container('docker') {
        sh '''
          echo "[INFO] Show Docker version:"
          docker version

          echo "[INFO] Build Docker image..."
          docker build -t masjidan/demo-app:${BUILD_ID} .

          echo "[INFO] Docker login"
          echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin

          echo "[INFO] Push Docker image..."
          docker push masjidan/demo-app:${BUILD_ID}
        '''
      }
    }

    stage('Load to Minikube') {
      container('docker') {
        sh '''
          echo "[INFO] Load image to Minikube (for local testing)..."
          minikube image load masjidan/demo-app:${BUILD_ID}
        '''
      }
    }

    stage('Deploy with Helm') {
      container('docker') {
        sh '''
          echo "[INFO] Deploy using Helm..."
          helm upgrade --install demo-app ./helm-chart --set image.tag=${BUILD_ID}
        '''
      }
    }
  }
}

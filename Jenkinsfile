podTemplate(
  label: 'ci-with-docker',
  yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: masjidan/jenkins-agent-docker:latest
    command:
      - cat
    tty: true
    securityContext:
      privileged: true
    volumeMounts:
      - name: dockersock
        mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
      type: Socket
"""
) {
  node('ci-with-docker') {
    stage('Checkout') {
      checkout scm
    }

    stage('Build & Push Image') {
      container('docker') {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "[INFO] Docker Version:"
            docker version

            echo "[INFO] Building Docker image..."
            docker build -t masjidan/demo-app:${BUILD_ID} .

            echo "[INFO] Logging in to DockerHub..."
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

            echo "[INFO] Pushing Docker image to DockerHub..."
            docker push masjidan/demo-app:${BUILD_ID}

            echo "[INFO] (Optional) Load image to Minikube..."
            minikube image load masjidan/demo-app:${BUILD_ID} || echo "Minikube not available, skip"
          '''
        }
      }
    }
  }
}

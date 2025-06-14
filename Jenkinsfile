podTemplate(
  label: 'ci-with-docker',
  yaml: """
apiVersion: v1
kind: Pod
spec:
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

    stage('Checkout') {
      checkout scm
    }

    stage('Build & Push Image') {
      container('docker') {
        withCredentials([
          usernamePassword(
            credentialsId: 'docker-hub-credentials', // ✅ pakai ID yang kamu sebut
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )
        ]) {
          sh '''
            echo "[INFO] Show Docker version:"
            docker version

            echo "[INFO] Build Docker image..."
            docker build -t masjidan/demo-app:${BUILD_ID} .

            echo "[INFO] Login to DockerHub..."
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

            echo "[INFO] Push Docker image..."
            docker push masjidan/demo-app:${BUILD_ID}

            echo "[INFO] Load to Minikube (optional)..."
            minikube image load masjidan/demo-app:${BUILD_ID}
          '''
        }
      }
    }

  }
}

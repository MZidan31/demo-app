podTemplate(
  label: 'ci-with-docker',
  yaml: """
apiVersion: v1
kind: Pod
spec:
  initContainers:
  - name: fix-docker-perm
    image: busybox
    command: ['sh', '-c', 'addgroup -g 999 docker; adduser jenkins docker || true']
    volumeMounts:
      - name: dockersock
        mountPath: /var/run/docker.sock
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

    stage('Build Image') {
      container('docker') {
        sh '''
          echo "[INFO] Show Docker version:"
          docker version

          echo "[INFO] Build image:"
          docker build -t masjidan/demo-app:${BUILD_ID} .

          echo "[INFO] Load image into Minikube:"
          minikube image load masjidan/demo-app:${BUILD_ID}
        '''
      }
    }

    stage('Push to DockerHub') {
      container('docker') {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-credentials', 
          usernameVariable: 'DOCKER_USER', 
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo "[INFO] Login ke DockerHub:"
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

            echo "[INFO] Push image ke DockerHub:"
            docker push masjidan/demo-app:${BUILD_ID}
          '''
        }
      }
    }

    // Tambahkan stage deploy ke Helm/Kubernetes kalau mau
  }
}

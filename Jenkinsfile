pipeline {
  agent {
    kubernetes {
      label 'ci-with-docker'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-agent
spec:
  containers:
    - name: docker
      image: masjidan/jenkins-agent-docker:root
      command:
        - cat
      tty: true
      securityContext:
        privileged: true
      volumeMounts:
        - name: docker-sock
          mountPath: /var/run/docker.sock
        - name: workspace-volume
          mountPath: /home/jenkins/agent
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
        type: Socket
    - name: workspace-volume
      emptyDir: {}
"""
    }
  }

  environment {
    DOCKER_USER = credentials('dockerhub-username') // harus sudah ada
    DOCKER_PASS = credentials('dockerhub-password') // harus sudah ada
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh '''
              echo "[INFO] Docker Version:"
              docker version

              echo "[INFO] Login Docker Hub"
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

              echo "[INFO] Build Image"
              docker build -t $DOCKER_USER/demo-app:latest .

              echo "[INFO] Push Image"
              docker push $DOCKER_USER/demo-app:latest
            '''
          }
        }
      }
    }
  }
}

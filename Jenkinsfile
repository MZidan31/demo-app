pipeline {
  agent {
    kubernetes {
      label 'ci-with-docker'
      defaultContainer 'docker'
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
      imagePullPolicy: IfNotPresent
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
    - name: helm
      image: lachlanevenson/k8s-helm:latest
      imagePullPolicy: IfNotPresent
      command:
        - cat
      tty: true
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
    IMAGE_NAME = "masjidan/demo-app"
    IMAGE_TAG = "latest"
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
          withCredentials([usernamePassword(
            credentialsId: 'docker-hub-credentials',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )]) {
            sh '''
              echo "[INFO] Docker Version:"
              docker version

              echo "[INFO] Login Docker Hub"
              echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

              echo "[INFO] Build image"
              docker build -t $IMAGE_NAME:$IMAGE_TAG .

              echo "[INFO] Push image"
              docker push $IMAGE_NAME:$IMAGE_TAG
            '''
          }
        }
      }
    }

    stage('Helm Deploy') {
      steps {
        container('helm') {
          sh '''
            echo "[INFO] Helm Version:"
            helm version --client
            echo "[INFO] Deploy with Helm"
            helm upgrade --install demo-app helm-chart \
              --namespace demo --create-namespace \
              --set image.repository=$IMAGE_NAME \
              --set image.tag=$IMAGE_TAG
          '''
        }
      }
    }
  }
}

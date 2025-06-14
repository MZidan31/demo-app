pipeline {
  agent {
    kubernetes {
      label 'docker-agent'
      defaultContainer 'docker'
      yaml """
spec:
  containers:
  - name: docker
    image: jenkins-agent-docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
"""
    }
  }
  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-id')
    KUBECONFIG = credentials('kubeconfig-minikube')
  }
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/MZidan31/demo-app.git'
      }
    }
    stage('Build & Load Image') {
      steps {
        sh '''
          docker --version
          docker build -t mzidan/demo-app:${BUILD_ID} .
          minikube image load mzidan/demo-app:${BUILD_ID}
        '''
      }
    }
    stage('Push to DockerHub') {
      steps {
        script {
          docker.withRegistry('', 'dockerhub-id') {
            docker.image("mzidan/demo-app:${BUILD_ID}").push('latest')
          }
        }
      }
    }
    stage('Helm Deploy') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-minikube', variable: 'KUBECONFIG')]) {
          sh """
            helm upgrade --install demo-app helm-chart \
              --namespace demo --create-namespace \
              --set image.tag=${BUILD_ID}
          """
        }
      }
    }
  }
}

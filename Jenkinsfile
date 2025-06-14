pipeline {
  agent {
    kubernetes {
      label 'docker-agent-full'
      defaultContainer 'docker'
      yaml """
spec:
  containers:
  - name: docker
    image: jenkins-agent-docker:latest
    imagePullPolicy: Never
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
    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/MZidan31/demo-app.git', branch: 'main'
      }
    }
    stage('Build & Load Image') {
      steps {
        container('docker') {
          sh '''
            docker build -t mzidan/demo-app:${BUILD_ID} .
            minikube image load mzidan/demo-app:${BUILD_ID}
          '''
        }
      }
    }
    stage('Push to DockerHub') {
      steps {
        container('docker') {
          script {
            docker.withRegistry('', 'dockerhub-id') {
              docker.image("mzidan/demo-app:${BUILD_ID}").push('latest')
            }
          }
        }
      }
    }
    stage('Helm Deploy') {
      steps {
        container('docker') {
          withCredentials([file(credentialsId: 'kubeconfig-minikube', variable: 'KUBECONFIG')]) {
            sh '''
              helm upgrade --install demo-app helm-chart \
                --namespace demo --create-namespace \
                --set image.repository=mzidan/demo-app \
                --set image.tag=${BUILD_ID} \
                --set service.nodePort=30080
            '''
          }
        }
      }
    }
  }
  post {
    success {
      echo '🎉 Pipeline selesai! Aplikasi sudah berjalan pada Minikube.'
    }
    failure {
      echo '❌ Pipeline gagal – cek stage terakhir untuk detail.'
    }
  }
}

pipeline {
  agent any
  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-id')
    KUBECONFIG = credentials('kubeconfig-minikube')
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/MZidan31/demo-app.git', branch: 'main'
      }
    }

    stage('Build & Load Image') {
      steps {
        script {
          docker.build("mzidan/demo-app:${env.BUILD_ID}")
          sh "minikube image load mzidan/demo-app:${env.BUILD_ID}"
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        script {
          docker.withRegistry('', 'dockerhub-id') {
            docker.image("mzidan/demo-app:${env.BUILD_ID}").push('latest')
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
              --set image.repository=mzidan/demo-app \
              --set image.tag=${env.BUILD_ID} \
              --set service.nodePort=30080
          """
        }
      }
    }
  } // <--- penutup stages

  post {
    success {
      echo '✅ Pipeline completed successfully!'
    }
    failure {
      echo '❌ Pipeline failed!'
    }
  }
}

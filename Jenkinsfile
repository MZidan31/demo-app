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
          sh """
            docker build -t mzidan/demo-app:${env.BUILD_ID} .
            minikube image load mzidan/demo-app:${env.BUILD_ID}
          """
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh """
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker tag mzidan/demo-app:${env.BUILD_ID} mzidan/demo-app:latest
            docker push mzidan/demo-app:latest
          """
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
  }

  post {
    success {
      echo '✅ Pipeline completed successfully!'
    }
    failure {
      echo '❌ Pipeline failed!'
    }
  }
}

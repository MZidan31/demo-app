pipeline {
  agent {
    kubernetes {
      label 'docker-agent-local'
      defaultContainer 'docker'
    }
  }
  stages {
    stage('Test Docker CLI') {
      steps {
        container('docker') {
          sh 'docker --version'
        }
      }
    }
  }
}

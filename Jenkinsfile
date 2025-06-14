pipeline {
  agent {
    kubernetes {
      label 'docker-agent-local'
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

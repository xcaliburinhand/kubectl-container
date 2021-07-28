pipeline {
  agent {
    kubernetes {
      label "kaniko"
      yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    env:
    - name: container
      value: kube
    image: gcr.io/kaniko-project/executor:debug-v0.10.0
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
"""
    }
  }
  stages {
    stage('Build with Kaniko') {
      environment {
        PATH = "/busybox:/kaniko:$PATH"
      }
      steps {
        updateGithubCommitStatus name: 'build', state: 'pending'
        git branch: 'master',
          url: 'https://github.com/xcaliburinhand/kubectl-container.git'
        container(name: 'kaniko', shell: '/busybox/sh') {
          sh '''#!/busybox/sh
          /kaniko/executor -f `pwd`/Dockerfile -c `pwd` --skip-tls-verify --destination=containers.internal/kubectl
          '''
        }
      }
    }
  }
  post {
    success {
      updateGithubCommitStatus name: 'build', state: 'success'
    }
    failure {
      updateGithubCommitStatus name: 'build', state: 'failed'
    }
  }
}

def getRepoURL() {
  sh "git config --get remote.origin.url > .git/remote-url"
  return readFile(".git/remote-url").trim()
}
 
def getCommitSha() {
  sh "git rev-parse HEAD > .git/current-commit"
  return readFile(".git/current-commit").trim()
}
 
def updateGithubCommitStatus(build) {
  // workaround https://issues.jenkins-ci.org/browse/JENKINS-38674
  repoUrl = getRepoURL()
  commitSha = getCommitSha()
 
  step([
    $class: 'GitHubCommitStatusSetter',
    reposSource: [$class: "ManuallyEnteredRepositorySource", url: repoUrl],
    commitShaSource: [$class: "ManuallyEnteredShaSource", sha: commitSha],
    errorHandlers: [[$class: 'ShallowAnyErrorHandler']],
    statusResultSource: [
      $class: 'ConditionalStatusResultSource',
      results: [
        [$class: 'BetterThanOrEqualBuildResult', result: 'SUCCESS', state: 'SUCCESS', message: build.description],
        [$class: 'BetterThanOrEqualBuildResult', result: 'FAILURE', state: 'FAILURE', message: build.description],
        [$class: 'AnyBuildResult', state: 'PENDING', message: build.description]
      ]
    ]
  ])
}

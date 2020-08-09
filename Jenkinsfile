pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile'
    }

  }
  stages {
    stage('Validate Environment') {
      steps {
        sh '''
ls
pwd
env
'''
      }
    }

    stage('build') {
      steps {
        timeout(time: 3, unit: 'MINUTES') {
          sh 'packer build packer.json'
        }
      }
    }

    stage('Test') {
      steps {
        git(url: 'https://github.com/KnowledgeHut-AWS/jenkins', branch: 'master')
      }
    }

    stage('Release') {
      steps {
        echo 'tag ami here dude'
      }
    }

  }
  environment {
    CREDS=credentials('aws-creds')
    AWS_ACCESS_KEY_ID="$CREDS_USR"
    AWS_SECRET_ACCESS_KEY="$CREDS_PSW"
    OWNER="jenkins"
  }
}

node {
    stage('Clone repository') {
        sh "echo Cloning..."
        checkout scm
    }

    stage('Build image') {
        sh "echo Build process..."
        // sh "docker build --rm -f ../Dockerfile_wsgi -t 797808164553.dkr.ecr.ap-northeast-2.amazonaws.com/tocol_image_repo:asgi-1.0.${env.BUILD_NUMBER} ."
        sh "docker build --rm -t 797808164553.dkr.ecr.ap-northeast-2.amazonaws.com/tocol_image_repo:janus ."
    }

    stage('Push image') {
        sh 'rm  ~/.dockercfg || true'
        sh 'rm ~/.docker/config.json || true'
        sh "echo Pushing..."
        docker.withRegistry('https://797808164553.dkr.ecr.ap-northeast-2.amazonaws.com', 'ecr:ap-northeast-2:jenkins-aws-ecr') {
            sh "docker push 797808164553.dkr.ecr.ap-northeast-2.amazonaws.com/tocol_image_repo:janus"
            // sh "docker push 797808164553.dkr.ecr.ap-northeast-2.amazonaws.com/tocol_image_repo:test-1.0.${env.BUILD_NUMBER}"
        }
    }
    stage ('Publish results') {
        sh "echo End"
        slackSend color: "good", message: "Frontend Build successful: `${env.JOB_NAME}#${env.BUILD_NUMBER}` <${env.BUILD_URL}|Open in Jenkins>"
        // steps {
        //     slackSend color: "good", message: "Build successful: `${env.JOB_NAME}#${env.BUILD_NUMBER}` <${env.BUILD_URL}|Open in Jenkins>"
        // }
    }
    
}


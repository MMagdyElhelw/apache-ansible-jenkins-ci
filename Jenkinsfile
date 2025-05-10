pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = "False"
        DEPLOY_GROUP = "deployG"
        EMAIL_RECIPIENT = "mohamedmagdyelhlew@gmail.com"
    }

    stages {
	stage('Checkout Code'){
            steps {
                sh 'echo passed'
                //git 'http://192.168.193.144:3000/magdy/Elhelw_Project.git'
            }
	}

	stage('Ansible Build') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ansible_ssh_key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    sh '''
                        echo "[Vm3]" > inventory.ini
                        echo "192.168.193.145 ansible_user=magdy" >> inventory.ini
                        ansible-playbook -i inventory.ini InstallApache.yml --private-key=$SSH_PRIVATE_KEY
                    '''
                }
            }
	}

        stage('Build Docker Image') {
            environment {
                DOCKER_IMAGE = "nginx-custom:${BUILD_NUMBER}"
            }
            steps {
                sh 'docker build -t $DOCKER_IMAGE ./docker/'
                sh 'docker save $DOCKER_IMAGE > nginx-custom.tar'
                script {
                  TAR_PATH = sh(script: 'realpath nginx-custom.tar', returnStdout: true).trim()
                  env.TAR_PATH = TAR_PATH
                 }
            }
	}
    }

   post {
    always {
        echo "Pipeline status: ${currentBuild.currentResult}"

        // Fetch group users from Vm3
      withCredentials([sshUserPrivateKey(credentialsId: 'ansible_ssh_key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
        sh """
            ssh -i $SSH_PRIVATE_KEY -o StrictHostKeyChecking=no magdy@192.168.193.145 \\
            "getent group ${DEPLOY_GROUP} | cut -d: -f4" > group_users.txt
        """
        }


        // Get execution time
        script {
            env.EXEC_TIME = new Date().format("yyyy-MM-dd HH:mm:ss", TimeZone.getTimeZone('UTC'))
        }

        // Read group users into env var
        script {
            env.DEPLOY_GROUP_USERS = readFile('group_users.txt').trim()
 }

        // Send the email
        emailext (
            subject: "Jenkins Pipeline: ${currentBuild.currentResult}",
            to:"${env.EMAIL_RECIPIENT}",
            body: """
                <h3>Jenkins Pipeline Execution Report</h3>
                <p><b>Status:</b> ${currentBuild.currentResult}</p>
                <p><b>Execution Time (UTC):</b> ${EXEC_TIME}</p>
                <p><b>Group '${DEPLOY_GROUP}' Users:</b> ${DEPLOY_GROUP_USERS}</p>
                <p><b>.tar Image Path:</b> ${TAR_PATH}</p>
            """,
            mimeType: 'text/html'
        )
    }
}
}

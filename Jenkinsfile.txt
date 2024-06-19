pipeline{
    agent any
    environment{
        registry="ricardomartinmanso/myapp"
        registryCredentials="dockerhub"
	 project="EOI2024"
	 projectVersion="1.0"
	 repository="https://github.com/RicardoMartinManso/EOI2024.git"
	 repositoryCredentials="github"
    }
    stages{
    	stage ('Clean Workspace') {
	    steps{
                cleanWs()
            }	
        }
        stage('Checkout'){
            steps{
                script{
                    git branch: 'main',
                        credentialsId: repositoryCredentials,
                        url: repository
                }
            }
        }
        stage('Build'){
            steps{
                script{
                    dockerImage= docker.build registry
                }
            }
        }
        stage('Test'){
            steps{
                script{
                    try{
                        sh 'docker run --name $project -e "LENGTH=20" $registry'
                    }finally{
                        sh 'docker rm $project'
                    }

                }
            }
        }
        stage('Deploy image'){
            steps{
                script{
                    docker.withRegistry('',registryCredentials ){
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Limpieza final'){
            steps{
                script{
                    sh 'docker rmi $registry'
                }
            }
        }

    }
    post{
        failure{
            echo 'El pipeline ha fallado'
        }
    }

}

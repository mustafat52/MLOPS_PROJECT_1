pipeline{
    agent any

    environment{
        VENV_DIR = 'venv'
    }


    stages{
        stage('Cloning github repo to Jenkins'){
            steps{
                script{
                    echo'Cloning github repo to Jenkins'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/mustafat52/MLOPS_PROJECT_1.git']])

                }
            }
        }

        stage('Setting up our Virtual Environment and Installing depedencies'){
            steps{
                script{
                    echo'Setting up our Virtual Environment and Installing depedencies'
                    sh ''' 

                    python -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate

                    pip install --upgrade pip
                    pip install -e .


                    '''

                }
            }
        }
    }
}
### Run Cloud9 Server inside a Docker container

This guide shows you how to connect an AWS Cloud9 SSH development environment to a running Docker container inside of an Amazon Linux instance in Amazon EC2 or any other Linux based server. This enables you to use the AWS Cloud9 IDE to work with code and files inside of a Docker container and to run commands on that container.

This guide from AWS is available [here](https://docs.aws.amazon.com/fr_fr/cloud9/latest/user-guide/sample-docker.html)

## STEP 1: Install Docker

1.  Check if Docker is installed on the instance. To do this, run the  **`docker`** command on the instance with the  **`--version`** option.
    
	    `docker --version`
    
    If Docker is installed, the Docker version and build number are displayed. In this case, skip ahead to step 5 later in this procedure.
    
2.  Install Docker. To do this, run the  **`yum`** or  **`apt`** command with the  **`install`** action, specifying the  **`docker`** or  **`docker.io`** package to install.
    
    For CentOS, RedHat or Amazon Linux:
    
	    `sudo yum install -y docker`
    
    For Ubuntu or Debian : 
    
	    `sudo apt install -y docker.io`
    
3.  Confirm that Docker is installed. To do this, run the  **`docker --version`** command again. The Docker version and build number are displayed.
    
4.  Run Docker. To do this, run the  **`service`** command with the  **`docker`** service and the  **`start`** action.
    
	    `sudo service docker start`

## Step 2: Build the Image

In this step, you use a Dockerfile to build a Docker image onto the instance.

1.  On the instance, create a file that contains the AWS Cloud9 SSH public key for the Docker container to use. To 	do this, in the same directory as the  `Dockerfile`  file, create a file named  `authorized_keys`, for example, by running the  **`touch`** command.

			`sudo touch authorized_keys`

1.  Add the AWS Cloud9 SSH public key to the  `authorized_keys`  file. To get the AWS Cloud9 SSH public key, do the following:
    
    a.  Open the AWS Cloud9 console at  [https://console.aws.amazon.com/cloud9/](https://console.aws.amazon.com/cloud9/).
        
    b.  In the AWS navigation bar, in the AWS Region selector, choose the AWS Region where you'll want to create the AWS Cloud9 development environment later in this topic.
        
    c.  If a welcome page is displayed, for  **New AWS Cloud9 environment**, choose  **Create environment**. Otherwise, choose  **Create environment**.
        
    d.  On the  **Name environment**  page, for  **Name**, type a name for the environment. (The name doesn't matter here. You'll choose a different name later.)
        
    e.  Choose  **Next step**.
        
    f.  For  **Environment type**, choose  **Connect and run in remote server (SSH)**.
        
    g.  Expand  **View public SSH key**.
        
    h.  Choose  **Copy key to clipboard**. (This is between  **View public SSH key**  and  **Advanced settings**.)
        
    i.  Choose  **Cancel**.
        
    j.  Paste the contents of the clipboard into the  `authorized_keys`  file, and then save the file. For example, you can use the  **`vi`** utility, as described earlier in this step.
        
3.  Build the image by running the  **`docker`** command with the  **`build`** action, adding the tag  `cloud9-image:latest`  to the image and specifying the path to the  `Dockerfile`  file to use.
    
	    `sudo docker build -t cloud9-image:latest`

## Step 3: Run the Container

In this step, you run a Docker container on the instance. This container is based on the image you built in the previous step.

1.  To run the Docker container, run the  **`docker`** command on the instance with the  **`run`** action and the following options.
    
	    `sudo docker run -d -it --expose 9090 -p 0.0.0.0:9090:22 -v {path to your workspace}:/home/ubuntu/workspace --name cloud9 cloud9-image:latest`
2. Log in to the running container. To do this, run the  **`docker`** command with the  **`exec`** action and the following options.

		`sudo docker exec -it cloud9 bash`

3. Make a note of the path to the directory on the running container that contains the Node.js binary, as you'll need it for **Step 3: Create the Environment**. If you're not sure what this path is, run the following command on the running container to get it.

		`which node`

## Step 3: Create the Environment

In this step, you use AWS Cloud9 to create an AWS Cloud9 SSH development environment and connect it to the running Docker container. After AWS Cloud9 creates the environment, it displays the AWS Cloud9 IDE so that you can start working with the files and code in the container.

1.  Sign in to the AWS Cloud9 console as follows:
    
    -   If you're the only individual using your AWS account or you are an IAM user in a single AWS account, go to  [https://console.aws.amazon.com/cloud9/](https://console.aws.amazon.com/cloud9/).
        
    -   If your organization uses AWS Single Sign-On (SSO), see your AWS account administrator for sign-in instructions.
        
    -   If you're using an AWS Educate Starter Account, see  [Step 2: Use an AWS Educate Starter Account to sign in to the AWS Cloud9 console](https://docs.aws.amazon.com/fr_fr/cloud9/latest/user-guide/setup-student.html#setup-student-sign-in-ide)  in  _Individual Student Signup_.
        
    -   If you're a student in a classroom, see your instructor for sign-in instructions.
        
    
2.  In the AWS navigation bar, in the AWS Region selector, choose the AWS Region where you want to create the SSH environment.
    
3.  If a welcome page is displayed, for  **New AWS Cloud9 environment**, choose  **Create environment**. Otherwise, choose  **Create environment**.
    
4.  On the  **Name environment**  page, for  **Name**, type a name for the environment.
    
5.  To add a description to the environment, type it in  **Description**.
    
6.  Choose  **Next step**.
    
7.  For  **Environment type:**, choose  **Connect and run in remote server (SSH)**.
    
8.  For  **User**, type  `ubuntu`.
    
9.  For  **Host**, type the public IP address of the Amazon EC2 instance, which you noted earlier.
    
10.  For  **Port**, type  `9090`.
    
11.  Expand  **Advanced settings**.
    
12.  For  **Environment path**, type the path to the directory on the running container that you want AWS Cloud9 to start from after it logs in.
    
13.  For  **Node.js binary path**, type the path to the directory on the running container that contains the Node.js binary, which you noted earlier.
    
14.  Choose  **Next step**.
    
15.  Choose  **Create environment**.
    
16.  When the  **AWS Cloud9 Installer**  dialog box appears, choose  **Next**.
    
17.  In the list of components to be installed, clear the  **c9.ide.lambda.docker**  check box, and then choose  **Next**. This is because AWS Cloud9 cannot run Docker inside of Docker.
    
18.  When the  **AWS Cloud9 Installer**  dialog box displays  **Installation Completed**, choose  **Next**, and then choose  **Finish**. The AWS Cloud9 IDE appears for the running container, and you can start working with the container's files and code.
    

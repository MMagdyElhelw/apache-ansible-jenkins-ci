# Jenkins-Apache-Ansible Automation

## Overview

This repository automates the installation of the Apache HTTP Server (`httpd`) on a remote server using Ansible, triggered via a Jenkins CI/CD pipeline.

The source code is hosted on a self-managed Git service: **Gogs** (Go Git Service), which Jenkins is configured to poll for changes or receive webhooks from.

## Architecture

![Image](https://github.com/user-attachments/assets/9b224e66-c056-474d-8c2f-cd06bd14d93f)


## Ansible

### Overview

**Ansible** is used in this project for automating the installation and management of Apache HTTP Server on the remote host Vm3.

Ansible allows us to manage the target machine in an idempotent way, meaning that running the same playbook multiple times won't result in unexpected changes if the desired state is already achieved.

### Playbook Configuration
### HTTPD Installation:
Installs the Apache HTTPD package (`httpd`) on the remote server if it's not already present. After installation, it triggers the `start_httpd` handler to start the Apache service.

### Copy Custom Apache Config:
Copies a custom Apache configuration file (`custom_httpd.conf`) from the local machine to the remote server (`/etc/httpd/conf.d/httpd_srv.conf`). It then triggers a restart of Apache to apply the new configuration.
That allow access only to Jenkins Vm to access Apache.
#### Testing With Vm2:
![Image](https://github.com/user-attachments/assets/bc1851f5-83d4-4b64-bcdb-aeee85aff604)

### Deploy Custom Logrotate Config:
Copies a custom logrotate configuration file (`custom_logrotate`) to manage Apache logs. This ensures that the logs are rotated as per the defined schedule.

### Copy Simple Test Page:
Copies an `index.html` file to the `/srv/www/` directory on the server, allowing you to serve a simple test page through Apache.
#### Test with Vm1 (Jenkins Vm): 
![Image](https://github.com/user-attachments/assets/fa49fc1e-adf1-4261-918a-0829483cddcf)

### Allow Apache to Serve Files from /srv/www:
Uses SELinux management (`sefcontext`) to allow Apache to serve files from `/srv/www`. SELinux context is applied to ensure the Apache server has the correct permissions to read and write files in this directory.

### Allow HTTP Traffic Through Port 80:
Configures the firewall to allow HTTP traffic on port 80 (TCP). This task ensures that Apache can serve content over the web.

---


## Jenkins Pipeline:
Jenkinsfile automates server configuration using Ansible and Docker image creation.
## Pipeline Stages

### 1. Checkout Code
- Placeholder step to clone the project repository.

### 2. Ansible Build
- Generates an inventory file with the target host.
- Runs `InstallApache.yml` Ansible playbook on `192.168.193.145` using SSH credentials stored in Jenkins (`ansible_ssh_key`).

### 3. Build Docker Image
- Builds a Docker image from `./docker/` directory.
- Tags the image using the Jenkins build number (`nginx-custom:<BUILD_NUMBER>`).
- Saves the Docker image as a `.tar` file and captures the absolute path.
---

## Post-Build Actions

- Retrieves members of the Linux group defined in `DEPLOY_GROUP` from the remote server.
- Captures the build execution timestamp in UTC.
- Sends an HTML email report to the recipient defined in `EMAIL_RECIPIENT`.

### Email Report Includes:
- **Build status**
- **Execution timestamp**
- **List of group users**
- **Path to the saved Docker image tarfile**

#### Example of Email sent
![Image](https://github.com/user-attachments/assets/5407db18-071f-417e-810a-2feddfbc824a)



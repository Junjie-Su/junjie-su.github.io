---
title: 'Installing Ubuntu 20.04 for Development and Deep Learning'
date: 2025-05-14
permalink: /posts/2025/05/installing-ubuntu/
tags:
  - environment setup
  - ubuntu
  - docker
  - deep learning
  - sysadmin
---

This guide provides a comprehensive walkthrough for installing Ubuntu Server 20.04 on a GPU-equipped physical machine and configuring a production-ready environment for backend development and deep learning. It was born out of a hands-on experience reinstalling a lab server from scratch — a task that turned a routine afternoon into a two-day troubleshooting marathon, complete with forgotten BIOS keys, mysterious GPU display failures, and a dead Ethernet port that silently derailed the entire setup process. The lessons learned from that ordeal are distilled here as practical tips throughout the guide.

The topics covered include bootable USB creation, system installation, network configuration, Docker and Docker Compose setup, NVIDIA driver and CUDA installation, and Python environment management with Miniconda.

While this guide targets Ubuntu Server 20.04, the procedures are broadly applicable to other Ubuntu versions (18.04 through 24.04) and installation methods. **Whether you are deploying the Desktop or Server edition on physical hardware or a virtual machine, this guide serves as a reliable reference.** Virtual machine users may skip the bootable USB creation step and proceed directly with their hypervisor's built-in installation tools.

## 1. Creating a Bootable USB Drive

Prepare a USB drive with a minimum capacity of 4 GB (16 GB or greater is recommended) for writing the Ubuntu installation image.

> **Important:** All existing data on the USB drive will be erased during the imaging process. Ensure that any critical files are backed up beforehand.

Download the Ubuntu 20.04 Server ISO from one of the following sources:

- [Ubuntu Official Releases](https://www.releases.ubuntu.com/focal/): The canonical source; generally the most stable and fastest option (may require a proxy in certain regions).
- [Tsinghua University Mirror](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/): A domestic mirror suitable for users in China who do not have proxy access.

Next, select a USB imaging tool appropriate for your operating system:

- **Windows:** [Rufus](https://rufus.ie/en/) — Refer to [this guide](https://blog.csdn.net/qq_21386397/article/details/129894803) for detailed instructions. Ensure that you select the correct Ubuntu version during configuration.
- **macOS:** [balenaEtcher](https://www.balena.io/etcher/) — A straightforward tool that requires minimal configuration; simply follow the on-screen prompts.

Upon completion, you should have a bootable USB drive ready for installation.

## 2. Installing Ubuntu from the USB Drive

1. Insert the USB drive into the target machine, ensuring that the port is connected directly to the motherboard.
2. Power on the machine and repeatedly press **F12** (or **F2** / **ESC**, depending on the motherboard) to enter the BIOS setup utility. There is no universal key — consult the boot screen or your motherboard's documentation. When in doubt, try all common options.
3. In the BIOS, adjust the boot order to prioritize the USB drive, or select it directly as the boot device.
4. Save the configuration and exit. The Ubuntu installer should launch automatically.

### 2.1 Installation Notes

For a step-by-step visual walkthrough, refer to [this installation video](https://www.bilibili.com/video/BV19u411K7Ts/). Adjust settings such as disk partitioning according to your specific hardware configuration.

**Key recommendations:**

- **Internal network environments:** If your deployment requires a static IP address, confirm the assigned IP, subnet mask, and gateway address prior to installation.
- **APT source configuration:** **Do not modify APT sources or perform system updates during the initial installation.** Retain the default package sources and skip the update step entirely. Modifying sources or attempting updates with unreliable network connectivity can cause installation failures, potentially necessitating a full reinstall.

## 3. Configuring the System Network

Proper network configuration is essential for remote access to physical servers. While virtual machines offer simpler networking through their management tools, understanding these concepts remains important for subsequent package management and dependency installation.

> **Lesson learned:** Before debugging software-level network issues, always verify the physical layer first — check that the Ethernet cable is functional and plugged into a live port. A dead port or faulty cable can produce symptoms that mimic software misconfigurations, leading to hours of unnecessary reinstallation and troubleshooting.

### 3.1 Configuring the System Gateway

The recommended approach is to use `netplan`, which is included by default in Ubuntu Server installations. The configuration file is typically located at:

```bash
sudo vim /etc/netplan/00-installer-config.yaml
```

Settings defined here are persistent and applied automatically at boot. For temporary route configuration, use:

```bash
sudo route add -net <target_network> netmask <subnet_mask> gw <gateway_IP>
```

The exact configuration syntax may vary depending on the system and `netplan` version. The following is a representative example:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.100/24]
      routes:
        - to: default          # Default route for external network access
          via: 192.168.1.1     # Gateway IP
        - to: 10.0.0.0/8      # Route for internal network machines
          via: 192.168.1.2     # Gateway IP
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

Apply the configuration using:

```bash
sudo netplan try    # Test configuration (automatically reverts if not confirmed)
# Or apply directly:
sudo netplan apply
```

Verify the applied routes:

```bash
ip route show
```

> **Tip:** When configuring the network remotely via SSH, always use `sudo netplan try` rather than `sudo netplan apply`. This command tests the configuration and automatically reverts to the previous settings if you do not confirm within the timeout period, preventing accidental loss of connectivity.

## 4. Configuring Essential Tools

Once networking is operational, you can access the server remotely from your local machine:

```bash
ssh <username>@<hostname_or_IP>
```

### 4.1 APT Package Manager

For users in China, configuring a domestic APT mirror is strongly recommended. Edit the sources list:

```bash
sudo vim /etc/apt/sources.list
```

Replace the contents with an appropriate mirror. The following example uses the Alibaba Cloud mirror:

```
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu focal stable
# deb-src [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu focal stable
```

Save the file, then update the package index and upgrade existing packages:

```bash
sudo apt update && sudo apt upgrade
```

This process may take several minutes. Once complete, install the essential build tools:

```bash
sudo apt install build-essential    # Includes GCC and other common compilation tools
sudo apt install docker docker-compose    # Required for backend deployment
```

### 4.2 Docker

Docker is an indispensable tool in modern production environments. This section provides a detailed walkthrough of its installation and configuration.

> **Reference:** [This article](https://blog.csdn.net/justlpf/article/details/132982953) offers a comprehensive overview of the Docker and Docker Compose installation process.

#### 4.2.1 Docker Engine Installation

While Docker can be installed directly via `apt`, this approach complicates mirror configuration. The following method is recommended instead.

Install the required dependencies:

```bash
sudo apt-get install ca-certificates curl gnupg lsb-release
```

Add Docker's official GPG key:

```bash
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
```

Add the Docker repository (using the Alibaba Cloud mirror):

```bash
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
```

Install Docker CE:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

To avoid requiring `sudo` for every Docker command, add your user to the `docker` group:

```bash
sudo usermod -aG docker $USER
```

A logout and login may be required for the group membership to take effect. Verify the installation:

```bash
sudo systemctl start docker
sudo systemctl status docker
sudo docker run hello-world
```

If the network is properly configured, the test container should execute successfully. Enable Docker to start automatically at boot:

```bash
sudo systemctl enable docker
```

Optional additional packages:

```bash
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
```

After installing new tools or modifying Docker's configuration, restart the Docker service:

```bash
sudo systemctl restart docker
```

To modify Docker daemon settings (such as registry mirrors), edit the file `/etc/docker/daemon.json` (requires root privileges). After making changes, reload the daemon configuration and restart the service:

```bash
sudo systemctl reload docker
sudo systemctl restart docker
```

#### 4.2.2 Docker Compose Installation

Download and install Docker Compose:

```bash
# GitHub: https://github.com/docker/compose/releases/tag/v2.20.2
# China mirror: https://gitee.com/smilezgy/compose/releases/tag/v2.20.2
sudo curl -SL \
  https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose

# Alternatively, download manually, upload to the server, then run:
sudo cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose

# Grant execute permissions
sudo chmod +x /usr/local/bin/docker-compose
```

Verify the installation:

```bash
docker-compose --version
```

If you encounter download timeouts when pulling images, configure Docker registry mirrors in `/etc/docker/daemon.json`:

```json
{
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "https://mirror.ccs.tencentyun.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://docker.m.daocloud.io",
        "https://docker.imgdb.de",
        "https://docker-0.unsee.tech",
        "https://docker.hlmirror.com",
        "https://docker.1ms.run",
        "https://func.ink",
        "https://lispy.org",
        "https://docker.xiaogenban1993.com"
    ]
}
```

It is advisable to test each mirror individually and retain only those that provide reliable connectivity.

## 5. NVIDIA Driver and CUDA Installation

### 5.1 NVIDIA Driver

This example uses the GTX 1080 Ti. The procedure is the same for other NVIDIA GPUs.

1. Navigate to the [NVIDIA Driver Downloads](https://www.nvidia.com/Download/index.aspx) page.
2. Select your GPU model, operating system, and platform, then search for the latest available driver.
3. Download the resulting `.run` file.
4. Make it executable and run the installer:

```bash
chmod +x NVIDIA-Linux-x86_64-*.run
sudo ./NVIDIA-Linux-x86_64-*.run
```

The installation process takes several minutes, and a system reboot is typically required. **Before rebooting, verify your `netplan` configuration to ensure you will not lose remote connectivity.**

Verify the installation:

```bash
nvidia-smi
```

**Tip:** This command displays the current GPU status. For real-time monitoring during deep learning workloads:

```bash
watch -n 1 nvidia-smi
```

This refreshes the GPU status every second, providing continuous visibility into compute core and memory utilization.

### 5.2 CUDA Toolkit Installation

This example uses CUDA 12.8. Note that NVIDIA has announced that CUDA 12.9 and later versions will discontinue support for certain legacy GPU architectures, including the GTX and TITAN series. **Verify your GPU's compatibility before selecting a CUDA version.**

1. Search for the desired CUDA version (e.g., "cuda 12.8") and navigate to the [NVIDIA CUDA Toolkit Download Archive](https://developer.nvidia.com/cuda-12-8-1-download-archive).
2. Select your operating system, architecture, distribution, version, and installer type (`deb (local)` is recommended).
3. Follow the instructions provided on the NVIDIA website. For CUDA 12.8 on Ubuntu 20.04:

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2004-12-8-local_12.8.1-570.124.06-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-8-local_12.8.1-570.124.06-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8
```

The installation process may take a considerable amount of time.

### 5.3 Enabling GPU Access in Docker Containers

To allow Docker containers to utilize the host GPU via CUDA, you need to install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html). Once installed, configure GPU access in your `docker-compose.yml` as follows:

```yaml
services:
  container-name:    # Replace with your container name
    deploy:
      resources:
        reservations:
          devices:
            - driver: "nvidia"
              count: "all"
              capabilities: ["gpu"]
```

## 6. Deep Learning Environment

### 6.1 Miniconda

Install Miniconda by following the instructions on the [official installation page](https://www.anaconda.com/docs/getting-started/miniconda/install#linux). The following commands are for Linux x86_64 systems (as of May 2025):

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

It is recommended to consult the official website for the latest stable release. During installation, when prompted to initialize Conda, select `yes` to enable automatic `~/.bashrc` configuration.

Upon successful installation, your terminal prompt should display the `(base)` environment indicator:

```bash
(base) user@hostname:~$
```

Configure pip to use a domestic mirror (Alibaba Cloud example):

```bash
mkdir ~/.pip
cd ~/.pip
vim pip.conf
```

Add the following content:

```text
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host = mirrors.aliyun.com
```

Create a virtual environment (e.g., for PyTorch development):

```bash
conda create -n torch python=3.9 -y
```

Activate the environment and install the required packages:

```bash
conda activate torch
pip install --upgrade pip
pip install torch torchvision torchaudio jupyter
```

Verify that PyTorch can access the GPU through CUDA:

```bash
(torch) user@hostname:~$ python
Python 3.9.21 (main, Dec 11 2024, 16:24:11)
[GCC 11.2.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> torch.cuda.is_available()
True
```

If the output is `True`, both PyTorch and CUDA have been configured correctly.

## 7. Conclusion

This guide has walked through the complete process of installing Ubuntu Server 20.04 on a GPU-equipped physical machine and establishing a production-ready environment for both backend development and deep learning. Each stage — from bootable drive creation and system installation to network configuration, Docker setup, NVIDIA driver and CUDA installation, and Python environment management — plays a critical role in building a stable and functional development platform.

The procedures and principles outlined here are broadly transferable to other Ubuntu versions, virtual machine deployments, and Desktop edition installations. By following these steps methodically, most common installation and configuration issues can be resolved efficiently.

A final note: system administration demands not only technical proficiency but also patience and a methodical approach to troubleshooting. When things go wrong — and they will — resist the urge to jump into complex debugging. Start with the basics: check physical connections, verify network reachability, and confirm BIOS settings before diving deeper. The simplest oversights often prove to be the most time-consuming to diagnose.

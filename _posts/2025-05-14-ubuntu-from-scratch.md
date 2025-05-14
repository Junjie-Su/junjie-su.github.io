---
title: 'Installing Ubuntu 20.04 for Development and Deep Learning'
date: 2025-05-14
permalink: /posts/2025/05/installing-ubuntu/
tags:
  - environment setup
  - ubuntu
  - docker
  - deep learning
---

This guide walks you through installing Ubuntu Server 20.04 on a physical machine with a GPU, setting up a basic development environment with Docker and Docker Compose, and configuring CUDA for deep learning. These steps generally apply to other installation methods and Ubuntu versions (18.04-24.04), so **you can follow this whether you're installing the Desktop or Server version, on a physical machine or a virtual machine.** If you're using a VM, you can skip the USB drive creation.

## 1. Create a Bootable USB Drive

First, you'll need a USB drive (at least 4GB, 16GB recommended) to burn the Ubuntu image onto.

> **Important:** Back up everything on the USB drive as it will be formatted.

Next, download the Ubuntu 20.04 Server image from:

- [ubuntu.com](https://www.releases.ubuntu.com/focal/): Official site, usually the most stable and fastest (may require a proxy).
- [Tsinghua Mirror](https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/): A mirror site that can be used without a proxy, but might be slower.

Then, download a tool to create the bootable USB drive:

- **Windows:** [Rufus](https://rufus.ie/en/) (refer to [this guide](https://blog.csdn.net/qq_21386397/article/details/129894803) - ensure you select the correct Ubuntu version).
- **macOS:** [balenaEtcher](/) (user-friendly, just follow the on-screen instructions).

Once done, you should have a bootable USB drive.

## 2. Install Ubuntu from USB

1.  Plug the USB drive into your server, ensuring it's connected to the motherboard.
2.  Start the server and press **F12** (or **F2**, **ESC**, check the boot screen) repeatedly to enter the BIOS.
3.  In the BIOS, change the boot order to prioritize the USB drive, or directly select the USB drive as the boot device.
4.  Save the changes and exit the BIOS. The Ubuntu installation process should begin.

### 2.1 Installation Details

Follow the steps in [this video](https://www.bilibili.com/video/BV19u411K7Ts/) for a visual guide. Customize settings like disk partitioning as needed.

**Tips:**

-   **Internal Network:** If installing on an internal network requiring a specific server address, ensure you have the static IP, subnet mask, and gateway IP.
-   **APT Sources and Updates:** **Avoid configuring APT sources or updating system packages during the initial installation.** Stick with the default sources and skip the update step. Changing sources or updating with network issues can lead to installation failures and the need to reinstall.

## 3. Configure System Network

This is crucial for remote server access on physical machines. VMs are simpler to configure via their tools, but understanding these concepts is important for later package installations.

### 3.1 Configure System Gateway

We recommend using `netplan`, which comes pre-installed on Ubuntu Server. The configuration file for Ubuntu Server 22.04 is typically at `/etc/netplan/00-installer-config.yaml`.

```bash
sudo vim /etc/netplan/00-installer-config.yaml
````

Changes here are permanent and applied on system boot. For temporary configuration, use:

```bash
sudo route add -net <target_network> netmask <subnet_mask> gw <gateway_IP>
```

Configuration varies by system and `netplan` version. Here's a sample:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.100/24]
      routes:
        - to: default # Default route for external network
          via: 192.168.1.1 # Gateway IP
        - to: 10.0.0.0/8 # Specific network for internal machines
          via: 192.168.1.2 # Gateway IP
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

Apply the configuration:

```bash
sudo netplan try  # Test configuration (reverts on no confirmation)
# Or apply directly:
sudo netplan apply
```

Verify the configuration:

```bash
ip route show
```

> **Tip:** If configuring the network remotely via SSH, use `sudo netplan try` to test your changes. If you don't confirm within the timeout, the configuration will revert, preventing you from losing connection due to errors.

## 3.2 Configure Basic Tools

Once networking is set up, you can SSH into your server from your local machine:

```bash
ssh <username>@<hostname_or_IP>
```

### 3.2.1 APT

First, configure APT sources, especially if you're in China. Edit the sources list:

```bash
sudo vim /etc/apt/sources.list
```

Replace the contents with a mirror like Aliyun:

```
deb [http://mirrors.aliyun.com/ubuntu/](http://mirrors.aliyun.com/ubuntu/) focal main restricted universe multiverse
deb [http://mirrors.aliyun.com/ubuntu/](http://mirrors.aliyun.com/ubuntu/) focal-security main restricted universe multiverse
deb [http://mirrors.aliyun.com/ubuntu/](http://mirrors.aliyun.com/ubuntu/) focal-updates main restricted universe multiverse
deb [http://mirrors.aliyun.com/ubuntu/](http://mirrors.aliyun.com/ubuntu/) focal-backports main restricted universe multiverse
deb [http://mirrors.aliyun.com/ubuntu/](http://mirrors.aliyun.com/ubuntu/) focal-proposed main restricted universe multiverse
deb [arch=amd64] [http://mirrors.aliyun.com/docker-ce/linux/ubuntu](http://mirrors.aliyun.com/docker-ce/linux/ubuntu) focal stable
# deb-src [arch=amd64] [http://mirrors.aliyun.com/docker-ce/linux/ubuntu](http://mirrors.aliyun.com/docker-ce/linux/ubuntu) focal stable
```

Save and update the APT sources and upgrade existing packages:

```bash
sudo apt update && sudo apt upgrade
```

This might take some time. Then, install essential tools:

```bash
sudo apt install build-essential  # Includes GCC and other common tools
sudo apt install docker docker-compose  # For backend deployment
```

### 3.2.2 Docker

Docker is a vital tool for production environments. Here's a more detailed setup:

> **Reference:** This [article](https://blog.csdn.net/justlpf/article/details/132982953) provides a good overview of Docker and Docker Compose installation.

#### 3.2.2.1 Docker Installation

While you can install Docker with `apt`, this method forgoes easier mirror configuration. We recommend this approach:

Install Docker dependencies:

```bash
sudo apt-get install ca-certificates curl gnupg lsb-release
```

Add Docker's official GPG key:

```bash
curl -fsSL [http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg](http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg) | sudo apt-key add -
```

Configure the Docker mirror (Aliyun):

```bash
sudo add-apt-repository "deb [arch=amd64] [http://mirrors.aliyun.com/docker-ce/linux/ubuntu](http://mirrors.aliyun.com/docker-ce/linux/ubuntu) $(lsb_release -cs) stable"
```

Now, install Docker CE:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Docker is now installed. To avoid using `sudo` with Docker commands, add your user to the `docker` group:

```bash
sudo usermod -aG docker $USER
```

You might need to log out and back in for this to take effect. Verify the installation:

```bash
sudo systemctl start docker
sudo systemctl status docker
sudo docker run hello-world
```

If your network is working, the test image should run successfully. Enable Docker to start on boot:

```bash
sudo systemctl enable docker
```

Optional tools:

```bash
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
```

Restart Docker after installing new tools or changing configurations:

```bash
sudo systemctl restart docker
```

To change Docker settings like mirrors, edit `/etc/docker/daemon.json` (requires `sudo`). After editing, reload the daemon and restart Docker:

```bash
sudo systemctl reload docker
sudo systemctl restart docker
```

#### 3.2.2.2 Docker Compose Installation

Install Docker Compose:

```bash
# GitHub: [https://github.com/docker/compose/releases/tag/v2.20.2](https://github.com/docker/compose/releases/tag/v2.20.2)
# China Mirror: [https://gitee.com/smilezgy/compose/releases/tag/v2.20.2](https://gitee.com/smilezgy/compose/releases/tag/v2.20.2)
sudo curl -SL \
[https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64](https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64) \
-o /usr/local/bin/docker-compose

# Or download manually, upload to the server, and run:
# In the same directory as docker-compose-linux-x86_64
sudo cp docker-compose-linux-x86_64 /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose
```

Verify the installation:

```bash
docker-compose --version
```

Docker and Docker Compose are now set up. If you encounter download timeouts, configure Docker mirrors in `/etc/docker/daemon.json`:

```json
{
    "registry-mirrors": [
        "[https://registry.docker-cn.com](https://registry.docker-cn.com)",
        "[https://mirror.ccs.tencentyun.com](https://mirror.ccs.tencentyun.com)",
        "[https://docker.mirrors.ustc.edu.cn](https://docker.mirrors.ustc.edu.cn)",
        "[https://docker.m.daocloud.io](https://docker.m.daocloud.io)",
        "[https://docker.imgdb.de](https://docker.imgdb.de)",
        "[https://docker-0.unsee.tech](https://docker-0.unsee.tech)",
        "[https://docker.hlmirror.com](https://docker.hlmirror.com)",
        "[https://docker.1ms.run](https://docker.1ms.run)",
        "[https://func.ink](https://func.ink)",
        "[https://lispy.org](https://lispy.org)",
        "[https://docker.xiaogenban1993.com](https://docker.xiaogenban1993.com)"
    ]
}
```

Test a few mirrors to see which work best for you.

## 4\. Install NVIDIA Driver and CUDA

### 4.1 NVIDIA Driver

For a 1080Ti (example GPU):

1.  Go to the [NVIDIA Drivers website](https://www.google.com/search?q=https://www.nvidia.com/geforce/drivers/).
2.  Select your GPU model and operating system, then search for the latest driver.
3.  Download the `.run` file.
4.  Make it executable and run it:

<!-- end list -->

```bash
chmod +x NVIDIA-Linux-x86_64-*.run
sudo ./NVIDIA-Linux-x86_64-*.run
```

Installation takes time, and a reboot is usually required. **Before rebooting, double-check your `netplan` configuration to avoid losing connection.** Verify the installation:

```bash
nvidia-smi
```

**Tip:** This command shows GPU status. For monitoring during deep learning:

```bash
watch -n 1 nvidia-smi
```

This updates the GPU status every second, useful for tracking utilization.

### 4.2 CUDA Installation

For CUDA 12.8 (example version): The latest version might not support older GPUs. **Check your GPU compatibility before proceeding.**

1.  Search online for "cuda [your version]" (e.g., "cuda 12.8").
2.  Go to the NVIDIA CUDA Toolkit [download archive](https://developer.nvidia.com/cuda-12-8-1-download-archive).
3.  Select your OS, architecture, distribution, version, and installer type (`deb (local)` recommended).
4.  Follow the instructions provided on the NVIDIA website. For the example CUDA 12.8 and Ubuntu 20.04:

<!-- end list -->

```bash
wget [https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin](https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin)
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget [https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2004-12-8-local_12.8.1-570.124.06-1_amd64.deb](https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2004-12-8-local_12.8.1-570.124.06-1_amd64.deb)
sudo dpkg -i cuda-repo-ubuntu2004-12-8-local_12.8.1-570.124.06-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8
```

The installation will take a while.

## 5\. Deep Learning Environment

### 5.1 Miniconda

1.  Go to the [Miniconda installation page](https://www.google.com/search?q=https://www.anaconda.com/docs/getting-started/miniconda/install%23linux) and get the latest Linux x64 installation instructions. As of May 14, 2025:

<!-- end list -->

```bash
mkdir -p ~/miniconda3
wget [https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh](https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh) -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

2.  The installer will ask if you want to initialize Conda. We recommend saying `yes` for automatic `~/.bashrc` configuration.

3.  After installation, your terminal prompt should show `(base)`:

<!-- end list -->

```bash
(base) user@hostname:~$
```

4.  Configure pip mirrors (Aliyun example):

<!-- end list -->

```bash
mkdir ~/.pip
cd ~/.pip
vim pip.conf
```

Add the following content:

```text
[global]
index-url = [https://mirrors.aliyun.com/pypi/simple/](https://mirrors.aliyun.com/pypi/simple/)

[install]
trusted-host = mirrors.aliyun.com
```

5.  Create a virtual environment (e.g., for PyTorch):

<!-- end list -->

```bash
conda create -n torch python=3.9 -y
```

6.  Activate the environment and install PyTorch and other dependencies:

<!-- end list -->

```bash
conda activate torch
pip install --upgrade pip
pip install torch torchvision torchaudio jupyter
```

7.  Verify the PyTorch and CUDA setup:

<!-- end list -->

```bash
(torch) user@hostname:~$ python
Python 3.9.21 (main, Dec 11 2024, 16:24:11)
[GCC 11.2.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> torch.cuda.is_available()
True
```

If `True` is printed, your PyTorch and CUDA environment is configured correctly.

## 6\. Conclusion

By following these steps, you've successfully installed Ubuntu Server 20.04 on a GPU-equipped machine and set up the necessary environment for backend development and deep learning. Each step, from creating the bootable drive to configuring the software, is crucial. This guide should help you overcome common installation and configuration challenges, regardless of your Ubuntu version or whether you're using a physical or virtual machine. We hope this helps you quickly establish your ideal development and deep learning environment.

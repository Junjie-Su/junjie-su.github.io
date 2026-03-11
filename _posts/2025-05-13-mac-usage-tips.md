---
title: 'Mac Usage Tips for CS Students and Developers'
date: 2025-05-13
permalink: /posts/2025/05/mac-usage-tips/
tags:
  - environment setup
  - mac
  - productivity
---

This guide is intended for computer science students and software developers who are considering adopting macOS, or who have recently made the switch and wish to maximize their productivity. The article covers three key areas: hardware configuration selection, software setup, and practical usage tips.

## Why Choose Mac

As an undergraduate student planning to pursue AI Agent research in graduate school, I had been using a Windows gaming laptop (Lenovo Y9000P) since entering college. While it served me well in terms of raw performance, several factors ultimately led me to adopt a Mac as my primary development machine:

1. **Superior Unix-based environment.** Windows falls short in file management and environment configuration compared to Unix-like systems such as Linux and macOS. macOS features a unified storage architecture (no drive partitioning) and supports [Homebrew](https://brew.sh/), which provides an `apt`-like package management experience familiar to Linux users.

2. **Separation of work and entertainment.** Having accumulated a significant number of entertainment applications on my Windows machine, file and storage management became increasingly cumbersome. A dedicated Mac allows the Windows machine to remain a gaming device while the Mac serves as a clean, focused productivity tool.

3. **Maturing software ecosystem.** With the advancement of Apple Silicon (M-series chips) and growing vendor support, the macOS software ecosystem has expanded considerably. Major IDEs such as IntelliJ IDEA and PyCharm are fully supported, and even deep learning workloads can be executed locally. The software compatibility concerns often cited online are largely overstated.

4. **Apple ecosystem integration.** For users already invested in the Apple ecosystem (iPhone, iPad, AirPods), adding a Mac completes the experience. Features such as AirDrop and seamless audio device switching across devices are remarkably convenient.

5. **Portability.** The Y9000P, while powerful, is impractical as a portable device. A lightweight MacBook is far better suited for commuting between workstations and working on the go.

6. **Competitive pricing.** Government subsidies combined with education discounts make the Mac an excellent value proposition.

## Hardware Configuration

My personal choice: **MacBook Air M4 (24GB RAM + 512GB SSD)**.

### 1. Model Selection

I chose the Air over the Pro for two reasons: I already own a high-performance Windows machine for compute-intensive tasks, and the Air better embodies the laptop form factor — lightweight yet capable. For workloads requiring significant computational resources, SSH access to a remote server is always an option. As for choosing M4 over M3 or earlier chips, the newer model offers a longer useful lifespan, resulting in a better cost-per-year ratio despite the higher upfront cost.

### 2. Memory Selection

A minimum of 24GB is recommended; 32GB is preferable if budget permits. Memory capacity directly impacts the user experience for both software development and algorithm work. Since macOS employs a unified memory architecture — where system memory also serves as GPU memory — its importance is amplified. Adequate memory ensures smooth operation when running local development environments and allows algorithm developers to validate code locally before deploying to remote servers.

### 3. Storage Selection

While 256GB is sufficient for minimal use, 512GB provides considerably more flexibility. Relying on external storage undermines the MacBook's value as a portable device. Moreover, 512GB offers headroom for a broader range of use cases over the machine's expected lifespan, which should span at least the duration of a graduate program. That said, 256GB remains viable under disciplined storage management when budget is a constraint.

> **Note:** The base model MacBook Air M4 (16GB + 256GB) ships with a downgraded charger and two fewer GPU cores compared to higher-tier configurations. Prospective buyers should be aware of these differences before making a purchase decision.

## Software Configuration

The following recommendations are oriented toward algorithm and backend development, though many are universally applicable to software engineers.

### 1. Network Configuration

The first priority after setting up a new Mac is to configure network access. Ensuring reliable connectivity is essential for all subsequent installation and configuration steps.

### 2. Browser

The Mac App Store has a limited selection, and some applications available there are inferior to their web-downloaded counterparts. For instance, Bilibili only offers an iOS version on the App Store, which results in a suboptimal layout when installed on macOS; the native Mac client is available exclusively from Bilibili's official website.

Regarding browser choice, there is no compelling reason to switch to Safari simply because you are now on macOS. While Safari is a capable browser, the time cost of adapting to a new browser's workflow is rarely justified. Maintaining your existing browser preference (e.g., Chrome) is generally the more efficient approach.

### 3. IDE

Similarly, it is advisable to retain your existing IDE preferences. Most popular IDEs offer native macOS versions. JetBrains products, Cursor, VS Code, and others can be downloaded directly from their respective official websites as `.dmg` installers.

### 4. Command-Line Tools and Development Environments

The first step is to install [Homebrew](https://brew.sh/). Ensure that network access is properly configured beforehand, as some packages are hosted on international servers. After installation, add the following to your `~/.zshrc` (the macOS equivalent of `~/.bashrc` on Linux):

```bash
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
```

Apply the changes:

```bash
source ~/.zshrc
```

> **Tip:** It is recommended to install all software using default paths on macOS. Unlike Windows, there is no need to manage separate system and data drives. Using default installation paths simplifies troubleshooting considerably.

Once Homebrew is configured, it can be used to install a wide range of development tools. Whether it is package managers like Maven and Node.js, or runtime environments like the JDK, installation is straightforward:

```bash
brew install maven
mvn --version  # Verify the installation
```

For services that should run persistently in the background and start automatically on boot (e.g., MySQL, PostgreSQL), Homebrew provides a built-in service management mechanism:

```bash
brew install mysql
brew services start mysql
brew services list  # View all running services
```

### 5. Deep Learning Environment

For local deep learning experimentation, [Miniconda](https://docs.anaconda.com/miniconda/) can be installed following the official instructions. After installation, Jupyter is recommended for interactive development:

```bash
pip install jupyter jupyter_contrib_nbextensions
pip install jupyter_nbextensions_configurator jupyterlab_code_formatter
```

It is also advisable to configure a mirror source for Conda. Edit the `.condarc` file located in your Miniconda installation directory (default: `~/miniconda3/.condarc`):

```yaml
channels:
  - https://mirrors.aliyun.com/anaconda/pkgs/main/
  - https://mirrors.aliyun.com/anaconda/pkgs/r/
  - https://mirrors.aliyun.com/anaconda/pkgs/msys2/
  - defaults
show_channel_urls: false
```

### 6. Academic Tools

A recommended academic workflow consists of the following tools:

- **Zotero**: A powerful reference manager. The browser extensions *Zotero Connector for Chrome* and *Translate for Zotero* are highly recommended for streamlining literature collection and reading. However, users should be aware of potential high memory consumption (see Known Issues below).
- **Notion**: A versatile cloud-based note-taking platform. The web interface works seamlessly across platforms with no discernible difference from the Windows experience.
- **Obsidian**: A popular local-first Markdown editor. macOS's efficient memory management makes it particularly well-suited for working with many open documents simultaneously, and the unified storage architecture eliminates file location concerns.
- **Overleaf**: A web-based LaTeX editor. No installation is required — simply use it through the browser for academic paper writing.

### 7. GitBook

For those looking to organize notes into a GitBook, be aware of several installation caveats:

- **NVM installation:** Installing NVM via `brew install nvm` is not recommended, as it frequently leads to `nvm ls-remote N/A` errors and mirror configuration difficulties. Instead, use the curl-based installation method and configure mirrors separately.
- **Known issue:** The `cb.apply` error is a common problem during GitBook installation that requires specific resolution steps.

## Practical Tips

### Trackpad

The MacBook trackpad is exceptionally well-designed and can fully replace a mouse for most workflows. Two recommended settings adjustments are enabling **tap to click** and **three-finger drag**. For learning specific gestures and operations, querying an AI assistant (e.g., "How do I [action] on Mac?") is often the fastest and most effective approach.

### Keyboard Shortcuts

macOS offers an extensive set of keyboard shortcuts covering virtually every common operation. While the sheer number of shortcuts can be daunting to memorize, AI assistants provide an efficient learning method — simply describe what you want to accomplish and specify that you are using macOS. The built-in Shortcuts app can also be useful for discovering available shortcuts.

## Known Issues

1. **Office compatibility.** Microsoft Office on macOS exhibits differences from the Windows version, including font incompatibility and licensing costs. While Apple's native Pages and Keynote are viable alternatives, documents with strict formatting requirements (e.g., grant applications) may still need to be verified on Windows to ensure compatibility.

2. **Zotero memory consumption.** Zotero 7 has been observed to consume approximately 500MB of memory at startup, escalating to over 2GB — and occasionally 4GB — when PDF documents are open. Investigation suggests that third-party plugins (such as *Ethereal Style*) may contribute to excessive memory usage through improper resource management. Disabling non-essential plugins has been reported to alleviate this issue.

3. **`.DS_Store` files.** macOS may generate `.DS_Store` metadata files when using Spotlight or Finder to browse directories. While generally harmless, these files can appear in version control repositories and should be added to `.gitignore` as a best practice.

4. **Accessory considerations.** While the MacBook trackpad is sufficient for most tasks, a mouse may improve efficiency for precision operations such as text selection in word processors. Recommended accessories include a USB-C hub (for port expansion) and a protective laptop sleeve for transport.

## Conclusion

Choosing a Mac should be a deliberate decision based on genuine needs. Hardware configuration — including model, memory, and storage — should be tailored to individual requirements and budget. With the continued maturation of the macOS ecosystem, the Mac has evolved into a highly capable development platform that can serve as an effective productivity tool for computer science students and software professionals alike.

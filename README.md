# 📱 Antigravity on Android
> Run Antigravity (coding editor) and a full Linux desktop environment on Android using Termux, PRoot, and XFCE4 — completely free.

![Platform](https://img.shields.io/badge/Platform-Android-green?style=flat-square&logo=android)
![Distro](https://img.shields.io/badge/Distro-Debian-red?style=flat-square&logo=debian)
![Desktop](https://img.shields.io/badge/Desktop-XFCE4-blue?style=flat-square)
![Status](https://img.shields.io/badge/Status-Working-brightgreen?style=flat-square)

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Step 1 — Termux Base Setup](#step-1--termux-base-setup)
- [Step 2 — Debian Desktop Environment](#step-2--debian-desktop-environment)
- [Step 3 — Launch the Desktop](#step-3--launch-the-desktop)
- [Step 4 — Install Firefox Browser](#step-4--install-firefox-browser)
- [Step 5 — Install Antigravity Editor](#step-5--install-antigravity-editor)
- [Step 6 — User Setup & Permissions](#step-6--user-setup--permissions)
- [Step 7 — Access Phone Storage](#step-7--access-phone-storage)
- [Shortcuts Reference](#shortcuts-reference)

---

## Prerequisites

- **Termux** — [Download from GitHub](https://github.com/termux/termux-app/releases) (recommended over Play Store)
- **Termux:X11** — [Download from GitHub](https://github.com/termux/termux-x11/releases/tag/nightly)
- **Magisk** (optional but recommended for root access)

---

## Step 1 — Termux Base Setup

Open Termux and run the following commands one by one.

### 1.1 Update Packages
```bash
pkg update && pkg upgrade -y
```

### 1.2 Install Root Tool
```bash
pkg install tsu -y
```

### 1.3 Grant Root Access
> ⚠️ If you have Magisk installed, a popup will appear — tap **Grant**.
```bash
su
```
```bash
exit
```

### 1.4 Grant Storage Permission
> A popup will appear on your phone — tap **Allow**.
```bash
termux-setup-storage
```

### 1.5 Install Graphics Repositories & Core Tools
```bash
pkg install x11-repo -y
```
```bash
pkg update
```
```bash
pkg install tsu proot-distro termux-x11 termux-api -y
```

### 1.6 Install Debian
```bash
proot-distro install debian
```
```bash
proot-distro login debian
```
```bash
apt update && apt upgrade -y
```

---

## Step 2 — Debian Desktop Environment

### 2.1 Install XFCE4 Desktop & Core Tools
```bash
apt install xfce4 xfce4-goodies xfce4-terminal dbus-x11 xdg-utils x11-apps sudo wget curl nano -y
```

### 2.2 Fix Fonts (Bengali & Unicode Support)
```bash
apt install fonts-noto-core fonts-noto-ui-core fonts-noto-cjk fonts-beng -y
```

### 2.3 Exit Back to Termux
```bash
exit
```

---

## Step 3 — Launch the Desktop

### 3.1 Create the "go" Launch Shortcut
Run this in Termux to set up a shortcut that auto-deletes session lock files on launch:
```bash
echo "alias go='rm -rf /tmp/.X11-unix/X1 /tmp/.X1-lock 2>/dev/null; termux-x11 :1 & sleep 3 && proot-distro login debian --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
source ~/.bashrc
```

### 3.2 Launch the Desktop
```bash
go
```

> ✅ Debian setup complete. The XFCE4 desktop should now open in Termux:X11.

---

## Step 4 — Install Firefox Browser

Log back into Debian first:
```bash
proot-distro login debian
```

### 4.1 Install Firefox ESR
```bash
apt update && apt install firefox-esr -y
```

### 4.2 Fix Sandbox for Proot
```bash
sed -i 's|^Exec=.*|Exec=firefox-esr --no-sandbox %u|g' /usr/share/applications/firefox-esr.desktop
```
```bash
chmod +x /usr/share/applications/firefox-esr.desktop
```

---

## Step 5 — Install Antigravity Editor

### 5.1 Add Repository & Install
```bash
mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > /etc/apt/sources.list.d/antigravity.list
apt update && apt install antigravity -y
```

### 5.2 Fix Desktop Icon (Sandbox & Data Directory)
```bash
sed -i 's|^Exec=.*|Exec=antigravity --no-sandbox --disable-gpu --user-data-dir=/root/.config/antigravity %U|g' /usr/share/applications/antigravity.desktop
```
```bash
chmod +x /usr/share/applications/antigravity.desktop
```

---

## Step 6 — User Setup & Permissions

### 6.1 Create User
```bash
useradd -m -s /bin/bash zaman
```

### 6.2 Grant Sudo Permission
```bash
echo "zaman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

### 6.3 Update Antigravity Icon for zaman User
```bash
sed -i 's|--user-data-dir=/root/.config/antigravity|--user-data-dir=/home/zaman/.config/antigravity|g' /usr/share/applications/antigravity.desktop
```

### 6.4 Setup Aliases & Environment for zaman
```bash
echo "alias ag='antigravity --no-sandbox --disable-gpu --user-data-dir=/home/zaman/.config/antigravity'" >> /home/zaman/.bashrc
echo "alias bb='firefox-esr --no-sandbox --disable-gpu'" >> /home/zaman/.bashrc
echo "export DISPLAY=:1" >> /home/zaman/.bashrc
ln -sf /sdcard /home/zaman/phone_storage
chown -R zaman:zaman /home/zaman/
```

### 6.5 Setup Aliases & Environment for Root
```bash
echo "alias ag='antigravity --no-sandbox --disable-gpu --user-data-dir=/root/.config/antigravity'" >> /root/.bashrc
echo "alias bb='firefox-esr --no-sandbox --disable-gpu'" >> /root/.bashrc
echo "export DISPLAY=:1" >> /root/.bashrc
ln -sf /sdcard /root/phone_storage
```

### 6.6 Activate Settings
```bash
source /root/.bashrc
```

---

## Step 7 — Access Phone Storage

### 7.1 Create "goz" Shortcut for zaman User (Run in Termux)
```bash
echo "alias goz='rm -rf /tmp/.X11-unix/X1 /tmp/.X1-lock 2>/dev/null; termux-x11 :1 & sleep 3 && proot-distro login debian --user zaman --bind /sdcard:/sdcard --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
```
```bash
source ~/.bashrc
```

### 7.2 Launch as zaman User
```bash
goz
```

> ✅ Phone storage is accessible at `~/phone_storage` inside the Debian environment.

---

## Shortcuts Reference

| Shortcut | User | Description |
|----------|------|-------------|
| `go` | root | Launch Debian desktop as root |
| `goz` | zaman | Launch Debian desktop as zaman with phone storage |
| `ag` | both | Launch Antigravity editor |
| `bb` | both | Launch Firefox browser |

---

Root to zaman in terminal
```bash
su - zaman
```
to back
```bash
exir
```
zaman to root in terminal
```bash
sudo -i
```
to back
```bash
exit
```

> **Target Device:** Rooted/Non-Rooted Android (Tested on Redmi Note 12)

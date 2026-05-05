# 📱 Antigravity on Android
> Run Antigravity (coding editor) and a full Linux desktop environment on Android using Termux, PRoot, and XFCE4 — completely free.

![Platform](https://img.shields.io/badge/Platform-Android-green?style=flat-square&logo=android)
![Distro](https://img.shields.io/badge/Distro-Ubuntu-orange?style=flat-square&logo=ubuntu)
![Desktop](https://img.shields.io/badge/Desktop-XFCE4-blue?style=flat-square)
![Status](https://img.shields.io/badge/Status-Working-brightgreen?style=flat-square)

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Step 1 — Termux Base Setup](#step-1--termux-base-setup)
- [Step 2 — Ubuntu Desktop Environment](#step-2--ubuntu-desktop-environment)
- [Step 3 — Launch the Desktop](#step-3--launch-the-desktop)
- [Step 4 — Install Brave Browser](#step-4--install-brave-browser)
- [Step 5 — Install Antigravity Editor](#step-5--install-antigravity-editor)
- [Step 6 — Fix Login & Browser Links](#step-6--fix-login--browser-links)
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

## Step 2 — Debian Desktop
```bash
apt install xfce4 xfce4-goodies xfce4-terminal dbus-x11 xdg-utils x11-apps sudo wget curl nano -y
```
<details>
 ### 2.4 Fix Fonts (Bengali & Unicode Support)
```bash
apt install fonts-noto-core fonts-noto-ui-core fonts-noto-cjk fonts-beng -y
```
</details>
```bash
exit
```

### 🚀 Phase 2.3: Create the "Master Go" Shortcut
ডেবিয়ান থেকে বের হয়ে টার্মাক্সে এই শর্টকাটটি সেট করুন (যা সেশন লক ফাইল অটো ডিলিট করবে):
```bash
echo "alias go='rm -rf /tmp/.X11-unix/X1 /tmp/.X1-lock 2>/dev/null; termux-x11 :1 & sleep 3 && proot-distro login debian --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
source ~/.bashrc
```

```bash
go
```

> ✅ Ubuntu setup complete. Now **exit back to Termux** to set up launch shortcuts.


Firefox Installation (Step-by-Step)

```bash
apt update && apt install firefox-esr -y
```
```bash
sed -i 's|^Exec=.*|Exec=firefox-esr --no-sandbox %u|g' /usr/share/applications/firefox-esr.desktop
```
```bash
chmod +x /usr/share/applications/firefox-esr.desktop
```


Install Antigravity Editor
```bash
mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" > /etc/apt/sources.list.d/antigravity.list
apt update && apt install antigravity -y
```
after install do this 
# 1. Update the icon file with sandbox fix and data directory
```bash
sed -i 's|^Exec=.*|Exec=antigravity --no-sandbox --disable-gpu --user-data-dir=/root/.config/antigravity %U|g' /usr/share/applications/antigravity.desktop
```
```bash
chmod +x /usr/share/applications/antigravity.desktop
```


ইউজার তৈরি এবং পারমিশন (Inside Debian - Root হিসেবে দিন)
# ১. জামান ইউজার তৈরি করা
```bash
useradd -m -s /bin/bash zaman
```
# ২. সুডো (Sudo) পারমিশন দেওয়া
```bash
echo "zaman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

# অ্যান্টিগ্রাভিটি আইকন আপডেট (Root থেকে /home/zaman এ পরিবর্তন)
```bash
sed -i 's|--user-data-dir=/root/.config/antigravity|--user-data-dir=/home/zaman/.config/antigravity|g' /usr/share/applications/antigravity.desktop
```

# --- ১. জামান ইউজারের জন্য (Setup for zaman) ---
```bash
echo "alias ag='antigravity --no-sandbox --disable-gpu --user-data-dir=/home/zaman/.config/antigravity'" >> /home/zaman/.bashrc
echo "alias bb='brave-browser --no-sandbox --disable-gpu'" >> /home/zaman/.bashrc
echo "export DISPLAY=:1" >> /home/zaman/.bashrc
ln -sf /sdcard /home/zaman/phone_storage
chown -R zaman:zaman /home/zaman/
```

# --- ২. রুট ইউজারের জন্য (Setup for root) ---
```bash
echo "alias ag='antigravity --no-sandbox --disable-gpu --user-data-dir=/root/.config/antigravity'" >> /root/.bashrc
echo "alias bb='brave-browser --no-sandbox --disable-gpu'" >> /root/.bashrc
echo "export DISPLAY=:1" >> /root/.bashrc
ln -sf /sdcard /root/phone_storage
```

# --- ৩. সেটিংস সাথে সাথে কার্যকর করা (Activation) ---
```bash
source /root/.bashrc
```

"goz" Shortcut for zaman user (Termux-এ দিন)
```bash
echo "alias goz='rm -rf /tmp/.X11-unix/X1 /tmp/.X1-lock 2>/dev/null; termux-x11 :1 & sleep 3 && proot-distro login debian --user zaman --bind /sdcard:/sdcard --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
```
```bash
source ~/.bashrc
```

Target Device: Rooted/Non-Rooted Android (Test on Redmi Note 12)





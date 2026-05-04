# 📱 Antigravity on Android
> Run Antigravity (coding editor) and a full Linux desktop environment on Android using Termux, PRoot, and XFCE4 — completely free.
> 
## 📋 Table of Contents
 * Prerequisites
 * Step 1 — Termux Base Setup
 * Step 2 — Ubuntu Desktop Environment
 * Step 3 — Launch the Desktop
 * Step 4 — Install Brave Browser
 * Step 5 — Install Antigravity Editor
 * Step 6 — Fix Login & Browser Links (Master Fix)
 * Step 7 — Access Phone Storage
 * Shortcuts Reference
## Prerequisites
 * **Termux** — Download from GitHub (recommended over Play Store)
 * **Termux:X11** — Download from GitHub
 * **Magisk** (optional but recommended for root access)
## Step 1 — Termux Base Setup
### 1.1 Core Setup
```bash
pkg update && pkg upgrade -y
pkg install tsu proot-distro termux-x11-nightly termux-api x11-repo -y
termux-setup-storage

```
### 1.2 Install Ubuntu
```bash
proot-distro install ubuntu

```
## Step 2 — Ubuntu Desktop Environment
### 2.1 Log In & Update
```bash
proot-distro login ubuntu
apt update && apt upgrade -y

```
### 2.2 Create User & Sudo Access
```bash
apt install sudo -y
useradd -m -s /bin/bash zaman
echo "zaman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Optional: Set password for zaman
# echo "zaman:1234" | chpasswd

```
### 2.3 Install Desktop (Balanced & Minimal)
> This version is lightweight but includes Bengali fonts and essential link tools.
> 
```bash
apt install xfce4 xfce4-terminal dbus-x11 xdg-utils fonts-noto-core fonts-beng sudo wget curl nano --no-install-recommends -y

```
### 2.4 Fix Fonts (Unicode Support)
```bash
apt install fonts-noto-ui-core fonts-noto-cjk -y

```
## Step 3 — Set Up Launch Shortcuts (Termux)
Exit Ubuntu (exit) and run this in Termux:
```bash
echo "alias go='termux-x11 :1 & sleep 2 && proot-distro login ubuntu --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
echo "alias goz='termux-x11 :1 & sleep 2 && proot-distro login ubuntu --user zaman --bind /sdcard:/sdcard --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
source ~/.bashrc

```
| Shortcut | Action |
|---|---|
| go | Launch as Root |
| goz | Launch as zaman (with SD Card Access) ✅ |
## Step 4 — Install Brave Browser
### 4.1 Setup Repo
```bash
apt update && apt install curl gnupg -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg [https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg](https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg)
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] [https://brave-browser-apt-release.s3.brave.com/](https://brave-browser-apt-release.s3.brave.com/) stable main" > /etc/apt/sources.list.d/brave-browser-release.list

```
### 4.2 Install
```bash
apt update && apt install brave-browser -y

```
## Step 5 — Install Antigravity Editor
### 5.1 Setup Repo
```bash
mkdir -p /etc/apt/keyrings
curl -fsSL [https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg](https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg) | gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] [https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/](https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/) antigravity-debian main" > /etc/apt/sources.list.d/antigravity.list

```
### 5.2 Install & Fix Ownership
```bash
apt update && apt install antigravity -y
chown -R zaman:zaman /usr/share/antigravity 2>/dev/null

```
## Step 6 — Fix Login & Browser Links (Master Fix)
> **Important:** Run this as **Root** to force Brave to be the default for all login buttons (GitHub/Google) and terminal links.
> 
### 6.1 Create bb-link Wrapper
```bash
cat <<'EOF' > /usr/bin/bb-link
#!/bin/bash
exec brave-browser --no-sandbox --disable-gpu "$@"
EOF
chmod +x /usr/bin/bb-link

```
### 6.2 Set System Defaults
```bash
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/bb-link 200
update-alternatives --set x-www-browser /usr/bin/bb-link
update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/bb-link 200
update-alternatives --set gnome-www-browser /usr/bin/bb-link

echo "export BROWSER=bb-link" >> /etc/environment

```
### 6.3 Patch Desktop Icons (Fix "App not opening")
```bash
sed -i 's|Exec=brave-browser|Exec=brave-browser --no-sandbox --disable-gpu|g' /usr/share/applications/brave-browser.desktop
sed -i 's|Exec=antigravity|Exec=antigravity --no-sandbox --disable-gpu|g' /usr/share/applications/antigravity.desktop

```
## Step 7 — Access Phone Storage
### 7.1 Link Storage
Inside Ubuntu:
```bash
ln -s /sdcard ~/phone_storage

```
> ℹ️ **Note:** Ownership of /sdcard cannot be changed via chown. Access is provided via the --bind flag in the goz shortcut.
> 
## Shortcuts Reference (Ubuntu Terminal)
Run these as **zaman** (goz) to enable short commands:
```bash
echo "alias ag='antigravity --no-sandbox --disable-gpu --user-data-dir=~/.antigravity-data'" >> ~/.bashrc
echo "alias bb='brave-browser --no-sandbox --disable-gpu'" >> ~/.bashrc
source ~/.bashrc

```
| Command | Action |
|---|---|
| bb | Open Brave Browser |
| ag | Open Antigravity Editor |
*Built with ❤️ on a phone. Tested on Android 12+ (Redmi Note 12).*

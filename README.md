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
pkg install x11-repo -y && pkg install proot-distro termux-x11-nightly termux-api -y
```

### 1.6 Install Ubuntu
```bash
proot-distro install ubuntu
```

---

## Step 2 — Ubuntu Desktop Environment

### 2.1 Log Into Ubuntu & Update
```bash
proot-distro login ubuntu
```
```bash
apt update && apt upgrade -y
```

### 2.2 Create a User with sudo Access
> Running apps as root causes errors. Creating a regular user (`zaman`) fixes this.
> Install sudo
```bash
apt install sudo -y
```
>Create the user
```bash
useradd -m -s /bin/bash zaman
```
```bash
echo "zaman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

### 2.3 Install XFCE4 Desktop (Recommended — Lightweight)
```bash
apt install xfce4 xfce4-terminal dbus-x11 xdg-utils fonts-noto-core fonts-beng sudo wget curl nano --no-install-recommends -y
```

<details>
<summary>Alternative (heavier) installation options</summary>

**Medium:**
```bash
apt install xfce4 xfce4-terminal dbus-x11 x11-apps xterm xdg-utils wget curl nano sudo -y
```

**Full (not recommended — very heavy):**
```bash
apt install xfce4 xfce4-goodies xfce4-terminal dbus-x11 x11-apps xterm xdg-utils wget curl nano sudo -y
```

### 2.4 Fix Fonts (Bengali & Unicode Support)
```bash
apt install fonts-noto-core fonts-noto-ui-core fonts-noto-cjk fonts-beng -y
```
</details>

> ✅ Ubuntu setup complete. Now **exit back to Termux** to set up launch shortcuts.

### 2.5 Set Up `go` and `goz` Shortcuts (in Termux)

Exit Ubuntu first:
```bash
exit
```

Then run in Termux:
```bash
echo "alias go='termux-x11 :1 & sleep 2 && proot-distro login ubuntu --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
echo "alias goz='termux-x11 :1 & sleep 2 && proot-distro login ubuntu --user zaman --bind /sdcard:/sdcard --shared-tmp -- env DISPLAY=:1 startxfce4'" >> ~/.bashrc
source ~/.bashrc
```

| Shortcut | User | Use For |
|----------|------|---------|
| `go`     | root | Admin / system tasks |
| `goz`    | zaman | Coding, browsing, daily use ✅ |

---

## Step 3 — Launch the Desktop

### 3.1 Launch Using Shortcuts (Recommended)

From Termux, simply type:
```bash
goz
```
Then open the **Termux:X11** app on your phone — the desktop will appear.
<details>
<summary>### 3.2 Manual Launch (Alternative Method) options</summary>



**Session 1** — Start the display server:
```bash
termux-x11 :1 &
```

**Session 2** — Start the desktop (inside Ubuntu):
```bash
export DISPLAY=:1
dbus-launch startxfce4
```

Then open the **Termux:X11** app on your phone — the desktop will appear.
</details>
---

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
---

## Step 7 — Access Phone Storage

### 7.1 Link Phone Storage into Linux
Run inside Ubuntu (as root or zaman):
```bash
ln -s /sdcard ~/phone_storage
```

### 7.2 Storage Access for zaman

No extra permission command is needed. The `goz` shortcut already includes `--bind /sdcard:/sdcard`, which automatically mounts your phone storage inside Linux for the zaman user.

> ℹ️ **Note:** Running `chown -R zaman:zaman /sdcard` will fail with "Operation not permitted" — this is normal. Android's `/sdcard` is a FUSE mount point and its ownership cannot be changed from inside Linux, even on rooted phones.

### 7.3 Open Files in Antigravity
1. Open Antigravity → click **"Open Folder"**
2. Enter the path: `/sdcard` or `/home/zaman/phone_storage`
3. Your phone's files will appear in the editor's file explorer.

> 💡 **Pro Tip:** Keep your projects in `/sdcard/projects/` so they're visible from your phone's file manager too — and never accidentally deleted when resetting PRoot.

---

## Shortcuts Reference

> If you always use `goz` to launch the desktop, you are already logged in as **zaman** — use the zaman shortcuts below. Root shortcuts are only needed if you launch with `go`.

### Zaman User Shortcuts (recommended — run in XFCE terminal as zaman)

```bash
echo "alias ag='antigravity --no-sandbox --disable-gpu --user-data-dir=/home/zaman/.antigravity-data'" >> ~/.bashrc
echo "alias bb='brave-browser --no-sandbox --disable-gpu'" >> ~/.bashrc
echo "export DISPLAY=:1" >> ~/.bashrc
source ~/.bashrc
```

### Root User Shortcuts (only if you use `go` to launch)

```bash
echo "alias bb='su - zaman -c \"export DISPLAY=:1; brave-browser --no-sandbox --disable-gpu\"'" >> /root/.bashrc
echo "alias ag='su - zaman -c \"export DISPLAY=:1; antigravity --no-sandbox --disable-gpu\"'" >> /root/.bashrc
source /root/.bashrc
```

### All Shortcuts Summary

| Command | Where to Run | Action |
|---------|-------------|--------|
| `go`    | Termux      | Launch desktop as root |
| `goz`   | Termux      | Launch desktop as zaman (recommended) |
| `bb`    | Ubuntu terminal | Open Brave Browser |
| `ag`    | Ubuntu terminal | Open Antigravity Editor |

---

## Why `--no-sandbox --disable-gpu`?

PRoot is not a full virtual machine — it doesn't have kernel-level isolation. Chromium-based apps (Brave, Antigravity) require sandbox mode by default, which doesn't work in PRoot. Passing `--no-sandbox --disable-gpu` tells these apps to skip that requirement and run normally.

---

## Contributing

Feel free to open an issue or PR if something doesn't work on your device. Tested on Android 11+ with Termux from F-Droid.

---

*Built with ❤️ on a phone.*

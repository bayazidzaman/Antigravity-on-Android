#!/bin/bash
# ================================================
# ALL-IN-ONE SETUP SCRIPT
# Paste this once in Termux — does everything!
# ================================================

echo "==> [1/6] Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "==> [2/6] Installing Termux tools..."
pkg install x11-repo -y
pkg install proot-distro termux-x11-nightly termux-api tsu -y

echo "==> [3/6] Granting storage permission (tap Allow)..."
termux-setup-storage
sleep 5

echo "==> [4/6] Installing Ubuntu..."
proot-distro install ubuntu

echo "==> [5/6] Setting up go/goz shortcuts in Termux..."
grep -qxF "alias goz=" ~/.bashrc || cat <<'EOF' >> ~/.bashrc

alias go='pkill -9 termux-x11; pkill -9 proot; termux-x11 :1 & sleep 3 && proot-distro login ubuntu --shared-tmp -- env DISPLAY=:1 startxfce4'
alias goz='pkill -9 termux-x11; pkill -9 proot; termux-x11 :1 & sleep 3 && proot-distro login ubuntu --user zaman --bind /sdcard:/sdcard --shared-tmp -- env DISPLAY=:1 startxfce4'
EOF
source ~/.bashrc

echo "==> [6/6] Setting up Ubuntu (this will take a while)..."
proot-distro login ubuntu -- bash -c '

echo "--> Updating Ubuntu..."
apt update && apt upgrade -y

echo "--> Installing sudo & user zaman..."
apt install sudo -y
useradd -m -s /bin/bash zaman 2>/dev/null
echo "zaman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "--> Installing XFCE4 desktop..."
apt install xfce4 xfce4-terminal dbus-x11 xdg-utils fonts-noto-core fonts-beng wget curl nano --no-install-recommends -y

echo "--> Installing Brave Browser..."
apt install curl gnupg -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
  > /etc/apt/sources.list.d/brave-browser-release.list
apt update && apt install brave-browser -y

echo "--> Installing Antigravity Editor..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" \
  > /etc/apt/sources.list.d/antigravity.list
apt update && apt install antigravity -y
chown -R zaman:zaman /usr/share/antigravity 2>/dev/null

echo "--> Fixing browser links..."
cat <<BEOF > /usr/bin/bb-link
#!/bin/bash
exec brave-browser --no-sandbox --disable-gpu "\$@"
BEOF
chmod +x /usr/bin/bb-link

update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/bb-link 200
update-alternatives --set x-www-browser /usr/bin/bb-link
update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/bb-link 200
update-alternatives --set gnome-www-browser /usr/bin/bb-link
echo "export BROWSER=bb-link" >> /etc/environment

sed -i "s|Exec=brave-browser|Exec=brave-browser --no-sandbox --disable-gpu|g" /usr/share/applications/brave-browser.desktop
sed -i "s|Exec=antigravity|Exec=antigravity --no-sandbox --disable-gpu|g" /usr/share/applications/antigravity.desktop

echo "--> Setting up zaman user shortcuts..."
ln -sf /sdcard /home/zaman/phone_storage 2>/dev/null
grep -qxF "alias ag=" /home/zaman/.bashrc || cat <<ZEOF >> /home/zaman/.bashrc

alias ag="antigravity --no-sandbox --disable-gpu --user-data-dir=/home/zaman/.antigravity-data"
alias bb="brave-browser --no-sandbox --disable-gpu"
export DISPLAY=:1
ZEOF

echo ""
echo "✅ Ubuntu setup complete!"
'

echo ""
echo "========================================"
echo "✅ ALL DONE! Everything is installed."
echo "========================================"
echo ""
echo "To launch desktop, type:  goz"
echo "Then open Termux:X11 app."

#!/bin/bash

# Setup script for Ubuntu on WSL2

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR"

echo "Ubuntu の基本セットアップを開始します。"

# inputrc

echo ".inputrc の enable-bracketed-paste を on にします。"

if ! grep -q 'set\s+enable-bracketed-paste' ~/.inputrc 2>/dev/null; then
    echo "set enable-bracketed-paste on" >> ~/.inputrc
else
    sed -i -e 's,^\s*#*\s*set\s+\(enable-bracketed-paste\)\s*.*$,set \1 on,' ~/.inputrc
fi

echo "/etc/wsl.conf を用意します。"

template="$(cat <<'EOF'
[automount]
enabled = true
root = /mnt
options = "metadata,umask=22,fmask=11"
EOF
)"

overwrite=
if [ -e /etc/wsl.conf ]; then
    if ! diff -Bw /etc/wsl.conf <(echo "$template"); then
	echo "警告: /etc/wsl.conf を以下の内容に書き換えます。"
	echo "$template"
	key=INITIAL
	while true; do
	    case "$key" in
		y|Y|yes|YES|Yes)
		    overwrite=1
		    break
		    ;;
		n|N|no|NO|No|"")
		    overwrite=
		    echo "/etc/wsl.conf を書き換えません。必要であれば書き換えて下さい。"
		    break
		    ;;
		*)
		    read -p "書き換えますか？ (y/N): " key
		    ;;
	    esac
	done
    fi
else
    overwrite=1
fi

if [ -n "$overwrite" ]; then
    echo "$template" > ~/wsl.conf.$$
    sudo mv ~/wsl.conf.$$ /etc/wsl.conf
    echo "/etc/wsl.conf を書き換えました。"
    echo "WSL の再起動が必要です。"
fi

### setup apt ###

echo "システムに必要な設定を行います。"
echo "パスワードを入力して下さい。"

sudo sed -i.bak -e "s/http:\/\/archive\.ubuntu\.com/http:\/\/jp\.archive\.ubuntu\.com/g" /etc/apt/sources.list

### Adjust clock ###

# https://github.com/microsoft/WSL/issues/8204
sudo hwclock -s
sudo apt-get install -y ntpdate
sudo ntpdate time.windows.com

### install package ###

sudo apt-get update
sudo apt-get install -y git make

git config --global credential.helper store

### create symbolic links ###

USERPROFILE=$(wslpath -ua "$(cd /mnt/c; cmd.exe /c "echo %USERPROFILE%" | tr -d \\r)")
DOCUMENTS="$USERPROFILE/Documents"

ln -srf "$USERPROFILE"/Documents/dataentry ~/
ln -srf "$USERPROFILE"/Documents ~
ln -srf "$USERPROFILE"/Downloads ~
ln -srf "$USERPROFILE"/Desktop ~

if [ -d dataentry ]; then
    find dataentry/ -type f | xargs chmod 644
fi

echo ""
echo "Ubuntu の基本セットアップが完了しました。"
echo ""
echo "念の為再起動する事をお薦めします。"

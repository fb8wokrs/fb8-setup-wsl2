# fb8-setup-wsl2

## Setup WSL2 (Ubuntu 20.04)

WSL2 のセットアップと基本的な設定を行います。本プロジェクトは利用者PCの設定に利用します。

## セットアップ手順

Powershell で以下のセットアップ用コマンドを実行してセットアップを行って下さい。

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iwr https://github.com/fb8works/fb8-setup-wsl2/archive/refs/heads/main.zip -OutFile fb8-setup-wsl2-main.zip; Expand-Archive .\fb8-setup-wsl2-main.zip . -Force; fb8-setup-wsl2-main\setup.bat
```

セットアップ中はプログラムの表示する手順に従って進めて下さい。
途中再起動が必要な場合があります。再起動した場合はもう一度セットアップを実行してください。（追記：再起動が要求されない事があります。失敗した場合は再起動してもう一度実行してください。）

1. 上述のセットアップ用コマンドをコピーします。(Github の場合はコマンドにマウスをポイントするとコピーボタンが表示されます)
1. スタートメニューから「Windows Powershell」を起動します (Win+X I)。
1. Ctrl+V または右クリックで貼り付けます。
1. Enter キーを押します。
1. 「Windows によって PC が保護されました」と表示されますので「詳細情報」をクリックします。
1. 「実行」ボタンを押します。

## インストールされるアプリケーションと設定内容について

WSL2 のセットアップを行います。セットアップを行うことで以下のアプリケーションのインストールと各種設定が行われます。

- scoop
- gsudo
- Git
- Windows Terminal
- Microsoft-Windows-Subsystem-Linux
- VirtualMachinePlatform
- WSL2 カーネルアップデート
- Ubuntu 20.04

Ubuntu には以下のアプリケーションをインストールします。

- git
- make

以下の設定を行います。

- Ubuntu を U: ドライブにマップします。
- /etc/wsl.conf を作成し umask 等の設定を行います。
- Desktop, Documents, Downloads へのシンボリックリンクを作成します。

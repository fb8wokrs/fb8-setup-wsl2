# -*- encoding: utf-8-with-signature-unix -*-

# Install windows features for WSL2.
# Administrator privilege required.

dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# check restart required
# TODO does not work
$result1 = dism /online /Get-FeatureInfo /featurename:Microsoft-Windows-Subsystem-Linux /english
$result2 = dism /online /Get-FeatureInfo /featurename:VirtualMachinePlatform /english
Write-Host "debug: result1=$result1"
Write-Host "debug: result2=$result2"
If (($result1 + $result2).Contains("Restart Required : Required")) {
    Write-Host "再起動が必要です。再起動してからもう一度セットアップを実行してください。"
    Read-Host "Enter キーを押すと再起動します。"
    Restart-Computer
    exit 1
}

Write-Host "WSL のインストールに必要な機能を有効化しました。"
exit 0

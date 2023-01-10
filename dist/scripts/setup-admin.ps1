# -*- encoding: utf-8-with-signature-unix -*-

# Install windows features for WSL2.
# Administrator privilege required.

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

$result = dism /online /Get-FeatureInfo /featurename:VirtualMachinePlatform /english
If ($result.Contains("Restart Required : Required")) {
    Write-Host "再起動が必要です。再起動してからもう一度 setup.bat を実行してください。"
    Read-Host "Enter キーを押すと再起動します。"
    Restart-Computer
    exit 1
}

Write-Host "WSL のインストールに必要な機能を有効化しました。"
exit 0

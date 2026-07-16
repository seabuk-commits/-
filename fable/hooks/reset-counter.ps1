# Stop 훅: Claude 응답(턴)이 끝날 때 직접수정 카운터를 0으로 리셋 (Windows PowerShell 버전)
$ErrorActionPreference = "SilentlyContinue"
$CounterFile = Join-Path $env:USERPROFILE ".claude\.fable-editcount"
Set-Content -Path $CounterFile -Value "0" -NoNewline
exit 0
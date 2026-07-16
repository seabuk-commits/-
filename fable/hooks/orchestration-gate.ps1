$ErrorActionPreference = "SilentlyContinue"
$StateFile   = Join-Path $env:USERPROFILE ".claude\.fable-state"
$CounterFile = Join-Path $env:USERPROFILE ".claude\.fable-editcount"
$ModelFile   = Join-Path $env:USERPROFILE ".claude\.fable-current-model"
$Limit = 2

try {
    $stdinStream = [Console]::OpenStandardInput()
    $reader = New-Object System.IO.StreamReader($stdinStream, [System.Text.Encoding]::UTF8)
    $raw = $reader.ReadToEnd()
    $data = $raw | ConvertFrom-Json
} catch {
    exit 0
}

$state = if (Test-Path $StateFile) { (Get-Content $StateFile -Raw).Trim().ToLower() } else { "off" }
if ($state -ne "on") { exit 0 }

$currentModel = if (Test-Path $ModelFile) { (Get-Content $ModelFile -Raw).Trim().ToLower() } else { "" }
if ($currentModel -notlike "*opus*") { exit 0 }

$toolName = $data.tool_name
$editTools = @("Edit", "Write", "MultiEdit")
if ($editTools -notcontains $toolName) { exit 0 }

$count = 0
if (Test-Path $CounterFile) {
    $c = (Get-Content $CounterFile -Raw).Trim()
    if ($c -match '^\d+$') { $count = [int]$c }
}

if ($count -ge $Limit) {
    $msg = "STOP [Fable Gate] Opus가 이번 턴 직접 파일수정 한도(2개)를 초과했습니다.`n" +
           "재시도하지 말고 이 작업을 explorer 비서에게 위임하거나,`n" +
           "정말 필요한 수정인지 재검토 후 다음 턴에 진행하십시오."
    $errStream = [Console]::OpenStandardError()
    $errWriter = New-Object System.IO.StreamWriter($errStream, [System.Text.Encoding]::UTF8)
    $errWriter.WriteLine($msg)
    $errWriter.Flush()
    exit 2
}
Set-Content -Path $CounterFile -Value ($count + 1) -NoNewline
exit 0

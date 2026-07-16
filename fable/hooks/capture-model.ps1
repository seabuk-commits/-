$ErrorActionPreference = "SilentlyContinue"
$ModelFile = Join-Path $env:USERPROFILE ".claude\.fable-current-model"

try {
    $stdinStream = [Console]::OpenStandardInput()
    $reader = New-Object System.IO.StreamReader($stdinStream, [System.Text.Encoding]::UTF8)
    $raw = $reader.ReadToEnd()
    $data = $raw | ConvertFrom-Json
    if ($data.model) {
        Set-Content -Path $ModelFile -Value $data.model -NoNewline
    }
} catch {
}
exit 0

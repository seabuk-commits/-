<#
이 프로젝트(git 동기화 폴더)를 새 컴퓨터(예: 회사 컴퓨터)에서 열었을 때,
색선이/족집게/귀눈이 서브에이전트가 바로 동작하도록 필요한 프로그램을 한 번에 설치한다.

agents/, scripts/ 같은 프로젝트 파일은 git으로 이미 동기화되지만,
Python 실행 파일과 pip로 설치한 라이브러리, ffmpeg 같은 실제 프로그램은 컴퓨터마다 따로
설치해야 한다 (동기화되지 않음). 이 스크립트가 그 부분을 담당한다.

사용법 (PowerShell):
    scripts\setup_machine.ps1

여러 번 실행해도 안전하다 (이미 설치된 건 건너뛴다).
리눅스/맥(또는 이 클라우드 환경)에서는 대신 scripts/setup_machine.sh 를 사용한다.
#>

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$pythonPath = "C:\Users\user\AppData\Local\Programs\Python\Python312\python.exe"

Write-Host "=== 1. Python 3.12 확인 ==="
if (-not (Test-Path $pythonPath)) {
    Write-Host "Python 3.12가 없어서 설치합니다..."
    winget install --id Python.Python.3.12 --source winget --accept-source-agreements --accept-package-agreements --silent
    Write-Host "설치 후 실제 경로가 다를 수 있습니다. 다음 명령으로 찾아서 이 스크립트 상단의 `$pythonPath 를 갱신하세요:"
    Write-Host '  Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Programs\Python" -Directory'
    exit 1
} else {
    Write-Host "OK: $pythonPath"
}

Write-Host ""
Write-Host "=== 2. ffmpeg 확인 ==="
$ffmpegCmd = Get-Command ffmpeg -ErrorAction SilentlyContinue
if (-not $ffmpegCmd) {
    Write-Host "ffmpeg가 없어서 설치합니다..."
    winget install --id Gyan.FFmpeg -e --source winget --accept-source-agreements --accept-package-agreements
    Write-Host "설치 완료. PATH 반영을 위해 터미널/Claude Code를 재시작해야 할 수 있습니다."
} else {
    Write-Host "OK: $($ffmpegCmd.Path)"
}

Write-Host ""
Write-Host "=== 2b. poppler(pdftoppm) 확인 ==="
$popplerCmd = Get-Command pdftoppm -ErrorAction SilentlyContinue
if (-not $popplerCmd) {
    Write-Host "poppler가 없어서 설치합니다... (스캔본/이미지 기반 PDF를 Read 도구로 읽을 때 필요)"
    winget install --id oschwartz10612.Poppler -e --source winget --accept-source-agreements --accept-package-agreements
    Write-Host "설치 완료. PATH 반영을 위해 터미널/Claude Code를 재시작해야 할 수 있습니다."
} else {
    Write-Host "OK: $($popplerCmd.Path)"
}

Write-Host ""
Write-Host "=== 3. Python 라이브러리 확인/설치 ==="
Write-Host "(faster-whisper: 귀눈이/족집게 STT / Pillow, numpy, opencv, scikit-learn, scipy: 색선이 이미지 처리)"
& $pythonPath -m pip install --upgrade pip faster-whisper pillow numpy opencv-python-headless scikit-learn scipy pymupdf markdown

Write-Host ""
Write-Host "=== 4. 최종 확인 ==="
& $pythonPath -c "import faster_whisper, PIL, numpy, cv2, sklearn, scipy; print('faster_whisper ok'); print('Pillow', PIL.__version__); print('numpy', numpy.__version__); print('cv2', cv2.__version__); print('sklearn', sklearn.__version__); print('scipy', scipy.__version__)"

Write-Host ""
Write-Host "완료. 색선이/족집게/귀눈이 에이전트를 바로 사용할 수 있습니다."

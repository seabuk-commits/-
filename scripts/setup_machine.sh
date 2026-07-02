#!/usr/bin/env bash
# 이 프로젝트를 새 컴퓨터(리눅스/맥, 또는 이 클라우드 환경)에서 열었을 때,
# 색선이/족집게/귀눈이 서브에이전트가 바로 동작하도록 필요한 프로그램을 한 번에 설치한다.
#
# agents/, scripts/ 같은 프로젝트 파일은 git으로 이미 동기화되지만,
# python 실행 파일과 pip로 설치한 라이브러리, ffmpeg/poppler 같은 실제 프로그램은
# 컴퓨터마다 따로 설치해야 한다 (동기화되지 않음). 이 스크립트가 그 부분을 담당한다.
#
# 사용법 (bash/zsh):
#   bash scripts/setup_machine.sh
#
# 여러 번 실행해도 안전하다 (이미 설치된 건 건너뛴다).
# Windows에서는 대신 scripts/setup_machine.ps1 을 사용한다.

set -e

echo "=== 1. python3 확인 ==="
if ! command -v python3 >/dev/null 2>&1; then
    echo "python3가 없습니다. apt(데비안/우분투) 기준 설치를 시도합니다..."
    apt-get update -qq && apt-get install -y -qq python3 python3-pip
else
    echo "OK: $(command -v python3) ($(python3 --version))"
fi

echo ""
echo "=== 2. ffmpeg 확인 ==="
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg가 없어서 설치합니다..."
    apt-get update -qq && apt-get install -y -qq ffmpeg
else
    echo "OK: $(command -v ffmpeg)"
fi

echo ""
echo "=== 2b. poppler(pdftoppm) 확인 ==="
if ! command -v pdftoppm >/dev/null 2>&1; then
    echo "poppler가 없어서 설치합니다... (스캔본/이미지 기반 PDF를 Read 도구로 읽을 때 필요)"
    apt-get update -qq && apt-get install -y -qq poppler-utils
else
    echo "OK: $(command -v pdftoppm)"
fi

echo ""
echo "=== 3. Python 라이브러리 확인/설치 ==="
echo "(faster-whisper: 귀눈이/족집게 STT / Pillow, numpy, opencv, scikit-learn, scipy: 색선이 이미지 처리 / pymupdf, markdown: PDF·문서 처리)"
python3 -m pip install --break-system-packages --quiet faster-whisper pillow numpy opencv-python-headless scikit-learn scipy pymupdf markdown

echo ""
echo "=== 4. 최종 확인 ==="
python3 -c "
import faster_whisper, PIL, numpy, cv2, sklearn, scipy, fitz, markdown
print('faster_whisper ok')
print('Pillow', PIL.__version__)
print('numpy', numpy.__version__)
print('cv2', cv2.__version__)
print('sklearn', sklearn.__version__)
print('scipy', scipy.__version__)
print('markdown', markdown.__version__)
"

echo ""
echo "완료. 색선이/족집게/귀눈이 에이전트를 바로 사용할 수 있습니다."

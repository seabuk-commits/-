"""
mp3/wav 등 음성 파일을 텍스트 대본으로 변환한다.
귀눈이 서브에이전트(agents/귀눈이.md)가 읽을 수 있는 타임스탬프 포함 텍스트를 만든다.

사용법:
    python transcribe.py <오디오파일> [--model 모델크기] [--lang 언어코드]

예시:
    python transcribe.py "강의녹음.mp3"
    python transcribe.py "강의녹음.mp3" --model small --lang ko

출력:
    같은 폴더에 <오디오파일 이름>.txt 로 저장한다.
"""

import argparse
import sys
from pathlib import Path

from faster_whisper import WhisperModel


def format_timestamp(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    h, m = divmod(m, 60)
    if h:
        return f"{h:02d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"


def main():
    parser = argparse.ArgumentParser(description="음성 파일을 텍스트 대본으로 변환")
    parser.add_argument("audio", help="변환할 오디오 파일 경로")
    parser.add_argument("--model", default="medium",
                         help="whisper 모델 크기: tiny/base/small/medium/large-v3 (기본값 medium)")
    parser.add_argument("--lang", default="ko", help="언어 코드 (기본값 ko)")
    parser.add_argument("--device", default="cpu", choices=["cpu", "cuda"],
                         help="cpu 또는 cuda (기본값 cpu, GPU 드라이버 문제 시 cpu 권장)")
    parser.add_argument("--out", default=None, help="출력 텍스트 파일 경로 (기본값: 오디오와 같은 폴더, 같은 이름 .txt)")
    args = parser.parse_args()

    audio_path = Path(args.audio)
    if not audio_path.exists():
        print(f"파일을 찾을 수 없음: {audio_path}", file=sys.stderr)
        sys.exit(1)

    out_path = Path(args.out) if args.out else audio_path.with_suffix(".txt")

    compute_type = "int8" if args.device == "cpu" else "float16"
    print(f"모델 로딩 중: {args.model} ({args.device}, {compute_type})")
    model = WhisperModel(args.model, device=args.device, compute_type=compute_type)

    print(f"변환 시작: {audio_path}")
    segments, info = model.transcribe(str(audio_path), language=args.lang, beam_size=5)

    print(f"감지된 언어: {info.language} (확률 {info.language_probability:.2f})")

    lines = []
    for seg in segments:
        start = format_timestamp(seg.start)
        end = format_timestamp(seg.end)
        text = seg.text.strip()
        lines.append(f"[{start} - {end}] {text}")
        print(f"[{start} - {end}] {text}")

    out_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"\n대본 저장 완료: {out_path}")


if __name__ == "__main__":
    main()

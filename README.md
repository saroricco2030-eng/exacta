# Exacta — Tamper-Proof Field Camera

![version](https://img.shields.io/badge/version-1.7.0-blue) ![platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green) ![flutter](https://img.shields.io/badge/Flutter-3.x-02569B) ![license](https://img.shields.io/badge/license-Proprietary-red)

> **현장 전용. 법적 증거급. 완전 오프라인.**
>
> 시간·GPS·SHA-256 해시 체인이 픽셀에 합성되는 위변조 불가 카메라 앱.

---

## ✨ Why Exacta

대부분의 카메라 앱은 EXIF 메타데이터에 시간을 기록합니다. **EXIF는 누구나 5초 만에 지울 수 있습니다.** Exacta는 다릅니다 —

- **픽셀 번인**: 시간/GPS/주소가 사진 픽셀에 직접 합성. 포토샵으로 그 영역을 복원 편집해야 지울 수 있음 = 즉시 조작 흔적
- **NTP 시각 보정**: 기기 시계를 바꿔도 인터넷 표준 시간이 기록됨
- **SHA-256 해시 체인**: 사진 1장만 조작해도 이후 모든 사진의 체인 해시가 깨져서 즉시 탐지
- **완전 오프라인**: 서버 없음, 계정 없음, 광고 없음. 사진은 단말에만 저장
- **법적 증거 팩 PDF**: 사건명/작성자 입력 → 표지+사진+해시+검증 안내 자동 생성

---

## 🎯 누구를 위한 앱인가

| 직군 | 용도 |
|------|------|
| HVAC·배관·전기 시공자 | 시공 전/후 사진, 검수 증거 |
| 건설 현장 감독 | 일일 진행 기록, 안전 점검 |
| 부동산 임장·하자 점검 | 임차 입주/퇴실 상태, 하자 증거 |
| 보험 손해사정 | 차량 사고 현장, 재해 증거 |
| 택배·물류 | 인수인계 사진, 배송 완료 증거 |
| 법무·소송 | 증거 사진, 현장 검증 |

40~50대 현장 기술자를 1차 페르소나로 설계 — 굵은 글씨, 큰 셔터(66dp), 장갑 환경 56dp 터치 타겟, 한 손 조작.

---

## 📱 핵심 기능

### 촬영
- 사진 / 영상 / 타임랩스 / 인터벌 모드
- 시공 / 보안 2개 프리셋 (보안 모드는 GPS·주소 완전 차단 + EXIF 위치 스트리핑)
- 12종 스탬프 프리셋 (Full / Construction / Inspection / Delivery / Real Estate / ...)
- 3종 스탬프 레이아웃 (Card / Bar / **Text** ← 기본)

### 스탬프 메타
- 시간 (NTP 보정)
- 날짜 + 요일 (한/영/일 자동)
- 주소 (역지오코딩)
- GPS 좌표 (위경도)
- 도시명 (우측 컬럼)
- 증거 ID (`EX-YYYYMMDD-HHMMSS-XXXX`)
- 메모 (블루 하이라이트, 우측 컬럼 전폭)
- 나침반 / 고도 / 속도 (옵션)
- 날씨 (자동)
- 로고 / 손글씨 서명 (선택)
- **위변조 불가 배지** (모든 사진 하단)

### 프로젝트
- 프로젝트 CRUD + 컬러 라벨
- 자동 분류 + 프로젝트 필터
- 진행/완료 상태

### 갤러리
- 날짜별 그룹 + 프로젝트 필터 칩
- 핀치 줌 + 정보 시트
- **법적 증거 카드** (NTP 상태, 4가지 위변조 방지 사유, 무결성 검증 버튼)

### 내보내기
- 개별 공유 (시스템 공유 시트)
- ZIP 일괄 내보내기 (백그라운드 isolate 인코딩)
- PDF 리포트 (사진 + 메타데이터)
- **법적 증거 팩 PDF** (사건명/작성자/표지/전체 해시/외부 검증 안내, Noto Sans CJK 자동 로드)

### 설정
- 스탬프 포맷 / 색상 / 위치 / 폰트 / 레이아웃
- 카메라 해상도 / 셔터음 / 배터리 세이버
- 보안 옵션 (EXIF 스트립 / 보안 공유 제한)
- 테마 (시스템/라이트/다크)
- 언어 (시스템/한국어/English/日本語)

---

## 🛠 기술 스택

- **Flutter 3.x** (Dart)
- **State**: Riverpod 2.x
- **DB**: Drift (SQLite) — schema v11
- **Camera**: `camera` plugin
- **Location**: `geolocator` + `geocoding`
- **Image**: `dart:ui` Canvas API (스탬프 번인) + `image` 패키지 (JPEG 인코딩, isolate)
- **PDF**: `pdf` + `printing` (PdfGoogleFonts)
- **Hash**: `crypto` (SHA-256)
- **Time**: `ntp`
- **i18n**: `flutter_localizations` + `intl`
- **Native channels**: Android MediaStore (Pictures/Exacta/)

---

## 🏗 빌드

### 필수
- Flutter SDK 3.10+
- Android: SDK 34+, NDK
- iOS: Xcode 15+ (macOS 필요), CocoaPods

### Android (Play Store용 AAB)
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift 코드 생성
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
# → build/app/outputs/bundle/release/app-release.aab (~58MB)
```

### Android (개발용 APK)
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
# → build/app/outputs/flutter-apk/app-release.apk (~68MB)
```

### iOS
```bash
cd ios && pod install && cd ..
flutter build ios --release
# 이후 Xcode에서 Archive → App Store Connect 업로드
```

---

## 📂 프로젝트 구조

```
lib/
├── main.dart                       # 앱 진입점, 테마/로케일 초기화
├── shell/
│   └── dual_shell.dart             # 5탭 바텀 네비
├── core/
│   ├── colors.dart                 # AppColors 토큰
│   ├── theme/                      # 라이트/다크 테마
│   ├── transitions.dart            # SlideUp/SlideRight/Fade 라우트
│   └── extensions/
├── data/
│   ├── database.dart               # Drift 스키마 v11 + DAO
│   └── providers.dart              # Riverpod providers
├── features/
│   ├── camera/                     # 촬영 + 스탬프 편집
│   ├── gallery/                    # 갤러리 + 사진 상세 + 증거 카드
│   ├── projects/                   # 프로젝트 CRUD
│   ├── export/                     # 공유/ZIP/PDF/증거팩
│   ├── settings/                   # 설정 + 낙관적 업데이트
│   └── splash/                     # 브랜드 스플래시 + 버전 배지
├── services/
│   ├── stamp_burn_service.dart     # Canvas 픽셀 번인
│   ├── photo_save_service.dart     # 저장 파이프라인
│   ├── evidence_hash_service.dart  # SHA-256 해시 체인
│   ├── evidence_pack_service.dart  # 법적 증거 PDF
│   ├── pdf_report_service.dart     # 일반 PDF 리포트
│   ├── gallery_register_service.dart # MediaStore 등록
│   ├── ntp_service.dart            # 시간 동기화
│   ├── photo_code_service.dart     # 증거 ID 생성
│   └── weather_service.dart
└── l10n/                           # ko/en/ja arb
```

---

## 🔐 보안 설계

| 레이어 | 적용 |
|--------|------|
| 코드 난독화 | `--obfuscate --split-debug-info` |
| ProGuard / R8 | `minifyEnabled true`, `shrinkResources true` |
| EXIF 위치 스트리핑 | 보안 모드 + 일반 모드 모두 |
| 권한 최소화 | 런타임 요청, 최소 권한 |
| NTP 시각 검증 | 기기 시계 조작 탐지 |
| SHA-256 해시 체인 | 위변조 탐지 |
| 데이터 완전 로컬 | 외부 통신 0건 |

---

## 📋 스토어 제출 자료

`store/` 디렉토리:
- `ko/` — 한국어 타이틀, 짧은 설명, 긴 설명, 키워드
- `en/` — English
- `ja/` — 日本語

`docs/` 디렉토리 (GitHub Pages 호스팅 가능):
- `privacy_policy_{ko,en,ja}.md` — 개인정보 처리방침
- `terms_of_service_{ko,en,ja}.md` — 이용약관

---

## 📜 License

Proprietary © saroricco2030-eng. All rights reserved.

---

## 🐛 Issue / Contact

[GitHub Issues](https://github.com/saroricco2030-eng/exacta/issues)

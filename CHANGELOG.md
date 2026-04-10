# Changelog

이 문서는 [Keep a Changelog](https://keepachangelog.com/) 형식과
[Semantic Versioning](https://semver.org/)을 따릅니다.

## [1.7.0+17] — 2026-04-10

### Added — 스토어 제출 준비
- **Android AAB 빌드** (`flutter build appbundle --release --obfuscate`) — 57.9MB
- **iOS Info.plist 권한 사유 5종** (Camera/Mic/Location/PhotoLibrary/Add)
- **iOS InfoPlist.strings 한/영/일 로케일별** (`ko.lproj`, `en.lproj`, `ja.lproj`)
- **iOS PrivacyInfo.xcprivacy** (iOS 17+ 필수 매니페스트)
  - NSPrivacyTracking: false (추적 없음)
  - NSPrivacyCollectedDataTypes: 빈 배열 (수집 데이터 없음)
  - 4가지 Required Reason API 선언 (FileTimestamp/DiskSpace/UserDefaults/SystemBootTime)
- **iOS Podfile** (표준 Flutter 템플릿) — macOS에서 `pod install` 즉시 가능
- **스토어 리스팅 카피** (store/ko, en, ja) — 타이틀/짧은 설명/긴 설명/키워드
- **개인정보 처리방침** (docs/privacy_policy_{ko,en,ja}.md) — GitHub Pages 호스팅 가능
- **이용약관** (docs/terms_of_service_{ko,en,ja}.md)
- **README.md** 전면 재작성 — 기능, 빌드 방법, 프로젝트 구조
- **CHANGELOG.md** 신규 작성

### Fixed
- AndroidManifest.xml `android:label` `"exacta"` → `"Exacta"` (브랜딩)

## [1.6.2+16] — 2026-04-10
### Changed
- 코드 검수 정리: `Colors.white` 하드코딩 제거 → `const Color(0xFFFFFFFF)`
- Dead import 제거 (`flutter/material.dart show Colors`)
- 성능: text 모드에서 weather painter 생성 스킵 (4K 사진당 1~3ms 절약)

## [1.6.1+15] — 2026-04-10
### Removed
- 퀵 메모 칩 + QuickMemoSheet 롤백 (UX 피드백 반영)
- 관련 i18n 키 정리

### Kept
- 메모 블루 컬러(#4FC3F7)는 유지

## [1.6.0+14] — 2026-04-10
### Added
- 메모 블루 하이라이트 (다른 흰색 스탬프 글씨와 시각적 구분)

## [1.5.3+13] — 2026-04-10
### Changed
- 메모를 우측 컬럼 위치정보 아래 빈 공간으로 이동 (Row 구조 반전)

## [1.5.1+11] — 2026-04-10
### Fixed
- 스탬프 2열 정렬 버그 (좌/우 높이 불일치, 센서 라인 별도 Row 빠짐)
- `crossAxisAlignment: start` 강제 + 센서를 좌측 컬럼에 흡수

## [1.5.0+10] — 2026-04-10
### Changed
- 스탬프 구조 정규화: 2열 + 구분선 + 중앙 배지

## [1.4.0+9] — 2026-04-10
### Added
- 위변조 불가 배지 — 모든 스탬프 하단에 픽셀 번인
  ko: `✓ Exacta · 위변조 불가 (NTP · GPS 번인 · SHA-256)`

## [1.3.3+8] — 2026-04-10
### Changed
- 사진 정보의 해시 64자리 테크 표시 → 평범한 한국말 4가지 사유 카드

## [1.3.2+7] — 2026-04-10
### Fixed
- 증거 검증 스낵바 중첩 (clearSnackBars 호출 추가)

## [1.3.1+6] — 2026-04-10
### Changed
- 스탬프 기본 레이아웃 `card` → `text` (DB v10→v11 마이그레이션)

## [1.3.0+5] — 2026-04-10
### Added
- 스탬프 'text' 레이아웃 (Timemark 스타일, 배경 없이 그림자 텍스트)

## [1.2.1+4] — 2026-04-10
### Fixed
- 스탬프 프리셋 12종 한/영/일 현지화 (`stampPreset*` 13개 키)

## [1.2.0+3] — 2026-04-10
### Added — 법적 증거 팩 ⭐
- DB v9→v10: photoHash / prevHash / chainHash / ntpSynced 컬럼
- `EvidenceHashService`: SHA-256 파일 해싱 + canonical 체인 공식
- `PhotoSaveService` 증거 해시 파이프라인 통합
- 사진 상세 화면 "법적 증거" 카드 + 무결성 검증 버튼
- `EvidencePackService` — 법적 제출용 PDF 생성 (PdfGoogleFonts CJK 자동)
- 내보내기 화면 증거 팩 옵션 (사건명/작성자 입력 다이얼로그)
- crypto ^3.0.5 의존성

## [1.1.0+2] — 2026-04-10
### Added
- 설정 낙관적 업데이트 리팩토링 (DB 왕복 제거)
- 페이지 전환 + 마이크로 애니메이션 통일
- 바텀 셸 탭 애니메이션
- 버전 배지 (스플래시 + 설정)
- `package_info_plus` 의존성

### Fixed
- 홈 캘린더 월/날짜 off-by-one
- 카메라 프로젝트 칩 피드백 (로컬 state)
- 순정 갤러리 토글 양방향 동기화
- MainActivity MIME 타입 항상 PNG 버그
- Android 12+ 시스템 스플래시 아이콘 숨김

## [1.0.0+1] — 2026-03-30
### Added
- Phase 1~4 전체 완료 + 800 원칙 감사 기반 전면 개선
- 카메라 / 스탬프 번인 / 갤러리 / 프로젝트 / 설정 / 다국어 / 다크모드 / 위젯

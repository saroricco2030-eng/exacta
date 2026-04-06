# 앱 개발 공통 수칙

> AI 개발 파트너 행동 원칙
>
> ┌─ 지식베이스 구조 (범용 2파일 + 프로젝트 1파일) ──────────────────────────┐
> │  3개 파일은 서로를 교차 참조한다. 하나라도 빠지면 참조 연결이 끊긴다.  │
> │  Claude Code 환경 : 프로젝트 루트에 파일 배치 → 자동 로드             │
> │  일반 채팅 환경   : 코딩 요청 시 관련 파일 동시 첨부 필수              │
> │                                                                        │
> │  ★ 코딩 전 필수 확인 순서 (매번) — 이 목록이 유일한 기준              │
> │    1. 이 파일 "디자인 시스템" → AppColors 토큰 + 다크/라이트 스타일 확인│
> │       (비어있으면 토큰 작성 요청)                                      │
> │    2. 이 파일 "특이사항" → 터치 기준 / RBAC 역할 확인                 │
> │    3. 이 파일 "0-1 Phase" → 현재 Phase 범위 확인                      │
> │    4. DESIGN_MASTER PART 13 → Phase 핵심 컴포넌트 확인               │
> │       DESIGN_MASTER PART 14 → 도메인 UX 확인                         │
> │       이 파일 "페르소나" 섹션 → 신규 화면 설계 전 주 페르소나 확인    │
> │         ※ 비어있으면 → 화면 설계 전 작성 요청, 임의 설계 금지        │
> │         ※ PART 14 명칭과 반드시 동일하게 유지                         │
> │    5. SECURITY_MASTER_v2.2.md PART 13 → 프로젝트 특화 보안 확인      │
> │                                                                        │
> │  DESIGN_MASTER_v3.2.md          ← 범용 / 프로젝트 무관                │
> │    비주얼·UX·IA·오프라인·알람·성능 / Flutter 코드(PART 12)            │
> │    ※ PART 5-3 컬러 토큰 → 이 파일 "디자인 시스템" 섹션이 덮어씀      │
> │    ※ PART 13(Phase 컴포넌트) · PART 14(도메인 UX) → 프로젝트별 작성 │
> │                                                                        │
> │  SECURITY_MASTER_v2.2.md        ← 범용 / 프로젝트 무관                │
> │    보안 12개 레이어 · RBAC · 데이터 거버넌스                          │
> │    ★ 보안·RBAC·CLIENT_VIEW 관련 단일 출처(Source of Truth)            │
> │    ※ PART 13(도메인 특화 보안) → 이 파일 "특이사항" 섹션과 연동      │
> │                                                                        │
> │  [프로젝트명]_FEATURE_UNIVERSE.md  ← 프로젝트 전용                   │
> │    해당 프로젝트 기능 전체 정의 + Phase 로드맵                        │
> │    (없는 경우 이 CLAUDE.md 하단 "프로젝트 정보" 섹션에 직접 기재)    │
> └────────────────────────────────────────────────────────────────────────┘
>
> **AI 행동 원칙**
> - 이 파일을 어기는 코드·설계 발견 시 즉시 알리고 수정 방향을 제안한다
> - 모호한 요청은 구현 전에 의도를 확인한다
> - 잘못된 방향이라 판단되면 솔직하게 피드백한다
> - 선택지 필요 시 근거와 함께 제시하고 결정을 기다린다
> - Firestore/DB 구조 확정 시 "데이터 구조" 섹션에 즉시 반영
> - 설계 변경 시 기존 내용 수정 + 변경 이유 한 줄 메모
>
> **기능 완성 기록**
> - Claude Code 환경: AI가 이 파일을 직접 수정하여 기록 (`- [YYYY-MM-DD] 기능명: 설명`)
> - 일반 채팅 환경: AI가 완성 내용을 알려주면 사업주가 직접 파일에 기록

---

> **섹션 참조 시점 가이드**
> ```
> [매 화면 코딩 시 — 항상]  섹션 0~0-2, 1(i18n), 3(UX), 4(디자인)
> [특정 시점에만]           섹션 2(보안) → 인증/API/DB 작업 시
>                          섹션 5(Post-Build) → Phase 완료 시
>                          섹션 6(경쟁앱) → 신규 기능 설계 시
> [프로젝트 설정 시 1회]    섹션 7~12
> ```

## 0. 개발 워크플로우

모든 기능 요청은 아래 순서를 따른다.

```
1. PLAN      — 요구사항 분석 · 사용자 흐름 확인
               현재 Phase 범위 확인 (섹션 0-1)
               ※ 신규 기능 설계 시만: 경쟁앱 레퍼런스 검토 (섹션 6)
               ※ 단순 수정/추가: 경쟁앱 분석 스킵
2. IMPLEMENT — 완성형 코드 제공 (바로 실행 가능한 상태)
               섹션 0-2 자동 적용 규칙 전체 적용
3. VALIDATE  — 2단계 검증 실행 (아래 참조)
```

**검증 2단계 체계**
```
[인라인 검증] — 코드 생성 직후 매번 실행 (빠른 self-check)
  → 섹션 1 i18n 검증 (5단계)
  → 섹션 4-6 디자인 검증 (6단계)
  → 섹션 3 UX 핵심 체크 (3항목):
    ✓ 3상태(Loading/Empty/Error) 구현 여부
    ✓ 주요 CTA 엄지존(하단) 배치 여부
    ✓ 모든 액션에 상태 피드백 존재 여부
  → 리포트 (이 형식이 유일한 출력):
    "검증 완료 — i18n 키 N개 / 디자인 위반 N건 / UX 이상 없음"
    ※ 섹션 1·4-6의 개별 리포트는 내부 절차. 최종 출력은 이 통합 형식 1회.

[종합 검증] — Phase 완료 시 실행 (전수 검사)
  → DESIGN_MASTER PART 8 체크리스트 전체 (i18n·UX·디자인·성능 모두 포함)
  → Post-Build Review (섹션 5) — 리뷰어 시점 평가
  → 개선 포인트 리포트
```

- 파일 구조 변경 · 대규모 리팩토링은 반드시 사전 확인 후 진행
- 에러 발생 시: 원인 + 해결책을 함께 보고

---

## 0-1. Phase 개발 순서 (프로젝트별 작성)

> **현재 구현 중인 Phase 외의 기능은 절대 구현하지 않는다.**
> Phase 경계를 넘는 구현 요청은 수락 전 반드시 확인한다.
> ※ PROJECT_INIT_SEQUENCE.md STEP 3에서 이 섹션을 채운다.

```
▶ 현재 진행 Phase: PHASE 4
```

---

### PHASE 1 — [카메라 코어 + 갤러리]
```
기능:
- 카메라 촬영 (사진) + 타임스탬프 실시간 번인 (시간/날짜/요일/주소/GPS)
- 프리셋 2종 (시공기록 / 보안촬영)
- 보안 모드 (GPS/주소/나침반/미니맵 숨김 + EXIF 위치 스트리핑)
- 스탬프 편집 바텀시트 (메모/태그 입력, 프로젝트 선택, 요소별 on/off 토글)
- 프로젝트 CRUD (생성/편집/삭제)
- 프로젝트별 사진 자동분류 + 프로젝트 없이 촬영 허용
- 갤러리 (날짜별 그룹 + 프로젝트 필터 칩)
- 순정 갤러리 표시 제어 토글 (보안촬영분은 강제 숨김)
- 설정 화면 (스탬프 포맷/색상/위치/폰트, 해상도, 셔터음, 보안 옵션)
```

**Phase 1 시작 전 AI 읽기 목록**
```
DESIGN_MASTER:
  ✅ PART 1~2    비주얼 시스템 + 레이아웃 규칙
  ✅ PART 3      UX 7원칙 (Krug·Wroblewski·Nielsen·Norman)
  ✅ PART 3-7    화면 완성 전 UX 체크리스트
  ✅ PART 5-3    컬러 토큰 (→ 이 파일 디자인 시스템 섹션이 덮어씀)
  ✅ PART 12-1   AppColors 토큰 파일
  ✅ PART 12-2   AppTheme (ThemeData)
  ✅ PART 12-3   GlassCard 위젯
  ✅ PART 12-5   PrimaryButton (CTA 72dp)
  ✅ PART 12-6   main.dart 설정
  ✅ PART 12-7   EmptyState 위젯
  ✅ PART 12-8   ErrorState 위젯
  ✅ PART 13     Phase 1 핵심 컴포넌트 목록 (프로젝트별 작성)
  ✅ PART 14     도메인 UX + 페르소나 플로우

SECURITY_MASTER:
  ✅ PART 2      데이터 보안 (저장소 선택 + API 키 관리)
  ✅ PART 7      Firebase 보안 (Rules + App Check)
  ✅ PART 9      개인정보 보호 (권한 요청 설계)
```

**Phase 1에서 구현 금지**
```
❌ 영상 촬영 / 타임랩스 — Phase 2
❌ 오버레이 옵션 (나침반/미니맵/해발) — Phase 2
❌ 커스텀 로고 삽입 — Phase 2
❌ 손글씨 서명 — Phase 2
❌ 사진 내보내기 (ZIP/일괄 공유) — Phase 2
❌ 다크모드 전체 테마 — Phase 3
❌ 다국어 (영어/일본어) — Phase 3
❌ 홈스크린 위젯 — Phase 3
```

---

### PHASE 2 — [촬영 확장 + 내보내기]
```
기능:
- 영상 촬영 + 실시간 워터마크
- 타임랩스 모드
- 오버레이 옵션 (나침반/미니맵/해발/속도)
- 커스텀 로고 이미지 삽입
- 손글씨 서명 등록 + 오버레이
- 사진 내보내기 (프로젝트별 일괄 공유 / 날짜별 ZIP)
- 자동 인터벌 촬영
```

**Phase 2 시작 전 AI 읽기 목록**
```
Phase 1 목록 전체 유지 +

DESIGN_MASTER:
  ✅ PART 9      IA & 네비게이션 구조 (역할 기반 분기 포함)
  ✅ PART 10     오프라인 UX 패턴 (오프라인 기능 있는 경우만)

SECURITY_MASTER:
  ✅ PART 3      인증 & 인가 (OAuth PKCE + 세션 관리)
  ✅ PART 5      앱 내부 보안 (WebView·딥링크·UGC — 해당 시)
  ✅ PART 9-2    Crashlytics PII 유출 방지
```

**Phase 2에서 구현 금지**
```
❌ 다크모드 전체 테마 — Phase 3
❌ 다국어 (영어/일본어) — Phase 3
❌ 홈스크린 위젯 — Phase 3
❌ 앱스토어 제출 — Phase 4
```

---

### PHASE 3 — [테마 + 다국어 + 위젯]
```
기능:
- 다크모드 전체 테마 (시스템 연동)
- 다국어 지원 (영어/일본어 추가)
- 홈스크린 위젯 (바로 촬영 진입)
- 배터리 세이버 모드 (검은 화면 촬영)
```

**Phase 3 시작 전 AI 읽기 목록**
```
Phase 1~2 목록 전체 유지 +

DESIGN_MASTER:
  ✅ PART 2-3    Paywall 컴포넌트 (잠긴 기능 UI)
  ✅ PART 11     알람 & 상태 UI (알람 기능 있는 경우만)

SECURITY_MASTER:
  ✅ PART 11     데이터 거버넌스 & 보존기간
  ✅ PART 12     RBAC 설계 (Rules + 모니터링 + TTL)
  ✅ PART 13-5   결제 보안 + 영수증 서버 검증 (결제 있는 경우만)
  ✅ PART 13-6   AI API 보안 (AI 연동 있는 경우만)
```

**Phase 3에서 구현 금지**
```
❌ 앱스토어 제출 — Phase 4
❌ 성능 최적화 전수 검사 — Phase 4
```

---

### PHASE 4 — [배포 준비 + 종합 검수]
```
기능:
- App Store / Google Play 제출 준비
- 종합 성능 최적화 (Profile 모드 60fps)
- 접근성 검수 (WCAG 2.1 AA)
- 스토어 스크린샷/설명/개인정보 처리방침
```

**Phase 4 시작 전 AI 읽기 목록**
```
전체 PART 확인 +

DESIGN_MASTER:
  ✅ PART 8      종합 체크리스트 전체 실행 (배포 전 QA)
  ✅ PART 6      성능 최적화 (Profile 모드 60fps 확인)

SECURITY_MASTER:
  ✅ PART 3-7    Passkey(FIDO2) 도입 검토
  ✅ PART 4-5    PQC(포스트-양자 암호화) Crypto-Agility 구조 확보
  ✅ PART 8-3    런타임 시크릿 로테이션 정책 수립
  ✅ PART 10     배포 전 보안 체크리스트 전수 검사
```

**Phase 4 종합 검수 (배포 전 필수)**
```
→ DESIGN_MASTER PART 8 전체 항목 실행
→ CLAUDE.md 섹션 5 Post-Build Review 실행
→ SECURITY_MASTER PART 10 배포 전 전수 검사
→ 스토어 심사 가이드라인 적합성 확인 (CLAUDE.md 섹션 7)
```

---

**차후 요청 시 구현 (현재 이전 Phase 구현 금지)**
```
- 클라우드 동기화 (Firebase/Supabase)
- 팀 공유 기능 (프로젝트 공동 작업)
- AI 기반 사진 자동 태깅
- SheetNinja 연동 (사진 → 보고서 삽입)
```

**Phase별 핵심 컴포넌트 상세** → DESIGN_MASTER_v3.2.md PART 13 (프로젝트별 작성)
**Phase별 보안 적용 타이밍** → SECURITY_MASTER_v2.2.md PART 13 + 위 읽기 목록
**전체 기능 상세 스펙** → [프로젝트명]_FEATURE_UNIVERSE.md 참조

---

## 0-2. Flutter 화면 요청 시 자동 적용 규칙

> 별도 언급 없어도 모든 Flutter 화면 요청에 아래를 무조건 적용한다.

- **⛔ 문자열** — 위젯 안 문자열 리터럴 금지 / 반드시 `context.l10n.키명` 사용 / 섹션 1 규칙 강제 적용
- **⛔ 컬러** — AppColors 토큰만 허용 / Color(0xFF...) · Colors.XXX 직접 입력 금지 / 섹션 4 규칙 강제 적용
- **터치** — 특이사항 "터치 기준" 테이블 따름
- **구조** — 화면 뎁스 3단계 이내 (IA 구조는 FEATURE_UNIVERSE 또는 아래 섹션 참조)
- **완료 후** — 인라인 검증 실행: 섹션 1(i18n) + 섹션 4-6(디자인) + 섹션 3 UX 핵심 3항목
  리포트: `"검증 완료 — i18n 키 N개 / 디자인 위반 N건 / UX 이상 없음"`
  ※ PART 8 종합 체크리스트는 Phase 완료 시 실행 (섹션 0 워크플로우 참조)

## 1. 다국어 (i18n) — 하드코딩 원천봉쇄

> ⛔ **이 섹션은 선택사항이 아니다. 모든 문자열은 처음부터 i18n 키로 작성한다.**
> "나중에 정리하자" 없음. 첫 줄부터 키 사용.

### 강제 규칙

1. **위젯 안에 문자열 직접 삽입 절대 금지**
   ```dart
   // ❌ 절대 금지
   Text('홈')
   Text('저장')
   ElevatedButton(child: Text('시작하기'))
   SnackBar(content: Text('저장되었습니다'))

   // ✅ 유일한 허용 형태
   Text(context.l10n.home)
   Text(context.l10n.save)
   ```

2. **위젯과 arb 키는 반드시 같은 커밋에 포함** — 위젯만 있고 키가 없는 상태 금지
   - 선호: arb 키 먼저 정의 → 위젯 작성
   - 허용: 위젯에 `context.l10n.키명` 사용하며 작성 → 완성 후 arb 키 일괄 추가
   - ⛔ 금지: 위젯에 문자열 리터럴 넣고 "나중에 키 추가"

3. **AppStrings 상수 파일도 금지**
   - `class AppStrings { static const title = '홈'; }` 패턴도 하드코딩과 동일하게 취급

4. **에러 메시지 / 스낵바 / 다이얼로그 / 툴팁 전부 포함** — UI에 노출되는 모든 텍스트 예외 없음

5. **AI가 생성하는 코드에 문자열 리터럴이 보이면 즉시 거부 후 arb 키로 교체하여 제공**

### 셋업 구조

```
lib/
  l10n/
    app_ko.arb      ← 기본 언어 (프로젝트별 결정)
    app_en.arb      ← 영어
  core/
    extensions/
      build_context_ext.dart  ← context.l10n 단축 확장
```

**pubspec.yaml**
```yaml
flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

**l10n.yaml** (프로젝트 루트)
```yaml
arb-dir: lib/l10n
template-arb-file: app_ko.arb
output-localization-file: app_localizations.dart
```

**build_context_ext.dart**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

**MaterialApp 설정**
```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

### arb 키 네이밍 규칙

```
camelCase, 화면명_요소명 형태
  공통     → common_*   예: commonSave, commonCancel, commonError
  화면별   → [screen]_* 예: homeTitle, listEmptyMessage, detailSaveSuccess

플레이스홀더:
  "listItemCount": "{current} / {total}",
  "@listItemCount": {
    "placeholders": {
      "current": { "type": "int" },
      "total":   { "type": "int" }
    }
  }
```

### AI 자체 검증 절차 (코드 생성 시마다 실행)

```
1. 생성 코드에서 Text( · ElevatedButton(child: Text( · SnackBar(content: Text( 패턴 검색
2. 따옴표 안에 문자열이 있으면 → 즉시 중단
3. arb 양쪽 파일에 키 추가 후 context.l10n.키명 으로 교체
4. 교체 완료 후에만 코드 제공
5. 리포트: "i18n 검증 완료 — 신규 키 N개 추가 (app_ko.arb / app_en.arb)"
```

- 기본 지원: 한국어(ko) · 영어(en) / 추가 언어는 프로젝트별 결정
- 프로젝트 초기 arb 키 목록 → CLAUDE.md "프로젝트 정보 > i18n 초기 키" 섹션에 기재

## 2. 보안
- 설계 단계부터 보안을 반영한다 (Security by Design)
- 필수 체크리스트
  - API 키 · 민감정보: 환경변수 또는 비밀 저장소 사용, 코드 직접 삽입 금지
  - 입력값 검증: 모든 사용자 입력은 서버·클라이언트 양측 검증
  - 인증/인가: 최소 권한 원칙 적용
  - 데이터 전송: HTTPS 강제, 인증서 핀닝 고려
  - 로컬 저장: 민감 데이터는 암호화 저장 (Keychain / Keystore)
- 상세 구현 → SECURITY_MASTER_v2.2.md 전체 참조
  (OWASP Mobile Top 10 · RBAC · 데이터 거버넌스 · 법적 보존기간 포함)
- **프로젝트 특화 보안** → SECURITY_MASTER_v2.2.md PART 13 (프로젝트별 작성)
- **Phase별 최소 참조 범위** (컨텍스트 효율화 — SECURITY_MASTER v2.2 헤더 "Phase별 참조 분기" 기준)
  ```
  Phase 1: PART 2(저장소) + PART 7(Firebase) + PART 9(권한)
  Phase 2: + PART 3(인증+세션) + PART 5(WebView+UGC — 사용 시) + PART 9-2(Crashlytics PII)
  Phase 3: + PART 11(거버넌스) + PART 12(RBAC+모니터링+TTL) + PART 13-5(결제) + PART 13-6(AI API)
  Phase 4: 전체 + PART 3-7(Passkey 도입 검토) + PART 4-5(PQC) + PART 8-3(시크릿 로테이션)
  ```
- **Passkey(FIDO2)**: Phase 4에서 도입 검토 → SECURITY_MASTER_v2.2.md PART 3-7 참조
- **AI 행동:** 보안 체크리스트 미충족 항목 발견 시 구현 전 경고

## 3. UX — 철칙

> ⛔ 디자인·i18n과 동일 레벨의 강제 사항. 권고가 아니다.

**코딩 전 필수 확인**
- 신규 화면 설계 시 → CLAUDE.md 페르소나 섹션에서 주 페르소나 확인 후 설계
  - **페르소나 섹션이 비어있으면 → 화면 설계 전 페르소나 작성 요청, 임의 추정 금지**
  - 페르소나가 있으면 → DESIGN_MASTER PART 14 명칭과 동일한지 확인 (불일치 시 알림)
- 기능 추가 시 → 사용자 흐름(User Flow) 먼저 정의 후 구현

**절대 금지 (발견 즉시 수정)**
```
❌ 홈 화면 동일 레벨 CTA 4개 이상 나열 (Hick's Law)
❌ 홈 → 핵심 결과까지 탭 4회 이상 (3회 이내 원칙)
❌ 터치 타겟 기준 미만 (특이사항 "터치 기준" 테이블 참조)
❌ Loading / Empty / Error 3상태 중 하나라도 누락
❌ 상태 변화에 피드백 없음 (버튼 눌림, 저장 완료, 에러 등)
```

**강제 적용 원칙**
1. **Hick's Law** — 동일 레벨 선택지 최대 3개. 초과 시 그룹핑 또는 Progressive Disclosure
2. **탭 3회 원칙** — 초과 발견 시 플로우 재설계 제안 후 구현
3. **3상태 완전 구현** — 모든 데이터 화면에 Loading / Empty / Error 화면 필수
4. **상태 피드백** — 모든 액션에 ripple + 결과 피드백 (SnackBar / 색상 변화 / 햅틱)
5. **엄지존** — 주요 CTA는 하단 영역 배치 (Wroblewski Mobile-First)

**상세 규칙** → DESIGN_MASTER_v3.2.md PART 3 + PART 14
**UX 빠른 리뷰** → DM PART 3-7 (설계 단계 참고용 / 종합 검증은 Phase 완료 시 PART 8)

## 4. 디자인 — 철칙

> ⛔ 모든 Flutter 화면에 예외 없이 적용. 단, 철칙은 **하한선**이다 — 더 좋게 만드는 건 항상 허용.

### 4-1. 컬러 — 임의값 완전 금지

```
✅ 유일한 허용 소스: 아래 "디자인 시스템" 섹션의 AppColors 토큰
✅ AppColors.accent / AppColors.surface / AppColors.text1 …
❌ Color(0xFF...) 직접 입력 — 토큰에 없는 값 무조건 금지
❌ Colors.blue / Colors.white / Colors.grey 등 Flutter 기본 컬러
❌ Theme.of(context).colorScheme.XXX 단독 사용 (AppColors 경유 없는 경우)
```

- 디자인 시스템 섹션이 비어있으면 → 코드 작성 전 토큰 작성 요청, 임의 생성 금지
- 토큰에 없는 새 값 필요 시 → "디자인 시스템" 섹션에 먼저 추가 제안 후 사용

### 4-2. 컴포넌트 구조

**아이콘 카드**
```
✅ 카드 → 아이콘(48dp+, 상단 중앙) → 텍스트(하단) / 여백·비율로만 분리
❌ 카드 안 아이콘 래퍼 박스(배경 있는 중간 컨테이너) 절대 금지
❌ 아이콘-텍스트 사이 구분선(Divider / border-top) 금지
```

**8pt 그리드** ← UI 수치의 Source of Truth (섹션 11 매직 넘버 규칙에서도 이 기준 참조)
```
✅ 패딩·마진·간격: 8의 배수 (8/16/24/32/48/64)
✅ 예외: 4pt 단위까지 허용 (4/12/20/28 …)
❌ 13/15/22px 등 임의 수치
```

**터치 타겟** → 특이사항 "터치 기준" 테이블이 유일한 기준

### 4-3. 아이콘
```
✅ 기본: Lucide Icons (lucide_flutter) — 변경 시 특이사항 섹션에 기재
   (허용 대안: Phosphor / Heroicons — 프로젝트당 1종 통일)
❌ 이모지 금지 (UI 어디에도)
❌ 업종 클리셰 아이콘 금지
❌ 아이콘 세트 혼용 금지 (프로젝트당 1종만)
→ 포인트 컬러는 AppColors 액센트 토큰만
```

### 4-4. 타이포그래피
```
✅ 기본: Theme.of(context).textTheme.XXX 상속
✅ 특수 목적(히어로 수치, 배지, 레이블 등) → fontSize/fontWeight 직접 지정 허용
   단, 근거 한 줄 주석 필수: // hero number — custom 48sp Bold
✅ 수치·코드: Monospace 폰트 (JetBrains Mono 등)
❌ 근거 없는 임의 fontSize/fontWeight 남발
```

### 4-5. 스타일 일관성
```
다크 Glass:    DESIGN_MASTER PART 1 공식 적용
라이트 파스텔: DESIGN_MASTER PART 4 공식 적용
→ 프로젝트당 하나. 혼용 금지.
→ 프로젝트 스타일은 아래 "디자인 시스템" 섹션에 명시
```

### 4-6. AI 자체 검증 (화면 코드 생성 완료 시마다)
```
1. Color(0xFF...) / Colors.XXX 직접 사용 → AppColors 토큰으로 교체
2. 특이사항 "터치 기준" 미만 터치 영역 → SizedBox로 영역 확장
3. 아이콘 래퍼 박스 → 제거
4. 8pt 그리드 위반 수치 → 교체
5. 이모지 → Lucide 아이콘으로 교체
6. 리포트: "디자인 검증 완료 — 위반 N건 수정 (컬러N/터치N/그리드N)"
```

### 4-7. 트렌드
- 빌드마다 최신 트렌드 반영, 획일적 반복 금지
- **트렌드 적용 전 → DESIGN_MASTER_v3.2.md PART 7-0 판단 필터 3가지 반드시 확인**
  (페르소나 적합성 / 도메인 신뢰도 / 성능 비용 — 3가지 통과한 트렌드만 적용)
- 참조: Mobbin · Dribbble · App Store 피처드 / Schoger · Malewicz · Gary Simon
- 디자인 결정 시 `[참조 소스] → [적용 근거] → [구현 방법]` 형식으로 명시
- 상세 원칙 → DESIGN_MASTER_v3.2.md PART 7 전체

## 5. 완성도 평가 (Post-Build Review) — 종합 검증 단계

> ⚠️ **Phase 완료 시 실행** (섹션 0 "종합 검증" 단계). 매 화면 단위가 아님.
> 매 화면은 인라인 검증(섹션 1 + 3 + 4-6)만 실행. Phase 완료 시 이 섹션을 실행한다.

**실행 기준**
- DESIGN_MASTER PART 8 체크리스트 전체 실행
- 오프라인 기능 없는 프로젝트: PART 10(오프라인 UX) 항목 스킵 명시
- 알람 기능 없는 프로젝트: PART 11(알람 UI) 항목 스킵 명시
- RBAC 없는 프로젝트: 권한 분기 항목 스킵 명시

**평가 기준**
- 저명 앱 리뷰어 시점 (App Store 에디터, The Verge 등)
- App Store / Google Play 심사 가이드라인 적합성
- 접근성 (WCAG 2.1 AA 이상)
- 성능: 실기기 Profile 모드 60fps / const 위젯 / builder 리스트 / dispose 처리
- 섹션 1(i18n) · 섹션 3(UX) · 섹션 4(디자인) 철칙 준수 여부

**리포트 형식**: `[항목] 현재 상태 → 개선 제안`
개선 여부는 사업주 판단으로 결정

## 6. 경쟁앱 분석 · 기능 제안

> **실행 시점**: 신규 기능 설계 시에만. 기존 화면 수정·단순 추가 시에는 스킵.

- 빌드 전: 동종업계 전세계 경쟁앱 기능 분석 → 차별화 포인트 제안
- 빌드 후: 경쟁앱 대비 부족한 기능 적극 제안
- 제안 형식: `[경쟁앱 기능] → [우리 버전 개선 방향] → [예상 효과]`
- **AI 행동:** 신규 기능 구현 시 관련 경쟁앱 사례를 1~2개 함께 언급

## 7. 스토어 등록 기준
- 모든 플랜·코딩은 App Store · Google Play 등록을 최종 기준으로 한다
- 필수 반영 사항
  - 개인정보 처리방침 · 이용약관 화면 포함
  - 앱 추적 투명성 (ATT) / 권한 요청 사유 명시
  - 스크린샷·앱 아이콘 규격 계획 포함
  - 심사 거절 주요 사유 사전 점검 (결제 정책, 콘텐츠 정책)
- **AI 행동:** 심사 거절 가능성이 있는 코드·설계 발견 시 즉시 경고

## 8. 버전 관리
- 브랜치 전략: `main` (배포) · `dev` (개발) · `feature/기능명` (기능 단위)
- 커밋 컨벤션: `[type] 간단한 설명` 형식 사용
  - `feat`: 새 기능
  - `fix`: 버그 수정
  - `design`: UI/디자인 변경
  - `refactor`: 리팩토링
  - `chore`: 설정·의존성 변경
- 배포 전 반드시 `dev → main` PR 후 머지
- 태그 규칙: `v1.0.0` (major.minor.patch)

## 9. 앱 아이콘 · 스플래시 화면
- 스플래시 화면은 브랜드 이미지(앱 아이콘 + 워드마크)를 배경색 #FFF8F2(라이트) / #0D1118(다크) 위에 배치
- Android 12+ 시스템 스플래시의 아이콘 단계는 투명 1x1 PNG로 처리하여 이음새 없이 커스텀 스플래시만 보이도록 한다
- 애니메이션 등 불필요한 요소 금지 (심플 유지)
- 앱 아이콘은 아이콘 영역에 최대한 꽉 차게 디자인한다 (여백 최소화)
- 플랫폼별 규격 준수
  - iOS: 1024×1024px 마스터 이미지 기준, 알파 채널 금지
  - Android: Adaptive Icon 적용 (foreground + background 분리), 108×108dp 기준
- 아이콘 배경색은 스플래시 배경색과 통일하여 브랜드 일관성 유지

## 10. 에러 추적 · 크래시 리포팅
- 모든 앱에 크래시 리포팅 도구를 기본 탑재한다
  - Flutter / Android: Firebase Crashlytics (기본) 또는 Sentry
  - 웹앱: Sentry (프로젝트가 웹앱인 경우만 해당)
  - 선택 기준: Firebase 백엔드 사용 시 Crashlytics, 멀티 플랫폼/비Firebase 시 Sentry
- 로그 레벨 구분: DEBUG · INFO · WARNING · ERROR / 프로덕션에서 DEBUG 출력 금지
- 사용자 식별 정보는 로그에 포함하지 않는다 (개인정보 보호)
- 주요 사용자 행동 이벤트는 Analytics로 별도 추적 (Firebase Analytics 등)
- **개인정보 보호:** Analytics 이벤트에 PII(이름, 이메일, 전화번호 등) 포함 금지 → SECURITY_MASTER_v2.2.md PART 9 참조
- **AI 행동:** 프로덕션 빌드에 DEBUG 로그 또는 콘솔 출력 잔존 시 즉시 알림

## 11. 코드 품질
- 클린 코드 원칙 준수 (단일 책임, 명확한 네이밍, why 주석)
- 시니어 개발자가 봤을 때 군더더기 없는 코드를 목표로
- 함수/위젯은 하나의 역할만, 200줄 초과 시 분리 검토
- 매직 넘버 금지 — 상수로 분리 (UI 수치는 섹션 4-2 "8pt 그리드" 참조)

---

## 12. 코드 보호 (난독화 · 리버스엔지니어링 방지)

### 빌드 시 필수 적용
- **Flutter 난독화:** 릴리즈 빌드 시 아래 플래그 필수
  ```
  flutter build apk --release --obfuscate --split-debug-info=build/debug-info
  flutter build ios --release --obfuscate --split-debug-info=build/debug-info
  ```
- **Android ProGuard/R8:** `android/app/build.gradle`에 minifyEnabled true 적용
- **iOS 컴파일러 최적화:** Xcode Release 빌드 기본 적용 (별도 설정 불필요)

### 런타임 보호
- **루팅/탈옥 감지:** 기본 `flutter_jailbreak_detection` 또는 고급 `freerasp` 패키지 적용 — 감지 시 보안 경고
  - 상세 선택 기준 → SECURITY_MASTER_v2.2.md PART 6 참조
- **스크린샷 방지:** 민감 화면 (결제, 비번 등)에서 `FLAG_SECURE` 적용
- **SSL Pinning:** 주요 API 통신에 인증서 핀닝 적용 (중간자 공격 방지)

### 코드 구조 보호
- API 엔드포인트 · 비즈니스 로직은 서버사이드로 분리
- 핵심 알고리즘은 클라이언트에 노출하지 않는다
- **AI 행동:** 핵심 로직이 클라이언트에 노출되는 구조 발견 시 서버 이전 제안

### 한계 인식
- 난독화는 분석을 어렵게 할 뿐 완전 차단은 불가능
- 진짜 보호막은 도메인 노하우 + 운영 경험 + 선점 효과
- 상세 구현 코드 → SECURITY_MASTER_v2.2.md PART 6 (앱 무결성) 참조

---

# 프로젝트 정보 (프로젝트 시작 시 작성)

## 기본 정보
- 앱 이름: Exacta
- 플랫폼: Flutter (Android + iOS)
- 타겟 사용자: 현장 엔지니어/기술자 (HVAC-R, 건설, 조선, 설비 전반) — 40~50대 중심
- 주요 기능 요약: 타임스탬프 현장 카메라 — GPS/주소/시간 번인, 보안 촬영(위치 완전차단+EXIF 스트리핑), 프로젝트별 폴더 분류, 촬영 중 메모/태그 편집, 순정 갤러리 표시 제어
- 수익 모델: 완전 무료 (광고 없음)
- 백엔드: 없음 (로컬 저장 전용)

## 경로
- 주요 소스 경로: `lib/`
- i18n 파일 경로: `lib/l10n/app_ko.arb` · `lib/l10n/app_en.arb`
- 환경변수 파일: 없음 (로컬 전용 앱, API 키 불필요)

## i18n 초기 키 (Phase 1)

```json
// app_ko.arb
{
  "@@locale": "ko",
  "appTitle": "Exacta",
  "commonSave": "저장",
  "commonCancel": "취소",
  "commonError": "오류가 발생했습니다",
  "commonRetry": "다시 시도",
  "commonDelete": "삭제",
  "commonEdit": "편집",
  "commonDone": "완료",
  "commonSearch": "검색",
  "commonSelect": "선택",
  "commonAll": "전체",
  "commonShare": "공유",

  "homeTitle": "Exacta",
  "homeThisWeek": "이번 주",
  "homeTotalShots": "총 촬영",
  "homeProjects": "프로젝트",
  "homeSecureShots": "보안 촬영",
  "homeQuickActions": "빠른 실행",
  "homeActiveProject": "진행중 프로젝트",
  "homeContinueShooting": "이어서 촬영",

  "cameraConstruction": "시공 기록",
  "cameraSecure": "보안 촬영",
  "cameraConstructionDesc": "GPS + 주소 + 시간",
  "cameraSecureDesc": "위치 완전차단",
  "cameraPhoto": "사진",
  "cameraVideo": "영상",
  "cameraTimelapse": "타임랩스",
  "cameraSecureBadge": "SECURE · EXIF STRIPPED",

  "stampEditTitle": "스탬프 편집",
  "stampMemoPlaceholder": "촬영 메모를 입력하세요...",
  "stampProject": "프로젝트",
  "stampDisplayItems": "표시 항목",
  "stampOverlays": "오버레이",
  "stampTime": "시간",
  "stampDate": "날짜",
  "stampAddress": "주소",
  "stampGps": "GPS 좌표",
  "stampMinimap": "미니맵",
  "stampCompass": "나침반",
  "stampAltitude": "해발",
  "stampLogo": "로고",
  "stampSignature": "손글씨 서명",
  "stampWeather": "날씨",

  "galleryTitle": "갤러리",
  "galleryToday": "오늘",
  "galleryYesterday": "어제",
  "galleryNoProject": "프로젝트 없음",
  "galleryPhotos": "{count}장",
  "@galleryPhotos": {
    "placeholders": { "count": { "type": "int" } }
  },

  "projectsTitle": "프로젝트",
  "projectsSearch": "프로젝트 검색...",
  "projectsActive": "진행중",
  "projectsDone": "완료",
  "projectsNew": "새 프로젝트",

  "settingsTitle": "설정",
  "settingsTimestamp": "타임스탬프",
  "settingsDateFormat": "날짜 포맷",
  "settingsFont": "폰트",
  "settingsStampColor": "스탬프 색상",
  "settingsStampPosition": "스탬프 위치",
  "settingsCamera": "카메라",
  "settingsResolution": "해상도",
  "settingsShutterSound": "셔터음 끄기",
  "settingsBatterySaver": "배터리 세이버",
  "settingsStorage": "저장",
  "settingsShowInGallery": "순정 갤러리에 표시",
  "settingsSecureAlwaysHidden": "보안 촬영분 항상 숨김",
  "settingsForced": "강제",
  "settingsSecurity": "보안",
  "settingsExifStrip": "EXIF 위치 제거",
  "settingsSecureShareLimit": "보안모드 공유제한",
  "settingsExport": "사진 내보내기",
  "settingsExportDesc": "프로젝트별 일괄 선택 → 카톡 · 메일 · AirDrop 공유 또는 날짜별 ZIP",

  "emptyGallery": "아직 촬영한 사진이 없습니다",
  "emptyGalleryAction": "첫 사진을 촬영해보세요",
  "emptyProjects": "프로젝트가 없습니다",
  "emptyProjectsAction": "새 프로젝트를 만들어보세요",
  "errorCameraPermission": "카메라 권한이 필요합니다",
  "errorLocationPermission": "위치 권한이 필요합니다",
  "errorStoragePermission": "저장소 권한이 필요합니다",
  "errorSaveFailed": "사진 저장에 실패했습니다"
}
```

## 페르소나
<!-- DESIGN_MASTER_v3.2.md PART 14와 명칭 완전 통일 -->
- P1 — 현장 엔지니어 (Field Engineer): 40~50대, HVAC-R/배관/전기/건설 기술자. 장갑 착용 빈번, 한 손 조작 필수, 야외 직사광선+먼지 환경. 하루 10~50장 촬영. 빠른 촬영 진입과 큰 글씨가 핵심.

## 디자인 시스템
<!-- DESIGN_MASTER_v3.2.md PART 5 형식으로 이 프로젝트 컬러 토큰을 아래에 기재 -->

- 도메인:    전문직 도구 (현장 엔지니어 카메라)
- 분위기:    프리미엄 파스텔 + 기술적 신뢰 (Apple Music 레이아웃 + 웜 크림 톤)

- 다크모드 지원 여부: ✅ (Phase 1은 카메라 뷰파인더만 다크, Phase 3에서 전체 다크모드 추가)
- 폰트: Sora (UI) + JetBrains Mono (스탬프/데이터/수치)
- 스타일: 라이트 파스텔 (DESIGN_MASTER PART 4 공식 적용)
- 아이콘: Lucide Icons (lucide_flutter)

**컬러 선정 프로세스 (DESIGN_MASTER PART 5-2)**
```
1. 도메인 personality 키워드: 정밀(Precision) · 현장(Field) · 신뢰(Trust)
2. 에너지/엔지니어링 계열 → 앰버/피치 + 크림 방향 선택
3. 메인 액센트: #FF9B7B (Peach) — 따뜻하면서 전문적, 타임마크의 촌스러운 파란색과 차별화
4. 기능 컬러: danger(#DC2626)/warning(#F59E0B)/success(#059669) 피치와 충돌 없음 확인
5. 다크(카메라): 피치를 밝게 조정(#FFB49A)하여 어두운 뷰파인더에서 가독성 확보
   라이트(앱 UI): 피치 원본(#FF9B7B) + 크림 배경(#FFF8F2)으로 따뜻한 프리미엄 톤
```

**Dark Mode 토큰** (카메라 뷰파인더 + Phase 3 전체 다크모드용)
```
--bg:             #0D1118
--surface:        rgba(255,255,255, 0.06)
--surface-hi:     rgba(255,255,255, 0.10)
--border:         rgba(255,255,255, 0.08)
--border-hi:      rgba(255,255,255, 0.15)

--accent:         #FFB49A  (라이트 피치 — 어두운 배경에서 가독성용)
--accent-dim:     rgba(255,180,154, 0.12)
--accent-glow:    rgba(255,180,154, 0.30)
--on-accent:      #0D1118  (다크 배경색 — 피치 버튼 위 텍스트)

--danger:         #EF5350
--warning:        #FBBF24
--success:        #34D399
--info:           #B8A0E8  (라벤더 — 보조 컬러)

--text-primary:   rgba(255,255,255, 0.92)
--text-secondary: rgba(255,255,255, 0.45)
--text-muted:     rgba(255,255,255, 0.20)
```

**Light Mode 토큰** (앱 메인 UI — 홈/갤러리/프로젝트/설정)
```
--bg:             #FFF8F2  (웜 크림)
--surface:        #FFFFFF
--surface-hi:     #FFF0E6  (피치 틴트 인풋 배경)
--border:         rgba(255,155,123, 0.08)
--border-hi:      rgba(255,255,255, 0.90)

--accent:         #FF9B7B  (피치 — 메인 액센트)
--accent-dark:    #D4715A  (텍스트용 어두운 피치)
--accent-dim:     rgba(255,155,123, 0.12)
--accent-glow:    rgba(255,155,123, 0.30)
--on-accent:      #FFFFFF  (피치 버튼 위 텍스트 = 화이트)

--btn-gradient:   linear-gradient(135deg, #FF9B7B, #E880A0)  (CTA 버튼)

--danger:         #DC2626
--warning:        #F59E0B
--success:        #059669
--info:           #B8A0E8  (라벤더 — 보조 컬러)

--text-primary:   #3D2E22  (웜 다크 브라운)
--text-secondary: rgba(61,46,34, 0.50)
--text-muted:     rgba(61,46,34, 0.30)
```

**Exacta 전용 토큰 (추가)**
```
--stamp-construction: #FFB49A  (시공기록 스탬프 색)
--stamp-secure:       #FCA5A5  (보안촬영 스탬프 색)
--secure-bg:          #2A1520  (보안모드 뷰파인더 배경 틴트)
--lavender:           #B8A0E8  (보조 카테고리 컬러)
--mint:               #7ECBB4  (성공/오버레이 보조)
--sand:               #F0C078  (경고/포인트 보조)
```

## 외부 서비스 · 의존성
- 백엔드: 없음 (완전 로컬 앱)
- 데이터 저장: SQLite (drift 또는 sqflite) — 프로젝트/사진 메타데이터
- 파일 저장: 앱 내부 디렉토리 (path_provider)
- 카메라: camera 패키지
- GPS: geolocator + geocoding 패키지
- EXIF 처리: exif 패키지 (보안 모드 스트리핑용)
- 이미지 합성: Canvas API (dart:ui) — 스탬프 번인
- 아이콘: lucide_flutter
- 크래시 리포팅: Firebase Crashlytics (Phase 4 배포 시 적용)
- 상태관리: Riverpod

## 특이사항 · 주의사항
- 로컬 전용 앱 — 서버 통신 없음, 인증 없음, RBAC 불필요
- 카메라 앱 특성상 앱 진입 → 촬영까지 2탭 이내 필수
- 보안 촬영 모드: EXIF GPS 태그 완전 제거 + 순정 갤러리 미등록 강제
- 사진 번인: Canvas API로 뷰파인더 스탬프를 픽셀 단위 합성 (별도 레이어 아님)
- **터치 기준 (이 테이블이 유일한 기준 — 다른 섹션은 여기를 참조):**
  ```
  일반 버튼/아이콘:  56dp  ← 장갑 환경 기준 적용
  리스트 아이템:     56dp
  바텀 탭:          64dp
  CTA 버튼:         72dp
  셔터 버튼:        66dp (원형)
  프리셋 카드:      최소 높이 58dp
  스탬프 편집 버튼:  30dp (뷰파인더 위 보조 — 예외 허용)
  ```
- **아이콘 세트:** Lucide Icons (lucide_flutter) — 프로젝트 전체 통일
- **RBAC 역할:** 없음 (싱글 유저 로컬 앱)

## 개발 진행사항

### 완성된 기능
- [2026-03-30] Phase 1 전체 완료
- [2026-03-29] 프로젝트 기초 세팅: Flutter 프로젝트 생성, AppColors/AppTheme, l10n 인프라, Riverpod
- [2026-03-29] 홈 화면: 히어로 카드(주간 통계 DB 연동) + 빠른 실행 3종 + 진행중 프로젝트 카드
- [2026-03-29] 바텀 네비게이션: 5탭 셸 (홈/갤러리/카메라/프로젝트/설정) + 센터 카메라 버튼
- [2026-03-29] 카메라 화면: 뷰파인더 + 프리셋 토글(시공기록/보안촬영) + 플래시 + 카메라 전환
- [2026-03-29] 스탬프 오버레이: 하단 풀와이드 바, 시간/날짜/요일/주소/GPS/메모 실시간 표시
- [2026-03-29] 스탬프 편집 바텀시트: 메모 + 태그 입력, 프로젝트 선택, 시간/날짜/주소/GPS 토글
- [2026-03-29] SQLite 데이터 레이어: drift로 projects/photos/stamp_config 테이블 + DAO + Riverpod providers
- [2026-03-29] 카메라 저장 파이프라인: 셔터 → Canvas API 스탬프 번인 → 앱 내부 저장 → DB 삽입
- [2026-03-29] 보안 모드: GPS/주소 강제 숨김 + PNG 출력(EXIF 없음) + 순정 갤러리 미등록 + 별도 폴더
- [2026-03-29] 프로젝트 CRUD: 생성/편집/삭제/상태전환(active↔done) + 컬러 선택 + DB 연동
- [2026-03-29] 갤러리: 날짜별 그룹 + 프로젝트 필터 칩 + 보안촬영 뱃지 + 실제 사진 표시 + 삭제
- [2026-03-29] 설정 화면: 스탬프 포맷/색상/위치/폰트, 해상도, 셔터음, 순정갤러리 표시, 보안 옵션 — DB 연동
- [2026-03-30] 순정 갤러리 등록: Android MediaStore MethodChannel 네이티브 구현
- [2026-03-30] 설정값 카메라 반영: dateFormat/stampColor/stampPosition/resolution이 촬영+미리보기에 적용
- [2026-03-30] 사진 상세보기: 핀치 줌 + 메타정보 + 삭제 + 공유 버튼
- [2026-03-30] 폰트 적용: google_fonts로 Sora(UI) + JetBrains Mono(스탬프/수치) 실제 적용
- [2026-03-30] 색상 선택 UI: 설정에서 스탬프 색상 8색 선택 팝업
- [2026-03-30] 태그 기능: DB tags 컬럼 + 스탬프 편집 태그 입력 + 촬영 파이프라인 연결
- [2026-03-30] 종합 검증: i18n 위반 1건 + UX 피드백 누락 4건 수정 완료
- [2026-03-30] Phase 2 전체 완료
- [2026-03-30] 영상 촬영: 사진/영상 모드 전환 + 녹화 시작/중지 + 타이머 UI + DB 저장
- [2026-03-30] 타임랩스: 간격 선택(1~30초) → 자동 사진 촬영 + 스탬프 번인 + 카운터 UI
- [2026-03-30] 오버레이 옵션: 나침반(flutter_compass) + 해발 + 속도 + 스탬프 편집 토글
- [2026-03-30] 커스텀 로고: image_picker로 선택 → 앱 내부 저장 → 뷰파인더/번인 합성
- [2026-03-30] 손글씨 서명: 캔버스 드로잉 → PNG 저장 → 뷰파인더/번인 합성
- [2026-03-30] 사진 내보내기: 선택 → share_plus 공유 또는 ZIP(archive) 생성 + 공유
- [2026-03-30] 자동 인터벌 촬영: 분 단위 간격(1~30분) → 자동 반복 촬영 + 카운터 UI
- [2026-03-30] Phase 3 전체 완료
- [2026-03-30] 다크모드: ThemeMode.system 연동 + 모든 화면 context.* 테마 반응형 색상 전환 + 설정 UI (시스템/라이트/다크)
- [2026-03-30] 다국어: app_ja.arb 일본어 전체 번역 추가 + 설정에서 언어 선택 (시스템/한국어/영어/일본어)
- [2026-03-30] 홈스크린 위젯: Android AppWidget + ExactaWidgetProvider + 탭→카메라 바로 진입
- [2026-03-30] 배터리 세이버: 설정 토글 → 카메라 뷰파인더 검은 화면 오버레이 (AMOLED 절전)
- [2026-03-30] Phase 4 전체 완료
- [2026-03-30] 성능 최적화: 미사용 allPhotosProvider 제거
- [2026-03-30] 접근성: 바텀 네비게이션 Semantics (button/label/selected) 추가
- [2026-03-30] 스플래시: flutter_native_splash — 라이트 #FFF8F2 / 다크 #0D1118
- [2026-03-30] 법적 고지: 개인정보 처리방침 + 이용약관 화면 (3개 국어) + 앱 버전
- [2026-03-30] 릴리즈 빌드: ProGuard minifyEnabled + shrinkResources + proguard-rules.pro

### 데이터 구조
```
[SQLite — drift]

projects 테이블:
  id            INTEGER PRIMARY KEY
  name          TEXT NOT NULL
  color         TEXT (hex — 프로젝트 컬러바)
  startDate     TEXT (ISO 8601)
  endDate       TEXT (nullable — 완료 시)
  status        TEXT ('active' | 'done')
  createdAt     TEXT
  updatedAt     TEXT

photos 테이블:
  id            INTEGER PRIMARY KEY
  projectId     INTEGER (nullable — 프로젝트 없이 촬영 허용) → REFERENCES projects(id)
  filePath      TEXT NOT NULL
  thumbnailPath TEXT
  presetType    TEXT ('construction' | 'secure')
  memo          TEXT (nullable)
  tags          TEXT (nullable — 쉼표 구분 태그 목록)
  timestamp     TEXT (ISO 8601 — 촬영 시각)
  latitude      REAL (nullable — 보안 모드 시 null)
  longitude     REAL (nullable)
  address       TEXT (nullable)
  isSecure      INTEGER (0 | 1)
  isVideo       INTEGER (0 | 1)
  createdAt     TEXT

stamp_config 테이블 (싱글 로우 설정):
  id            INTEGER PRIMARY KEY DEFAULT 1
  dateFormat    TEXT DEFAULT 'YYYY.MM.DD'
  fontFamily    TEXT DEFAULT 'mono'
  stampColor    TEXT DEFAULT '#FF9B7B'
  stampPosition TEXT DEFAULT 'bottom'  ('bottom' | 'top')
  showInNativeGallery  INTEGER DEFAULT 1
  resolution    TEXT DEFAULT '4k'  ('1080p' | '4k')
  shutterSound  INTEGER DEFAULT 0
  batterySaver  INTEGER DEFAULT 0
  exifStrip     INTEGER DEFAULT 1
  secureShareLimit INTEGER DEFAULT 1
```

### 설계 변경 이력
- [2026-03-29] 보고서 탭 제거 / 이유: 카메라앱에 보고서는 비대화, SheetNinja로 분리
- [2026-03-29] 출퇴근 프리셋 제거 / 이유: 시공기록의 변형일 뿐, 프리셋 2개로 단순화
- [2026-03-29] B/A 프리셋 제거 / 이유: 별도 모드보다 시공기록으로 전후 촬영이 자연스러움
- [2026-03-29] 스탬프 레이아웃 변경: 좌측 카드 → 하단 풀와이드 바 / 이유: 사진 가림 최소화

### MVP 체크리스트
- [x] 카메라 촬영 (사진): 뷰파인더 + 셔터 + 저장
- [x] 스탬프 번인: Canvas API로 시간/날짜/주소 합성
- [x] 프리셋 전환: 시공기록 ↔ 보안촬영 실시간 스탬프 변경
- [x] 보안 모드: GPS/주소 숨김 + EXIF 위치 스트리핑
- [x] 스탬프 편집 드로어: 메모/태그 입력 + 프로젝트 선택 + 요소 토글
- [x] 프로젝트 CRUD: 생성/편집/삭제/목록
- [x] 갤러리: 날짜별 그룹 + 프로젝트 필터 + 보안촬영 뱃지
- [x] 순정 갤러리 표시 제어: 토글 + 보안촬영분 강제 숨김
- [x] 설정: 스탬프 포맷/색상/위치, 해상도, 셔터음, 보안 옵션
- [x] 홈: 히어로 카드 + 주간 통계 + 빠른 실행
- [x] 빈 상태: 갤러리 비었을 때, 프로젝트 비었을 때
- [x] 에러 상태: 카메라 권한 거부, 위치 권한 거부, 저장 실패

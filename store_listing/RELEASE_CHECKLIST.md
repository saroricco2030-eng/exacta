# Exacta 출시 체크리스트

## ✅ 완료된 항목

### 코드 & 빌드
- [x] 릴리즈 키스토어 생성 (`android/app/exacta-release.jks`)
- [x] 키스토어 비밀번호 보관 (`android/key.properties`, .gitignore에 포함)
- [x] 서명된 AAB 빌드 (`build/app/outputs/bundle/release/app-release.aab`, 58.2MB)
- [x] ProGuard 난독화 + 리소스 축소 활성화
- [x] Sentry 크래시 리포팅 SDK 통합 (DSN 환경변수로 활성화)

### 앱 메타데이터
- [x] 한국어 스토어 설명문 (`store_listing/ko.md`)
- [x] 영어 스토어 설명문 (`store_listing/en.md`)
- [x] 일본어 스토어 설명문 (`store_listing/ja.md`)
- [x] 스크린샷 가이드 (`store_listing/SCREENSHOT_GUIDE.md`)

### 컴플라이언스
- [x] 개인정보 처리방침 (앱 내 + 3개국어)
- [x] 이용약관 (앱 내 + 3개국어)
- [x] iOS Privacy Manifest (PrivacyInfo.xcprivacy)
- [x] Android 권한 사유 명시

## 🔲 사용자 작업 필요

### Sentry 활성화 (5분)
1. https://sentry.io 회원가입 → 프로젝트 생성 (Flutter 선택)
2. DSN 복사 (예: `https://abc123@o123.ingest.sentry.io/456`)
3. 빌드 시 환경변수 전달:
   ```bash
   flutter build appbundle --release --dart-define=SENTRY_DSN=YOUR_DSN_HERE
   ```

### 스크린샷 촬영 (30분)
- `store_listing/SCREENSHOT_GUIDE.md` 참고
- 5장 권장: 카메라 / 갤러리 / 사진상세 / 설정 / 보안모드
- 1080×1920 이상

### 피처 그래픽 제작 (30분)
- 1024×500 PNG
- Figma/Photoshop 사용
- `store_listing/SCREENSHOT_GUIDE.md` 가이드 참고

### Google Play Console 등록 (1시간)
1. 개발자 계정 생성 ($25 일회성)
2. 앱 만들기 → 패키지명 `com.exacta.app`
3. AAB 업로드: `build/app/outputs/bundle/release/app-release.aab`
4. 스토어 등록정보:
   - 앱 이름, 짧은 설명, 전체 설명 (3개국어)
   - 스크린샷 5장 + 피처 그래픽
   - 카테고리: **도구** 또는 **비즈니스**
   - 콘텐츠 등급: **전체 이용가**
5. 개인정보 처리방침 URL (앱 내 화면 또는 GitHub Pages 호스팅)
6. 출시 트랙: **내부 테스트 → 비공개 테스트 → 프로덕션** 순서 권장

### App Store Connect (Apple, 선택)
- 개발자 계정 $99/년
- Xcode로 IPA 빌드 + App Store Connect 업로드
- 동일한 메타데이터 사용

## 🔑 보안 보관 (절대 분실 금지)

다음 파일을 안전한 곳(1Password, 외장 SSD 등)에 백업:
- `android/app/exacta-release.jks` ← **분실 시 앱 영원히 업데이트 불가**
- `android/key.properties` ← 비밀번호 보관

키스토어 정보:
- **별칭**: exacta
- **유효기간**: 27년 (10,000일)
- **알고리즘**: RSA 2048-bit, SHA384

## 출시 후 1주차 모니터링

- Sentry 크래시 대시보드 일 1회 확인
- Play Console "통계" 탭에서 ANR 비율 < 0.5% 유지
- 사용자 리뷰 확인 (1점 리뷰는 24시간 내 답글)
- 별점 4.5+ 유지 목표

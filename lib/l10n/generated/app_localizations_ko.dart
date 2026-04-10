// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get commonSave => '저장';

  @override
  String get commonCancel => '취소';

  @override
  String get commonError => '오류가 발생했습니다';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonEdit => '편집';

  @override
  String get commonAll => '전체';

  @override
  String get commonShare => '공유';

  @override
  String get commonSearch => '검색';

  @override
  String get homeTitle => 'Exacta';

  @override
  String get homeThisWeek => '이번 주';

  @override
  String get homeTotalShots => '총 촬영';

  @override
  String get homeProjects => '프로젝트';

  @override
  String get homeSecureShots => '보안 촬영';

  @override
  String get homeQuickActions => '빠른 실행';

  @override
  String get homeActiveProject => '진행중 프로젝트';

  @override
  String get homeContinueShooting => '이어서 촬영';

  @override
  String get cameraConstruction => '시공 기록';

  @override
  String get cameraSecure => '보안 촬영';

  @override
  String get cameraConstructionDesc => 'GPS + 주소 + 시간';

  @override
  String get cameraSecureDesc => '위치 완전차단';

  @override
  String get cameraTimelapse => '타임랩스';

  @override
  String get cameraSecureBadge => 'SECURE · EXIF STRIPPED';

  @override
  String get cameraRecording => '녹화 중';

  @override
  String get cameraRecordingDone => '영상이 저장되었습니다';

  @override
  String get cameraModePhoto => '사진';

  @override
  String get cameraModeVideo => '영상';

  @override
  String get cameraModeTimelapse => '타임랩스';

  @override
  String cameraTimelapseRunning(int count) {
    return '촬영 중 · $count장';
  }

  @override
  String get cameraTimelapseInterval => '촬영 간격';

  @override
  String cameraTimelapseDone(int count) {
    return '타임랩스 완료 · $count장 저장';
  }

  @override
  String get cameraInterval1s => '1초';

  @override
  String get cameraInterval3s => '3초';

  @override
  String get cameraInterval5s => '5초';

  @override
  String get cameraInterval10s => '10초';

  @override
  String get cameraInterval30s => '30초';

  @override
  String get cameraInterval1m => '1분';

  @override
  String get cameraInterval5m => '5분';

  @override
  String get cameraInterval10m => '10분';

  @override
  String get cameraInterval30m => '30분';

  @override
  String cameraIntervalShooting(int count) {
    return '인터벌 촬영 중 · $count장';
  }

  @override
  String cameraIntervalDone(int count) {
    return '인터벌 촬영 완료 · $count장';
  }

  @override
  String get cameraModeInterval => '인터벌';

  @override
  String get stampEditTitle => '스탬프 편집';

  @override
  String get stampMemoPlaceholder => '촬영 메모를 입력하세요...';

  @override
  String get stampProject => '프로젝트';

  @override
  String get stampDisplayItems => '표시 항목';

  @override
  String get stampTagsPlaceholder => '태그를 입력하세요 (쉼표로 구분)';

  @override
  String get stampTags => '태그';

  @override
  String get stampOverlays => '오버레이';

  @override
  String get stampTime => '시간';

  @override
  String get stampDate => '날짜';

  @override
  String get stampAddress => '주소';

  @override
  String get stampGps => 'GPS 좌표';

  @override
  String get stampCompass => '나침반';

  @override
  String get stampAltitude => '해발';

  @override
  String get stampSpeed => '속도';

  @override
  String get stampLogo => '로고';

  @override
  String get stampLogoSelect => '로고 이미지 선택';

  @override
  String get stampSignature => '손글씨 서명';

  @override
  String get stampSignatureDraw => '서명 그리기';

  @override
  String get galleryTitle => '갤러리';

  @override
  String get galleryToday => '오늘';

  @override
  String get galleryYesterday => '어제';

  @override
  String get galleryNoProject => '프로젝트 없음';

  @override
  String galleryPhotos(int count) {
    return '$count장';
  }

  @override
  String get projectsTitle => '프로젝트';

  @override
  String get projectsSearch => '프로젝트 검색...';

  @override
  String get projectsActive => '진행중';

  @override
  String get projectsDone => '완료';

  @override
  String get projectsNew => '새 프로젝트';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsTimestamp => '타임스탬프';

  @override
  String get settingsDateFormat => '날짜 포맷';

  @override
  String get settingsFont => '폰트';

  @override
  String get settingsStampColor => '스탬프 색상';

  @override
  String get settingsStampPosition => '스탬프 위치';

  @override
  String get settingsCamera => '카메라';

  @override
  String get settingsResolution => '해상도';

  @override
  String get settingsShutterSound => '셔터음 끄기';

  @override
  String get settingsBatterySaver => '배터리 세이버';

  @override
  String get settingsStorage => '저장';

  @override
  String get settingsShowInGallery => '순정 갤러리에 표시';

  @override
  String get settingsSecureAlwaysHidden => '보안 촬영분 항상 숨김';

  @override
  String get settingsForced => '강제';

  @override
  String get settingsSecurity => '보안';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsExifStrip => 'EXIF 위치 제거';

  @override
  String get settingsSecureShareLimit => '보안모드 공유제한';

  @override
  String get exportTitle => '내보내기';

  @override
  String get exportSelectPhotos => '사진 선택';

  @override
  String get exportShareSelected => '선택 공유';

  @override
  String get exportZipDone => 'ZIP 파일이 저장되었습니다';

  @override
  String get exportNoPhotos => '내보낼 사진이 없습니다';

  @override
  String exportSelectedCount(int count) {
    return '$count장 선택';
  }

  @override
  String projectsDeleteConfirm(String name) {
    return '$name을(를) 삭제하시겠습니까?';
  }

  @override
  String get projectsStatusChanged => '프로젝트 상태가 변경되었습니다';

  @override
  String get commonDeleteSuccess => '삭제되었습니다';

  @override
  String get emptyGallery => '아직 촬영한 사진이 없습니다';

  @override
  String get emptyGalleryAction => '첫 사진을 촬영해보세요';

  @override
  String get emptyProjects => '프로젝트가 없습니다';

  @override
  String get emptyProjectsAction => '새 프로젝트를 만들어보세요';

  @override
  String get errorCameraPermission => '카메라 권한이 필요합니다';

  @override
  String get errorSaveFailed => '사진 저장에 실패했습니다';

  @override
  String get settingsAbout => '앱 정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsPrivacyPolicy => '개인정보 처리방침';

  @override
  String get settingsTerms => '이용약관';

  @override
  String get privacyTitle => '개인정보 처리방침';

  @override
  String get privacyBody =>
      'Exacta는 사용자의 개인정보를 수집하지 않습니다.\n\n모든 사진과 데이터는 기기 내부에만 저장되며, 외부 서버로 전송되지 않습니다.\n\n위치 정보는 스탬프 번인 목적으로만 사용되며, 보안 모드 사용 시 위치 정보가 완전히 제거됩니다.\n\n카메라 및 저장소 권한은 촬영과 사진 저장에만 사용됩니다.';

  @override
  String get termsTitle => '이용약관';

  @override
  String get termsBody =>
      'Exacta를 이용해 주셔서 감사합니다.\n\n1. 본 앱은 현장 촬영 기록용으로 제공됩니다.\n2. 촬영된 사진의 관리 책임은 사용자에게 있습니다.\n3. 앱 사용 중 발생한 데이터 손실에 대해 개발자는 책임지지 않습니다.\n4. 본 앱은 무료이며 광고를 포함하지 않습니다.';

  @override
  String get navHome => '홈';

  @override
  String get navGallery => '갤러리';

  @override
  String get navCamera => '촬영';

  @override
  String get themeSystem => '시스템';

  @override
  String get undoDelete => '삭제 취소';

  @override
  String get photoDeleted => '사진이 삭제되었습니다';

  @override
  String get onboarding1TitleFull => '현장 촬영, 정확하게';

  @override
  String get onboarding1DescFull => 'GPS · 주소 · 시간 · 날씨를 사진에 자동 기록합니다';

  @override
  String get onboarding2TitleFull => '프로젝트별 관리';

  @override
  String get onboarding2DescFull => '현장별로 사진을 분류하고 PDF 리포트로 내보내세요';

  @override
  String get onboarding3TitleFull => '보안 촬영 모드';

  @override
  String get onboarding3DescFull => '위치정보 완전 차단 · EXIF 제거 · 위변조 방지 NTP 시간';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get navProjects => '프로젝트';

  @override
  String get navSettings => '설정';

  @override
  String get commonUndo => '실행 취소';

  @override
  String get projectNameHint => '새 프로젝트 이름';

  @override
  String get projectsMarkDone => '완료 처리';

  @override
  String get projectsMarkActive => '진행중으로';

  @override
  String projectsMovedToDone(String name) {
    return '$name → 완료 탭으로 이동';
  }

  @override
  String projectsMovedToActive(String name) {
    return '$name → 진행중 탭으로 이동';
  }

  @override
  String projectsDeleteWithCount(String name, int count) {
    return '$name\n연결된 사진 $count장';
  }

  @override
  String get projectsDeleteKeepPhotos => '프로젝트만 삭제 (사진 유지)';

  @override
  String get projectsDeleteWithPhotos => '사진도 함께 삭제';

  @override
  String projectsPhotoCount(int count) {
    return '사진 $count장';
  }

  @override
  String get galleryNoProjectFilter => '미지정';

  @override
  String get photoDetailInfo => '정보';

  @override
  String get photoDetailProject => '프로젝트';

  @override
  String get photoDetailNoProject => '프로젝트 없음';

  @override
  String get photoDetailChangeProject => '프로젝트 변경';

  @override
  String get photoDetailTimestamp => '촬영 시각';

  @override
  String get photoDetailAddress => '주소';

  @override
  String get photoDetailGps => 'GPS';

  @override
  String get photoDetailMemo => '메모';

  @override
  String get photoDetailTags => '태그';

  @override
  String get photoDetailCode => '코드';

  @override
  String get photoProjectChanged => '프로젝트가 변경되었습니다';

  @override
  String get ntpSynced => 'NTP 동기화됨';

  @override
  String get ntpNotSynced => 'NTP 미동기화 · 기기 시간 사용';

  @override
  String get pdfReportGenerated => 'PDF 리포트가 생성되었습니다';

  @override
  String pdfPhotosCount(int count) {
    return '$count장의 사진';
  }

  @override
  String get pdfGeneratedBy => 'Exacta로 생성됨';

  @override
  String get pdfImageNotAvailable => '이미지 없음';

  @override
  String get pdfWeatherLabel => '날씨';

  @override
  String photoDetailChangeConfirm(String name) {
    return '이 사진의 프로젝트를 \'$name\'(으)로 변경하시겠습니까?';
  }

  @override
  String get photoDetailClearProjectConfirm => '이 사진을 \'프로젝트 없음\'으로 변경하시겠습니까?';

  @override
  String get settingsReset => '기본값 복원';

  @override
  String get settingsResetConfirm => '모든 설정을 기본값으로 복원하시겠습니까?';

  @override
  String get settingsResetDone => '설정이 복원되었습니다';

  @override
  String get projectNameTooShort => '이름은 1자 이상 입력해주세요';

  @override
  String get projectNameTooLong => '이름은 50자 이하로 입력해주세요';

  @override
  String get projectNameDuplicate => '같은 이름의 프로젝트가 이미 있습니다';

  @override
  String memoTooLong(int max) {
    return '메모는 $max자 이하로 입력해주세요';
  }

  @override
  String tagsTooMany(int max) {
    return '태그는 최대 $max개까지 입력 가능합니다';
  }

  @override
  String get saveError => '저장 중 오류가 발생했습니다';

  @override
  String get updateError => '수정 중 오류가 발생했습니다';

  @override
  String get deleteError => '삭제 중 오류가 발생했습니다';

  @override
  String get cameraBusy => '카메라가 준비되지 않았습니다';

  @override
  String get permissionPartial => '일부 권한이 거부되었습니다';

  @override
  String get flashNotSupported => '이 기기에서 플래시를 사용할 수 없습니다';

  @override
  String get photoDetailWeather => '날씨';

  @override
  String homeTodayPhotos(int count) {
    return '오늘 $count장';
  }

  @override
  String homeTodaySecure(int count) {
    return '보안 $count장';
  }

  @override
  String homeTodayProjects(int count) {
    return '$count개 프로젝트';
  }

  @override
  String get homeLastPhoto => '마지막 촬영';

  @override
  String get homeNoPhotosYet => '아직 촬영한 사진이 없습니다';

  @override
  String get homeRecentProjects => '바로 촬영';

  @override
  String get storageUsed => '저장 공간';

  @override
  String storagePhotos(int count) {
    return '사진 $count장';
  }

  @override
  String get storageCalculating => '계산 중...';

  @override
  String get settingsStampLayout => '스탬프 레이아웃';

  @override
  String get stampLayoutBar => '풀 바';

  @override
  String get stampLayoutCard => '카드';

  @override
  String get stampLayoutText => '텍스트만';

  @override
  String get localeSystem => '시스템';

  @override
  String get localeKorean => '한국어';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeJapanese => '日本語';

  @override
  String get stampTamperBadge => '✓ Exacta · 위변조 불가 (NTP · GPS 번인 · SHA-256)';

  @override
  String get tamperProofTitle => '수정 불가 사진';

  @override
  String get tamperProofIntro => '이 사진은 다음 기술적 이유로 위조가 불가능합니다';

  @override
  String get tamperProofNtp =>
      '촬영 시각이 인터넷 표준 시간(NTP) 서버로 보정되어 기록됩니다. 기기 시계를 바꿔도 실제 시각이 그대로 남습니다.';

  @override
  String get tamperProofBurnIn =>
      'GPS 좌표·주소·시각이 사진 픽셀에 직접 합성되어 있어 EXIF 메타데이터를 제거해도 지울 수 없습니다.';

  @override
  String get tamperProofHash =>
      '파일 전체에 고유 SHA-256 지문이 찍혀 있어 1바이트만 변경되어도 즉시 감지됩니다.';

  @override
  String get tamperProofChain =>
      '직전 촬영 사진과 수학적으로 연결되어 있어, 사진 1장만 조작해도 이후 모든 사진의 체인이 깨집니다.';

  @override
  String get evidenceSectionTitle => '법적 증거';

  @override
  String get evidenceHashLabel => '파일 해시';

  @override
  String get evidenceChainLabel => '체인 해시';

  @override
  String get evidencePrevLabel => '직전 체인';

  @override
  String get evidenceGenesis => '최초 블록';

  @override
  String get evidenceNtpSynced => 'NTP 동기화됨';

  @override
  String get evidenceNtpLocal => '로컬 시계';

  @override
  String get evidenceVerifyButton => '파일 무결성 검증';

  @override
  String get evidenceVerifying => '검증 중...';

  @override
  String get evidenceVerifyOk => '검증 완료 — 파일이 변조되지 않음';

  @override
  String get evidenceVerifyFail => '경고: 파일 해시 불일치 — 변조 또는 손상';

  @override
  String get evidenceNoHash => '이 사진은 증거 해시가 없습니다';

  @override
  String get evidenceExportTitle => '증거 팩 PDF';

  @override
  String get evidenceExportDesc => '법적 제출용 — 해시 체인 + 메타데이터 포함';

  @override
  String get evidenceCaseNameLabel => '사건명 / 건명';

  @override
  String get evidenceCaseNamePlaceholder => '예: 2026-03 누수 분쟁';

  @override
  String get evidenceAuthorLabel => '작성자';

  @override
  String get evidenceAuthorPlaceholder => '예: 김현장';

  @override
  String get evidenceGenerate => '증거 팩 생성';

  @override
  String get evidencePackGenerated => '증거 팩이 생성되었습니다';

  @override
  String get evidencePackCover => '법적 증거 팩';

  @override
  String get evidencePackCaseName => '사건명';

  @override
  String get evidencePackAuthor => '작성자';

  @override
  String get evidencePackGeneratedAt => '작성 일시';

  @override
  String get evidencePackPhotoCount => '사진 수';

  @override
  String get evidencePackHashAlgo => '해시 알고리즘';

  @override
  String get evidencePackNtpNote =>
      '모든 타임스탬프는 NTP 서버로 보정되었으며, 각 사진은 SHA-256 해시 체인으로 연결되어 있습니다. 사진 1장을 조작하면 이후 모든 사진의 체인 해시가 무효가 됩니다.';

  @override
  String evidencePackPhotoTitle(int index) {
    return '사진 #$index';
  }

  @override
  String get evidencePackTimestamp => '촬영 시각';

  @override
  String get evidencePackGps => 'GPS 좌표';

  @override
  String get evidencePackAddress => '주소';

  @override
  String get evidencePackProject => '프로젝트';

  @override
  String get evidencePackMemo => '현장 메모';

  @override
  String get evidencePackPhotoHash => '파일 SHA-256';

  @override
  String get evidencePackChainHash => '체인 SHA-256';

  @override
  String get evidencePackPrevHash => '직전 체인';

  @override
  String get evidencePackVerifyTitle => '외부 검증 방법';

  @override
  String get evidencePackVerifyStep1 => '1. 각 사진 파일을 별도 저장한다.';

  @override
  String get evidencePackVerifyStep2 =>
      '2. 표준 SHA-256 도구로 파일의 해시를 계산한다 (예: Linux: sha256sum / macOS: shasum -a 256 / Windows: certutil -hashfile FILE SHA256).';

  @override
  String get evidencePackVerifyStep3 =>
      '3. 계산된 해시가 본 문서의 \"파일 SHA-256\" 값과 일치하는지 확인한다.';

  @override
  String get evidencePackVerifyStep4 =>
      '4. 체인 해시는 SHA-256(파일해시 | 직전체인 | 타임스탬프 | 위도 | 경도) 공식으로 재계산하여 검증 가능하다.';

  @override
  String get stampPresetSection => '스탬프 프리셋';

  @override
  String get stampPresetFull => '전체';

  @override
  String get stampPresetConstruction => '시공';

  @override
  String get stampPresetInspection => '점검';

  @override
  String get stampPresetDelivery => '배송';

  @override
  String get stampPresetRealEstate => '부동산';

  @override
  String get stampPresetOutdoor => '야외';

  @override
  String get stampPresetNavigation => '내비게이션';

  @override
  String get stampPresetLocation => '위치';

  @override
  String get stampPresetMinimal => '미니멀';

  @override
  String get stampPresetTimeOnly => '시간만';

  @override
  String get stampPresetGpsOnly => 'GPS만';

  @override
  String get stampPresetClean => '깔끔';
}

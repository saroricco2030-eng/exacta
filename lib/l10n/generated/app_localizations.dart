import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @commonSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @commonError.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get commonRetry;

  /// No description provided for @commonDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In ko, this message translates to:
  /// **'편집'**
  String get commonEdit;

  /// No description provided for @commonAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get commonAll;

  /// No description provided for @commonSelectAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 선택'**
  String get commonSelectAll;

  /// No description provided for @commonDeselectAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 해제'**
  String get commonDeselectAll;

  /// No description provided for @galleryDeleteConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 삭제'**
  String get galleryDeleteConfirmTitle;

  /// No description provided for @galleryDeleteConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'선택한 {count}장을 삭제합니다. 복구할 수 없습니다.'**
  String galleryDeleteConfirmMessage(int count);

  /// No description provided for @commonShare.
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get commonShare;

  /// No description provided for @commonSearch.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get commonSearch;

  /// No description provided for @homeTitle.
  ///
  /// In ko, this message translates to:
  /// **'Exacta'**
  String get homeTitle;

  /// No description provided for @homeThisWeek.
  ///
  /// In ko, this message translates to:
  /// **'이번 주'**
  String get homeThisWeek;

  /// No description provided for @homeTotalShots.
  ///
  /// In ko, this message translates to:
  /// **'총 촬영'**
  String get homeTotalShots;

  /// No description provided for @homeProjects.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get homeProjects;

  /// No description provided for @homeSecureShots.
  ///
  /// In ko, this message translates to:
  /// **'보안 촬영'**
  String get homeSecureShots;

  /// No description provided for @homeQuickActions.
  ///
  /// In ko, this message translates to:
  /// **'빠른 실행'**
  String get homeQuickActions;

  /// No description provided for @homeActiveProject.
  ///
  /// In ko, this message translates to:
  /// **'진행중 프로젝트'**
  String get homeActiveProject;

  /// No description provided for @homeContinueShooting.
  ///
  /// In ko, this message translates to:
  /// **'이어서 촬영'**
  String get homeContinueShooting;

  /// No description provided for @cameraConstruction.
  ///
  /// In ko, this message translates to:
  /// **'시공 기록'**
  String get cameraConstruction;

  /// No description provided for @cameraSecure.
  ///
  /// In ko, this message translates to:
  /// **'보안 촬영'**
  String get cameraSecure;

  /// No description provided for @cameraConstructionDesc.
  ///
  /// In ko, this message translates to:
  /// **'GPS + 주소 + 시간'**
  String get cameraConstructionDesc;

  /// No description provided for @cameraSecureDesc.
  ///
  /// In ko, this message translates to:
  /// **'위치 완전차단'**
  String get cameraSecureDesc;

  /// No description provided for @cameraTimelapse.
  ///
  /// In ko, this message translates to:
  /// **'타임랩스'**
  String get cameraTimelapse;

  /// No description provided for @cameraSecureBadge.
  ///
  /// In ko, this message translates to:
  /// **'SECURE · EXIF STRIPPED'**
  String get cameraSecureBadge;

  /// No description provided for @cameraRecording.
  ///
  /// In ko, this message translates to:
  /// **'녹화 중'**
  String get cameraRecording;

  /// No description provided for @cameraRecordingDone.
  ///
  /// In ko, this message translates to:
  /// **'영상이 저장되었습니다'**
  String get cameraRecordingDone;

  /// No description provided for @cameraModePhoto.
  ///
  /// In ko, this message translates to:
  /// **'사진'**
  String get cameraModePhoto;

  /// No description provided for @cameraModeVideo.
  ///
  /// In ko, this message translates to:
  /// **'영상'**
  String get cameraModeVideo;

  /// No description provided for @cameraModeTimelapse.
  ///
  /// In ko, this message translates to:
  /// **'타임랩스'**
  String get cameraModeTimelapse;

  /// No description provided for @cameraTimelapseRunning.
  ///
  /// In ko, this message translates to:
  /// **'촬영 중 · {count}장'**
  String cameraTimelapseRunning(int count);

  /// No description provided for @cameraTimelapseInterval.
  ///
  /// In ko, this message translates to:
  /// **'촬영 간격'**
  String get cameraTimelapseInterval;

  /// No description provided for @cameraTimelapseDone.
  ///
  /// In ko, this message translates to:
  /// **'타임랩스 완료 · {count}장 저장'**
  String cameraTimelapseDone(int count);

  /// No description provided for @cameraInterval1s.
  ///
  /// In ko, this message translates to:
  /// **'1초'**
  String get cameraInterval1s;

  /// No description provided for @cameraInterval3s.
  ///
  /// In ko, this message translates to:
  /// **'3초'**
  String get cameraInterval3s;

  /// No description provided for @cameraInterval5s.
  ///
  /// In ko, this message translates to:
  /// **'5초'**
  String get cameraInterval5s;

  /// No description provided for @cameraInterval10s.
  ///
  /// In ko, this message translates to:
  /// **'10초'**
  String get cameraInterval10s;

  /// No description provided for @cameraInterval30s.
  ///
  /// In ko, this message translates to:
  /// **'30초'**
  String get cameraInterval30s;

  /// No description provided for @cameraInterval1m.
  ///
  /// In ko, this message translates to:
  /// **'1분'**
  String get cameraInterval1m;

  /// No description provided for @cameraInterval5m.
  ///
  /// In ko, this message translates to:
  /// **'5분'**
  String get cameraInterval5m;

  /// No description provided for @cameraInterval10m.
  ///
  /// In ko, this message translates to:
  /// **'10분'**
  String get cameraInterval10m;

  /// No description provided for @cameraInterval30m.
  ///
  /// In ko, this message translates to:
  /// **'30분'**
  String get cameraInterval30m;

  /// No description provided for @cameraIntervalShooting.
  ///
  /// In ko, this message translates to:
  /// **'인터벌 촬영 중 · {count}장'**
  String cameraIntervalShooting(int count);

  /// No description provided for @cameraIntervalDone.
  ///
  /// In ko, this message translates to:
  /// **'인터벌 촬영 완료 · {count}장'**
  String cameraIntervalDone(int count);

  /// No description provided for @cameraModeInterval.
  ///
  /// In ko, this message translates to:
  /// **'인터벌'**
  String get cameraModeInterval;

  /// No description provided for @stampEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 편집'**
  String get stampEditTitle;

  /// No description provided for @stampMemoPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'촬영 메모를 입력하세요...'**
  String get stampMemoPlaceholder;

  /// No description provided for @stampProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get stampProject;

  /// No description provided for @stampDisplayItems.
  ///
  /// In ko, this message translates to:
  /// **'표시 항목'**
  String get stampDisplayItems;

  /// No description provided for @stampTagsPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'태그를 입력하세요 (쉼표로 구분)'**
  String get stampTagsPlaceholder;

  /// No description provided for @stampTags.
  ///
  /// In ko, this message translates to:
  /// **'태그'**
  String get stampTags;

  /// No description provided for @stampOverlays.
  ///
  /// In ko, this message translates to:
  /// **'오버레이'**
  String get stampOverlays;

  /// No description provided for @stampTime.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get stampTime;

  /// No description provided for @stampDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get stampDate;

  /// No description provided for @stampAddress.
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get stampAddress;

  /// No description provided for @stampGps.
  ///
  /// In ko, this message translates to:
  /// **'GPS 좌표'**
  String get stampGps;

  /// No description provided for @stampCompass.
  ///
  /// In ko, this message translates to:
  /// **'나침반'**
  String get stampCompass;

  /// No description provided for @stampAltitude.
  ///
  /// In ko, this message translates to:
  /// **'해발'**
  String get stampAltitude;

  /// No description provided for @stampSpeed.
  ///
  /// In ko, this message translates to:
  /// **'속도'**
  String get stampSpeed;

  /// No description provided for @stampLogo.
  ///
  /// In ko, this message translates to:
  /// **'로고'**
  String get stampLogo;

  /// No description provided for @stampLogoSelect.
  ///
  /// In ko, this message translates to:
  /// **'로고 이미지 선택'**
  String get stampLogoSelect;

  /// No description provided for @stampSignature.
  ///
  /// In ko, this message translates to:
  /// **'손글씨 서명'**
  String get stampSignature;

  /// No description provided for @stampSignatureDraw.
  ///
  /// In ko, this message translates to:
  /// **'서명 그리기'**
  String get stampSignatureDraw;

  /// No description provided for @galleryTitle.
  ///
  /// In ko, this message translates to:
  /// **'갤러리'**
  String get galleryTitle;

  /// No description provided for @galleryToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get galleryToday;

  /// No description provided for @galleryYesterday.
  ///
  /// In ko, this message translates to:
  /// **'어제'**
  String get galleryYesterday;

  /// No description provided for @galleryNoProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 없음'**
  String get galleryNoProject;

  /// No description provided for @galleryPhotos.
  ///
  /// In ko, this message translates to:
  /// **'{count}장'**
  String galleryPhotos(int count);

  /// No description provided for @projectsTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get projectsTitle;

  /// No description provided for @projectsSearch.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 검색...'**
  String get projectsSearch;

  /// No description provided for @projectsActive.
  ///
  /// In ko, this message translates to:
  /// **'진행중'**
  String get projectsActive;

  /// No description provided for @projectsDone.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get projectsDone;

  /// No description provided for @projectsNew.
  ///
  /// In ko, this message translates to:
  /// **'새 프로젝트'**
  String get projectsNew;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @settingsTimestamp.
  ///
  /// In ko, this message translates to:
  /// **'타임스탬프'**
  String get settingsTimestamp;

  /// No description provided for @settingsDateFormat.
  ///
  /// In ko, this message translates to:
  /// **'날짜 포맷'**
  String get settingsDateFormat;

  /// No description provided for @settingsFont.
  ///
  /// In ko, this message translates to:
  /// **'폰트'**
  String get settingsFont;

  /// No description provided for @settingsStampColor.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 색상'**
  String get settingsStampColor;

  /// No description provided for @settingsStampPosition.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 위치'**
  String get settingsStampPosition;

  /// No description provided for @settingsCamera.
  ///
  /// In ko, this message translates to:
  /// **'카메라'**
  String get settingsCamera;

  /// No description provided for @settingsResolution.
  ///
  /// In ko, this message translates to:
  /// **'해상도'**
  String get settingsResolution;

  /// No description provided for @settingsShutterSound.
  ///
  /// In ko, this message translates to:
  /// **'셔터음 끄기'**
  String get settingsShutterSound;

  /// No description provided for @settingsBatterySaver.
  ///
  /// In ko, this message translates to:
  /// **'배터리 세이버'**
  String get settingsBatterySaver;

  /// No description provided for @settingsStorage.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get settingsStorage;

  /// No description provided for @settingsShowInGallery.
  ///
  /// In ko, this message translates to:
  /// **'순정 갤러리에 표시'**
  String get settingsShowInGallery;

  /// No description provided for @settingsSecureAlwaysHidden.
  ///
  /// In ko, this message translates to:
  /// **'보안 촬영분 항상 숨김'**
  String get settingsSecureAlwaysHidden;

  /// No description provided for @settingsForced.
  ///
  /// In ko, this message translates to:
  /// **'강제'**
  String get settingsForced;

  /// No description provided for @settingsSecurity.
  ///
  /// In ko, this message translates to:
  /// **'보안'**
  String get settingsSecurity;

  /// No description provided for @settingsTheme.
  ///
  /// In ko, this message translates to:
  /// **'테마'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// No description provided for @settingsExifStrip.
  ///
  /// In ko, this message translates to:
  /// **'EXIF 위치 제거'**
  String get settingsExifStrip;

  /// No description provided for @settingsSecureShareLimit.
  ///
  /// In ko, this message translates to:
  /// **'보안모드 공유제한'**
  String get settingsSecureShareLimit;

  /// No description provided for @exportTitle.
  ///
  /// In ko, this message translates to:
  /// **'내보내기'**
  String get exportTitle;

  /// No description provided for @exportSelectPhotos.
  ///
  /// In ko, this message translates to:
  /// **'사진 선택'**
  String get exportSelectPhotos;

  /// No description provided for @exportShareSelected.
  ///
  /// In ko, this message translates to:
  /// **'선택 공유'**
  String get exportShareSelected;

  /// No description provided for @exportZipDone.
  ///
  /// In ko, this message translates to:
  /// **'ZIP 파일이 저장되었습니다'**
  String get exportZipDone;

  /// No description provided for @exportNoPhotos.
  ///
  /// In ko, this message translates to:
  /// **'내보낼 사진이 없습니다'**
  String get exportNoPhotos;

  /// No description provided for @exportSelectedCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}장 선택'**
  String exportSelectedCount(int count);

  /// No description provided for @projectsDeleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 삭제하시겠습니까?'**
  String projectsDeleteConfirm(String name);

  /// No description provided for @projectsStatusChanged.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 상태가 변경되었습니다'**
  String get projectsStatusChanged;

  /// No description provided for @commonDeleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'삭제되었습니다'**
  String get commonDeleteSuccess;

  /// No description provided for @emptyGallery.
  ///
  /// In ko, this message translates to:
  /// **'아직 촬영한 사진이 없습니다'**
  String get emptyGallery;

  /// No description provided for @emptyGalleryAction.
  ///
  /// In ko, this message translates to:
  /// **'첫 사진을 촬영해보세요'**
  String get emptyGalleryAction;

  /// No description provided for @emptyProjects.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트가 없습니다'**
  String get emptyProjects;

  /// No description provided for @emptyProjectsAction.
  ///
  /// In ko, this message translates to:
  /// **'새 프로젝트를 만들어보세요'**
  String get emptyProjectsAction;

  /// No description provided for @errorCameraPermission.
  ///
  /// In ko, this message translates to:
  /// **'카메라 권한이 필요합니다'**
  String get errorCameraPermission;

  /// No description provided for @errorSaveFailed.
  ///
  /// In ko, this message translates to:
  /// **'사진 저장에 실패했습니다'**
  String get errorSaveFailed;

  /// No description provided for @settingsAbout.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get settingsTerms;

  /// No description provided for @privacyTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In ko, this message translates to:
  /// **'Exacta는 사용자의 개인정보를 수집하지 않습니다.\n\n■ 데이터 저장\n모든 사진과 데이터는 기기 내부에만 저장되며, 외부 서버로 전송되지 않습니다.\n\n■ 위치 정보\n위치 정보는 스탬프 번인 목적으로만 사용되며, 보안 모드 사용 시 위치 정보가 완전히 제거됩니다.\n\n■ 권한 사용 목적\n• 카메라: 사진/영상 촬영\n• 위치: GPS 좌표 및 주소 스탬프\n• 저장소: 사진 파일 저장\n• 마이크: 영상 촬영 시 음성 녹음\n\n■ 제3자 서비스\n날씨 정보 표시를 위해 Open-Meteo API를 사용합니다. GPS 좌표가 날씨 조회 시 전송되며, 다른 개인정보는 전송되지 않습니다.\n\n■ 데이터 보존\n앱을 삭제하면 모든 데이터가 즉시 삭제됩니다. 별도의 데이터 보존 기간은 없습니다.\n\n■ 사용자 권리\n언제든지 앱 내 갤러리에서 사진을 삭제하거나, 앱을 삭제하여 모든 데이터를 제거할 수 있습니다.\n\n■ 문의\nsupport@exacta.app'**
  String get privacyBody;

  /// No description provided for @termsTitle.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get termsTitle;

  /// No description provided for @termsBody.
  ///
  /// In ko, this message translates to:
  /// **'Exacta를 이용해 주셔서 감사합니다.\n\n1. 본 앱은 현장 촬영 기록용으로 제공됩니다.\n2. 촬영된 사진의 관리 책임은 사용자에게 있습니다.\n3. 앱 사용 중 발생한 데이터 손실에 대해 개발자는 책임지지 않습니다.\n4. 본 앱은 무료이며 광고를 포함하지 않습니다.'**
  String get termsBody;

  /// No description provided for @navHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// No description provided for @navGallery.
  ///
  /// In ko, this message translates to:
  /// **'갤러리'**
  String get navGallery;

  /// No description provided for @navCamera.
  ///
  /// In ko, this message translates to:
  /// **'촬영'**
  String get navCamera;

  /// No description provided for @themeSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템'**
  String get themeSystem;

  /// No description provided for @undoDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제 취소'**
  String get undoDelete;

  /// No description provided for @photoDeleted.
  ///
  /// In ko, this message translates to:
  /// **'사진이 삭제되었습니다'**
  String get photoDeleted;

  /// No description provided for @onboarding1TitleFull.
  ///
  /// In ko, this message translates to:
  /// **'셔터 한 번,\n시간과 위치가 박힙니다'**
  String get onboarding1TitleFull;

  /// No description provided for @onboarding1DescFull.
  ///
  /// In ko, this message translates to:
  /// **'시공·점검·배송·인수증\n현장 사진 한 장으로 끝나는 증빙'**
  String get onboarding1DescFull;

  /// No description provided for @onboarding2TitleFull.
  ///
  /// In ko, this message translates to:
  /// **'법정에서도 통하는\n증거 사진'**
  String get onboarding2TitleFull;

  /// No description provided for @onboarding2DescFull.
  ///
  /// In ko, this message translates to:
  /// **'SHA-256 해시 체인 + NTP 서버 시간\n위변조 즉시 탐지, PDF 증거 팩 자동 생성'**
  String get onboarding2DescFull;

  /// No description provided for @onboarding3TitleFull.
  ///
  /// In ko, this message translates to:
  /// **'민감한 촬영,\n위치는 완전 비밀'**
  String get onboarding3TitleFull;

  /// No description provided for @onboarding3DescFull.
  ///
  /// In ko, this message translates to:
  /// **'보안 모드 — GPS 0, EXIF 0, 갤러리 미등록\n나만의 비공개 폴더에 안전하게'**
  String get onboarding3DescFull;

  /// No description provided for @themeLight.
  ///
  /// In ko, this message translates to:
  /// **'라이트'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get themeDark;

  /// No description provided for @navProjects.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get navProjects;

  /// No description provided for @navSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get navSettings;

  /// No description provided for @commonUndo.
  ///
  /// In ko, this message translates to:
  /// **'실행 취소'**
  String get commonUndo;

  /// No description provided for @projectNameHint.
  ///
  /// In ko, this message translates to:
  /// **'새 프로젝트 이름'**
  String get projectNameHint;

  /// No description provided for @projectsMarkDone.
  ///
  /// In ko, this message translates to:
  /// **'완료 처리'**
  String get projectsMarkDone;

  /// No description provided for @projectsMarkActive.
  ///
  /// In ko, this message translates to:
  /// **'진행중으로'**
  String get projectsMarkActive;

  /// No description provided for @projectsMovedToDone.
  ///
  /// In ko, this message translates to:
  /// **'{name} → 완료 탭으로 이동'**
  String projectsMovedToDone(String name);

  /// No description provided for @projectsMovedToActive.
  ///
  /// In ko, this message translates to:
  /// **'{name} → 진행중 탭으로 이동'**
  String projectsMovedToActive(String name);

  /// No description provided for @projectsDeleteWithCount.
  ///
  /// In ko, this message translates to:
  /// **'{name}\n연결된 사진 {count}장'**
  String projectsDeleteWithCount(String name, int count);

  /// No description provided for @projectsDeleteKeepPhotos.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트만 삭제 (사진 유지)'**
  String get projectsDeleteKeepPhotos;

  /// No description provided for @projectsDeleteWithPhotos.
  ///
  /// In ko, this message translates to:
  /// **'사진도 함께 삭제'**
  String get projectsDeleteWithPhotos;

  /// No description provided for @projectsPhotoCount.
  ///
  /// In ko, this message translates to:
  /// **'사진 {count}장'**
  String projectsPhotoCount(int count);

  /// No description provided for @galleryNoProjectFilter.
  ///
  /// In ko, this message translates to:
  /// **'미지정'**
  String get galleryNoProjectFilter;

  /// No description provided for @photoDetailInfo.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get photoDetailInfo;

  /// No description provided for @photoDetailProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get photoDetailProject;

  /// No description provided for @photoDetailNoProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 없음'**
  String get photoDetailNoProject;

  /// No description provided for @photoDetailChangeProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 변경'**
  String get photoDetailChangeProject;

  /// No description provided for @photoDetailTimestamp.
  ///
  /// In ko, this message translates to:
  /// **'촬영 시각'**
  String get photoDetailTimestamp;

  /// No description provided for @photoDetailAddress.
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get photoDetailAddress;

  /// No description provided for @photoDetailGps.
  ///
  /// In ko, this message translates to:
  /// **'GPS'**
  String get photoDetailGps;

  /// No description provided for @photoDetailMemo.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get photoDetailMemo;

  /// No description provided for @photoDetailTags.
  ///
  /// In ko, this message translates to:
  /// **'태그'**
  String get photoDetailTags;

  /// No description provided for @photoDetailCode.
  ///
  /// In ko, this message translates to:
  /// **'코드'**
  String get photoDetailCode;

  /// No description provided for @photoProjectChanged.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트가 변경되었습니다'**
  String get photoProjectChanged;

  /// No description provided for @ntpSynced.
  ///
  /// In ko, this message translates to:
  /// **'NTP 동기화됨'**
  String get ntpSynced;

  /// No description provided for @ntpNotSynced.
  ///
  /// In ko, this message translates to:
  /// **'NTP 미동기화 · 기기 시간 사용'**
  String get ntpNotSynced;

  /// No description provided for @pdfReportGenerated.
  ///
  /// In ko, this message translates to:
  /// **'PDF 리포트가 생성되었습니다'**
  String get pdfReportGenerated;

  /// No description provided for @pdfPhotosCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}장의 사진'**
  String pdfPhotosCount(int count);

  /// No description provided for @pdfGeneratedBy.
  ///
  /// In ko, this message translates to:
  /// **'Exacta로 생성됨'**
  String get pdfGeneratedBy;

  /// No description provided for @pdfImageNotAvailable.
  ///
  /// In ko, this message translates to:
  /// **'이미지 없음'**
  String get pdfImageNotAvailable;

  /// No description provided for @pdfWeatherLabel.
  ///
  /// In ko, this message translates to:
  /// **'날씨'**
  String get pdfWeatherLabel;

  /// No description provided for @photoDetailChangeConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 사진의 프로젝트를 \'{name}\'(으)로 변경하시겠습니까?'**
  String photoDetailChangeConfirm(String name);

  /// No description provided for @photoDetailClearProjectConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 사진을 \'프로젝트 없음\'으로 변경하시겠습니까?'**
  String get photoDetailClearProjectConfirm;

  /// No description provided for @settingsReset.
  ///
  /// In ko, this message translates to:
  /// **'기본값 복원'**
  String get settingsReset;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In ko, this message translates to:
  /// **'모든 설정을 기본값으로 복원하시겠습니까?'**
  String get settingsResetConfirm;

  /// No description provided for @settingsResetDone.
  ///
  /// In ko, this message translates to:
  /// **'설정이 복원되었습니다'**
  String get settingsResetDone;

  /// No description provided for @projectNameTooShort.
  ///
  /// In ko, this message translates to:
  /// **'이름은 1자 이상 입력해주세요'**
  String get projectNameTooShort;

  /// No description provided for @projectNameTooLong.
  ///
  /// In ko, this message translates to:
  /// **'이름은 50자 이하로 입력해주세요'**
  String get projectNameTooLong;

  /// No description provided for @projectNameDuplicate.
  ///
  /// In ko, this message translates to:
  /// **'같은 이름의 프로젝트가 이미 있습니다'**
  String get projectNameDuplicate;

  /// No description provided for @memoTooLong.
  ///
  /// In ko, this message translates to:
  /// **'메모는 {max}자 이하로 입력해주세요'**
  String memoTooLong(int max);

  /// No description provided for @tagsTooMany.
  ///
  /// In ko, this message translates to:
  /// **'태그는 최대 {max}개까지 입력 가능합니다'**
  String tagsTooMany(int max);

  /// No description provided for @saveError.
  ///
  /// In ko, this message translates to:
  /// **'저장 중 오류가 발생했습니다'**
  String get saveError;

  /// No description provided for @updateError.
  ///
  /// In ko, this message translates to:
  /// **'수정 중 오류가 발생했습니다'**
  String get updateError;

  /// No description provided for @deleteError.
  ///
  /// In ko, this message translates to:
  /// **'삭제 중 오류가 발생했습니다'**
  String get deleteError;

  /// No description provided for @cameraBusy.
  ///
  /// In ko, this message translates to:
  /// **'카메라가 준비되지 않았습니다'**
  String get cameraBusy;

  /// No description provided for @permissionPartial.
  ///
  /// In ko, this message translates to:
  /// **'일부 권한이 거부되었습니다'**
  String get permissionPartial;

  /// No description provided for @flashNotSupported.
  ///
  /// In ko, this message translates to:
  /// **'이 기기에서 플래시를 사용할 수 없습니다'**
  String get flashNotSupported;

  /// No description provided for @photoDetailWeather.
  ///
  /// In ko, this message translates to:
  /// **'날씨'**
  String get photoDetailWeather;

  /// No description provided for @homeTodayPhotos.
  ///
  /// In ko, this message translates to:
  /// **'오늘 {count}장'**
  String homeTodayPhotos(int count);

  /// No description provided for @homeTodaySecure.
  ///
  /// In ko, this message translates to:
  /// **'보안 {count}장'**
  String homeTodaySecure(int count);

  /// No description provided for @homeTodayProjects.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 프로젝트'**
  String homeTodayProjects(int count);

  /// No description provided for @homeLastPhoto.
  ///
  /// In ko, this message translates to:
  /// **'마지막 촬영'**
  String get homeLastPhoto;

  /// No description provided for @homeNoPhotosYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 촬영한 사진이 없습니다'**
  String get homeNoPhotosYet;

  /// No description provided for @homeRecentProjects.
  ///
  /// In ko, this message translates to:
  /// **'바로 촬영'**
  String get homeRecentProjects;

  /// No description provided for @storageUsed.
  ///
  /// In ko, this message translates to:
  /// **'저장 공간'**
  String get storageUsed;

  /// No description provided for @storagePhotos.
  ///
  /// In ko, this message translates to:
  /// **'사진 {count}장'**
  String storagePhotos(int count);

  /// No description provided for @storageCalculating.
  ///
  /// In ko, this message translates to:
  /// **'계산 중...'**
  String get storageCalculating;

  /// No description provided for @settingsStampLayout.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 레이아웃'**
  String get settingsStampLayout;

  /// No description provided for @stampLayoutBar.
  ///
  /// In ko, this message translates to:
  /// **'풀 바'**
  String get stampLayoutBar;

  /// No description provided for @stampLayoutCard.
  ///
  /// In ko, this message translates to:
  /// **'카드'**
  String get stampLayoutCard;

  /// No description provided for @stampLayoutText.
  ///
  /// In ko, this message translates to:
  /// **'텍스트만'**
  String get stampLayoutText;

  /// No description provided for @settingsStampSize.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 크기'**
  String get settingsStampSize;

  /// No description provided for @stampSizeSmall.
  ///
  /// In ko, this message translates to:
  /// **'소'**
  String get stampSizeSmall;

  /// No description provided for @stampSizeMedium.
  ///
  /// In ko, this message translates to:
  /// **'중'**
  String get stampSizeMedium;

  /// No description provided for @stampSizeLarge.
  ///
  /// In ko, this message translates to:
  /// **'대'**
  String get stampSizeLarge;

  /// No description provided for @settingsStampOpacity.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 투명도'**
  String get settingsStampOpacity;

  /// No description provided for @settingsStampBgColor.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 배경색'**
  String get settingsStampBgColor;

  /// No description provided for @settingsCustomLine1.
  ///
  /// In ko, this message translates to:
  /// **'회사명'**
  String get settingsCustomLine1;

  /// No description provided for @settingsCustomLine1Hint.
  ///
  /// In ko, this message translates to:
  /// **'회사명을 입력하세요'**
  String get settingsCustomLine1Hint;

  /// No description provided for @settingsCustomLine2.
  ///
  /// In ko, this message translates to:
  /// **'담당자명'**
  String get settingsCustomLine2;

  /// No description provided for @settingsCustomLine2Hint.
  ///
  /// In ko, this message translates to:
  /// **'담당자명을 입력하세요'**
  String get settingsCustomLine2Hint;

  /// No description provided for @localeSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템'**
  String get localeSystem;

  /// No description provided for @localeKorean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get localeKorean;

  /// No description provided for @localeEnglish.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// No description provided for @localeJapanese.
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get localeJapanese;

  /// No description provided for @stampTamperBadge.
  ///
  /// In ko, this message translates to:
  /// **'✓ Exacta · 위변조 불가 (NTP · GPS 번인 · SHA-256)'**
  String get stampTamperBadge;

  /// No description provided for @tamperProofTitle.
  ///
  /// In ko, this message translates to:
  /// **'수정 불가 사진'**
  String get tamperProofTitle;

  /// No description provided for @tamperProofIntro.
  ///
  /// In ko, this message translates to:
  /// **'이 사진은 다음 기술적 이유로 위조가 불가능합니다'**
  String get tamperProofIntro;

  /// No description provided for @tamperProofNtp.
  ///
  /// In ko, this message translates to:
  /// **'촬영 시각이 인터넷 표준 시간(NTP) 서버로 보정되어 기록됩니다. 기기 시계를 바꿔도 실제 시각이 그대로 남습니다.'**
  String get tamperProofNtp;

  /// No description provided for @tamperProofBurnIn.
  ///
  /// In ko, this message translates to:
  /// **'GPS 좌표·주소·시각이 사진 픽셀에 직접 합성되어 있어 EXIF 메타데이터를 제거해도 지울 수 없습니다.'**
  String get tamperProofBurnIn;

  /// No description provided for @tamperProofHash.
  ///
  /// In ko, this message translates to:
  /// **'파일 전체에 고유 SHA-256 지문이 찍혀 있어 1바이트만 변경되어도 즉시 감지됩니다.'**
  String get tamperProofHash;

  /// No description provided for @tamperProofChain.
  ///
  /// In ko, this message translates to:
  /// **'직전 촬영 사진과 수학적으로 연결되어 있어, 사진 1장만 조작해도 이후 모든 사진의 체인이 깨집니다.'**
  String get tamperProofChain;

  /// No description provided for @evidenceSectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'법적 증거'**
  String get evidenceSectionTitle;

  /// No description provided for @evidenceHashLabel.
  ///
  /// In ko, this message translates to:
  /// **'파일 해시'**
  String get evidenceHashLabel;

  /// No description provided for @evidenceChainLabel.
  ///
  /// In ko, this message translates to:
  /// **'체인 해시'**
  String get evidenceChainLabel;

  /// No description provided for @evidencePrevLabel.
  ///
  /// In ko, this message translates to:
  /// **'직전 체인'**
  String get evidencePrevLabel;

  /// No description provided for @evidenceGenesis.
  ///
  /// In ko, this message translates to:
  /// **'최초 블록'**
  String get evidenceGenesis;

  /// No description provided for @evidenceNtpSynced.
  ///
  /// In ko, this message translates to:
  /// **'NTP 동기화됨'**
  String get evidenceNtpSynced;

  /// No description provided for @evidenceNtpLocal.
  ///
  /// In ko, this message translates to:
  /// **'로컬 시계'**
  String get evidenceNtpLocal;

  /// No description provided for @evidenceVerifyButton.
  ///
  /// In ko, this message translates to:
  /// **'파일 무결성 검증'**
  String get evidenceVerifyButton;

  /// No description provided for @evidenceVerifying.
  ///
  /// In ko, this message translates to:
  /// **'검증 중...'**
  String get evidenceVerifying;

  /// No description provided for @evidenceVerifyOk.
  ///
  /// In ko, this message translates to:
  /// **'검증 완료 — 파일이 변조되지 않음'**
  String get evidenceVerifyOk;

  /// No description provided for @evidenceVerifyFail.
  ///
  /// In ko, this message translates to:
  /// **'경고: 파일 해시 불일치 — 변조 또는 손상'**
  String get evidenceVerifyFail;

  /// No description provided for @evidenceNoHash.
  ///
  /// In ko, this message translates to:
  /// **'이 사진은 증거 해시가 없습니다'**
  String get evidenceNoHash;

  /// No description provided for @evidenceExportTitle.
  ///
  /// In ko, this message translates to:
  /// **'증거 팩 PDF'**
  String get evidenceExportTitle;

  /// No description provided for @evidenceExportDesc.
  ///
  /// In ko, this message translates to:
  /// **'법적 제출용 — 해시 체인 + 메타데이터 포함'**
  String get evidenceExportDesc;

  /// No description provided for @evidenceCaseNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'사건명 / 건명'**
  String get evidenceCaseNameLabel;

  /// No description provided for @evidenceCaseNamePlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'예: 2026-03 누수 분쟁'**
  String get evidenceCaseNamePlaceholder;

  /// No description provided for @evidenceAuthorLabel.
  ///
  /// In ko, this message translates to:
  /// **'작성자'**
  String get evidenceAuthorLabel;

  /// No description provided for @evidenceAuthorPlaceholder.
  ///
  /// In ko, this message translates to:
  /// **'예: 김현장'**
  String get evidenceAuthorPlaceholder;

  /// No description provided for @evidenceGenerate.
  ///
  /// In ko, this message translates to:
  /// **'증거 팩 생성'**
  String get evidenceGenerate;

  /// No description provided for @evidencePackGenerated.
  ///
  /// In ko, this message translates to:
  /// **'증거 팩이 생성되었습니다'**
  String get evidencePackGenerated;

  /// No description provided for @evidencePackCover.
  ///
  /// In ko, this message translates to:
  /// **'법적 증거 팩'**
  String get evidencePackCover;

  /// No description provided for @evidencePackCaseName.
  ///
  /// In ko, this message translates to:
  /// **'사건명'**
  String get evidencePackCaseName;

  /// No description provided for @evidencePackAuthor.
  ///
  /// In ko, this message translates to:
  /// **'작성자'**
  String get evidencePackAuthor;

  /// No description provided for @evidencePackGeneratedAt.
  ///
  /// In ko, this message translates to:
  /// **'작성 일시'**
  String get evidencePackGeneratedAt;

  /// No description provided for @evidencePackPhotoCount.
  ///
  /// In ko, this message translates to:
  /// **'사진 수'**
  String get evidencePackPhotoCount;

  /// No description provided for @evidencePackHashAlgo.
  ///
  /// In ko, this message translates to:
  /// **'해시 알고리즘'**
  String get evidencePackHashAlgo;

  /// No description provided for @evidencePackNtpNote.
  ///
  /// In ko, this message translates to:
  /// **'모든 타임스탬프는 NTP 서버로 보정되었으며, 각 사진은 SHA-256 해시 체인으로 연결되어 있습니다. 사진 1장을 조작하면 이후 모든 사진의 체인 해시가 무효가 됩니다.'**
  String get evidencePackNtpNote;

  /// No description provided for @evidencePackPhotoTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 #{index}'**
  String evidencePackPhotoTitle(int index);

  /// No description provided for @evidencePackTimestamp.
  ///
  /// In ko, this message translates to:
  /// **'촬영 시각'**
  String get evidencePackTimestamp;

  /// No description provided for @evidencePackGps.
  ///
  /// In ko, this message translates to:
  /// **'GPS 좌표'**
  String get evidencePackGps;

  /// No description provided for @evidencePackAddress.
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get evidencePackAddress;

  /// No description provided for @evidencePackProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get evidencePackProject;

  /// No description provided for @evidencePackMemo.
  ///
  /// In ko, this message translates to:
  /// **'현장 메모'**
  String get evidencePackMemo;

  /// No description provided for @evidencePackPhotoHash.
  ///
  /// In ko, this message translates to:
  /// **'파일 SHA-256'**
  String get evidencePackPhotoHash;

  /// No description provided for @evidencePackChainHash.
  ///
  /// In ko, this message translates to:
  /// **'체인 SHA-256'**
  String get evidencePackChainHash;

  /// No description provided for @evidencePackPrevHash.
  ///
  /// In ko, this message translates to:
  /// **'직전 체인'**
  String get evidencePackPrevHash;

  /// No description provided for @evidencePackVerifyTitle.
  ///
  /// In ko, this message translates to:
  /// **'외부 검증 방법'**
  String get evidencePackVerifyTitle;

  /// No description provided for @evidencePackVerifyStep1.
  ///
  /// In ko, this message translates to:
  /// **'1. 각 사진 파일을 별도 저장한다.'**
  String get evidencePackVerifyStep1;

  /// No description provided for @evidencePackVerifyStep2.
  ///
  /// In ko, this message translates to:
  /// **'2. 표준 SHA-256 도구로 파일의 해시를 계산한다 (예: Linux: sha256sum / macOS: shasum -a 256 / Windows: certutil -hashfile FILE SHA256).'**
  String get evidencePackVerifyStep2;

  /// No description provided for @evidencePackVerifyStep3.
  ///
  /// In ko, this message translates to:
  /// **'3. 계산된 해시가 본 문서의 \"파일 SHA-256\" 값과 일치하는지 확인한다.'**
  String get evidencePackVerifyStep3;

  /// No description provided for @evidencePackVerifyStep4.
  ///
  /// In ko, this message translates to:
  /// **'4. 체인 해시는 SHA-256(파일해시 | 직전체인 | 타임스탬프 | 위도 | 경도) 공식으로 재계산하여 검증 가능하다.'**
  String get evidencePackVerifyStep4;

  /// No description provided for @stampPresetSection.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 프리셋'**
  String get stampPresetSection;

  /// No description provided for @stampPresetFull.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get stampPresetFull;

  /// No description provided for @stampPresetConstruction.
  ///
  /// In ko, this message translates to:
  /// **'시공'**
  String get stampPresetConstruction;

  /// No description provided for @stampPresetInspection.
  ///
  /// In ko, this message translates to:
  /// **'점검'**
  String get stampPresetInspection;

  /// No description provided for @stampPresetDelivery.
  ///
  /// In ko, this message translates to:
  /// **'배송'**
  String get stampPresetDelivery;

  /// No description provided for @stampPresetRealEstate.
  ///
  /// In ko, this message translates to:
  /// **'부동산'**
  String get stampPresetRealEstate;

  /// No description provided for @stampPresetOutdoor.
  ///
  /// In ko, this message translates to:
  /// **'야외'**
  String get stampPresetOutdoor;

  /// No description provided for @stampPresetNavigation.
  ///
  /// In ko, this message translates to:
  /// **'내비게이션'**
  String get stampPresetNavigation;

  /// No description provided for @stampPresetLocation.
  ///
  /// In ko, this message translates to:
  /// **'위치'**
  String get stampPresetLocation;

  /// No description provided for @stampPresetMinimal.
  ///
  /// In ko, this message translates to:
  /// **'미니멀'**
  String get stampPresetMinimal;

  /// No description provided for @stampPresetTimeOnly.
  ///
  /// In ko, this message translates to:
  /// **'시간만'**
  String get stampPresetTimeOnly;

  /// No description provided for @stampPresetGpsOnly.
  ///
  /// In ko, this message translates to:
  /// **'GPS만'**
  String get stampPresetGpsOnly;

  /// No description provided for @stampPresetClean.
  ///
  /// In ko, this message translates to:
  /// **'깔끔'**
  String get stampPresetClean;

  /// No description provided for @commonSelect.
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get commonSelect;

  /// No description provided for @commonOk.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonOk;

  /// No description provided for @commonBack.
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get commonClose;

  /// No description provided for @commonSkip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get commonSkip;

  /// No description provided for @exitConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'앱을 종료하시겠습니까?'**
  String get exitConfirmMessage;

  /// No description provided for @stampEditLabel.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 편집'**
  String get stampEditLabel;

  /// No description provided for @commonStart.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get commonStart;

  /// No description provided for @stampPositionTopLeft.
  ///
  /// In ko, this message translates to:
  /// **'좌상단'**
  String get stampPositionTopLeft;

  /// No description provided for @stampPositionTopCenter.
  ///
  /// In ko, this message translates to:
  /// **'상단 중앙'**
  String get stampPositionTopCenter;

  /// No description provided for @stampPositionTopRight.
  ///
  /// In ko, this message translates to:
  /// **'우상단'**
  String get stampPositionTopRight;

  /// No description provided for @stampPositionCenter.
  ///
  /// In ko, this message translates to:
  /// **'중앙'**
  String get stampPositionCenter;

  /// No description provided for @stampPositionBottomLeft.
  ///
  /// In ko, this message translates to:
  /// **'좌하단'**
  String get stampPositionBottomLeft;

  /// No description provided for @stampPositionBottomCenter.
  ///
  /// In ko, this message translates to:
  /// **'하단 중앙'**
  String get stampPositionBottomCenter;

  /// No description provided for @stampPositionBottomRight.
  ///
  /// In ko, this message translates to:
  /// **'우하단'**
  String get stampPositionBottomRight;

  /// No description provided for @photoDetailRestamp.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 재적용'**
  String get photoDetailRestamp;

  /// No description provided for @restampConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 사진에 새 스탬프를 적용하시겠습니까?'**
  String get restampConfirm;

  /// No description provided for @restampSuccess.
  ///
  /// In ko, this message translates to:
  /// **'스탬프가 적용되었습니다'**
  String get restampSuccess;

  /// No description provided for @restampError.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 적용 실패'**
  String get restampError;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'첫 촬영을 시작하세요'**
  String get homeWelcomeTitle;

  /// No description provided for @homeWelcomeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'시간 · 위치 · 메모가 자동으로 사진에 새겨집니다'**
  String get homeWelcomeSubtitle;

  /// No description provided for @homeWelcomeStartButton.
  ///
  /// In ko, this message translates to:
  /// **'촬영 시작'**
  String get homeWelcomeStartButton;

  /// No description provided for @homeWelcomeBadgeTime.
  ///
  /// In ko, this message translates to:
  /// **'시간 자동 기록'**
  String get homeWelcomeBadgeTime;

  /// No description provided for @homeWelcomeBadgeGps.
  ///
  /// In ko, this message translates to:
  /// **'위치 스탬프'**
  String get homeWelcomeBadgeGps;

  /// No description provided for @homeWelcomeBadgeTamper.
  ///
  /// In ko, this message translates to:
  /// **'위변조 방지'**
  String get homeWelcomeBadgeTamper;

  /// No description provided for @captureSuccessTitle.
  ///
  /// In ko, this message translates to:
  /// **'기록 완료'**
  String get captureSuccessTitle;

  /// No description provided for @captureSuccessTamper.
  ///
  /// In ko, this message translates to:
  /// **'위변조 불가 · SHA-256 체인'**
  String get captureSuccessTamper;

  /// No description provided for @emptyGalleryExampleLabel.
  ///
  /// In ko, this message translates to:
  /// **'예시'**
  String get emptyGalleryExampleLabel;

  /// No description provided for @emptyGalleryStampPreviewAddress.
  ///
  /// In ko, this message translates to:
  /// **'서울 강남구'**
  String get emptyGalleryStampPreviewAddress;

  /// No description provided for @onboarding1Bullet1.
  ///
  /// In ko, this message translates to:
  /// **'시간 자동'**
  String get onboarding1Bullet1;

  /// No description provided for @onboarding1Bullet2.
  ///
  /// In ko, this message translates to:
  /// **'GPS 자동'**
  String get onboarding1Bullet2;

  /// No description provided for @onboarding1Bullet3.
  ///
  /// In ko, this message translates to:
  /// **'주소 자동'**
  String get onboarding1Bullet3;

  /// No description provided for @onboarding2Bullet1.
  ///
  /// In ko, this message translates to:
  /// **'해시 체인'**
  String get onboarding2Bullet1;

  /// No description provided for @onboarding2Bullet2.
  ///
  /// In ko, this message translates to:
  /// **'NTP 시간'**
  String get onboarding2Bullet2;

  /// No description provided for @onboarding2Bullet3.
  ///
  /// In ko, this message translates to:
  /// **'PDF 출력'**
  String get onboarding2Bullet3;

  /// No description provided for @onboarding3Bullet1.
  ///
  /// In ko, this message translates to:
  /// **'GPS 차단'**
  String get onboarding3Bullet1;

  /// No description provided for @onboarding3Bullet2.
  ///
  /// In ko, this message translates to:
  /// **'EXIF 제거'**
  String get onboarding3Bullet2;

  /// No description provided for @onboarding3Bullet3.
  ///
  /// In ko, this message translates to:
  /// **'갤러리 미등록'**
  String get onboarding3Bullet3;

  /// No description provided for @settingsSaveOriginal.
  ///
  /// In ko, this message translates to:
  /// **'원본도 함께 저장'**
  String get settingsSaveOriginal;

  /// No description provided for @settingsSaveOriginalDesc.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 없는 원본을 별도 보관합니다 (보안 모드 제외)'**
  String get settingsSaveOriginalDesc;

  /// No description provided for @photoDetailViewOriginal.
  ///
  /// In ko, this message translates to:
  /// **'원본 보기'**
  String get photoDetailViewOriginal;

  /// No description provided for @photoDetailShareOriginal.
  ///
  /// In ko, this message translates to:
  /// **'원본 공유'**
  String get photoDetailShareOriginal;

  /// No description provided for @photoDetailOriginalLabel.
  ///
  /// In ko, this message translates to:
  /// **'원본 (스탬프 없음)'**
  String get photoDetailOriginalLabel;

  /// No description provided for @photoDetailStampedLabel.
  ///
  /// In ko, this message translates to:
  /// **'스탬프본'**
  String get photoDetailStampedLabel;

  /// No description provided for @cameraStampToggleLabel.
  ///
  /// In ko, this message translates to:
  /// **'스탬프 켜기/끄기'**
  String get cameraStampToggleLabel;

  /// No description provided for @cameraShutterLabel.
  ///
  /// In ko, this message translates to:
  /// **'셔터'**
  String get cameraShutterLabel;

  /// No description provided for @cameraStopRecordingLabel.
  ///
  /// In ko, this message translates to:
  /// **'녹화 중지'**
  String get cameraStopRecordingLabel;

  /// No description provided for @openSettingsAction.
  ///
  /// In ko, this message translates to:
  /// **'설정 열기'**
  String get openSettingsAction;

  /// No description provided for @onboardingReplay.
  ///
  /// In ko, this message translates to:
  /// **'온보딩 다시 보기'**
  String get onboardingReplay;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

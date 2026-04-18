// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonError => 'An error occurred';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAll => 'All';

  @override
  String get commonSelectAll => 'Select All';

  @override
  String get commonDeselectAll => 'Deselect All';

  @override
  String get galleryDeleteConfirmTitle => 'Delete Photos';

  @override
  String galleryDeleteConfirmMessage(int count) {
    return 'Delete $count selected photo(s)? This cannot be undone.';
  }

  @override
  String get commonShare => 'Share';

  @override
  String get commonSearch => 'Search';

  @override
  String get homeTitle => 'Exacta';

  @override
  String get homeThisWeek => 'This Week';

  @override
  String get homeTotalShots => 'Total Shots';

  @override
  String get homeProjects => 'Projects';

  @override
  String get homeSecureShots => 'Secure Shots';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeActiveProject => 'Active Project';

  @override
  String get homeContinueShooting => 'Continue Shooting';

  @override
  String get cameraConstruction => 'Construction';

  @override
  String get cameraSecure => 'Secure';

  @override
  String get cameraConstructionDesc => 'GPS + Address + Time';

  @override
  String get cameraSecureDesc => 'Location blocked';

  @override
  String get cameraTimelapse => 'Timelapse';

  @override
  String get cameraSecureBadge => 'SECURE · EXIF STRIPPED';

  @override
  String get cameraRecording => 'Recording';

  @override
  String get cameraRecordingDone => 'Video saved';

  @override
  String get cameraModePhoto => 'Photo';

  @override
  String get cameraModeVideo => 'Video';

  @override
  String get cameraModeTimelapse => 'Timelapse';

  @override
  String cameraTimelapseRunning(int count) {
    return 'Shooting · $count photos';
  }

  @override
  String get cameraTimelapseInterval => 'Interval';

  @override
  String cameraTimelapseDone(int count) {
    return 'Timelapse done · $count photos saved';
  }

  @override
  String get cameraInterval1s => '1s';

  @override
  String get cameraInterval3s => '3s';

  @override
  String get cameraInterval5s => '5s';

  @override
  String get cameraInterval10s => '10s';

  @override
  String get cameraInterval30s => '30s';

  @override
  String get cameraInterval1m => '1min';

  @override
  String get cameraInterval5m => '5min';

  @override
  String get cameraInterval10m => '10min';

  @override
  String get cameraInterval30m => '30min';

  @override
  String cameraIntervalShooting(int count) {
    return 'Interval · $count photos';
  }

  @override
  String cameraIntervalDone(int count) {
    return 'Interval done · $count photos';
  }

  @override
  String get cameraModeInterval => 'Interval';

  @override
  String get stampEditTitle => 'Edit Stamp';

  @override
  String get stampMemoPlaceholder => 'Enter a memo...';

  @override
  String get stampProject => 'Project';

  @override
  String get stampDisplayItems => 'Display Items';

  @override
  String get stampTagsPlaceholder => 'Enter tags (comma separated)';

  @override
  String get stampTags => 'Tags';

  @override
  String get stampOverlays => 'Overlays';

  @override
  String get stampTime => 'Time';

  @override
  String get stampDate => 'Date';

  @override
  String get stampAddress => 'Address';

  @override
  String get stampGps => 'GPS Coordinates';

  @override
  String get stampCompass => 'Compass';

  @override
  String get stampAltitude => 'Altitude';

  @override
  String get stampSpeed => 'Speed';

  @override
  String get stampLogo => 'Logo';

  @override
  String get stampLogoSelect => 'Select logo image';

  @override
  String get stampSignature => 'Signature';

  @override
  String get stampSignatureDraw => 'Draw signature';

  @override
  String get galleryTitle => 'Gallery';

  @override
  String get galleryToday => 'Today';

  @override
  String get galleryYesterday => 'Yesterday';

  @override
  String get galleryNoProject => 'No Project';

  @override
  String galleryPhotos(int count) {
    return '$count photos';
  }

  @override
  String get projectsTitle => 'Projects';

  @override
  String get projectsSearch => 'Search projects...';

  @override
  String get projectsActive => 'Active';

  @override
  String get projectsDone => 'Done';

  @override
  String get projectsNew => 'New Project';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTimestamp => 'Timestamp';

  @override
  String get settingsDateFormat => 'Date Format';

  @override
  String get settingsFont => 'Font';

  @override
  String get settingsStampColor => 'Stamp Color';

  @override
  String get settingsStampPosition => 'Stamp Position';

  @override
  String get settingsCamera => 'Camera';

  @override
  String get settingsResolution => 'Resolution';

  @override
  String get settingsShutterSound => 'Shutter Sound Off';

  @override
  String get settingsBatterySaver => 'Battery Saver';

  @override
  String get settingsStorage => 'Storage';

  @override
  String get settingsShowInGallery => 'Show in Gallery';

  @override
  String get settingsSecureAlwaysHidden => 'Always hide secure shots';

  @override
  String get settingsForced => 'Forced';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsExifStrip => 'Strip EXIF Location';

  @override
  String get settingsSecureShareLimit => 'Secure Mode Share Limit';

  @override
  String get exportTitle => 'Export';

  @override
  String get exportSelectPhotos => 'Select photos';

  @override
  String get exportShareSelected => 'Share selected';

  @override
  String get exportZipDone => 'ZIP file saved';

  @override
  String get exportNoPhotos => 'No photos to export';

  @override
  String exportSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String projectsDeleteConfirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get projectsStatusChanged => 'Project status changed';

  @override
  String get commonDeleteSuccess => 'Deleted';

  @override
  String get emptyGallery => 'No photos yet';

  @override
  String get emptyGalleryAction => 'Take your first photo';

  @override
  String get emptyProjects => 'No projects yet';

  @override
  String get emptyProjectsAction => 'Create a new project';

  @override
  String get errorCameraPermission => 'Camera permission required';

  @override
  String get errorSaveFailed => 'Failed to save photo';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Use';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get privacyBody =>
      'Exacta does not collect any personal information.\n\n■ Data Storage\nAll photos and data are stored only on your device and are never transmitted to external servers.\n\n■ Location Data\nLocation data is used solely for stamp burn-in purposes. When using Secure Mode, location data is completely removed.\n\n■ Permission Usage\n• Camera: Photo/video capture\n• Location: GPS coordinates and address stamp\n• Storage: Saving photo files\n• Microphone: Audio recording during video capture\n\n■ Third-Party Services\nWeather information is provided by the Open-Meteo API. GPS coordinates are sent for weather queries only; no other personal data is transmitted.\n\n■ Data Retention\nAll data is immediately deleted when you uninstall the app. There is no separate data retention period.\n\n■ Your Rights\nYou can delete photos anytime from the in-app gallery, or uninstall the app to remove all data.\n\n■ Contact\nsupport@exacta.app';

  @override
  String get termsTitle => 'Terms of Use';

  @override
  String get termsBody =>
      'Thank you for using Exacta.\n\n1. This app is provided for on-site photo documentation.\n2. Users are responsible for managing their captured photos.\n3. The developer is not liable for any data loss during app use.\n4. This app is free and contains no advertisements.';

  @override
  String get navHome => 'Home';

  @override
  String get navGallery => 'Gallery';

  @override
  String get navCamera => 'Shoot';

  @override
  String get themeSystem => 'System';

  @override
  String get undoDelete => 'Undo';

  @override
  String get photoDeleted => 'Photo deleted';

  @override
  String get onboarding1TitleFull => 'One tap,\ntime and place locked in';

  @override
  String get onboarding1DescFull =>
      'Construction · inspection · delivery · proof\nOne photo, one complete record';

  @override
  String get onboarding2TitleFull => 'Court-grade\nphoto evidence';

  @override
  String get onboarding2DescFull =>
      'SHA-256 hash chain + NTP server time\nInstant tamper detection, auto PDF evidence pack';

  @override
  String get onboarding3TitleFull => 'Sensitive shots,\nlocation kept private';

  @override
  String get onboarding3DescFull =>
      'Secure mode — zero GPS, zero EXIF, hidden from gallery\nSafe in your private folder';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get navProjects => 'Projects';

  @override
  String get navSettings => 'Settings';

  @override
  String get commonUndo => 'Undo';

  @override
  String get projectNameHint => 'New project name';

  @override
  String get projectsMarkDone => 'Mark done';

  @override
  String get projectsMarkActive => 'Reactivate';

  @override
  String projectsMovedToDone(String name) {
    return '$name → moved to Done';
  }

  @override
  String projectsMovedToActive(String name) {
    return '$name → moved to Active';
  }

  @override
  String projectsDeleteWithCount(String name, int count) {
    return '$name\n$count photos linked';
  }

  @override
  String get projectsDeleteKeepPhotos => 'Delete project only (keep photos)';

  @override
  String get projectsDeleteWithPhotos => 'Delete with all photos';

  @override
  String projectsPhotoCount(int count) {
    return '$count photos';
  }

  @override
  String get galleryNoProjectFilter => 'Unassigned';

  @override
  String get photoDetailInfo => 'Info';

  @override
  String get photoDetailProject => 'Project';

  @override
  String get photoDetailNoProject => 'No project';

  @override
  String get photoDetailChangeProject => 'Change project';

  @override
  String get photoDetailTimestamp => 'Timestamp';

  @override
  String get photoDetailAddress => 'Address';

  @override
  String get photoDetailGps => 'GPS';

  @override
  String get photoDetailMemo => 'Memo';

  @override
  String get photoDetailTags => 'Tags';

  @override
  String get photoDetailCode => 'Code';

  @override
  String get photoProjectChanged => 'Project changed';

  @override
  String get ntpSynced => 'NTP Synced';

  @override
  String get ntpNotSynced => 'NTP not synced · using device time';

  @override
  String get pdfReportGenerated => 'PDF report generated';

  @override
  String pdfPhotosCount(int count) {
    return '$count photos';
  }

  @override
  String get pdfGeneratedBy => 'Generated by Exacta';

  @override
  String get pdfImageNotAvailable => 'Image not available';

  @override
  String get pdfWeatherLabel => 'Weather';

  @override
  String photoDetailChangeConfirm(String name) {
    return 'Move this photo to \'$name\'?';
  }

  @override
  String get photoDetailClearProjectConfirm =>
      'Move this photo to \'No project\'?';

  @override
  String get settingsReset => 'Reset to defaults';

  @override
  String get settingsResetConfirm => 'Reset all settings to defaults?';

  @override
  String get settingsResetDone => 'Settings restored';

  @override
  String get projectNameTooShort => 'Name must be at least 1 character';

  @override
  String get projectNameTooLong => 'Name must be 50 characters or fewer';

  @override
  String get projectNameDuplicate => 'A project with this name already exists';

  @override
  String memoTooLong(int max) {
    return 'Memo must be $max characters or fewer';
  }

  @override
  String tagsTooMany(int max) {
    return 'Up to $max tags allowed';
  }

  @override
  String get saveError => 'Error while saving';

  @override
  String get updateError => 'Error while updating';

  @override
  String get deleteError => 'Error while deleting';

  @override
  String get cameraBusy => 'Camera not ready';

  @override
  String get permissionPartial => 'Some permissions were denied';

  @override
  String get flashNotSupported => 'Flash is not available on this device';

  @override
  String get photoDetailWeather => 'Weather';

  @override
  String homeTodayPhotos(int count) {
    return 'Today $count';
  }

  @override
  String homeTodaySecure(int count) {
    return 'Secure $count';
  }

  @override
  String homeTodayProjects(int count) {
    return '$count projects';
  }

  @override
  String get homeLastPhoto => 'Last shot';

  @override
  String get homeNoPhotosYet => 'No photos yet';

  @override
  String get homeRecentProjects => 'Quick shoot';

  @override
  String get storageUsed => 'Storage';

  @override
  String storagePhotos(int count) {
    return '$count photos';
  }

  @override
  String get storageCalculating => 'Calculating...';

  @override
  String get settingsStampLayout => 'Stamp layout';

  @override
  String get stampLayoutBar => 'Full bar';

  @override
  String get stampLayoutCard => 'Card';

  @override
  String get stampLayoutText => 'Text only';

  @override
  String get settingsStampSize => 'Stamp size';

  @override
  String get stampSizeSmall => 'Small';

  @override
  String get stampSizeMedium => 'Medium';

  @override
  String get stampSizeLarge => 'Large';

  @override
  String get settingsStampOpacity => 'Stamp opacity';

  @override
  String get settingsStampBgColor => 'Stamp background color';

  @override
  String get settingsCustomLine1 => 'Company name';

  @override
  String get settingsCustomLine1Hint => 'Enter company name';

  @override
  String get settingsCustomLine2 => 'Contact name';

  @override
  String get settingsCustomLine2Hint => 'Enter contact name';

  @override
  String get localeSystem => 'System';

  @override
  String get localeKorean => '한국어';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeJapanese => '日本語';

  @override
  String get stampTamperBadge =>
      '✓ Exacta · Tamper-Proof (NTP · Pixel GPS · SHA-256)';

  @override
  String get tamperProofTitle => 'Tamper-Proof Photo';

  @override
  String get tamperProofIntro =>
      'This photo cannot be forged for the following technical reasons';

  @override
  String get tamperProofNtp =>
      'Capture time is corrected by an Internet standard (NTP) time server. Changing the device clock does not affect the recorded time.';

  @override
  String get tamperProofBurnIn =>
      'GPS coordinates, address, and time are baked directly into the photo pixels, so removing EXIF metadata cannot erase them.';

  @override
  String get tamperProofHash =>
      'A unique SHA-256 fingerprint is computed over the entire file. Changing even a single byte is detected instantly.';

  @override
  String get tamperProofChain =>
      'Each photo is mathematically linked to the previous one. Tampering with a single photo breaks the chain for all subsequent photos.';

  @override
  String get evidenceSectionTitle => 'Legal Evidence';

  @override
  String get evidenceHashLabel => 'File Hash';

  @override
  String get evidenceChainLabel => 'Chain Hash';

  @override
  String get evidencePrevLabel => 'Previous Chain';

  @override
  String get evidenceGenesis => 'Genesis Block';

  @override
  String get evidenceNtpSynced => 'NTP Synced';

  @override
  String get evidenceNtpLocal => 'Local Clock';

  @override
  String get evidenceVerifyButton => 'Verify File Integrity';

  @override
  String get evidenceVerifying => 'Verifying...';

  @override
  String get evidenceVerifyOk => 'Verified — file has not been tampered';

  @override
  String get evidenceVerifyFail =>
      'Warning: file hash mismatch — tampered or corrupted';

  @override
  String get evidenceNoHash => 'This photo has no evidence hash';

  @override
  String get evidenceExportTitle => 'Evidence Pack PDF';

  @override
  String get evidenceExportDesc =>
      'For legal submission — includes hash chain + metadata';

  @override
  String get evidenceCaseNameLabel => 'Case Name';

  @override
  String get evidenceCaseNamePlaceholder => 'e.g. 2026-03 Water Damage Dispute';

  @override
  String get evidenceAuthorLabel => 'Author';

  @override
  String get evidenceAuthorPlaceholder => 'e.g. Jane Field';

  @override
  String get evidenceGenerate => 'Generate Evidence Pack';

  @override
  String get evidencePackGenerated => 'Evidence pack generated';

  @override
  String get evidencePackCover => 'Legal Evidence Pack';

  @override
  String get evidencePackCaseName => 'Case Name';

  @override
  String get evidencePackAuthor => 'Author';

  @override
  String get evidencePackGeneratedAt => 'Generated At';

  @override
  String get evidencePackPhotoCount => 'Photo Count';

  @override
  String get evidencePackHashAlgo => 'Hash Algorithm';

  @override
  String get evidencePackNtpNote =>
      'All timestamps are corrected using an NTP server, and each photo is linked by a SHA-256 hash chain. Tampering with a single photo invalidates all subsequent chain hashes.';

  @override
  String evidencePackPhotoTitle(int index) {
    return 'Photo #$index';
  }

  @override
  String get evidencePackTimestamp => 'Captured At';

  @override
  String get evidencePackGps => 'GPS Coordinates';

  @override
  String get evidencePackAddress => 'Address';

  @override
  String get evidencePackProject => 'Project';

  @override
  String get evidencePackMemo => 'Field Memo';

  @override
  String get evidencePackPhotoHash => 'File SHA-256';

  @override
  String get evidencePackChainHash => 'Chain SHA-256';

  @override
  String get evidencePackPrevHash => 'Previous Chain';

  @override
  String get evidencePackVerifyTitle => 'External Verification';

  @override
  String get evidencePackVerifyStep1 => '1. Save each photo file separately.';

  @override
  String get evidencePackVerifyStep2 =>
      '2. Compute SHA-256 with a standard tool (Linux: sha256sum / macOS: shasum -a 256 / Windows: certutil -hashfile FILE SHA256).';

  @override
  String get evidencePackVerifyStep3 =>
      '3. Confirm that the computed hash matches the \"File SHA-256\" value in this document.';

  @override
  String get evidencePackVerifyStep4 =>
      '4. Chain hashes can be re-computed via SHA-256(fileHash | prevChain | timestamp | lat | lng).';

  @override
  String get stampPresetSection => 'Stamp Preset';

  @override
  String get stampPresetFull => 'Full';

  @override
  String get stampPresetConstruction => 'Construction';

  @override
  String get stampPresetInspection => 'Inspection';

  @override
  String get stampPresetDelivery => 'Delivery';

  @override
  String get stampPresetRealEstate => 'Real Estate';

  @override
  String get stampPresetOutdoor => 'Outdoor';

  @override
  String get stampPresetNavigation => 'Navigation';

  @override
  String get stampPresetLocation => 'Location';

  @override
  String get stampPresetMinimal => 'Minimal';

  @override
  String get stampPresetTimeOnly => 'Time Only';

  @override
  String get stampPresetGpsOnly => 'GPS Only';

  @override
  String get stampPresetClean => 'Clean';

  @override
  String get commonSelect => 'Select';

  @override
  String get commonOk => 'OK';

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSkip => 'Skip';

  @override
  String get exitConfirmMessage => 'Exit the app?';

  @override
  String get stampEditLabel => 'Edit stamp';

  @override
  String get commonStart => 'Start';

  @override
  String get stampPositionTopLeft => 'Top Left';

  @override
  String get stampPositionTopCenter => 'Top Center';

  @override
  String get stampPositionTopRight => 'Top Right';

  @override
  String get stampPositionCenter => 'Center';

  @override
  String get stampPositionBottomLeft => 'Bottom Left';

  @override
  String get stampPositionBottomCenter => 'Bottom Center';

  @override
  String get stampPositionBottomRight => 'Bottom Right';

  @override
  String get photoDetailRestamp => 'Re-stamp';

  @override
  String get restampConfirm => 'Apply new stamp to this photo?';

  @override
  String get restampSuccess => 'Photo re-stamped';

  @override
  String get restampError => 'Re-stamp failed';

  @override
  String get homeWelcomeTitle => 'Take your first photo';

  @override
  String get homeWelcomeSubtitle =>
      'Time · location · notes burned into every shot';

  @override
  String get homeWelcomeStartButton => 'Start Shooting';

  @override
  String get homeWelcomeBadgeTime => 'Auto timestamp';

  @override
  String get homeWelcomeBadgeGps => 'GPS stamp';

  @override
  String get homeWelcomeBadgeTamper => 'Tamper-proof';

  @override
  String get captureSuccessTitle => 'Captured';

  @override
  String get captureSuccessTamper => 'Tamper-proof · SHA-256 chain';

  @override
  String get emptyGalleryExampleLabel => 'Example';

  @override
  String get emptyGalleryStampPreviewAddress => 'Seoul, Gangnam';

  @override
  String get onboarding1Bullet1 => 'Auto time';

  @override
  String get onboarding1Bullet2 => 'Auto GPS';

  @override
  String get onboarding1Bullet3 => 'Auto address';

  @override
  String get onboarding2Bullet1 => 'Hash chain';

  @override
  String get onboarding2Bullet2 => 'NTP time';

  @override
  String get onboarding2Bullet3 => 'PDF export';

  @override
  String get onboarding3Bullet1 => 'GPS blocked';

  @override
  String get onboarding3Bullet2 => 'EXIF stripped';

  @override
  String get onboarding3Bullet3 => 'Hidden gallery';

  @override
  String get settingsSaveOriginal => 'Save original alongside';

  @override
  String get settingsSaveOriginalDesc =>
      'Keeps the unstamped original in a separate folder (excluded in Secure mode)';

  @override
  String get photoDetailViewOriginal => 'View original';

  @override
  String get photoDetailShareOriginal => 'Share original';

  @override
  String get photoDetailOriginalLabel => 'Original (no stamp)';

  @override
  String get photoDetailStampedLabel => 'Stamped';

  @override
  String get cameraStampToggleLabel => 'Toggle stamp';

  @override
  String get cameraShutterLabel => 'Shutter';

  @override
  String get cameraStopRecordingLabel => 'Stop recording';

  @override
  String get openSettingsAction => 'Open Settings';

  @override
  String get onboardingReplay => 'Replay Onboarding';
}

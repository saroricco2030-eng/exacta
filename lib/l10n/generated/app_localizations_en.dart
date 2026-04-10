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
      'Exacta does not collect any personal information.\n\nAll photos and data are stored only on your device and are never transmitted to external servers.\n\nLocation data is used solely for stamp burn-in purposes. When using Secure Mode, location data is completely removed.\n\nCamera and storage permissions are used only for capturing and saving photos.';

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
  String get onboarding1TitleFull => 'Precise Field Photos';

  @override
  String get onboarding1DescFull =>
      'Auto-stamp GPS, address, time, and weather on every photo';

  @override
  String get onboarding2TitleFull => 'Project Management';

  @override
  String get onboarding2DescFull =>
      'Organize photos by project and export PDF reports';

  @override
  String get onboarding3TitleFull => 'Secure Capture Mode';

  @override
  String get onboarding3DescFull =>
      'Block all location data · Strip EXIF · NTP tamper-proof time';

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
  String get localeSystem => 'System';

  @override
  String get localeKorean => '한국어';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeJapanese => '日本語';

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
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonError => 'エラーが発生しました';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonDelete => '削除';

  @override
  String get commonEdit => '編集';

  @override
  String get commonAll => 'すべて';

  @override
  String get commonShare => '共有';

  @override
  String get commonSearch => '検索';

  @override
  String get homeTitle => 'Exacta';

  @override
  String get homeThisWeek => '今週';

  @override
  String get homeTotalShots => '総撮影';

  @override
  String get homeProjects => 'プロジェクト';

  @override
  String get homeSecureShots => 'セキュア撮影';

  @override
  String get homeQuickActions => 'クイックアクション';

  @override
  String get homeActiveProject => '進行中プロジェクト';

  @override
  String get homeContinueShooting => '続けて撮影';

  @override
  String get cameraConstruction => '施工記録';

  @override
  String get cameraSecure => 'セキュア撮影';

  @override
  String get cameraConstructionDesc => 'GPS + 住所 + 時間';

  @override
  String get cameraSecureDesc => '位置情報完全遮断';

  @override
  String get cameraTimelapse => 'タイムラプス';

  @override
  String get cameraSecureBadge => 'SECURE · EXIF STRIPPED';

  @override
  String get cameraRecording => '録画中';

  @override
  String get cameraRecordingDone => '動画が保存されました';

  @override
  String get cameraModePhoto => '写真';

  @override
  String get cameraModeVideo => '動画';

  @override
  String get cameraModeTimelapse => 'タイムラプス';

  @override
  String cameraTimelapseRunning(int count) {
    return '撮影中 · $count枚';
  }

  @override
  String get cameraTimelapseInterval => '撮影間隔';

  @override
  String cameraTimelapseDone(int count) {
    return 'タイムラプス完了 · $count枚保存';
  }

  @override
  String get cameraInterval1s => '1秒';

  @override
  String get cameraInterval3s => '3秒';

  @override
  String get cameraInterval5s => '5秒';

  @override
  String get cameraInterval10s => '10秒';

  @override
  String get cameraInterval30s => '30秒';

  @override
  String get cameraInterval1m => '1分';

  @override
  String get cameraInterval5m => '5分';

  @override
  String get cameraInterval10m => '10分';

  @override
  String get cameraInterval30m => '30分';

  @override
  String cameraIntervalShooting(int count) {
    return 'インターバル撮影中 · $count枚';
  }

  @override
  String cameraIntervalDone(int count) {
    return 'インターバル撮影完了 · $count枚';
  }

  @override
  String get cameraModeInterval => 'インターバル';

  @override
  String get stampEditTitle => 'スタンプ編集';

  @override
  String get stampMemoPlaceholder => '撮影メモを入力...';

  @override
  String get stampProject => 'プロジェクト';

  @override
  String get stampDisplayItems => '表示項目';

  @override
  String get stampTagsPlaceholder => 'タグを入力（カンマ区切り）';

  @override
  String get stampTags => 'タグ';

  @override
  String get stampOverlays => 'オーバーレイ';

  @override
  String get stampTime => '時間';

  @override
  String get stampDate => '日付';

  @override
  String get stampAddress => '住所';

  @override
  String get stampGps => 'GPS座標';

  @override
  String get stampCompass => 'コンパス';

  @override
  String get stampAltitude => '標高';

  @override
  String get stampSpeed => '速度';

  @override
  String get stampLogo => 'ロゴ';

  @override
  String get stampLogoSelect => 'ロゴ画像を選択';

  @override
  String get stampSignature => '手書きサイン';

  @override
  String get stampSignatureDraw => 'サインを描く';

  @override
  String get galleryTitle => 'ギャラリー';

  @override
  String get galleryToday => '今日';

  @override
  String get galleryYesterday => '昨日';

  @override
  String get galleryNoProject => 'プロジェクトなし';

  @override
  String galleryPhotos(int count) {
    return '$count枚';
  }

  @override
  String get projectsTitle => 'プロジェクト';

  @override
  String get projectsSearch => 'プロジェクト検索...';

  @override
  String get projectsActive => '進行中';

  @override
  String get projectsDone => '完了';

  @override
  String get projectsNew => '新規プロジェクト';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsTimestamp => 'タイムスタンプ';

  @override
  String get settingsDateFormat => '日付フォーマット';

  @override
  String get settingsFont => 'フォント';

  @override
  String get settingsStampColor => 'スタンプ色';

  @override
  String get settingsStampPosition => 'スタンプ位置';

  @override
  String get settingsCamera => 'カメラ';

  @override
  String get settingsResolution => '解像度';

  @override
  String get settingsShutterSound => 'シャッター音オフ';

  @override
  String get settingsBatterySaver => 'バッテリーセーバー';

  @override
  String get settingsStorage => 'ストレージ';

  @override
  String get settingsShowInGallery => '標準ギャラリーに表示';

  @override
  String get settingsSecureAlwaysHidden => 'セキュア撮影は常に非表示';

  @override
  String get settingsForced => '強制';

  @override
  String get settingsSecurity => 'セキュリティ';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsExifStrip => 'EXIF位置情報削除';

  @override
  String get settingsSecureShareLimit => 'セキュアモード共有制限';

  @override
  String get exportTitle => 'エクスポート';

  @override
  String get exportSelectPhotos => '写真を選択';

  @override
  String get exportShareSelected => '選択を共有';

  @override
  String get exportZipDone => 'ZIPファイルが保存されました';

  @override
  String get exportNoPhotos => 'エクスポートする写真がありません';

  @override
  String exportSelectedCount(int count) {
    return '$count枚選択';
  }

  @override
  String projectsDeleteConfirm(String name) {
    return '$nameを削除しますか？';
  }

  @override
  String get projectsStatusChanged => 'プロジェクトの状態が変更されました';

  @override
  String get commonDeleteSuccess => '削除しました';

  @override
  String get emptyGallery => 'まだ撮影した写真がありません';

  @override
  String get emptyGalleryAction => '最初の写真を撮影しましょう';

  @override
  String get emptyProjects => 'プロジェクトがありません';

  @override
  String get emptyProjectsAction => '新しいプロジェクトを作成しましょう';

  @override
  String get errorCameraPermission => 'カメラの権限が必要です';

  @override
  String get errorSaveFailed => '写真の保存に失敗しました';

  @override
  String get settingsAbout => 'アプリ情報';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTerms => '利用規約';

  @override
  String get privacyTitle => 'プライバシーポリシー';

  @override
  String get privacyBody =>
      'Exactaは個人情報を一切収集しません。\n\nすべての写真とデータはデバイス内にのみ保存され、外部サーバーには送信されません。\n\n位置情報はスタンプ焼き込み目的でのみ使用されます。セキュアモード使用時は位置情報が完全に削除されます。\n\nカメラとストレージの権限は撮影と写真保存にのみ使用されます。';

  @override
  String get termsTitle => '利用規約';

  @override
  String get termsBody =>
      'Exactaをご利用いただきありがとうございます。\n\n1. 本アプリは現場撮影記録用に提供されます。\n2. 撮影した写真の管理責任はユーザーにあります。\n3. アプリ使用中のデータ損失について開発者は責任を負いません。\n4. 本アプリは無料で広告を含みません。';

  @override
  String get navHome => 'ホーム';

  @override
  String get navGallery => 'ギャラリー';

  @override
  String get navCamera => '撮影';

  @override
  String get themeSystem => 'システム';

  @override
  String get undoDelete => '取り消し';

  @override
  String get photoDeleted => '写真が削除されました';

  @override
  String get onboarding1TitleFull => '正確な現場撮影';

  @override
  String get onboarding1DescFull => 'GPS・住所・時間・天気を写真に自動記録します';

  @override
  String get onboarding2TitleFull => 'プロジェクト管理';

  @override
  String get onboarding2DescFull => '現場別に写真を分類しPDFレポートで出力';

  @override
  String get onboarding3TitleFull => 'セキュア撮影モード';

  @override
  String get onboarding3DescFull => '位置情報完全遮断・EXIF削除・NTP改ざん防止時間';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get navProjects => 'プロジェクト';

  @override
  String get navSettings => '設定';

  @override
  String get commonUndo => '取り消し';

  @override
  String get projectNameHint => '新しいプロジェクト名';

  @override
  String get projectsMarkDone => '完了にする';

  @override
  String get projectsMarkActive => '進行中に戻す';

  @override
  String projectsMovedToDone(String name) {
    return '$name → 完了タブへ移動';
  }

  @override
  String projectsMovedToActive(String name) {
    return '$name → 進行中タブへ移動';
  }

  @override
  String projectsDeleteWithCount(String name, int count) {
    return '$name\n紐づいた写真 $count枚';
  }

  @override
  String get projectsDeleteKeepPhotos => 'プロジェクトのみ削除 (写真は保持)';

  @override
  String get projectsDeleteWithPhotos => '写真も一緒に削除';

  @override
  String projectsPhotoCount(int count) {
    return '写真 $count枚';
  }

  @override
  String get galleryNoProjectFilter => '未割当';

  @override
  String get photoDetailInfo => '情報';

  @override
  String get photoDetailProject => 'プロジェクト';

  @override
  String get photoDetailNoProject => 'プロジェクトなし';

  @override
  String get photoDetailChangeProject => 'プロジェクト変更';

  @override
  String get photoDetailTimestamp => '撮影時刻';

  @override
  String get photoDetailAddress => '住所';

  @override
  String get photoDetailGps => 'GPS';

  @override
  String get photoDetailMemo => 'メモ';

  @override
  String get photoDetailTags => 'タグ';

  @override
  String get photoDetailCode => 'コード';

  @override
  String get photoProjectChanged => 'プロジェクトが変更されました';

  @override
  String get ntpSynced => 'NTP同期済み';

  @override
  String get ntpNotSynced => 'NTP未同期・端末時刻を使用';

  @override
  String get pdfReportGenerated => 'PDFレポートが生成されました';

  @override
  String pdfPhotosCount(int count) {
    return '$count枚の写真';
  }

  @override
  String get pdfGeneratedBy => 'Exactaで生成';

  @override
  String get pdfImageNotAvailable => '画像なし';

  @override
  String get pdfWeatherLabel => '天気';

  @override
  String photoDetailChangeConfirm(String name) {
    return 'この写真を「$name」に変更しますか?';
  }

  @override
  String get photoDetailClearProjectConfirm => 'この写真を「プロジェクトなし」に変更しますか?';

  @override
  String get settingsReset => 'デフォルトに戻す';

  @override
  String get settingsResetConfirm => 'すべての設定をデフォルトに戻しますか?';

  @override
  String get settingsResetDone => '設定を復元しました';

  @override
  String get projectNameTooShort => '名前を1文字以上入力してください';

  @override
  String get projectNameTooLong => '名前は50文字以下で入力してください';

  @override
  String get projectNameDuplicate => '同じ名前のプロジェクトが既に存在します';

  @override
  String memoTooLong(int max) {
    return 'メモは$max文字以下で入力してください';
  }

  @override
  String tagsTooMany(int max) {
    return 'タグは最大$max個まで入力できます';
  }

  @override
  String get saveError => '保存中にエラーが発生しました';

  @override
  String get updateError => '更新中にエラーが発生しました';

  @override
  String get deleteError => '削除中にエラーが発生しました';

  @override
  String get cameraBusy => 'カメラの準備ができていません';

  @override
  String get permissionPartial => '一部の権限が拒否されました';

  @override
  String get flashNotSupported => 'この端末ではフラッシュを使用できません';

  @override
  String get photoDetailWeather => '天気';

  @override
  String homeTodayPhotos(int count) {
    return '今日 $count枚';
  }

  @override
  String homeTodaySecure(int count) {
    return 'セキュア $count枚';
  }

  @override
  String homeTodayProjects(int count) {
    return '$countプロジェクト';
  }

  @override
  String get homeLastPhoto => '最後の撮影';

  @override
  String get homeNoPhotosYet => 'まだ撮影した写真がありません';

  @override
  String get homeRecentProjects => 'すぐ撮影';

  @override
  String get storageUsed => 'ストレージ';

  @override
  String storagePhotos(int count) {
    return '写真 $count枚';
  }

  @override
  String get storageCalculating => '計算中...';

  @override
  String get settingsStampLayout => 'スタンプレイアウト';

  @override
  String get stampLayoutBar => 'フルバー';

  @override
  String get stampLayoutCard => 'カード';

  @override
  String get stampLayoutText => 'テキストのみ';

  @override
  String get localeSystem => 'システム';

  @override
  String get localeKorean => '한국어';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeJapanese => '日本語';

  @override
  String get stampTamperBadge => '✓ Exacta · 改ざん不可 (NTP · GPS焼き込み · SHA-256)';

  @override
  String get tamperProofTitle => '改ざん不可能な写真';

  @override
  String get tamperProofIntro => 'この写真は以下の技術的理由により偽造が不可能です';

  @override
  String get tamperProofNtp =>
      '撮影時刻はインターネット標準時刻(NTP)サーバーで補正されて記録されます。端末の時計を変えても実際の時刻は変わりません。';

  @override
  String get tamperProofBurnIn =>
      'GPS座標・住所・時刻が写真のピクセルに直接合成されており、EXIFメタデータを削除しても消せません。';

  @override
  String get tamperProofHash =>
      'ファイル全体に固有のSHA-256指紋が記録されており、1バイトでも変更されると即座に検知されます。';

  @override
  String get tamperProofChain =>
      '各写真は直前の写真と数学的に連結されており、1枚でも改ざんすると以降すべての写真のチェーンが壊れます。';

  @override
  String get evidenceSectionTitle => '法的証拠';

  @override
  String get evidenceHashLabel => 'ファイルハッシュ';

  @override
  String get evidenceChainLabel => 'チェーンハッシュ';

  @override
  String get evidencePrevLabel => '前のチェーン';

  @override
  String get evidenceGenesis => '最初のブロック';

  @override
  String get evidenceNtpSynced => 'NTP同期済み';

  @override
  String get evidenceNtpLocal => 'ローカル時計';

  @override
  String get evidenceVerifyButton => 'ファイル整合性検証';

  @override
  String get evidenceVerifying => '検証中...';

  @override
  String get evidenceVerifyOk => '検証完了 — ファイルは改ざんされていません';

  @override
  String get evidenceVerifyFail => '警告: ファイルハッシュ不一致 — 改ざんまたは破損';

  @override
  String get evidenceNoHash => 'この写真には証拠ハッシュがありません';

  @override
  String get evidenceExportTitle => '証拠パックPDF';

  @override
  String get evidenceExportDesc => '法的提出用 — ハッシュチェーン + メタデータを含む';

  @override
  String get evidenceCaseNameLabel => '案件名';

  @override
  String get evidenceCaseNamePlaceholder => '例: 2026-03 漏水紛争';

  @override
  String get evidenceAuthorLabel => '作成者';

  @override
  String get evidenceAuthorPlaceholder => '例: 山田現場';

  @override
  String get evidenceGenerate => '証拠パック生成';

  @override
  String get evidencePackGenerated => '証拠パックが生成されました';

  @override
  String get evidencePackCover => '法的証拠パック';

  @override
  String get evidencePackCaseName => '案件名';

  @override
  String get evidencePackAuthor => '作成者';

  @override
  String get evidencePackGeneratedAt => '生成日時';

  @override
  String get evidencePackPhotoCount => '写真枚数';

  @override
  String get evidencePackHashAlgo => 'ハッシュアルゴリズム';

  @override
  String get evidencePackNtpNote =>
      'すべてのタイムスタンプはNTPサーバーで補正されており、各写真はSHA-256ハッシュチェーンで連結されています。1枚でも改ざんされると以降すべてのチェーンハッシュが無効になります。';

  @override
  String evidencePackPhotoTitle(int index) {
    return '写真 #$index';
  }

  @override
  String get evidencePackTimestamp => '撮影時刻';

  @override
  String get evidencePackGps => 'GPS座標';

  @override
  String get evidencePackAddress => '住所';

  @override
  String get evidencePackProject => 'プロジェクト';

  @override
  String get evidencePackMemo => '現場メモ';

  @override
  String get evidencePackPhotoHash => 'ファイルSHA-256';

  @override
  String get evidencePackChainHash => 'チェーンSHA-256';

  @override
  String get evidencePackPrevHash => '前のチェーン';

  @override
  String get evidencePackVerifyTitle => '外部検証方法';

  @override
  String get evidencePackVerifyStep1 => '1. 各写真ファイルを別途保存する。';

  @override
  String get evidencePackVerifyStep2 =>
      '2. 標準SHA-256ツールでファイルのハッシュを計算する (Linux: sha256sum / macOS: shasum -a 256 / Windows: certutil -hashfile FILE SHA256)。';

  @override
  String get evidencePackVerifyStep3 =>
      '3. 計算されたハッシュが本書の「ファイルSHA-256」値と一致するか確認する。';

  @override
  String get evidencePackVerifyStep4 =>
      '4. チェーンハッシュはSHA-256(ファイルハッシュ | 前のチェーン | タイムスタンプ | 緯度 | 経度)式で再計算可能。';

  @override
  String get stampPresetSection => 'スタンププリセット';

  @override
  String get stampPresetFull => 'フル';

  @override
  String get stampPresetConstruction => '施工';

  @override
  String get stampPresetInspection => '点検';

  @override
  String get stampPresetDelivery => '配送';

  @override
  String get stampPresetRealEstate => '不動産';

  @override
  String get stampPresetOutdoor => '屋外';

  @override
  String get stampPresetNavigation => 'ナビ';

  @override
  String get stampPresetLocation => '位置';

  @override
  String get stampPresetMinimal => 'ミニマル';

  @override
  String get stampPresetTimeOnly => '時刻のみ';

  @override
  String get stampPresetGpsOnly => 'GPSのみ';

  @override
  String get stampPresetClean => 'シンプル';
}

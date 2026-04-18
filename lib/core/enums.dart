/// 프로젝트 상태
enum ProjectStatus {
  active('active'),
  done('done');

  final String value;
  const ProjectStatus(this.value);

  static ProjectStatus fromString(String s) =>
      s == 'done' ? done : active;
}

/// 스탬프 프리셋
enum StampPreset {
  construction('construction'),
  secure('secure');

  final String value;
  const StampPreset(this.value);

  static StampPreset fromString(String s) =>
      s == 'secure' ? secure : construction;
}

/// 스탬프 위치 (7곳)
enum StampPosition {
  topLeft('topLeft'),
  topCenter('topCenter'),
  topRight('topRight'),
  center('center'),
  bottomLeft('bottomLeft'),
  bottomCenter('bottomCenter'),
  bottomRight('bottomRight');

  final String value;
  const StampPosition(this.value);

  static StampPosition fromString(String s) =>
      StampPosition.values.firstWhere(
        (e) => e.value == s,
        orElse: () => bottomLeft,
      );
}

/// 해상도
enum CameraResolution {
  hd1080('1080p'),
  uhd4k('4k');

  final String value;
  const CameraResolution(this.value);

  static CameraResolution fromString(String s) =>
      s == '1080p' ? hd1080 : uhd4k;
}

/// 폰트
enum StampFont {
  mono('mono'),
  sans('sans');

  final String value;
  const StampFont(this.value);

  static StampFont fromString(String s) =>
      s == 'sans' ? sans : mono;
}

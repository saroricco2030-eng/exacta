/// Android MediaStore native gallery registration via MethodChannel
import 'dart:io';

import 'package:flutter/services.dart';
/// 순정 갤러리(MediaStore) 등록/미등록 제어
class GalleryRegisterService {
  static const _channel = MethodChannel('com.exacta/gallery');

  /// 사진을 순정 갤러리에 등록 (Android MediaStore)
  /// 보안 촬영분은 이 메서드를 호출하지 않는다.
  static Future<void> registerToGallery(String filePath) async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('addToGallery', {'path': filePath});
    } on MissingPluginException {
      // 네이티브 채널 미구현 시 무시 — 개발 단계에서는 정상
    }
  }

  /// MediaStore의 Pictures/Exacta 항목 전체 제거. 토글 OFF 시 호출.
  /// 반환값: 삭제된 행 개수 (실패/지원 안됨 → 0)
  static Future<int> removeAllFromGallery() async {
    if (!Platform.isAndroid) return 0;
    try {
      final result = await _channel.invokeMethod<int>('removeAllFromGallery');
      return result ?? 0;
    } on MissingPluginException {
      return 0;
    } on PlatformException {
      return 0;
    }
  }
}

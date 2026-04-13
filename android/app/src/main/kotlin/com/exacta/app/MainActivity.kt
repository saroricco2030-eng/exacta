package com.exacta.app

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.exacta/gallery"
    private val WIDGET_CHANNEL = "com.exacta/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 위젯 인텐트 처리
        val widgetChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL)
        intent?.extras?.let { extras ->
            if (extras.getBoolean("open_camera", false)) {
                widgetChannel.invokeMethod("openCamera", null)
            }
        }

        // 딥링크 / 앱 바로가기 처리
        intent?.data?.let { uri ->
            if (uri.scheme == "exacta") {
                when (uri.host) {
                    "camera" -> widgetChannel.invokeMethod("openCamera", null)
                    "gallery" -> widgetChannel.invokeMethod("openGallery", null)
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "addToGallery" -> {
                        val path = call.argument<String>("path")
                        if (path != null) {
                            addToGallery(path)
                            result.success(true)
                        } else {
                            result.error("INVALID_PATH", "Path is null", null)
                        }
                    }
                    "removeAllFromGallery" -> {
                        val deleted = removeAllFromGallery()
                        result.success(deleted)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun mimeFor(file: File): String =
        if (file.extension.equals("png", true)) "image/png" else "image/jpeg"

    private fun addToGallery(filePath: String) {
        val file = File(filePath)
        if (!file.exists()) return

        val values = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, file.name)
            put(MediaStore.Images.Media.MIME_TYPE, mimeFor(file))
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Exacta")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }
        }

        val resolver = contentResolver
        val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)

        uri?.let {
            resolver.openOutputStream(it)?.use { outputStream ->
                file.inputStream().use { inputStream ->
                    inputStream.copyTo(outputStream)
                }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.clear()
                values.put(MediaStore.Images.Media.IS_PENDING, 0)
                resolver.update(it, values, null, null)
            }
        }
    }

    /// MediaStore의 Pictures/Exacta 항목 전체 삭제 (앱이 삽입한 항목만 동의 없이 삭제 가능)
    /// Returns the number of rows deleted.
    private fun removeAllFromGallery(): Int {
        val resolver = contentResolver
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val selection = "${MediaStore.Images.Media.RELATIVE_PATH} LIKE ?"
                val selectionArgs = arrayOf("Pictures/Exacta/%")
                resolver.delete(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    selection,
                    selectionArgs
                )
            } else {
                // Pre-Q: DATA 컬럼 경로 매칭
                @Suppress("DEPRECATION")
                val selection = "${MediaStore.Images.Media.DATA} LIKE ?"
                val selectionArgs = arrayOf("%/Pictures/Exacta/%")
                resolver.delete(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    selection,
                    selectionArgs
                )
            }
        } catch (e: Exception) {
            0
        }
    }
}

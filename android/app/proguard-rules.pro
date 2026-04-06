# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift / SQLite
-keep class org.sqlite.** { *; }
-keep class sqlite3.** { *; }

# Camera
-keep class androidx.camera.** { *; }

# Google Fonts
-keep class com.google.android.gms.** { *; }

# Share Plus
-keep class dev.fluttercommunity.plus.** { *; }

# Play Core (R8 missing classes fix)
-dontwarn com.google.android.play.core.**

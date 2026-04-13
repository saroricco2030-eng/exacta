# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift / SQLite
-keep class org.sqlite.** { *; }
-keep class sqlite3.** { *; }
-keep class app.cash.sqldelight.** { *; }

# Camera
-keep class androidx.camera.** { *; }

# Google Fonts
-keep class com.google.android.gms.** { *; }

# Share Plus
-keep class dev.fluttercommunity.plus.** { *; }

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# NTP
-keep class com.shivamkumarjha.** { *; }

# PDF / Printing
-keep class net.nfet.flutter.** { *; }

# Video Player
-keep class io.flutter.plugins.videoplayer.** { *; }

# Crypto
-keep class org.bouncycastle.** { *; }

# Play Core (R8 missing classes fix)
-dontwarn com.google.android.play.core.**
-dontwarn org.bouncycastle.**

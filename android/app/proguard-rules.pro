# Flutter ProGuard / R8 Rules for Boscdex

# Flutter Engine & Plugin bindings
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# TensorFlow Lite native libraries & JNI wrappers
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.support.** { *; }
-dontwarn org.tensorflow.lite.**

# SQLite & Drift native bindings
-keep class com.tekartik.sqflite.** { *; }
-keep class org.sqlite.** { *; }

# Hardware & Native Plugins (Camera, Geolocator, Permissions, Storage)
-keep class io.flutter.plugins.camera.** { *; }
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class com.example.imagegallerysaver.** { *; }
-keep class dev.fluttercommunity.plus.share.** { *; }

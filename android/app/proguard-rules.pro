# ProGuard rules for Surah Yaseen App
# Add project specific ProGuard rules here.

# Keep ExoPlayer classes
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Suppress ExoPlayer codec capability warnings
# These warnings are harmless - they just indicate unsupported codecs on the device
# Note: -assumenosideeffects only works when code shrinking is enabled (release builds)
# For debug builds, these warnings may still appear but they don't affect functionality

# Specifically suppress AudioCapabilities and VideoCapabilities warnings
-assumenosideeffects class com.google.android.exoplayer2.audio.AudioCapabilities {
    public static *** getCapabilities(...);
}

-assumenosideeffects class com.google.android.exoplayer2.video.VideoCapabilities {
    public static *** getCapabilities(...);
}

# Suppress warnings from ExoPlayer's MediaCodecUtil
-dontwarn com.google.android.exoplayer2.mediacodec.MediaCodecUtil

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Hive classes
-keep class hive.** { *; }
-keep class **$BookmarkAdapter { *; }

# Keep GetX classes
-keep class com.example.get.** { *; }

# Suppress warnings for missing classes (these are optional dependencies)
-dontwarn com.google.android.exoplayer2.ext.**
-dontwarn com.google.android.exoplayer2.ui.**

# Suppress AudioCapabilities and VideoCapabilities log warnings
# Filter out the specific warnings about unsupported codecs
-assumenosideeffects class android.media.MediaCodecInfo$CodecCapabilities {
    public *** getCapabilitiesForType(...);
}

# Suppress ExoPlayer capability check warnings
-dontwarn com.google.android.exoplayer2.mediacodec.MediaCodecUtil
-dontwarn com.google.android.exoplayer2.audio.AudioCapabilitiesReceiver
-dontwarn com.google.android.exoplayer2.video.VideoCapabilitiesReceiver

# Suppress warnings for Google Play Core (optional dependency for deferred components)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

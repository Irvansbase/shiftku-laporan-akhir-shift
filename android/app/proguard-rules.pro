##########################
# Flutter core & plugins
##########################
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.andriirv.laporan_akhir_shift.MainActivity { *; } 

# Tambahan penting untuk Flutter engine
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

##########################
# Google Mobile Ads (AdMob)
##########################
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**
-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}

##########################
# Reflection safety
##########################
-keepattributes Signature,InnerClasses,EnclosingMethod
-keepclassmembers class * {
    *;
}

##########################
# AndroidX dan Support Library
##########################
-keep class androidx.** { *; }
-keep class android.support.** { *; }
-dontwarn androidx.**
-dontwarn android.support.**

##########################
# Java/Kotlin runtime
##########################
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**
-keep class org.jetbrains.** { *; }
-dontwarn org.jetbrains.**

##########################
# R8/Proguard umum
##########################
-ignorewarnings
-dontobfuscate
-dontoptimize
# Agar tidak menghapus class yang punya anotasi @Keep
-keep class ** {
    @androidx.annotation.Keep *;
}

# Supabase (jika kamu pakai supabase_flutter)
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Untuk json serialization (kalau pakai)
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

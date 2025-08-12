# Razorpay ProGuard rules for R8 minification
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

# Keep ProGuard annotation classes (this fixes the missing classes error)
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# JavaScript interface for Razorpay
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-optimizations !method/inlining/*

-keepclasseswithmembers class * {
    public void onPayment*(...);
}

# Additional rules for Razorpay Flutter plugin
-keep class com.razorpay.razorpay_flutter.** { *; }

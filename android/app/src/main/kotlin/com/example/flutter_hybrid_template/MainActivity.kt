package com.example.flutter_hybrid_template

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import kotlin.system.exitProcess
import java.io.File

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 1. قفل التصوير والسكرين شوت (الأساس)
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )

        // 2. فحص الـ ADB (لو مفعل يقفل)
        if (isAdbEnabled()) { exitProcess(0) }

        // 3. فحص الـ Root (لو الجهاز متهكر يقفل)
        if (isDeviceRooted()) { exitProcess(0) }

        // 4. فحص المحاكي (لو شغال على كمبيوتر يقفل)
        if (isEmulator()) { exitProcess(0) }
    }

    // دالة فحص الـ ADB
    private fun isAdbEnabled(): Boolean {
        return Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0) == 1
    }

    // دالة فحص الـ Root (بتبحث عن ملفات النظام المخفية)
    private fun isDeviceRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk", "/sbin/su", "/system/bin/su",
            "/system/xbin/su", "/data/local/xbin/su", "/data/local/bin/su",
            "/system/sd/xbin/su", "/working/bin/su", "/system/bin/failsafe/su", "/data/local/su"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }
        return false
    }

    // دالة كشف المحاكيات (Emulators)
    private fun isEmulator(): Boolean {
        return (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk_google")
                || Build.PRODUCT.contains("google_sdk")
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("sdk_x86")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator"))
    }
}

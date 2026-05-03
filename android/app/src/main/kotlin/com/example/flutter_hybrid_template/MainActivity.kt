package com.example.flutter_hybrid_template

import android.os.Bundle
import android.view.WindowManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import kotlin.system.exitProcess

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 1. تفعيل التشفير لمنع تصوير الشاشة وتسجيل الفيديو نهائياً
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )

        // 2. الحماية ضد الـ ADB لمنع الهندسة العكسية وسحب البيانات عبر الكمبيوتر
        val adbEnabled = Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0)
        if (adbEnabled == 1) {
            // إغلاق التطبيق وطرد المستخدم فوراً إذا حاول تشغيل وضع المطورين
            exitProcess(0)
        }
    }
}

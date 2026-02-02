package com.surahyaseen.companion

import android.app.Application

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Note: ExoPlayer codec capability warnings are suppressed via:
        // 1. ProGuard rules (for release builds) - removes log statements at compile time
        // 2. These warnings are harmless - they just indicate unsupported codecs on the device
        // 3. They don't affect app functionality - ExoPlayer will use supported codecs automatically
    }
}

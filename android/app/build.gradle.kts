plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.surah_yaseen"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8 // Set to Java 1.8
        targetCompatibility = JavaVersion.VERSION_1_8 // Set to Java 1.8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString() // Set JVM target to Java 1.8
    }

    defaultConfig {
        applicationId = "com.example.surah_yaseen"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Enable core library desugaring here
    compileOptions {
        isCoreLibraryDesugaringEnabled = true // Correct Kotlin DSL syntax
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.10.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // Correct Kotlin DSL syntax
}

flutter {
    source = "../.."
}

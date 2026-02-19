import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val keystorePropertiesAvailable = keystorePropertiesFile.exists().also {
    if (it) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    namespace = "com.amarhumayun.surahyaseen"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8 // Set to Java 1.8
        targetCompatibility = JavaVersion.VERSION_1_8 // Set to Java 1.8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString() // Set JVM target to Java 1.8
    }

    defaultConfig {
        applicationId = "com.amarhumayun.surahyaseen"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesAvailable) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now,
            // so `flutter run --release` works.
            if (keystorePropertiesAvailable) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
            
            // ProGuard rules for suppressing ExoPlayer warnings
            // R8 is enabled by default in Flutter release builds
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
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
    
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
    
    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}

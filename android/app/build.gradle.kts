import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
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
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"])
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now,
            // so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
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

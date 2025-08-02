plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // ➕ Plugin Flutter
    id("com.google.gms.google-services")    // ✅ Firebase
}

android {
    namespace = "com.academia.fitapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.academia.fitapp"
        minSdk = 23 // 🔧 Firebase exige minSdk >= 19
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // 🔑 Assinatura (use releaseConfig em produção)
            signingConfig = signingConfigs.getByName("debug")

            // 🔧 Minify ativo para shrinking de código (sem shrinkResources no Kotlin DSL)
            isMinifyEnabled = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ BoM (Bill of Materials): controla todas as versões do Firebase
    implementation(platform("com.google.firebase:firebase-bom:34.0.0"))

    // Core do Firebase (comum)
    implementation("com.google.firebase:firebase-common")

    // Firestore (banco de dados em nuvem)
    implementation("com.google.firebase:firebase-firestore")

    // Firebase Auth (opcional)
    implementation("com.google.firebase:firebase-auth")

    // Firebase Analytics (opcional)
    // implementation("com.google.firebase:firebase-analytics")
}

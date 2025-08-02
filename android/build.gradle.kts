// 🔧 BuildScript: inclui o plugin Google Services (Firebase)
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Última versão estável do Google Services
        classpath("com.google.gms:google-services:4.3.15")
    }
}

// 🔧 Repositórios globais para todos os módulos
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}2

// 🔧 Ajusta o diretório de build para sair da pasta android/
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// 🔧 Garante que o projeto app seja avaliado antes dos outros
subprojects {
    project.evaluationDependsOn(":app")
}

// 🔧 Task clean (limpa a pasta de build global)
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {
    val subprojectBuildDir = rootBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)
    
    project.evaluationDependsOn(":app")

    // Force outdated plugins to use SDK 36 using modern AGP 9 APIs
    project.pluginManager.withPlugin("com.android.library") {
        val androidExt = project.extensions.findByName("android") as? com.android.build.api.dsl.LibraryExtension
        androidExt?.compileSdk = 36
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
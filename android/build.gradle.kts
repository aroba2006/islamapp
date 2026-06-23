allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootBuildDir = java.io.File(rootProject.projectDir, "../build")
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {
    project.layout.buildDirectory.set(java.io.File(rootBuildDir, project.name))
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
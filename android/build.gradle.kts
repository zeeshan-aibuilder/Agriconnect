allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
// YEH NAYA CODE PICHLE WALE KI JAGAH PASTE KAREIN
subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
    // Yeh line har plugin ko uski package name ke taur par namespace de degi
    project.extensions.extraProperties.set("android.namespace", project.group.toString())
}
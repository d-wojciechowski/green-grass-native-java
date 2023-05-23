plugins {
    kotlin("jvm") version "1.8.21"
    id("org.graalvm.buildtools.native") version "0.9.22"
    id("com.adarshr.test-logger") version "3.2.0"

    application
}

group = "com.dwojciechowski"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
    implementation("com.amazonaws:aws-java-sdk-greengrassv2:1.12.472")
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(17)
}

application {
    mainClass.set("com.dwojciechowski.MainKt")
}

graalvmNative {
    testSupport.set(false) // Testing in native mode in addition to JVM mode is a little bit too much for me.

    binaries {
        named("main") {
            imageName.set("application")
        }
    }
}
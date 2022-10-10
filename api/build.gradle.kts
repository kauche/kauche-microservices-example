plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.apollographql.apollo3").version("3.6.2")
}

android {
    compileSdk = 32
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

apollo {
    service("customer-graphql") {
        srcDir("platform/customer/graphql")
        packageName.set("com.kauche.api.platform.customer.graphql")
        generateKotlinModels.set(true)
  }
}

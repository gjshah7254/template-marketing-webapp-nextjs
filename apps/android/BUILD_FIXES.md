# Android Build Fixes

## Issues Fixed

1. **Updated Android Gradle Plugin**: Updated from 8.1.0 to 8.2.2 to resolve compatibility warnings
2. **Updated Kotlin Version**: Updated from 1.9.0 to 1.9.22
3. **Replaced Contentful Java SDK with GraphQL API**: Removed problematic Java SDK dependency and implemented Contentful GraphQL API directly using Retrofit
4. **Added Gradle Wrapper**: Created gradle-wrapper.properties with Gradle 8.2
5. **Fixed Coroutine Usage**: Wrapped API calls in `withContext(Dispatchers.IO)` for proper threading
6. **Removed Unused Plugin**: Removed `kotlin-kapt` plugin that wasn't being used
7. **Added JitPack Repository**: Added to settings.gradle.kts for additional dependency sources

## If Build Still Fails

If you still encounter dependency resolution errors:

1. **Check Contentful SDK Version**: The Contentful Java SDK version might need to be updated. Check available versions at:
   - Maven Central: https://mvnrepository.com/artifact/com.contentful.java/java-sdk

2. **Try Alternative Approach**: If the Contentful SDK continues to have issues, you can:
   - Use Contentful's GraphQL API directly with Retrofit
   - Use Contentful's REST API with Retrofit
   - Check for a newer version of the SDK

3. **Verify Network Access**: Ensure your build environment can access:
   - Maven Central (https://repo1.maven.org/maven2/)
   - Google Maven (https://maven.google.com/)
   - JitPack (https://jitpack.io)

4. **Clean Build**:
   ```bash
   cd apps/android
   ./gradlew clean
   ./gradlew build --refresh-dependencies
   ```

5. **Check local.properties**: Ensure your `local.properties` file exists and has the correct Android SDK path:
   ```properties
   sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
   ```

## Alternative: Use GraphQL API Directly

If the Contentful Java SDK continues to cause issues, you can use Contentful's GraphQL API directly:

```kotlin
// Add to build.gradle.kts dependencies:
implementation("com.squareup.retrofit2:retrofit:2.9.0")
implementation("com.squareup.retrofit2:converter-gson:2.9.0")

// Then create a GraphQL service interface
interface ContentfulGraphQLService {
    @POST("content/v1/spaces/{spaceId}")
    suspend fun query(
        @Path("spaceId") spaceId: String,
        @Body query: GraphQLQuery
    ): Response<GraphQLResponse>
}
```

This approach gives you more control and avoids SDK dependency issues.


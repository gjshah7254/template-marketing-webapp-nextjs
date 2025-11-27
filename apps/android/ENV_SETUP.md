# Android Environment Variables Setup

## Contentful Configuration

The Android app requires Contentful credentials to fetch content. You can configure them in one of the following ways:

### Option 1: gradle.properties (Recommended)

Edit `apps/android/gradle.properties` and replace the placeholder values:

```properties
CONTENTFUL_SPACE_ID=your_actual_space_id
CONTENTFUL_ACCESS_TOKEN=your_actual_access_token
CONTENTFUL_PREVIEW_ACCESS_TOKEN=your_actual_preview_token
```

**Pros:**
- Simple and straightforward
- Works immediately after sync

**Cons:**
- Values are in version control (use Option 2 for sensitive projects)

### Option 2: local.properties (Recommended for Teams)

1. Copy the example file:
   ```bash
   cp apps/android/local.properties.example apps/android/local.properties
   ```

2. Edit `apps/android/local.properties` and add your credentials:
   ```properties
   sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
   CONTENTFUL_SPACE_ID=your_actual_space_id
   CONTENTFUL_ACCESS_TOKEN=your_actual_access_token
   CONTENTFUL_PREVIEW_ACCESS_TOKEN=your_actual_preview_token
   ```

**Pros:**
- Not committed to version control (git-ignored)
- Safe for team projects
- Each developer can have their own credentials

**Cons:**
- Each developer needs to create their own file

### Option 3: .env File

1. Copy the example file:
   ```bash
   cp apps/android/.env.example apps/android/.env
   ```

2. Edit `.env` and add your credentials

**Note:** Android doesn't natively support .env files. You would need to:
- Use a Gradle plugin to load .env files, OR
- Manually copy values to gradle.properties or local.properties

## Getting Your Contentful Credentials

1. **Space ID**: 
   - Go to your Contentful space
   - Settings → General Settings
   - Copy the Space ID

2. **Access Token (Delivery API)**:
   - Settings → API keys
   - Create or use an existing Content Delivery API key
   - Copy the Access token

3. **Preview Token (Preview API)**:
   - Settings → API keys
   - Create or use an existing Content Preview API key
   - Copy the Access token

## Verification

After setting up credentials:

1. Sync Gradle: File → Sync Project with Gradle Files
2. Build the app: Build → Make Project
3. Run the app: The app should now fetch content from Contentful

If you see errors, check:
- Credentials are correct (no extra spaces)
- Space ID matches your Contentful space
- Access token has the correct permissions
- Check Logcat for detailed error messages


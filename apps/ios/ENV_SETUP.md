# iOS Environment Variables Setup

## Contentful Configuration

The iOS app requires Contentful credentials to fetch content. You can configure them in one of the following ways:

### Option 1: Xcode Scheme Environment Variables (Recommended for Development)

1. In Xcode, select your app scheme (next to the device selector)
2. Click "Edit Scheme..."
3. Select "Run" in the left sidebar
4. Go to the "Arguments" tab
5. Under "Environment Variables", click the "+" button
6. Add these variables:

   | Name | Value |
   |------|-------|
   | `CONTENTFUL_SPACE_ID` | `your_actual_space_id` |
   | `CONTENTFUL_DELIVERY_ACCESS_TOKEN` | `your_actual_access_token` |

**Pros:**
- Easy to set up
- Different values for Debug/Release
- Not committed to version control

**Cons:**
- Only works in Xcode
- Each developer needs to configure their own scheme

### Option 2: Config.xcconfig (Recommended for Production)

1. Copy the example file:
   ```bash
   cp apps/ios/Config.xcconfig.example apps/ios/Config.xcconfig
   ```

2. Edit `Config.xcconfig` and add your actual credentials:
   ```
   CONTENTFUL_SPACE_ID = your_actual_space_id
   CONTENTFUL_DELIVERY_ACCESS_TOKEN = your_actual_access_token
   ```

3. In Xcode:
   - Select your project in the navigator
   - Select your target
   - Go to "Build Settings"
   - Search for "xcconfig"
   - Add `Config.xcconfig` to your configuration

**Pros:**
- Works with CI/CD
- Can be version controlled (if not sensitive)
- Consistent across team

**Cons:**
- Requires Xcode project setup
- More complex initial setup

### Option 3: Info.plist (Alternative)

You can also add environment variables to Info.plist, but this is less secure and not recommended for production.

## Getting Your Contentful Credentials

1. **Space ID**: 
   - Go to your Contentful space
   - Settings → General Settings
   - Copy the Space ID

2. **Access Token (Delivery API)**:
   - Settings → API keys
   - Create or use an existing Content Delivery API key
   - Copy the Access token
   
   **Note**: This app uses only the Content Delivery API (CDA) for production content.

## Verification

After setting up credentials:

1. Clean build folder: Product → Clean Build Folder (⇧⌘K)
2. Build the app: Product → Build (⌘B)
3. Run the app: Product → Run (⌘R)
4. The app should now fetch content from Contentful

If you see errors, check:
- Credentials are correct (no extra spaces)
- Space ID matches your Contentful space
- Access token has the correct permissions
- Check Xcode console for detailed error messages

## Security Note

⚠️ **Important**: Never commit actual credentials to version control. Use `.gitignore` to exclude:
- `Config.xcconfig` (if it contains real credentials)
- Any files with actual API keys

The example files (`.env.example`, `Config.xcconfig.example`) are safe to commit as they contain placeholder values.


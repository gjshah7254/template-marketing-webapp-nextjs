# Android App Troubleshooting

## White Screen Issue

If you're seeing a white screen, it's most likely because **Contentful credentials are not configured**.

### Quick Fix

1. **Open `apps/android/gradle.properties`** (or create `local.properties`)

2. **Add your Contentful credentials**:
   ```properties
   CONTENTFUL_SPACE_ID=your_space_id_here
   CONTENTFUL_DELIVERY_ACCESS_TOKEN=your_access_token_here
   ENVIRONMENT_NAME=master
   ```

3. **Sync Gradle** in Android Studio (File → Sync Project with Gradle Files)

4. **Rebuild and run** the app

### What You Should See

After configuring credentials, you should see one of these:

1. **Loading Indicator** - While fetching content from Contentful
2. **Error Message** - If credentials are invalid or API call fails
3. **Content** - Your marketing content from Contentful
4. **"No Content Available"** - If no page data is returned (with retry button)

### Debugging

If you still see a white screen:

1. **Check Logcat** in Android Studio:
   - View → Tool Windows → Logcat
   - Filter by "HomeScreen" or "ContentfulService"
   - Look for error messages

2. **Verify Credentials**:
   - Make sure `CONTENTFUL_SPACE_ID` and `CONTENTFUL_DELIVERY_ACCESS_TOKEN` are set
   - They should NOT be empty strings
   - Check that they're correct in your Contentful dashboard

3. **Check Network**:
   - Ensure the emulator/device has internet access
   - Check if Contentful API is accessible

4. **Test API Manually**:
   ```bash
   curl -X POST https://graphql.contentful.com/content/v1/spaces/YOUR_SPACE_ID \
     -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"query":"{ pageCollection(where: { slug: \"home\" }, limit: 1) { items { slug } } }"}'
   ```

### Common Issues

1. **Empty Credentials**: Most common cause - credentials are empty strings
2. **Wrong Space ID**: Double-check your Space ID in Contentful
3. **Invalid Token**: Make sure you're using the Delivery API token, not Management API token
4. **No "home" Page**: Make sure you have a page with slug "home" in Contentful
5. **Network Issues**: Emulator might not have internet access

### Expected Behavior

- **With Valid Credentials**: App loads → Shows loading indicator → Displays content or error
- **Without Credentials**: App loads → Shows "No Content Available" message with retry button
- **With Invalid Credentials**: App loads → Shows error message with details


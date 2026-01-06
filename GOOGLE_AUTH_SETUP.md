# Google Authentication Setup Guide

This guide will help you set up Google OAuth authentication for your TaskHub app.

## Prerequisites

- A Supabase project (already set up)
- A Google Cloud Console account

## Step 1: Configure Google OAuth in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to **APIs & Services** > **Credentials**
4. Click **Create Credentials** > **OAuth client ID**
5. If prompted, configure the OAuth consent screen:
   - Choose **External** user type
   - Fill in the required information (App name, User support email, Developer contact)
   - Add scopes: `email`, `profile`, `openid`
   - Add test users if needed
6. Create OAuth client ID:
   - Application type: **Web application**
   - Name: `TaskHub Web Client`
   - Authorized redirect URIs:
     - Add your Supabase project's redirect URL: `https://[YOUR_PROJECT_REF].supabase.co/auth/v1/callback`
     - You can find this in your Supabase project settings under Authentication > URL Configuration
7. Save the **Client ID** and **Client Secret**

## Step 2: Configure Google Provider in Supabase

1. Go to your Supabase project dashboard
2. Navigate to **Authentication** > **Providers**
3. Find **Google** in the list and click to enable it
4. Enter the **Client ID** and **Client Secret** from Google Cloud Console
5. Save the configuration

## Step 3: Configure Redirect URLs in Supabase

1. In Supabase, go to **Authentication** > **URL Configuration**
2. Add the following to **Redirect URLs**:
   - `io.supabase.taskhub://login-callback/` (for mobile app deep linking)
   - `https://[YOUR_PROJECT_REF].supabase.co/auth/v1/callback` (for web)

## Step 4: Test the Integration

1. Run your Flutter app
2. On the login or signup screen, tap the **Google** button
3. You should be redirected to Google's sign-in page
4. After signing in, you'll be redirected back to the app
5. The app should automatically navigate to the dashboard

## Troubleshooting

### Issue: "Failed to sign in with Google"

- **Solution**: Verify that Google OAuth is enabled in Supabase and the credentials are correct
- Check that the redirect URL matches exactly in both Google Cloud Console and Supabase

### Issue: App doesn't redirect back after Google sign-in

- **Solution**:
  - Verify the deep link is configured in `AndroidManifest.xml`
  - Check that the redirect URL in Supabase includes `io.supabase.taskhub://login-callback/`
  - For iOS, you'll need to configure URL schemes in `Info.plist`

### Issue: "Terms and Conditions" button disabled on signup

- **Solution**: This is intentional - users must accept terms before using Google sign-up. Make sure the checkbox is checked.

## Notes

- The Google sign-up button on the signup screen is disabled until the user accepts the Terms & Conditions
- The app uses deep linking (`io.supabase.taskhub://login-callback/`) to handle OAuth callbacks
- For production, make sure to configure the OAuth consent screen properly and publish it if needed

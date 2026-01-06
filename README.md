# TaskHub - Personal Task Tracker

<div align="center">

![TaskHub Logo](assets/images/icon_with_text.png)

**A modern Flutter application for managing personal tasks with Supabase authentication and backend**

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10.4+-0175C2?logo=dart)](https://dart.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-2.5.0-3ECF8E?logo=supabase)](https://supabase.com/)

</div>

## 📱 Overview

TaskHub is a beautiful, modern task management application built with Flutter and Supabase. It provides a seamless experience for users to create, manage, and track their tasks with a clean, intuitive interface designed according to Figma specifications.

### Key Highlights

- ✨ **Modern UI/UX** - Designed with attention to detail, matching Figma specifications
- 🔐 **Secure Authentication** - Email/password and Google OAuth sign-in
- 📊 **Real-time State Management** - Powered by Provider
- 🎨 **Custom Theme** - Consistent color palette and typography
- 🚀 **Smooth Animations** - Enhanced user experience with flutter_animate
- ✅ **Full CRUD Operations** - Create, read, update, and delete tasks
- 🧪 **Tested** - Unit tests for core functionality

## 🎯 Features

### ✅ Core Features (100% Complete)

#### Authentication

- **Email/Password Authentication** - Secure sign-up and sign-in via Supabase
- **Google OAuth Sign-In** - One-click authentication with Google (in-app webview)
- **Session Management** - Automatic session handling and persistence
- **Protected Routes** - Automatic redirect to login if not authenticated
- **Email Verification** - Support for email confirmation flow
- **Terms & Conditions** - Custom animated checkbox with terms acceptance

#### Task Management

- **Task List View** - Display all user tasks with title and status
- **Add New Tasks** - Dialog-based task creation with title and optional description
- **Edit Tasks** - Full editing capability via Task Details screen
- **Delete Tasks** - Swipe-to-delete gesture with confirmation
- **Toggle Completion** - Mark tasks as pending or completed
- **Task Details** - View and edit individual task information
- **Pull-to-Refresh** - Refresh task list with pull gesture
- **Empty State** - User-friendly empty state when no tasks exist

#### User Experience

- **Splash Screen** - Branded welcome screen with custom typography
- **Responsive Design** - Works seamlessly across different screen sizes
- **Loading States** - Visual feedback during async operations
- **Error Handling** - User-friendly error messages with color coding
- **Animations** - Smooth transitions and micro-interactions
- **Custom Widgets** - Reusable components (buttons, checkboxes, tiles)

### 🎁 Bonus Features

#### ✅ Completed

- **Task Editing** - Full edit functionality in Task Details screen

#### 🚧 Planned (Feature Drop Branch)

The following features will be implemented in a separate `feature-drop` branch:

- **Real-time Updates** - Supabase Realtime integration for live task synchronization
- **Dark Theme Toggle** - Light/dark theme switching functionality

> **Note**: The `feature-drop` branch will contain these additional features. Current implementation focuses on core functionality with 100% feature completion.

## 📸 Screenshots

> **Note**: Screenshots will be added here. Please provide screenshots of the following screens:

### Splash Screen

<!-- Add screenshot: assets/screenshots/splash_screen.png -->

![Splash Screen](assets/screenshots/splash_screen.png)

_Initial welcome screen with app branding and "Let's Start" button_

### Login Screen

<!-- Add screenshot: assets/screenshots/login_screen.png -->

![Login Screen](assets/screenshots/login_screen.png)

_User authentication screen with email/password fields and Google sign-in option_

### Sign Up Screen

<!-- Add screenshot: assets/screenshots/signup_screen.png -->

![Sign Up Screen](assets/screenshots/signup_screen.png)

_Registration screen with name, email, password fields, terms acceptance, and Google sign-up_

### Dashboard Screen

<!-- Add screenshot: assets/screenshots/dashboard_screen.png -->

![Dashboard Screen](assets/screenshots/dashboard_screen.png)

_Main task list view showing tasks with status indicators and floating action button_

### Task Details Screen

<!-- Add screenshot: assets/screenshots/task_details_screen.png -->

![Task Details Screen](assets/screenshots/task_details_screen.png)

_Individual task view with edit capability, status toggle, and delete option_

### Add Task Dialog

<!-- Add screenshot: assets/screenshots/add_task_dialog.png -->

![Add Task Dialog](assets/screenshots/add_task_dialog.png)

_Dialog for creating new tasks with title and description fields_

### Empty State

<!-- Add screenshot: assets/screenshots/empty_state.png -->

![Empty State](assets/screenshots/empty_state.png)

_Empty state shown when user has no tasks_

## 🛠️ Technology Stack

### Frontend

- **Flutter** (3.10.4+) - Cross-platform mobile framework
- **Dart** (3.10.4+) - Programming language
- **Provider** (6.1.1) - State management
- **flutter_animate** (4.5.0) - Animation library
- **google_fonts** (6.2.1) - Custom typography (Inter & Pilat Extended)

### Backend

- **Supabase** (2.5.0) - Backend-as-a-Service
  - Authentication (Email/Password + OAuth)
  - PostgreSQL Database
  - Row Level Security (RLS)

### Development Tools

- **Flutter Lints** (6.0.0) - Code quality and linting

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.10.4 or higher)
- **Dart SDK** (comes with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control
- **A Supabase account** and project

### System Requirements

- **Android**: Android SDK (API level 21+)
- **iOS**: Xcode 14+ (for iOS development)
- **Development**: Android Studio / VS Code

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd TaskHub/taskhub
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Supabase Setup

**📖 For detailed step-by-step instructions, see [SUPABASE_SETUP.md](SUPABASE_SETUP.md)**

#### Quick Setup Summary:

1. **Create the Tasks Table**

   - Go to Supabase Dashboard → SQL Editor
   - Run the SQL script from `SUPABASE_SETUP.md`
   - Or use the Table Editor to create the table manually

2. **Enable Row Level Security (RLS)**

   - Navigate to Authentication → Policies
   - Enable RLS on the `tasks` table

3. **Create RLS Policies**

   - Create 4 policies: SELECT, INSERT, UPDATE, DELETE
   - Policy condition: `auth.uid() = user_id`
   - This ensures users can only access their own tasks

4. **Configure Authentication**
   - Enable Email provider in Authentication → Providers
   - For Google Sign-In, see [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md)

**Note**: Supabase credentials are already configured in `lib/main.dart`. You only need to set up the database table and policies.

### 4. Run the App

```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For a specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

## 📁 Project Structure

```
taskhub/
├── lib/
│   ├── main.dart                    # App entry point & initialization
│   ├── app/
│   │   └── theme.dart               # App theme & color palette
│   ├── auth/
│   │   ├── auth_service.dart        # Authentication service (Provider)
│   │   ├── login_screen.dart        # Sign in screen
│   │   └── signup_screen.dart       # Sign up screen
│   ├── dashboard/
│   │   ├── dashboard_screen.dart    # Main task list screen
│   │   ├── task_details_screen.dart # Task detail/edit screen
│   │   ├── task_tile.dart           # Reusable task list item widget
│   │   ├── task_model.dart          # Task data model
│   │   ├── task_provider.dart       # Task state management (Provider)
│   │   └── add_task_dialog.dart     # Add task dialog
│   ├── services/
│   │   └── supabase_service.dart    # Supabase client & database methods
│   ├── utils/
│   │   └── validators.dart          # Form validation utilities
│   ├── widgets/
│   │   ├── custom_button.dart       # Reusable button widget
│   │   ├── custom_checkbox.dart     # Custom animated checkbox
│   │   └── loading_indicator.dart  # Loading indicator widget
│   └── splash/
│       └── splash_screen.dart       # Splash/loading screen
├── assets/
│   ├── images/                      # App images & icons
│   │   ├── icon_with_text.png      # App logo
│   │   ├── splash_image.png        # Splash illustration
│   │   └── google.png              # Google logo
│   └── fonts/                       # Custom fonts
│       ├── PilatExtended-Regular.ttf
│       └── PilatExtended-Bold.ttf
├── test/
│   ├── task_model_test.dart        # Task model unit tests
│   └── widget_test.dart            # Widget tests
├── android/                         # Android platform files
├── ios/                             # iOS platform files
├── pubspec.yaml                     # Dependencies & assets
├── README.md                        # This file
├── SUPABASE_SETUP.md                # Supabase setup guide
└── GOOGLE_AUTH_SETUP.md            # Google OAuth setup guide
```

## 🎨 Design System

### Color Palette

The app uses a carefully curated color palette matching Figma specifications:

- **Page Background**: `#212832` - Dark background for all screens
- **Input Field Background**: `#455A64` - Input fields and cards
- **Text Dark Color**: `#8CAAB9` - Secondary text and labels
- **Text White Color**: `#FFFFFF` - Primary text
- **Text Black Color**: `#000000` - Text on buttons
- **Button Background**: `#FED36A` - App yellow for buttons and accents
- **Error Color**: `#FF5252` - Standard red for error states

### Typography

- **Splash Screen**: Pilat Extended (custom font)
- **All Other Screens**: Inter (via Google Fonts)

### UI Components

- **Buttons**: Square corners, yellow background, black text
- **Input Fields**: Square corners, dark background, white text
- **Cards**: Dark background matching input fields
- **Checkboxes**: Custom animated checkbox with yellow border

## 🔄 Hot Reload vs Hot Restart

### Hot Reload (⚡)

**What it does:**

- Quickly updates the UI without losing the current app state
- Preserves variables, form inputs, and scroll positions
- Typically takes 1-2 seconds

**When to use:**

- Making UI changes (colors, text, layout)
- Modifying widget build methods
- Adjusting styling and theming
- Most code changes that don't affect app initialization

**How to trigger:**

- Press `r` in the terminal where `flutter run` is active
- Click the hot reload button in your IDE
- Save the file (if auto-save is enabled)

**Example scenario:**
You change a button's color from blue to red. Hot reload will immediately show the red button without resetting the form you're filling.

### Hot Restart (🔄)

**What it does:**

- Completely restarts the app from scratch
- Resets all app state (variables, form inputs, etc.)
- Re-runs `main()` function
- Takes longer than hot reload (5-10 seconds)

**When to use:**

- Adding or removing dependencies
- Modifying `main()` function
- Changing app initialization code
- Adding new routes or navigation changes
- When hot reload doesn't work or causes issues

**How to trigger:**

- Press `R` (capital R) in the terminal
- Click the hot restart button in your IDE
- Stop and restart the app manually

**Example scenario:**
You add a new package to `pubspec.yaml` and run `flutter pub get`. You need to hot restart to load the new package.

### Quick Reference

| Change Type        | Use            |
| ------------------ | -------------- |
| UI styling         | Hot Reload ⚡  |
| Widget layout      | Hot Reload ⚡  |
| Business logic     | Hot Reload ⚡  |
| `main()` function  | Hot Restart 🔄 |
| Dependencies       | Hot Restart 🔄 |
| App initialization | Hot Restart 🔄 |
| Navigation setup   | Hot Restart 🔄 |

**Tip:** Always try hot reload first. If it doesn't work or the app behaves unexpectedly, use hot restart.

## 🧠 State Management

This app uses **Provider** for state management:

- **AuthService**: Manages authentication state (login, signup, logout, Google OAuth)
- **TaskProvider**: Manages task list state (CRUD operations)

Both services extend `ChangeNotifier` and notify listeners when state changes, ensuring the UI stays in sync with the data.

### State Flow

```
User Action → Service Method → Supabase API → State Update → UI Refresh
```

## 🧪 Testing

Run the test suite:

```bash
flutter test
```

### Test Coverage

The project includes comprehensive tests for the Task model:

- ✅ Task creation from JSON
- ✅ Task conversion to JSON
- ✅ Task copyWith functionality
- ✅ Task completion status logic
- ✅ Null description handling

**Test File**: `test/task_model_test.dart`

## 📦 Dependencies

### Production Dependencies

- **supabase_flutter** (^2.5.0) - Backend and authentication
- **provider** (^6.1.1) - State management
- **flutter_animate** (^4.5.0) - Smooth animations
- **google_fonts** (^6.2.1) - Custom typography

### Development Dependencies

- **flutter_test** - Testing framework
- **flutter_lints** (^6.0.0) - Code quality and linting

## 🔧 Troubleshooting

### Supabase Connection Issues

- Verify your Supabase URL and anon key are correct in `lib/main.dart`
- Check that RLS policies are properly configured
- Ensure the `tasks` table exists and has the correct schema
- See [SUPABASE_SETUP.md](SUPABASE_SETUP.md) for detailed setup

### Authentication Not Working

- Verify email/password provider is enabled in Supabase Dashboard
- Check Supabase logs for error messages
- Ensure RLS policies allow user access
- For Google Sign-In issues, see [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md)

### Tasks Not Loading

- Check that the `tasks` table exists in Supabase
- Verify RLS policies allow SELECT operations
- Check Supabase logs for database errors
- Ensure user is properly authenticated

### Google Sign-In Issues

- Verify Google OAuth is enabled in Supabase
- Check that redirect URL is configured in Supabase dashboard
- Ensure deep link is properly configured in AndroidManifest.xml
- See [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md) for detailed setup

### Build Issues

- Run `flutter clean` and then `flutter pub get`
- Ensure all dependencies are compatible
- Check Flutter and Dart SDK versions match requirements

## 🌿 Feature Drop Branch

A separate `feature-drop` branch will contain the following bonus features:

### Planned Features

1. **Real-time Updates (Supabase Realtime)**

   - Live task synchronization across devices
   - Automatic UI updates when tasks change
   - WebSocket-based real-time subscriptions

2. **Dark Theme Toggle**
   - Light/dark theme switching
   - Theme persistence across app sessions
   - System theme detection

### Current Status

- ✅ **Task Editing** - Already implemented in main branch
- 🚧 **Real-time Updates** - Planned for feature-drop branch
- 🚧 **Dark Theme Toggle** - Planned for feature-drop branch

To work on these features:

```bash
# Create and switch to feature-drop branch
git checkout -b feature-drop

# Work on features...

# Merge back when ready
git checkout main
git merge feature-drop
```

## 📄 License

This project is created for educational purposes.

## 🤝 Contributing

This is an assignment/learning project. Contributions are welcome for learning purposes.

### Contribution Guidelines

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Additional Resources

### Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [flutter_animate Package](https://pub.dev/packages/flutter_animate)

### Setup Guides

- [SUPABASE_SETUP.md](SUPABASE_SETUP.md) - Detailed Supabase database setup
- [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md) - Google OAuth configuration

## 🎯 Project Status

### Implementation Status

- ✅ **Core Features**: 100% Complete
- ✅ **Required Features**: All implemented
- 🎁 **Bonus Features**: 1/3 complete (Task editing done)

### What's Working

- ✅ Email/Password authentication
- ✅ Google OAuth sign-in/sign-up
- ✅ Task CRUD operations
- ✅ Task editing
- ✅ Swipe-to-delete
- ✅ Task completion toggle
- ✅ Pull-to-refresh
- ✅ Empty state handling
- ✅ Error handling
- ✅ Loading states
- ✅ Animations
- ✅ Custom widgets
- ✅ Unit tests

### What's Coming (Feature Drop Branch)

- 🚧 Real-time task updates
- 🚧 Dark theme toggle

## 📞 Support

For issues or questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review setup guides: [SUPABASE_SETUP.md](SUPABASE_SETUP.md), [GOOGLE_AUTH_SETUP.md](GOOGLE_AUTH_SETUP.md)
3. Refer to official documentation links above

---

<div align="center">

**Built with ❤️ using Flutter and Supabase**

[Report Bug](https://github.com/yourusername/TaskHub/issues) · [Request Feature](https://github.com/yourusername/TaskHub/issues)

</div>

# Hancord App

Hancord is a Flutter application for discovering and booking home services (e.g. cleaning, plumbing, etc.).  
It includes authentication, a modern home dashboard, rich service listings with coupons and wallet balance, and optional Supabase‑backed cart persistence.

## Overview of What’s Implemented

- **Authentication**
  - Phone number + OTP flow (send and verify OTP).
  - Google sign‑in.
  - Current user loading and sign‑out use cases.
  - Centralized auth state management in `lib/features/auth/presentation/providers`.

- **Home & Navigation**
  - Bottom navigation handling via `home_navigation_provider`.
  - Home screen sections:
    - **Banners** and promotional content.
    - **Search bar** for quickly finding services.
    - **Available services** and **cleaning services** sections.
  - Reusable widgets for service cards and home UI.

- **Services & Cart**
  - Service domain models and dummy data in `lib/features/services`.
  - Category chips, coupon code input, custom painters, and a detailed services listing UI.
  - Wallet balance info and grand total card.
  - Cart persistence via Supabase (optional, falls back to in‑memory state if not configured).

- **Architecture**
  - Layered feature structure: `core` (constants, network, utils, errors) and `features` (auth, home, profile, services).
  - Domain layer with entities, repositories, and use cases for auth and services.
  - Presentation layer powered by providers (state management) and widgets/screens.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Providers (in `lib/features/**/presentation/providers`)
- **Backend / Persistence**: Supabase (for cart), plus local/in‑memory state
- **Platforms**: Android, iOS, Web, Desktop (standard Flutter targets)

## Project Structure (High Level)

- `lib/main.dart` – App entry point and global configuration.
- `lib/core/` – Shared code:
  - `constants/` – App‑wide constants and theming helpers.
  - `errors/` – Failure classes and error handling.
  - `network/` – Supabase client and other networking utilities.
  - `utils/` – Common utilities, formatters, helpers.
- `lib/features/auth/` – Authentication domain, data, and presentation (login, OTP, Google, auth state).
- `lib/features/home/` – Home screen UI, navigation, and sections (banner, search, services, bottom nav).
- `lib/features/profile/` – User profile related screens and logic.
- `lib/features/services/` – Service entities, dummy data, providers, and service listing/cart UI.

## Supabase Setup (Cart Persistence)

The app supports Supabase‑backed cart persistence.  
You can run the app without Supabase (cart will be in‑memory only), but to enable persistence:

- **Follow the detailed steps in** `SUPABASE_SETUP.md`:
  - Create a Supabase project.
  - Configure the Supabase URL and anon key in `lib/core/network/supabase_client.dart`.
  - Create the `cart_items` (and optional `services`) tables and policies.

Once configured correctly, cart items for logged‑in users will be stored remotely and loaded across sessions.

## Getting Started (Local Development)

- **Prerequisites**
  - Flutter SDK installed and configured.
  - Dart SDK (bundled with Flutter).
  - Android Studio / Xcode / VS Code (or your preferred editor).

- **Install dependencies**
  ```bash
  flutter pub get
  ```

- **Run the app**
  ```bash
  flutter run
  ```

You can target Android, iOS (on macOS), web, or desktop depending on your Flutter setup.

## Auth Flows Implemented

- **Phone OTP Login**
  - Enter phone number.
  - Request OTP (send OTP use case).
  - Verify received OTP (verify OTP use case).
  - On success, the user is logged in and the home screen is shown.

- **Google Sign‑In**
  - Login via Google account.
  - User session persisted according to the auth repository implementation.

- **Sign‑Out**
  - Clear user session and return to the appropriate unauthenticated flow.

## Notes for Contributors

- Keep new code aligned with the existing feature‑based structure.
- Add new services or features under the appropriate `lib/features/**` folder.
- When adding new backend integrations, put shared logic under `lib/core/network` or `lib/core/utils` and expose them cleanly to the feature layers.


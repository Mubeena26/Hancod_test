# Supabase Setup Guide

This app uses Supabase for cart persistence. Follow these steps to set up Supabase:

## 1. Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Create a new project
4. Wait for the project to be fully initialized

## 2. Get Your Supabase Credentials

1. In your Supabase project dashboard, go to **Settings** > **API**
2. Copy your **Project URL** and **anon/public key**

## 3. Update the Supabase Configuration

Open `lib/core/network/supabase_client.dart` and replace:

```dart
url: 'YOUR_SUPABASE_URL', // Replace with your Supabase project URL
anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase anon key
```

With your actual credentials:

```dart
url: 'https://your-project-id.supabase.co',
anonKey: 'your-anon-key-here',
```

## 4. Create the Database Tables

Run this SQL in your Supabase SQL Editor:

```sql
-- Create cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  service_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  UNIQUE(user_id, service_id)
);

-- Create services table (optional, if you want to store services in Supabase)
CREATE TABLE IF NOT EXISTS services (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image TEXT,
  duration TEXT,
  rating DECIMAL(3, 1),
  order_count INTEGER DEFAULT 0,
  category TEXT
);

-- Enable Row Level Security (RLS)
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only see their own cart items
CREATE POLICY "Users can view own cart items"
  ON cart_items FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy: Users can insert their own cart items
CREATE POLICY "Users can insert own cart items"
  ON cart_items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy: Users can update their own cart items
CREATE POLICY "Users can update own cart items"
  ON cart_items FOR UPDATE
  USING (auth.uid() = user_id);

-- Create policy: Users can delete their own cart items
CREATE POLICY "Users can delete own cart items"
  ON cart_items FOR DELETE
  USING (auth.uid() = user_id);
```

## 5. Test the Setup

1. Run the app
2. Navigate to the service listing screen
3. Add items to cart
4. The cart should persist if you're logged in

## Note

The app will work with local cart state even if Supabase is not configured. Cart items will be stored in memory and will be lost when the app is closed. To persist cart items across app sessions, set up Supabase as described above.


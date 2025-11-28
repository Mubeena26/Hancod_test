import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize Supabase with your credentials
    await Supabase.initialize(
      url: 'https://aoyjocwencosozklgjpx.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFveWpvY3dlbmNvc296a2xnanB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzNTU2ODUsImV4cCI6MjA3OTkzMTY4NX0.uRofRWl35M-L0Aab5fNczGbR_BpOGlCsbPxL4XNEcMg',
    );
    
    _initialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
}


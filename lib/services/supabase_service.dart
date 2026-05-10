import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl =
      'https://yxcsjpchszoemqzzjyes.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl4Y3NqcGNoc3pvZW1xenpqeWVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzNTM3MDgsImV4cCI6MjA5MzkyOTcwOH0.yfu2NFOqWtdZHd24d0nW9PwOE9bCgoUG56LlBK4lMb4';

  // Initialize Supabase — call this in main()
  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  // Get Supabase client
  static SupabaseClient get client => Supabase.instance.client;

  // ─── AUTH ─────────────────────────────────────────────────────────────────

  static Future<AuthResponse> login(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  // ─── USERS / ROLES ────────────────────────────────────────────────────────

  static Future<String> getUserRole(String uid) async {
    final response = await client
        .from('users')
        .select('role')
        .eq('id', uid)
        .maybeSingle();
    return response?['role'] ?? 'agent';
  }

  // ─── PRODUCTS ─────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await client
        .from('products')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addProduct(Map<String, dynamic> product) async {
    await client.from('products').insert(product);
  }

  static Future<void> updateProduct(
      String id, Map<String, dynamic> updates) async {
    await client.from('products').update(updates).eq('id', id);
  }

  static Future<void> deleteProduct(String id) async {
    await client.from('products').delete().eq('id', id);
  }

  // ─── SELLERS ──────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getSellers() async {
    final response = await client
        .from('sellers')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addSeller(Map<String, dynamic> seller) async {
    await client.from('sellers').insert(seller);
  }

  static Future<void> updateSeller(
      String id, Map<String, dynamic> updates) async {
    await client.from('sellers').update(updates).eq('id', id);
  }

  static Future<void> deleteSeller(String id) async {
    await client.from('sellers').delete().eq('id', id);
  }

  // ─── VISITS ───────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getVisits() async {
    final response = await client
        .from('visits')
        .select('*, visit_items(*)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveVisit(
    Map<String, dynamic> visit,
    List<Map<String, dynamic>> items,
  ) async {
    final visitResponse =
        await client.from('visits').insert(visit).select().single();
    final visitId = visitResponse['id'];
    final itemsWithVisitId =
        items.map((item) => {...item, 'visit_id': visitId}).toList();
    await client.from('visit_items').insert(itemsWithVisitId);
  }
}

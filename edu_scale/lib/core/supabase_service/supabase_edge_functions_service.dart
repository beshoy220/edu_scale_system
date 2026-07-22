import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class SupabaseEdgeService {
  final _client = SupabaseConfig.client;

  Future<FunctionResponse> invoke({
    required String functionName,
    Map<String, dynamic>? body,
  }) async {
    return await _client.functions.invoke(
      // headers: {'Content-Type': 'application/json'},
      functionName,
      body: body,
    );
  }
}

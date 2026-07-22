import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client.dart';

class SupabaseDatabaseService {
  final _client = SupabaseConfig.client;

  SupabaseQueryBuilder from(String table) {
    final response = _client.from(table);
    return response;
  }

  PostgrestFilterBuilder rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) {
    final response = _client.rpc(functionName, params: params);
    return response;
  }
}

import 'package:edu_scale_admin/features/dashboard_base/data/data_sources/get_auth_data.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataProvider extends ChangeNotifier {
  User? currentUserData() {
    GetAuthData userData = GetAuthData();
    return userData.callUserData();
  }
}

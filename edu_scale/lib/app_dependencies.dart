import 'package:supabase_flutter/supabase_flutter.dart';

class AppDependencies {
  static Future<void> initDependencies() async {
    await supabaseDependencies();
  }

  static supabaseDependencies() async {
    await Supabase.initialize(
      url: 'https://fvxhepdodicxtljcetum.supabase.co',
      publishableKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGhlcGRvZGljeHRsamNldHVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1NzU5OTgsImV4cCI6MjA5ODE1MTk5OH0.5TRfAEqISx-WxNcelExuwW4xHoY2Iymhbnp6gvvIoVo',
    );
  }
}

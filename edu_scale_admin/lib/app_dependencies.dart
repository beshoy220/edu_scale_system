import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/template/data/data_sources/cache/template_cache_data_source.dart';
import 'features/template/data/data_sources/remote/template_remote_data_source.dart';
import 'features/template/data/repo_implementations/template_repo_implementation.dart';
import 'features/template/domain/repo_interfaces/template_repo_interface.dart';
import 'features/template/domain/use_cases/get_template_use_case.dart';

final sl = GetIt.instance;

class AppDependencies {
  static Future<void> initDependencies() async {
    await supabaseDependencies();
    await templateDependencies();
    await onBoardingDependencies();
    await dashboardBaseDependencies();
    await schoolUsersDependencies();
  }

  /// ================= SUPABASE =================
  static supabaseDependencies() async {
    await Supabase.initialize(
      url: 'https://fvxhepdodicxtljcetum.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2eGhlcGRvZGljeHRsamNldHVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1NzU5OTgsImV4cCI6MjA5ODE1MTk5OH0.5TRfAEqISx-WxNcelExuwW4xHoY2Iymhbnp6gvvIoVo',
    );
  }

  /// ================= TEMPLATE =================
  static Future<void> templateDependencies() async {
    sl.registerLazySingleton<TemplateRemoteDataSource>(
      () => TemplateRemoteDataSource(),
    );

    sl.registerLazySingleton<TemplateCacheDataSource>(
      () => TemplateCacheDataSource(),
    );

    sl.registerLazySingleton<TemplateRepoInterface>(
      () => TemplateRepoImplementation(
        remoteDataSource: sl(),
        cacheDataSource: sl(),
      ),
    );

    sl.registerLazySingleton<GetTemplateUseCase>(
      () => GetTemplateUseCase(sl()),
    );
  }

  /// ================= ONBOARDING =================
  static Future<void> onBoardingDependencies() async {}

  /// ================= DASHBOARD_BASE =================
  static Future<void> dashboardBaseDependencies() async {}

  /// ================= SCHOOL_USERS =================
  static Future<void> schoolUsersDependencies() async {}
}

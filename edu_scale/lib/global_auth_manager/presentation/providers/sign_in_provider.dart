import 'package:edu_scale/global_auth_manager/data/data_sources/update_user_remote_data_source.dart';
import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/account_manager/cached_account_model.dart';
import 'package:flutter/foundation.dart';
import 'package:edu_scale/global_auth_manager/data/data_sources/sign_in_remote_data_source.dart';
import 'package:edu_scale/global_auth_manager/data/models/updated_user_model.dart';

class SignInProvider extends ChangeNotifier {
  final SignInRemoteDataSource _signInRemoteDataSource =
      SignInRemoteDataSource();

  final UserRemoteDataSource _userRemoteDataSource = UserRemoteDataSource();

  UpdatedUserModel? currentUser;

  bool isLoading = false;
  String? error;

  Future<bool> signIn({required String email, required String password}) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();

      await _signInRemoteDataSource.signInWithEmailAndPassword(email, password);

      isLoading = false;

      notifyListeners();
      return true; // Success
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // Failure
    }
  }

  Future<UpdatedUserModel?> updateUserData(
    String userId,
    String gender,
    DateTime birthDay,
  ) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();

      final updatedUser = await _userRemoteDataSource.updateUserDataByUserUUID(
        userId,
        gender,
        birthDay,
      );

      isLoading = false;

      notifyListeners();
      return updatedUser; // Success
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return null; // Failure
    }
  }

  Future<void> saveCacheAccount(
    UpdatedUserModel userData,
    String userPassword,
  ) async {
    await AccountManager.setCurrentAccount(
      CachedAccount(
        id: userData.id,
        email: userData.email,
        password: userPassword,
        role: userData.role,
        gender: userData.gender ?? 'male',
        displayName: userData.name,
        lastSignIn: DateTime.now(),
        schoolId: userData.schoolId,
        ids: UserIds(
          gradeId: userData.gradeId,
          classId: userData.classId,
          subjectId: userData.subjectId,
          parentId: userData.parentId,
          studentId: userData.studentId,
        ),
      ),
    );
  }
}

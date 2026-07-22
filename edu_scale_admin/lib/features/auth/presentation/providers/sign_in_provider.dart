import 'package:flutter/widgets.dart';
import '../../data/data_sources/remote/sign_in.dart';

class SignInProvider extends ChangeNotifier {
  // states
  String? errorMessage;
  bool? isSchoolActive = false;
  bool isLoading = false;

  // sign-in from the controllers directly
  Future<bool> signIn(String email, String password) async {
    final SignIn auth = SignIn();

    try {
      errorMessage = null;
      isLoading = true;
      notifyListeners();

      await auth.call(email, password);

      isLoading = false;

      notifyListeners();
      return true; // Success
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // Failure
    }
  }

  void resetError() {
    errorMessage = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:newshub/repo/auth_repo.dart';
import 'package:newshub/view_models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  bool _isLoggedInOrSignUpSuccess = false;

  AuthProvider(this._authRepository);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedInOrSignUpSuccess => _isLoggedInOrSignUpSuccess;

  void signUp(String email, String password, String name) {
    _setLoading(true);
    _errorMessage = null;
    _authRepository.signUp(email, password, name).then((result) {
      result.fold(
        (error) {
          _errorMessage = error.toString();
          print('Sign up error: $_errorMessage');
        },
        (user) {
          _user = UserModel(uid: user.uid, name: name, email: user.email);
          _isLoggedInOrSignUpSuccess = true;
          notifyListeners();
        },
      );
      _setLoading(false);
    });
  }

  void signIn(String email, String password) {
    _setLoading(true);
    _errorMessage = null;
    _authRepository.signIn(email, password).then((result) {
      result.fold(
        (error) {
          _errorMessage = error.toString();
          print('Sign in error: $_errorMessage');
        },
        (user) {
          _user = UserModel(uid: user.uid, name: user.name, email: user.email);
          _isLoggedInOrSignUpSuccess = true;
          notifyListeners();
        },
      );
      _setLoading(false);
    });
  }

  void signOut() {
    _setLoading(true);
    _errorMessage = null;
    _authRepository.signOut().then(
      (result) {
        result.fold(
          (error) {
            _errorMessage = error.toString();
            print('Sign out error: $_errorMessage');
          },
          (_) {
            _user = null;
            _isLoggedInOrSignUpSuccess = false;
            notifyListeners();
          },
        );
        _setLoading(false);
      },
    );
  }

  clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}

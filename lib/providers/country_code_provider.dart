import 'package:flutter/material.dart';

class CountryCodeProvider with ChangeNotifier {
  String _countryCode = 'US';
  String get countryCode => _countryCode;

  set countryCode(String newCountryCode) {
    if (_countryCode != newCountryCode) {
      _countryCode = newCountryCode;
      notifyListeners();
    }
  }

  void updateCountryCode(String newCode) {
    countryCode = newCode;
    notifyListeners();
  }
}
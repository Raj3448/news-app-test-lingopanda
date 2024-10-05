import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  static Future<String> fetchCountryCodeFromRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      remoteConfig.setDefaults({
        "country_code":"us"
      });
      remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 10)));
      await remoteConfig.fetchAndActivate();
      String? countryCode = remoteConfig.getString('country_code');
      if (countryCode.isEmpty) {
        print(
            "Country code from remote config is null or empty. Using default 'US'");
        return 'US';
      }
      return countryCode;
    } catch (e) {
      print('Error fetching Remote Config: $e');
      return 'US';
    }
  }
}

import 'package:hive/hive.dart';
import 'package:newshub/core/util/setup_hivebox.dart';

class TokenManager {
  static final TokenManager _singletone = TokenManager._private();
  TokenManager._private();
  factory TokenManager() {
    return _singletone;
  }
  final box = Hive.box(TOKEN_BOX_NAME);

  Future<void> saveToken(String token) async {
    await box.put(JWT_TOKEN_KEY, token);
  }

  Future<dynamic> getToken() async {
    return box.get(JWT_TOKEN_KEY);
  }

  Future<void> deleteToken() async {
    await box.delete(JWT_TOKEN_KEY);
  }

  bool hasToken() {
    return box.containsKey(JWT_TOKEN_KEY);
  }
}

import 'dart:convert';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:hive_flutter/adapters.dart';

const TOKEN_BOX_NAME = 'jwt_token_box';
const JWT_TOKEN_KEY = 'JWT_token';

Future<void> setupHiveBox() async {
  await Hive.initFlutter();
  await initializeBoxForToken();
}

Future<void> initializeBoxForToken() async {
  var existingKey = await FlutterKeychain.get(key: 'hive_key');
  
  if (existingKey == null) {
    final newKey = Hive.generateSecureKey();
    await FlutterKeychain.put(key: 'hive_key', value: base64UrlEncode(newKey));
    existingKey = base64UrlEncode(newKey);
  }
  
  final key = base64Url.decode(existingKey);
  await Hive.openBox(TOKEN_BOX_NAME, encryptionCipher: HiveAesCipher(key));
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/core/services/firebase_auth_service.dart';
import 'package:newshub/providers/auth_provider.dart';
import 'package:newshub/providers/country_code_provider.dart';
import 'package:newshub/repo/auth_repo.dart';
import 'package:newshub/ui/auth/auth_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepository(FirebaseAuthService())),
        ),
        ChangeNotifierProvider(
          create: (_) => CountryCodeProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: AppColors.backgroundColor,
        ),
        home: AuthPage(),
      ),
    );
  }
}

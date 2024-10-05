import 'package:flutter/material.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/providers/auth_provider.dart';
import 'package:newshub/ui/auth/components/login_form.dart';
import 'package:newshub/ui/auth/components/signup_form.dart';
import 'package:newshub/ui/home/home_page.dart';
import 'package:newshub/ui/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthController _controller = AuthController();
  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authProvider.errorMessage != null) {
          _showErrorSnackbar(authProvider.errorMessage!);
          authProvider.clearError();
        }
        if (authProvider.isLoggedInOrSignUpSuccess) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false,
          );
        }
      });
      return Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.secondaryColor,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLogin
                  ? LoginForm(controller: _controller, onSwitch: _toggleForm)
                  : SignUpForm(controller: _controller, onSwitch: _toggleForm),
            ),
          ),
          if (authProvider.isLoading)
            const Material(
              color: Colors.transparent,
              child: LoadingWidget(),
            )
        ],
      );
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

class AuthController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }
}

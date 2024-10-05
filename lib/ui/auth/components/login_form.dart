import 'package:flutter/material.dart';
import 'package:newshub/core/constant/app_colors.dart';
import 'package:newshub/core/constant/font_text.dart';
import 'package:newshub/providers/auth_provider.dart';
import 'package:newshub/ui/auth/auth_page.dart';
import 'package:newshub/ui/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  final AuthController controller;
  final VoidCallback onSwitch;

  const LoginForm({Key? key, required this.controller, required this.onSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'My News',
            style: AppFonts.titleFont.copyWith(color: AppColors.primaryColor),
          ),
        ),
        Column(
          children: [
            buildTextField(
              controller: controller.emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 20),
            buildTextField(
              controller: controller.passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
        Column(
          children: [
            buildElevatedButton(
              label: 'Login',
              onPressed: () {
                if (controller.emailController.text.trim().isEmpty ||
                    controller.passwordController.text.trim().isEmpty) {
                  _buildErrorSnackbar(
                      'Email and password should not be empty', context);
                  return;
                }
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.signIn(
                  controller.emailController.text.trim(),
                  controller.passwordController.text.trim(),
                );
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onSwitch,
              child: RichText(
                text: TextSpan(
                  style: AppFonts.captionFont.copyWith(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'New here? ',
                      style: AppFonts.buttonFont
                          .copyWith(color: AppColors.textColorSecondary),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: AppFonts.buttonFont
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildErrorSnackbar(String message, context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}

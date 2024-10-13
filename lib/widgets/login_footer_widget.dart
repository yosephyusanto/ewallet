import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              'register-screen'
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: const Text(
            'Register',
            style: TextStyle(
              color: Color(0xFF96C445),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

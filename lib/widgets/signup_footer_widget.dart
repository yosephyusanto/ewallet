import 'package:ewallet/pages/login_page.dart';
import 'package:flutter/material.dart';

class SignupFooterWidget extends StatelessWidget {
  const SignupFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Have an account?',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: const Text(
            'Login',
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

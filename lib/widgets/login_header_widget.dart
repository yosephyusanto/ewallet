import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login to your Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Welcome Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: 'Poppins',
            ),
          )
        ],
      ),
    );
  }
}

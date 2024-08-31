import 'package:flutter/material.dart';

class SignupHeaderWidget extends StatelessWidget {
  const SignupHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
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
            'Create Your Account',
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

import 'package:ewallet/widgets/signup_footer_widget.dart';
import 'package:ewallet/widgets/signup_form_widget.dart';
import 'package:ewallet/widgets/signup_header_widget.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFF0D1C2C),
              Color(0xFF172534),
              Color(0xFF202E3C),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60.0,
            ),
            const SignupHeaderWidget(),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    topRight: Radius.circular(60.0),
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                  child: ListView(
                    // padding: EdgeInsets.all(40.0),
                    children: [
                      SignupFormWidget(),
                      SignupFooterWidget(),
                    ],
                  ),
                ),
              ),
            ),
            // Text('Account'),
          ],
        ),
      ),
    );
  }
}

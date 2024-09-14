// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/pages/home_page.dart';
import 'package:ewallet/providers/auth_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    super.key,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(AuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        AppUser? user = await authProvider.login(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if(user != null){
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful')),
          );

          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(data: user)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!value.contains('@')) {
                  return 'Plese enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 20.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          authProvider.isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBDE864)),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => login(authProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBDE864),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF0D1C2C),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

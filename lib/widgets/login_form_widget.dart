// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/models/users_model.dart';
import 'package:ewallet/pages/home_page.dart';
import 'package:ewallet/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String uid = userCredential.user?.uid ?? '';
     
        final FirestoreService firestoreService = FirestoreService();
        DocumentSnapshot userDoc = await firestoreService.getUserData(uid);

        if (!userDoc.exists || userDoc.data() == null) {
          throw Exception('User data not found');
        }

        AppUser user = AppUser.fromMap(userDoc.data() as Map<String, dynamic>);

        // Handle successful login here (e.g., navigate to another page)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(data: user)),
        );
      } on FirebaseAuthException catch (e) {
        // Handle login error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${e.message}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBDE864)),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
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

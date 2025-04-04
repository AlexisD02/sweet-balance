import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sweet_balance/service/auth_service.dart';
import 'package:sweet_balance/ui/screens/forgot_pass_screen.dart';
import 'package:sweet_balance/ui/screens/home_screen.dart';
import 'package:sweet_balance/ui/screens/multi_step_form_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = AuthService();

  // Form key helps us validate user input before login
  final _formKey = GlobalKey<FormState>();

  // Text controllers for capturing user credentials
  final _email = TextEditingController();
  final _password = TextEditingController();

  // Controls password visibility toggle
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Navigates to home page screen after successful login
  void goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
    );
  }

  // Navigates to password recovery screen
  void goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  // Navigates to user registration screen by providing multi-step form
  void goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MultiStepFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('signInScreen'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            const Text(
              "Please sign in below to get started.",
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Form for user credentials input and validation
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email input with validation
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please enter your email.";
                      if (!RegExp(r"^[\w-.]+@([\w-]+\.)+\w{2,4}").hasMatch(value)) {
                        return "Enter a valid email.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Password input with show/hide toggle
                  TextFormField(
                    controller: _password,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          // Allow user to toggle password visibility
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter your password.";
                      if (value.length < 6) return "Password must be at least 6 characters.";
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Link to reset password
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: goToForgotPassword,
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Main login button using email/password
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final (user, error) = await _auth.handleEmailLogin(
                    email: _email.text.trim(),
                    password: _password.text.trim(),
                  );

                  if (user != null) {
                    log("User signed in successfully");
                    goToHome();
                  } else {
                    // Show error if login failed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error ?? 'Login failed')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 25),

            // Visual divider between email and Google sign-in
            const Row(
              children: [
                Expanded(child: Divider(thickness: 0.8, color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("OR", style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
                Expanded(child: Divider(thickness: 0.8, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 25),

            // Google Sign-in integration
            ElevatedButton.icon(
              onPressed: () async {
                final (user, error) = await _auth.handleGoogleLogin();

                if (user != null) {
                  goToHome();
                } else {
                  // Inform the user if google login fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error ?? 'Google sign-in failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: SvgPicture.asset("assets/images/svg/google_logo.svg", height: 24),
              label: const Text(
                "Continue With Google",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),

            const SizedBox(height: 25),

            // Link to go to registration if the user doesn't have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: goToRegister,
                  child: const Text(
                    "Register here",
                    style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

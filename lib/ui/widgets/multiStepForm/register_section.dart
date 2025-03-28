// lib/widgets/multiStepForm/register_step.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterStep extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool obscurePassword;
  final bool agreeToTerms;
  final bool agreeToPrivacyPolicy;

  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool> onAgreeToTermsChanged;
  final ValueChanged<bool> onAgreeToPrivacyPolicyChanged;
  final VoidCallback onSignUpPressed;
  final VoidCallback onGoogleSignUpPressed;

  const RegisterStep({
    required this.firstNameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.agreeToTerms,
    required this.agreeToPrivacyPolicy,
    required this.onTogglePasswordVisibility,
    required this.onAgreeToTermsChanged,
    required this.onAgreeToPrivacyPolicyChanged,
    required this.onSignUpPressed,
    required this.onGoogleSignUpPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Let's set up your account",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        TextFormField(
          controller: firstNameController,
          decoration: InputDecoration(
            labelText: "First Name",
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your first name.";
            }
            return null;
          },
        ),
        const SizedBox(height: 15),

        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email Address",
            prefixIcon: const Icon(Icons.email),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email.";
            }
            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(value)) {
              return "Please enter a valid email.";
            }
            return null;
          },
        ),
        const SizedBox(height: 15),

        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: onTogglePasswordVisibility,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password.";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters long.";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Switch(
              activeColor: Colors.teal,
              value: agreeToTerms,
              onChanged: onAgreeToTermsChanged,
            ),
            const SizedBox(width: 10.0),
            const Text("I agree to the "),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Terms of Service",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Switch(
              activeColor: Colors.teal,
              value: agreeToPrivacyPolicy,
              onChanged: onAgreeToPrivacyPolicyChanged,
            ),
            const SizedBox(width: 10.0),
            const Text("I agree to the "),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "Privacy Policy",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),

        ElevatedButton(
          onPressed: onSignUpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 25),

        const Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 0.8,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "OR",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 0.8,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),

        ElevatedButton.icon(
          onPressed: onGoogleSignUpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            minimumSize: const Size.fromHeight(50),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          icon: SvgPicture.asset(
            "assets/images/svg/google_logo.svg",
            height: 24.0,
          ),
          label: const Text(
            "Continue With Google",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

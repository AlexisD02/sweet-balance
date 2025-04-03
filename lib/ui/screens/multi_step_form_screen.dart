import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sweet_balance/ui/screens/home_screen.dart';

import '../widgets/multiStepForm/activity_section.dart';
import '../widgets/multiStepForm/weight_input_section.dart';
import '../widgets/multiStepForm/gender_input_section.dart';
import '../widgets/multiStepForm/height_input_section.dart';
import '../widgets/multiStepForm/date_picker_section.dart';
import '../widgets/multiStepForm/register_section.dart';
import '../widgets/multiStepForm/info_message.dart';
import '../widgets/multiStepForm/progress_indicator.dart';

class MultiStepFormScreen extends StatefulWidget {
  final int initialStep;

  const MultiStepFormScreen({this.initialStep = 1, super.key});

  @override
  _MultiStepFormScreenState createState() => _MultiStepFormScreenState();
}

class _MultiStepFormScreenState extends State<MultiStepFormScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController otherGenderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool agreeToTerms = false;
  bool agreeToPrivacyPolicy = false;

  DateTime selectedDate = DateTime.now();
  int selectedActivityIndex = 0;
  String? selectedGender;

  int currentStep = 1;
  final int totalSteps = 6;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentStep = widget.initialStep;
  }

  @override
  void dispose() {
    weightController.dispose();
    otherGenderController.dispose();
    heightController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      setState(() {
        if (currentStep < totalSteps) {
          currentStep++;
        }
        if (currentStep == totalSteps) {
          if (agreeToTerms && agreeToPrivacyPolicy) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          }
        }
      });
    }
  }

  void _previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildRegistrationStep() {
    return RegisterStep(
      firstNameController: firstNameController,
      emailController: emailController,
      passwordController: passwordController,
      obscurePassword: obscurePassword,
      agreeToTerms: agreeToTerms,
      agreeToPrivacyPolicy: agreeToPrivacyPolicy,
      onTogglePasswordVisibility: () {
        setState(() {
          obscurePassword = !obscurePassword;
        });
      },
      onAgreeToTermsChanged: (value) {
        setState(() {
          agreeToTerms = value;
        });
      },
      onAgreeToPrivacyPolicyChanged: (value) {
        setState(() {
          agreeToPrivacyPolicy = value;
        });
      },
      onSignUpPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (agreeToTerms && agreeToPrivacyPolicy) {
            try {
              final credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

              final uid = credential.user?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance.collection('users').doc(uid).set({
                  'firstName': firstNameController.text.trim(),
                  'email': emailController.text.trim(),
                  'weight': double.tryParse(weightController.text.trim()) ?? 0,
                  'gender': selectedGender ?? '',
                  'otherGender': otherGenderController.text.trim(),
                  'height': double.tryParse(heightController.text.trim()) ?? 0,
                  'dob': selectedDate.toIso8601String(),
                  'activityLevel': selectedActivityIndex,
                  'createdAt': Timestamp.now(),
                });

                if (!mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                );
              }
            } on FirebaseAuthException catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.message ?? 'Sign up failed.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please agree to Terms of Service and Privacy Policy to continue."),
              ),
            );
          }
        }
      },
      onGoogleSignUpPressed: () async {
        try {
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) {
            // User canceled the sign-in
            return;
          }

          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign in to Firebase with the Google credentials
          final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

          final uid = userCredential.user?.uid;
          final email = userCredential.user?.email ?? '';
          final displayName = userCredential.user?.displayName ?? '';

          if (!mounted) return;

          // Check if user data exists in Firestore
          final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
          final doc = await docRef.get();

          if (!doc.exists) {
            // New user, store default profile
            await docRef.set({
              'firstName': displayName,
              'email': email,
              'weight': double.tryParse(weightController.text.trim()) ?? 0,
              'gender': selectedGender ?? '',
              'otherGender': otherGenderController.text.trim(),
              'height': double.tryParse(heightController.text.trim()) ?? 0,
              'dob': selectedDate.toIso8601String(),
              'activityLevel': selectedActivityIndex,
              'createdAt': Timestamp.now(),
            });
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Google sign-in failed: ${e.toString()}")),
          );
        }
      },
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 1:
        return WeightInputSection(controller: weightController);
      case 2:
        return GenderInputSection(
          selectedGender: selectedGender,
          onGenderChanged: (gender) {
            setState(() {
              selectedGender = gender;
              if (gender != "Other") {
                otherGenderController.clear();
              }
            });
          },
          otherGenderController: otherGenderController,
        );
      case 3:
        return HeightInputSection(controller: heightController);
      case 4:
        return DatePickerSection(
          selectedDate: selectedDate,
          onDateChanged: (newDate) {
            setState(() {
              selectedDate = newDate;
            });
          },
        );
      case 5:
        return ActivitySelector(
          selectedActivityIndex: selectedActivityIndex,
          onActivitySelected: (index) {
            setState(() {
              selectedActivityIndex = index;
            });
          },
        );
      case 6:
        return _buildRegistrationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _previousStep,
          ),
          actions: currentStep == totalSteps
              ? [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                );
              },
              child: Text(
                "SKIP",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.0,
                ),
              ),
            ),
          ]
              : [],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ProgressIndicatorWidget(currentStep: currentStep, totalSteps: totalSteps),
                  const SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildStepContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: currentStep < totalSteps
            ? SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0, 40.0, isKeyboardOpen
                  ? MediaQuery.of(context).viewInsets.bottom + 16.0
                  : 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const InfoMessage(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}

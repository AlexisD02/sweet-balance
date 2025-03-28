import 'package:flutter/material.dart';

class GenderInputSection extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final TextEditingController otherGenderController;

  const GenderInputSection({
    required this.selectedGender,
    required this.onGenderChanged,
    required this.otherGenderController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: selectedGender,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender.';
        }
        if (value == 'Other' && otherGenderController.text.isEmpty) {
          return '';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "What's your ",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "gender",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "?"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: state.hasError ? Colors.red : Colors.grey[400]!,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGenderOption("Male", "Male", state),
                  _buildDivider(),
                  _buildGenderOption("Female", "Female", state),
                  _buildDivider(),
                  _buildGenderOption("Prefer not to say", "Prefer not to say", state),
                  _buildDivider(),
                  _buildGenderOption("Other", "Other", state),
                  if (selectedGender == "Other") ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: TextFormField(
                        controller: otherGenderController,
                        decoration: InputDecoration(
                          labelText: "Specify your gender",
                          labelStyle: const TextStyle(color: Colors.grey),
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
                              width: 2.0,
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
                          if (selectedGender == "Other") {
                            if (value == null || value.isEmpty) {
                              return 'Please specify your gender.';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGenderOption(String value, String title, FormFieldState<String> state) {
    return RadioListTile<String>(
      value: value,
      groupValue: state.value,
      onChanged: (String? newValue) {
        onGenderChanged(newValue);
        state.didChange(newValue);
      },
      title: Text(
        title,
        style: const TextStyle(fontSize: 16.0),
      ),
      activeColor: Colors.teal,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 2.0,
      indent: 70.0,
      endIndent: 20.0,
      thickness: 1,
      color: Colors.grey[300],
    );
  }
}

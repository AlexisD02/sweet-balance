import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class DatePickerSection extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerSection({
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: (value) {
        if (value == null) {
          return 'Please select your date of birth.';
        }
        if (value.isAfter(DateTime.now())) {
          return 'Date cannot be in the future.';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "When's your ",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "birthday",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "?"),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              child: Transform.scale(
                scale: 1.06,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DatePickerWidget(
                    looping: true,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    initialDate: selectedDate,
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.en_us,
                    onChange: (DateTime newDate, _) {
                      onDateChanged(newDate);
                      state.didChange(newDate);
                    },
                    pickerTheme: const DateTimePickerTheme(
                      backgroundColor: Colors.transparent,
                      itemTextStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),

            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
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
}

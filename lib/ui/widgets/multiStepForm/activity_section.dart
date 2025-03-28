import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivitySelector extends StatelessWidget {
  final int selectedActivityIndex;
  final ValueChanged<int> onActivitySelected;

  final List<Map<String, String>> activityItems = const [
    {
      'title': 'Not active',
      'description': 'Minimal daily activity, including sitting for most of the day with little to no physical exertion.',
      'image': 'assets/images/svg/resting.svg',
    },
    {
      'title': 'Lightly active',
      'description': 'Light daily activity, such as casual walking, occasional chores, or light stretching exercises.',
      'image': 'assets/images/svg/walking.svg',
    },
    {
      'title': 'Moderately active',
      'description': 'Moderate daily activities including consistent walking, cycling, or other moderate exercises for at least 60 minutes.',
      'image': 'assets/images/svg/cycling.svg',
    },
    {
      'title': 'Very active',
      'description': 'High daily activity involving regular intense physical workouts, sports, or physically demanding jobs.',
      'image': 'assets/images/svg/running.svg',
    },
  ];

  const ActivitySelector({
    required this.selectedActivityIndex,
    required this.onActivitySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      initialValue: selectedActivityIndex < 0 ? 0 : selectedActivityIndex,
      validator: (value) {
        if (value == null || value < 0 || value >= activityItems.length) {
          return 'Please select your activity level.';
        }
        return null;
      },
      builder: (FormFieldState<int> state) {
        final index = state.value ?? 0;
        final activity = activityItems[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "How ",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "active",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " are you?"),
                ],
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: SvgPicture.asset(
                activity['image']!,
                height: 170,
              ),
            ),
            const SizedBox(height: 30),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                showValueIndicator: ShowValueIndicator.never,
                activeTrackColor: Colors.teal,
                inactiveTrackColor: Colors.grey[300],
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                thumbColor: Colors.teal,
                overlayColor: Colors.teal.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
                valueIndicatorColor: Colors.teal,
              ),
              child: Slider(
                value: index.toDouble(),
                min: 0,
                max: activityItems.length - 1.toDouble(),
                divisions: activityItems.length - 1,
                label: activity['title'],
                onChanged: (value) {
                  final roundedValue = value.round();
                  onActivitySelected(roundedValue);
                  state.didChange(roundedValue);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  activityItems.first['title']!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  activityItems.last['title']!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              activity['title']!,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activity['description']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
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

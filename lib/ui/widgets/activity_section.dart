import 'package:flutter/material.dart';

class ActivitySelector extends StatelessWidget {
  final int selectedActivityIndex;
  final ValueChanged<int> onActivitySelected;
  final bool showError;

  final List<String> activityDescriptions = const [
    "Not active",
    "Lightly active",
    "Moderately active",
    "Very active",
  ];

  final List<String> activityDetails = const [
    "Minimal daily activity, including sitting for most of the day with little to no physical exertion.",
    "Light daily activity, such as casual walking, occasional chores, or light stretching exercises.",
    "Moderate daily activities including consistent walking, cycling, or other moderate exercises for at least 60 minutes.",
    "High daily activity involving regular intense physical workouts, sports, or physically demanding jobs.",
  ];

  const ActivitySelector({
    required this.selectedActivityIndex,
    required this.onActivitySelected,
    required this.showError,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () => onActivitySelected(index),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: selectedActivityIndex == index
                              ? Colors.teal
                              : Colors.grey[300],
                          child: Icon(
                            index == 0
                                ? Icons.accessible
                                : index == 1
                                ? Icons.accessibility
                                : index == 2
                                ? Icons.directions_walk
                                : Icons.directions_run,
                            color: selectedActivityIndex == index
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedActivityIndex == index
                                ? Colors.teal
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                activityDescriptions[selectedActivityIndex],
                style: const TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                activityDetails[selectedActivityIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

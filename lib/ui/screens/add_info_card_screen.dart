import 'package:flutter/material.dart';
import '../widgets/bottom_action_buttons.dart';

class AddInfoCard extends StatefulWidget {
  // Info cards that are previously removed by the user
  final List<String> removedCardKeys;

  const AddInfoCard({super.key, required this.removedCardKeys});

  @override
  State<AddInfoCard> createState() => _AddInfoCardState();
}

class _AddInfoCardState extends State<AddInfoCard> {
  // Tracks which cards are selected based on user preference to have them or not
  final Map<String, bool> cardSelectionStatus = {};

  // Controls the "select all" toggle state, in order to be able to select
  // all info cards
  bool isSelectAllEnabled = false;

  @override
  void initState() {
    super.initState();

    // Initialize selection state for each removed card as unselected.
    // User can only allow re-adding cards that were previously removed.
    for (final cardKey in widget.removedCardKeys) {
      cardSelectionStatus[cardKey] = false;
    }
  }

  // Returns how many cards the user has selected, used to update UI text
  int get selectedCount =>
      cardSelectionStatus.values.where((selected) => selected).length;

  // Toggles all cards to be selected or unselected
  // Used when the user taps "All" to quickly bulk-select/deselect
  void toggleSelectAll() {
    setState(() {
      isSelectAllEnabled = !isSelectAllEnabled;
      for (final key in cardSelectionStatus.keys) {
        cardSelectionStatus[key] = isSelectAllEnabled;
      }
    });
  }

  // Convert internal storage keys into more user-friendly card labels
  String getCardLabel(String key) {
    switch (key) {
      case 'sugar':
        return 'Sugar Intake';
      case 'fat':
        return 'Fat Intake';
      case 'proteins':
        return 'Protein Intake';
      case 'energy':
        return 'Calories';
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // The "select all" UI element, where lets users toggle all cards
              // at once
              Column(
                children: [
                  GestureDetector(
                    onTap: toggleSelectAll,
                    child: CircleAvatar(
                      radius: 10.0,
                      backgroundColor: isSelectAllEnabled ? Colors.black : Colors.grey[400],
                      child: isSelectAllEnabled
                          ? const Icon(Icons.check, color: Colors.white, size: 16.0)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  const Text("All", style: TextStyle(fontSize: 12.0, color: Colors.black)),
                ],
              ),
              const SizedBox(width: 20.0),

              // Displays dynamic status of how many cards are selected
              Text(
                selectedCount > 0
                    ? "$selectedCount selected"
                    : "Choose what to add",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          // If no cards are available to add, show a friendly message instead
          // of a list
          if (cardSelectionStatus.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Nothing to add.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    children: cardSelectionStatus.entries.map((entry) {
                      final cardKey = entry.key;
                      final isSelected = entry.value;

                      // Used to determine if this is the last item, to avoid
                      // showing a divider after it
                      final isLastItem = cardSelectionStatus.keys.toList().last == cardKey;

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),

                            // Small toggle icon for each card
                            leading: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cardSelectionStatus[cardKey] = !isSelected;

                                  // If every card is selected, also enable "select all"
                                  isSelectAllEnabled =
                                      cardSelectionStatus.values.every((val) => val);
                                });
                              },
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor:
                                isSelected ? Colors.black : Colors.grey[300],
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 14.0)
                                    : null,
                              ),
                            ),

                            // Card label from key
                            title: Text(
                              getCardLabel(cardKey),
                              style: const TextStyle(fontSize: 16.0),
                            ),

                            // Whole tile acts as a toggle for easier interaction
                            onTap: () {
                              setState(() {
                                cardSelectionStatus[cardKey] = !isSelected;
                                isSelectAllEnabled =
                                    cardSelectionStatus.values.every((val) => val);
                              });
                            },
                          ),

                          // Divider between cards for better visual separation
                          if (!isLastItem)
                            Divider(
                              height: 3.0,
                              indent: 50.0,
                              endIndent: 15.0,
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

          // Confirm/cancel action buttons to submit or reject the selection
          // of info cards
          Container(
            color: Colors.grey[200],
            child: BottomActionButtons(
              onCancel: () => Navigator.pop(context),
              onSave: () {
                final selectedKeys = cardSelectionStatus.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();

                // Return list of selected cards to the home page screen
                Navigator.pop(context, selectedKeys);
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/bottom_action_buttons.dart';

class AddInfoCard extends StatefulWidget {
  const AddInfoCard({super.key});

  @override
  State<AddInfoCard> createState() => _AddInfoCardState();
}

class _AddInfoCardState extends State<AddInfoCard> {
  final Map<String, bool> _infoCardOptions = {
    "Info Card 1": false,
    "Info Card 2": false,
    "Info Card 3": false,
    "Info Card 4": false,
    "Info Card 5": false,
    "Info Card 6": false,
    "Info Card 7": false,
    "Info Card 8": false,
    "Info Card 9": false,
    "Info Card 10": false,
    "Info Card 11": false,
    "Info Card 12": false,
    "Info Card 13": false,
    "Info Card 14": false,
    "Info Card 15": false,
    "Info Card 16": false,
  };

  bool _selectAll = false;

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      _infoCardOptions.updateAll((key, value) => _selectAll);
    });
  }

  int get _selectedCount =>
      _infoCardOptions.values.where((isSelected) => isSelected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: _toggleSelectAll,
                    child: CircleAvatar(
                      radius: 10.0,
                      backgroundColor:
                      _selectAll ? Colors.black : Colors.grey[400],
                      child: _selectAll
                          ? const Icon(Icons.check,
                          color: Colors.white, size: 16.0)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  const Text(
                    "All",
                    style: TextStyle(fontSize: 12.0, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(width: 20.0),
              Text(
                _selectedCount > 0
                    ? "$_selectedCount selected"
                    : "Choose what to add",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._infoCardOptions.keys.map((cardName) {
                      final index =
                      _infoCardOptions.keys.toList().indexOf(cardName);
                      return Column(
                        children: [
                          ListTile(
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            leading: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _infoCardOptions[cardName] =
                                  !_infoCardOptions[cardName]!;
                                  _selectAll = _infoCardOptions.values
                                      .every((value) => value);
                                });
                              },
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: _infoCardOptions[cardName]!
                                    ? Colors.black
                                    : Colors.grey[300],
                                child: _infoCardOptions[cardName]!
                                    ? const Icon(Icons.check,
                                    color: Colors.white, size: 14.0)
                                    : null,
                              ),
                            ),
                            title: Text(
                              cardName,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            onTap: () {
                              setState(() {
                                _infoCardOptions[cardName] =
                                !_infoCardOptions[cardName]!;
                                _selectAll = _infoCardOptions.values
                                    .every((value) => value);
                              });
                            },
                          ),
                          if (index != _infoCardOptions.keys.length - 1)
                            Divider(
                              height: 3.0,
                              indent: 50.0,
                              endIndent: 15.0,
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: BottomActionButtons(
              onCancel: () {
                Navigator.pop(context);
              },
              onSave: () {
                final selectedCards = _infoCardOptions.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();

                Navigator.pop(context, selectedCards);
              },
            ),
          ),
        ],
      ),
    );
  }
}

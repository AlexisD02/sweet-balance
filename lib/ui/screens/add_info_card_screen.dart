import 'package:flutter/material.dart';
import '../widgets/bottom_action_buttons.dart';

class AddInfoCard extends StatefulWidget {
  final List<String> removedKeys;

  const AddInfoCard({super.key, required this.removedKeys});

  @override
  State<AddInfoCard> createState() => _AddInfoCardState();
}

class _AddInfoCardState extends State<AddInfoCard> {
  final Map<String, bool> _selectionMap = {};

  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    for (final key in widget.removedKeys) {
      _selectionMap[key] = false;
    }
  }

  int get _selectedCount =>
      _selectionMap.values.where((selected) => selected).length;

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (final key in _selectionMap.keys) {
        _selectionMap[key] = _selectAll;
      }
    });
  }

  String _getCardLabel(String key) {
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
                  const Text("All",
                      style: TextStyle(fontSize: 12.0, color: Colors.black)),
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
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
        body: Column(
          children: [
            if (_selectionMap.isEmpty)
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
                      children: _selectionMap.entries.map((entry) {
                        final key = entry.key;
                        final selected = entry.value;
                        final index =
                        _selectionMap.keys.toList().indexOf(entry.key);

                        return Column(
                          children: [
                            ListTile(
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              leading: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectionMap[key] = !selected;
                                    _selectAll = _selectionMap.values
                                        .every((value) => value);
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 10.0,
                                  backgroundColor:
                                  selected ? Colors.black : Colors.grey[300],
                                  child: selected
                                      ? const Icon(Icons.check,
                                      color: Colors.white, size: 14.0)
                                      : null,
                                ),
                              ),
                              title: Text(
                                _getCardLabel(key),
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectionMap[key] = !selected;
                                  _selectAll = _selectionMap.values
                                      .every((value) => value);
                                });
                              },
                            ),
                            if (index != _selectionMap.keys.length - 1)
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
            Container(
              color: Colors.grey[200],
              child: BottomActionButtons(
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  final selectedCards = _selectionMap.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
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

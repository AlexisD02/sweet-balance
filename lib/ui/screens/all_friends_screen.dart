import 'package:flutter/material.dart';

import '../../models/friend_model.dart';
import '../widgets/friend_info_popup.dart';
import '../widgets/search_field.dart';

class AllFriendsScreen extends StatefulWidget {
  final List<Friend> allFriends;

  const AllFriendsScreen({super.key, required this.allFriends});

  @override
  State<AllFriendsScreen> createState() => _AllFriendsScreenState();
}

class _AllFriendsScreenState extends State<AllFriendsScreen> {
  String _searchQuery = '';
  String _sortOption = 'Alphabetical';

  @override
  Widget build(BuildContext context) {
    List<Friend> displayFriends = _applySearchAndSort(widget.allFriends);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: SearchField(
          placeholder: "Search friends...",
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  const Text(
                    "Sorted by ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _sortOption,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.swap_vert,
                      color: Colors.black87,
                      size: 28,
                    ),
                    onPressed: _showSortOptionsPopup,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: displayFriends.length,
                itemBuilder: (context, index) {
                  final friend = displayFriends[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(friend.avatarUrl),
                          backgroundColor: Colors.grey[200],
                        ),
                        title: Text(
                          friend.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          friend.status,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onTap: () {
                          _showFriendInfoPopup(context, friend);
                        },
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptionsPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        String selectedOption = _sortOption;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildRadioOption(
                    context,
                    'Alphabetical',
                    selectedOption,
                        (value) {
                      setModalState(() {
                        selectedOption = value;
                      });
                      setState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  _buildRadioOption(
                    context,
                    'Latest',
                    selectedOption,
                        (value) {
                      setModalState(() {
                        selectedOption = value;
                      });
                      setState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  _buildRadioOption(
                    context,
                    'Earliest',
                    selectedOption,
                        (value) {
                      setModalState(() {
                        selectedOption = value;
                      });
                      setState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadioOption(
      BuildContext context,
      String label,
      String groupValue,
      ValueChanged<String> onChanged,
      ) {
    return ListTile(
      title: Text(label),
      trailing: Transform.scale(
        scale: 1.2,
        child: Radio<String>(
          value: label,
          groupValue: groupValue,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
      onTap: () {
        onChanged(label);
      },
    );
  }


  List<Friend> _applySearchAndSort(List<Friend> friends) {
    final filtered = friends.where((friend) {
      final nameLower = friend.name.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    if (_sortOption == 'Alphabetical') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOption == 'Latest') {
      filtered.sort((a, b) => b.name.compareTo(a.name));
    } else if (_sortOption == 'Earliest') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }
    return filtered;
  }

  void _showFriendInfoPopup(BuildContext context, Friend friend) {
    showDialog(
      context: context,
      builder: (ctx) {
        return FriendInfoPopup(
          friend: friend,
          onUnfriend: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unfriended ${friend.name}'),
              ),
            );
          },
          onBlock: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Blocked ${friend.name}'),
              ),
            );
          },
        );
      },
    );
  }
}

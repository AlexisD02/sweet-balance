import 'package:flutter/material.dart';
import '../widgets/collapsible_header.dart';
import '../widgets/infoCards/notification_info_card.dart';
import '../widgets/popup_menu.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isEditMode = false;
  bool _showHighOnly = false;
  bool _showNormalOnly = false;
  bool _showRemindersOnly = false;

  final List<NotificationCard> _notifications = [
    const NotificationCard(
      icon: Icons.warning_amber_rounded,
      title: 'Sugar Level High',
      message: 'Your sugar level is higher than recommended. Please consult your doctor.',
      time: '10:00 AM',
      dateLabel: 'Today',
    ),
    const NotificationCard(
      icon: Icons.check_circle_outline,
      title: 'Sugar Level Normal',
      message: 'Your sugar level is within the normal range. Keep up the good work!',
      time: '9:00 AM',
      dateLabel: 'Today',
    ),
    const NotificationCard(
      icon: Icons.info_outline,
      title: 'Reminder',
      message: 'Time to check your sugar level.',
      time: '8:00 AM',
      dateLabel: 'Yesterday',
    ),
    const NotificationCard(
      icon: Icons.warning_amber_rounded,
      title: 'Sugar Level Low',
      message: 'Your sugar level is lower than recommended. Please take necessary precautions.',
      time: '7:00 AM',
      dateLabel: 'Yesterday',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(250.0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<NotificationCard> get _filteredNotifications {
    if (!_showHighOnly && !_showNormalOnly && !_showRemindersOnly) {
      return _notifications;
    }

    return _notifications.where((notification) {
      if (_showHighOnly && notification.icon == Icons.warning_amber_rounded) {
        return true;
      }
      if (_showNormalOnly && notification.icon == Icons.check_circle_outline) {
        return true;
      }
      if (_showRemindersOnly && notification.icon == Icons.info_outline) {
        return true;
      }
      return false;
    }).toList();
  }

  List<NotificationCard> _buildUniqueDateLabelList(List<NotificationCard> baseList) {
    final List<NotificationCard> processed = [];
    String? lastDateLabel;

    for (final card in baseList) {
      final showLabel = (card.dateLabel != lastDateLabel);
      final effectiveDateLabel = showLabel ? card.dateLabel : '';

      final clonedCard = NotificationCard(
        key: card.key,
        icon: card.icon,
        title: card.title,
        message: card.message,
        time: card.time,
        dateLabel: effectiveDateLabel,
        isEditMode: _isEditMode,
        onRemove: () {
          final index = _notifications.indexOf(card);
          if (index >= 0) {
            _removeNotification(index);
          }
        },
      );
      processed.add(clonedCard);

      if (card.dateLabel.isNotEmpty) {
        lastDateLabel = card.dateLabel;
      }
    }

    return processed;
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _removeNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _showFilterPopup() {
    bool localShowHighOnly = _showHighOnly;
    bool localShowNormalOnly = _showNormalOnly;
    bool localShowRemindersOnly = _showRemindersOnly;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter Notifications',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCheckboxRow(
                    label: 'High Priority',
                    value: localShowHighOnly,
                    onChanged: (val) {
                      setModalState(() => localShowHighOnly = val!);
                      setState(() => _showHighOnly = val!);
                    },
                  ),

                  _buildCheckboxRow(
                    label: 'Normal Priority',
                    value: localShowNormalOnly,
                    onChanged: (val) {
                      setModalState(() => localShowNormalOnly = val!);
                      setState(() => _showNormalOnly = val!);
                    },
                  ),

                  _buildCheckboxRow(
                    label: 'Reminders Only',
                    value: localShowRemindersOnly,
                    onChanged: (val) {
                      setModalState(() => localShowRemindersOnly = val!);
                      setState(() => _showRemindersOnly = val!);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return ListTile(
      title: Text(label),
      trailing: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final displayedNotifications = _filteredNotifications;
    final uniqueList = _buildUniqueDateLabelList(displayedNotifications);

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CollapsibleHeader(
              title: _isEditMode ? "Edit Notifications" : "Notifications",
              isEditMode: _isEditMode,
              onBackPressed: _toggleEditMode,
              actions: _isEditMode
                  ? []
                  : [
                GestureDetector(
                  onTap: _toggleEditMode,
                  child: const Icon(
                    Icons.delete_outline,
                    size: 26.0,
                  ),
                ),
                const SizedBox(width: 14),

                GestureDetector(
                  onTap: _showFilterPopup,
                  child: const Icon(
                    Icons.filter_list,
                    size: 26.0,
                  ),
                ),

                const PopupMenuWidget(),
              ],
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return uniqueList[index];
                },
                childCount: uniqueList.length,
              ),
            ),

            if (!_isEditMode && displayedNotifications.isEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Text(
                    'No notifications to show',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.5,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

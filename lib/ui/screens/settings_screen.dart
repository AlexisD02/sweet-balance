import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _highPriorityEnabled = true;
  bool _dailyReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  double _dailySugarLimit = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildCard(
            child: SwitchListTile(
              title: const Text("Sync Account"),
              subtitle: const Text("Last synced on December 25 at 09:45"),
              value: true,
              onChanged: (val) {
                // todo placeholder
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              "Notifications",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _buildCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Enable Notifications"),
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                      if (!value) {
                        _highPriorityEnabled = false;
                        _dailyReminderEnabled = false;
                      }
                    });
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                SwitchListTile(
                  title: const Text("High-Priority Alerts"),
                  value: _highPriorityEnabled,
                  onChanged: _notificationsEnabled
                      ? (bool value) {
                    setState(() {
                      _highPriorityEnabled = value;
                    });
                  }
                      : null,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                SwitchListTile(
                  title: const Text("Daily Reminder"),
                  subtitle: _dailyReminderEnabled
                      ? Text("Reminder Time: ${_reminderTime.format(context)}")
                      : null,
                  value: _dailyReminderEnabled,
                  onChanged: _notificationsEnabled
                      ? (bool value) {
                    setState(() {
                      _dailyReminderEnabled = value;
                    });
                  }
                      : null,
                ),

                if (_dailyReminderEnabled)
                  ListTile(
                    title: const Text("Choose Reminder Time"),
                    trailing: Text(_reminderTime.format(context)),
                    onTap: _pickReminderTime,
                  ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              "Sugar Intake",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _buildCard(
            child: ListTile(
              title: const Text("Daily Sugar Limit (g)"),
              subtitle: Text("${_dailySugarLimit.round()} grams"),
              onTap: _showSugarLimitDialog,
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              "Other",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.data_usage),
                  title: const Text("Manage Data"),
                  subtitle: const Text("Backup / Restore / Clear History"),
                  onTap: () {
                    // todo placeholder
                  },
                ),
                const Divider(height: 0.8, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text("Privacy & Terms"),
                  onTap: () {
                    // todo placeholder
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About App"),
                  onTap: () {
                    // todo placeholder
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _showSugarLimitDialog() async {
    final TextEditingController controller =
    TextEditingController(text: _dailySugarLimit.toString());
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Set Daily Sugar Limit (g)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "E.g. 40",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                final double? val = double.tryParse(controller.text);
                Navigator.pop(ctx, val);
              },
              child: const Text("SAVE"),
            ),
          ],
        );
      },
    );

    if (result != null && result > 0) {
      setState(() {
        _dailySugarLimit = result;
      });
    }
  }
}

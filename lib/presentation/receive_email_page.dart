import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/email_models.dart';

class ReceivedEmailsPage extends StatefulWidget {
  const ReceivedEmailsPage({super.key});

  @override
  State<ReceivedEmailsPage> createState() => _ReceivedEmailsPageState();
}

class _ReceivedEmailsPageState extends State<ReceivedEmailsPage> {
  List<Email> receivedEmails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReceivedEmails();
  }

  Future<void> loadReceivedEmails() async {
    final emails = await DBHelper().getReceivedEmails();
    setState(() {
      receivedEmails = emails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (receivedEmails.isEmpty) {
      return const Center(child: Text('Inbox is empty'));
    }

    return RefreshIndicator(
      onRefresh: loadReceivedEmails,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: receivedEmails.length,
        itemBuilder: (context, index) {
          final email = receivedEmails[index];
          return _emailCard(
            title: email.subject,
            subtitle: 'From: ${email.to}',
            body: email.body,
            time: email.timestamp,
            icon: Icons.inbox,
            iconColor: Colors.green,
          );
        },
      ),
    );
  }

  Widget _emailCard({
    required String title,
    required String subtitle,
    required String body,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.15),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '$subtitle\n$body',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(_formatTime(time), style: const TextStyle(fontSize: 12)),
        isThreeLine: true,
      ),
    );
  }

  String _formatTime(String time) {
    final date = DateTime.parse(time).toLocal();
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

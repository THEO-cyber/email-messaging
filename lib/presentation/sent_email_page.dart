import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/email_models.dart';

class SentEmailsPage extends StatefulWidget {
  const SentEmailsPage({super.key});

  @override
  State<SentEmailsPage> createState() => _SentEmailsPageState();
}

class _SentEmailsPageState extends State<SentEmailsPage> {
  List<Email> sentEmails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSentEmails();
  }

  Future<void> loadSentEmails() async {
    final emails = await DBHelper().getSentEmails();
    setState(() {
      sentEmails = emails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sentEmails.isEmpty) {
      return const Center(child: Text('No sent emails'));
    }

    return RefreshIndicator(
      onRefresh: loadSentEmails,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sentEmails.length,
        itemBuilder: (context, index) {
          final email = sentEmails[index];
          return _emailCard(
            title: email.subject,
            subtitle: 'To: ${email.to}',
            body: email.body,
            time: email.timestamp,
            icon: Icons.send,
            iconColor: Colors.deepPurple,
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

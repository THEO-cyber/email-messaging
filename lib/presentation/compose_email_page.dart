import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../database/db_helper.dart';
import '../models/email_models.dart';

class ComposeEmailPage extends StatefulWidget {
  const ComposeEmailPage({super.key});

  @override
  State<ComposeEmailPage> createState() => _ComposeEmailPageState();
}

class _ComposeEmailPageState extends State<ComposeEmailPage> {
  final toController = TextEditingController();
  final ccController = TextEditingController();
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();
  bool isSending = false;

  Future<void> sendEmail() async {
    if (toController.text.isEmpty ||
        subjectController.text.isEmpty ||
        bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in To, Subject, and Body')),
      );
      return;
    }

    setState(() => isSending = true);

   String username = 'theocyber57@gmail.com';
    String password = 'vnrnzkkfkkjzpkkt';
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'HIMS User')
      ..recipients.addAll(toController.text.split(',').map((e) => e.trim()))
      ..ccRecipients.addAll(ccController.text.split(',').map((e) => e.trim()))
      ..subject = subjectController.text
      ..text = bodyController.text;

    try {
      await send(message, smtpServer);

      // Save to SQLite
      final email = Email(
        to: toController.text,
        cc: ccController.text,
        subject: subjectController.text,
        body: bodyController.text,
        timestamp: DateTime.now().toIso8601String(),
        isSent: true,
      );
      await DBHelper().insertEmail(email);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email sent successfully!')));

      toController.clear();
      ccController.clear();
      subjectController.clear();
      bodyController.clear();
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to send email')));
    } finally {
      setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildTextField(toController, 'To (comma separated)'),
          const SizedBox(height: 10),
          buildTextField(ccController, 'CC (comma separated)'),
          const SizedBox(height: 10),
          buildTextField(subjectController, 'Subject'),
          const SizedBox(height: 10),
          buildTextField(bodyController, 'Message', maxLines: 6),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: isSending ? null : sendEmail,
            icon: isSending
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.send),
            label: Text(isSending ? 'Sending...' : 'Send Email'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

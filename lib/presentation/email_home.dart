import 'package:email_service/presentation/compose_email_page.dart';
import 'package:email_service/presentation/receive_email_page.dart';
import 'package:email_service/presentation/sent_email_page.dart';
import 'package:flutter/material.dart';


class EmailHome extends StatefulWidget {
  const EmailHome({super.key});

  @override
  State<EmailHome> createState() => _EmailHomeState();
}

class _EmailHomeState extends State<EmailHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = const [
    Tab(text: 'Compose', icon: Icon(Icons.edit)),
    Tab(text: 'Sent', icon: Icon(Icons.send)),
    Tab(text: 'Inbox', icon: Icon(Icons.inbox)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HIMS Email'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ComposeEmailPage(),
          SentEmailsPage(),
          ReceivedEmailsPage(),
        ],
      ),
    );
  }
}

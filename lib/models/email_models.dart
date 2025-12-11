class Email {
  int? id; // auto-increment in database
  String to;
  String cc;
  String subject;
  String body;
  String timestamp;
  bool isSent;
  Email({
    this.id,
    required this.to,
    required this.cc,
    required this.subject,
    required this.body,
    required this.timestamp,
    this.isSent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'to': to,
      'cc': cc,
      'subject': subject,
      'body': body,
      'timestamp': timestamp,
    };
  }

  factory Email.fromMap(Map<String, dynamic> map) {
    return Email(
      id: map['id'],
      to: map['to'],
      cc: map['cc'],
      subject: map['subject'],
      body: map['body'],
      timestamp: map['timestamp'],
    );
  }
}

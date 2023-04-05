import 'package:event_poll/models/user.dart';

class Vote{
  Vote({
    required this.pollId,
    required this.status,
    required this.created, 
    required this.user, 
  });
  int pollId;
  bool status;
  User user;
  DateTime created;

  Vote.fromJson(Map<String, dynamic> json)
    : this(
      pollId: json['pollId'] as int,
      status: json['status'] as bool,
      user: User.fromJson(json['user']), 
      created: DateTime.parse(json['created']),
    );

  
}
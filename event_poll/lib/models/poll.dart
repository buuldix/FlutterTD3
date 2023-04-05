import 'package:event_poll/models/vote.dart';

class Poll{
  Poll({
    required this.id,
    required this.name,
    required this.description, 
    required this.eventDate, 
    required this.votes,
  });
  int id;
  String name;
  String description;
  DateTime eventDate;
  List<Vote> votes;

  Poll.fromJson(Map<String, dynamic> json):this(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String, 
      eventDate: DateTime.parse(json['eventDate']),
      votes: (json['votes'] != null ? json['votes'] as List<dynamic>: []).map((e) => Vote.fromJson(e)).toList()
  );

  int nbParticipants(){
    int nb = 0;
    for (var element in votes) {
      if(element.status){
        nb++;
      }
    }
    return nb;
  }

  bool isParticipating(int id){
    for (Vote vote in votes) {
      if(vote.user.id == id){
        return vote.status;
      }
    }
    return false;
  }

  void changeParticipationState(int id){
    for (Vote vote in votes) {
      if(vote.user.id == id){
        if(vote.status){
          vote.status = false;
        }
        else{
          vote.status = true;
        }
      }
    }
  }
}
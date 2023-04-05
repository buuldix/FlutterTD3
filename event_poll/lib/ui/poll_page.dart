import 'package:event_poll/result.dart';
import 'package:event_poll/states/polls_state.dart';
import 'package:event_poll/ui/pollDetail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../states/auth_state.dart';

class PollPage extends StatefulWidget {
  @override
  _PollPageState createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<Result<List<Poll>,String>>(
          future: context.read<PollsState>().getPolls(),
          builder: (context,snapshot){
            List<Widget> widgets = [];
            if(snapshot.hasData){
              for (Poll poll in snapshot.data!.value!) {
                  widgets.add(
                    PollWidget(currentPoll: poll)
                  );
                }
              return Column(children: widgets,);
            }else{
              return const Text("Aucun évenement prévu !");
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 6), // changes position of shadow
                    ),
                  ],
                ),
                width: 50,
                height: 50,
                child: IconButton(
                  onPressed: () => {setState((){}) }, 
                  icon: const Icon(
                    Icons.replay_outlined,
                    color: Colors.blue,
                  )
                ),
              ),
              context.read<AuthState>().isLoggedIn?context.read<AuthState>().currentUser!.isAdmin? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 6), // changes position of shadow
                    ),
                  ],
                ),
                width: 50,
                height: 50,
                child: IconButton(
                  onPressed: () => {Navigator.pushNamedAndRemoveUntil(
                    context, '/polls/create', (_) => false)}, 
                  icon: const Icon(
                    Icons.add,
                    color: Colors.blue,
                  )
                ),
              ):Container():Container(),
              
            ],
          ),
        )
      ],
    );
  }
}

class PollWidget extends StatelessWidget {
  const PollWidget({
    super.key,
    required this.currentPoll,
  });

  final Poll currentPoll;

  Widget _buildPopupDialog(BuildContext context, Poll poll) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: pollDetailPage(poll: poll,)
    );
  }


  @override
  Widget build(BuildContext context) {
    final dateFormater = DateFormat('dd/MM/yyyy', 'fr');
    return TextButton(
      onPressed: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildPopupDialog(context, currentPoll),
          )
        },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: const Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
        width: MediaQuery.of(context).size.width*0.955,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(currentPoll.name),
                    Text(currentPoll.description),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(dateFormater.format(currentPoll.eventDate)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
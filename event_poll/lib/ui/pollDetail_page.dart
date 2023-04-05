import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../result.dart';
import '../states/auth_state.dart';
import '../states/polls_state.dart';

class pollDetailPage extends StatefulWidget {
  pollDetailPage({super.key,required this.poll});
  final Poll poll;
  @override
  _pollDetailPageState createState() => _pollDetailPageState(poll: poll);
}

class _pollDetailPageState extends State<pollDetailPage> {
  _pollDetailPageState({required this.poll});
  final Poll poll;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: FutureBuilder<Result<Poll, String>>(
            future: context.read<PollsState>().getPoll(poll.id),
            builder: (context, snapshot) {
              final dateFormater = DateFormat('dd/MM/yyyy', 'fr');

              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 245, 245, 245)),
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data!.value!.name,
                      style:
                          const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: const Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
                            ),
                            height: 70,
                            width: MediaQuery.of(context).size.width*0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(

                                  padding: const EdgeInsets.all(8.0),
                                  
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(dateFormater.format(snapshot.data!.value!.eventDate)),
                                      Text(snapshot.data!.value!.description)
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text("Participations"),
                                    Text("(${snapshot.data!.value!.nbParticipants()})")
                                  ],
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height*0.45,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.value!.votes.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        width: MediaQuery.of(context).size.width*0.6,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data!.value!.votes[index].user.username),
                                            !snapshot.data!.value!.votes[index].status?
                                            const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ):
                                            const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    if(context.read<AuthState>().isLoggedIn){
                                      context.read<PollsState>().changeParticipationState(snapshot.data!.value!.id, snapshot.data!.value!.isParticipating(context.read<AuthState>().currentUser!.id))
                                    }else{
                                      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false)
                                    },
                                    {setState((){}) }
                                  },
                                  child: Text(context.watch<AuthState>().isLoggedIn? snapshot.data!.value!.isParticipating(context.watch<AuthState>().currentUser!.id)? "Ne plus participer": "Participer" :'Connectez-vous pour vous inscrire à un événement !')
                                )
                                
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
              return const Text("Loading");
            }),
      );
  }
}
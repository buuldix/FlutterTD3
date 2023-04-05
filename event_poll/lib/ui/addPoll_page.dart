import 'package:event_poll/states/polls_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/auth_state.dart';

class AddPollPage extends StatefulWidget {
  const AddPollPage({super.key});
  @override
  _AddPollPageState createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  final _formKey = GlobalKey<FormState>(); 
  String name = '';
  String description = '';
  String? error;
  DateTime date = DateTime.now();

  String? _validateRequired(String? value) { 
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null; 
  } 

  void _submit() async { 
    if (!_formKey.currentState!.validate()) { 
      return; 
    } 
    _formKey.currentState!.save();
    final result = await context.read<PollsState>().createPoll(name,description,date);
    if (result.isSuccess) { 
      if (context.mounted) { 
        Navigator.pushNamedAndRemoveUntil(context, '/polls', (_) => false); 
      } 
    } else { 
      setState(() { 
        error = result.failure; 
      }); 
    } 
  } 


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey, 
        child: Column( 
          children: [ 
            TextFormField( 
              decoration: const InputDecoration(
                labelText: 'Nom'
              ), 
              onChanged: (value) => name = value,
              validator: _validateRequired, 
            ), 
            const SizedBox(height: 16), 
            TextFormField( 
              decoration: const InputDecoration(
                labelText: 'Description'
              ), 
              onChanged: (value) => description = value,
              validator: _validateRequired, 
            ), 
            InputDatePickerFormField( 
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              onDateSaved: (value) {date = value;},
            ), 
            Text(error ?? ''),
            const SizedBox(height: 16), 
              ElevatedButton( 
                onPressed: _submit, 
                child: const Text('Enregistrer'), 
              ), 
            ], 
          ), 
        ),
    ); 
  }
}
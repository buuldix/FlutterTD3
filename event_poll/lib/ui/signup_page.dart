import 'package:event_poll/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> { 
  String username = '';
  String password = ''; 
  String? error; 
  final _formKey = GlobalKey<FormState>(); 
  String? _validateRequired(String? value) { 
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null; 
  } 
  void _submit() async { 
    if (!_formKey.currentState!.validate()) { 
      return; 
    } 
    final success = await context.read<AuthState>().signup(username, password);
    if (success) { 
      if (context.mounted) { 
        Navigator.pushNamedAndRemoveUntil(context, '/polls', (_) => false); 
      } 
    } else { 
      setState(() { 
        error = 'Une erreur est survenue.'; 
      }); 
    } 
  } 
  
  @override Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    return Form(
      key: _formKey, 
      child: Column( 
        children: [ 
          TextFormField( 
            decoration: const InputDecoration(
              labelText: 'Identifiant'
            ), 
            onChanged: (value) => username = value,
            validator: _validateRequired, 
          ), 
          const SizedBox(height: 16), 
          TextFormField( 
            decoration: const InputDecoration(
              labelText: 'Mot de passe'
            ), 
            obscureText: true, 
            onChanged: (value) => password = value, 
            validator: _validateRequired, 
          ), 
          const SizedBox(height: 16), 
          if (error != null) 
            Text(
            error!, 
            style: theme.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.error
              )
            ), 
            ElevatedButton( 
              onPressed: _submit, 
              child: const Text('S\'inscrire'), 
            ), 
          ], 
        ), 
      ); 
    } 
  }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      home: CommentPage(),
    );
  }
}

class CommentPage extends StatelessWidget {
  CommentPage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit a comment'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FormBuilder(
              key: _formKey,
              child: ListView(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'firstName',
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'lastName',
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'petName',
                    decoration: const InputDecoration(
                      labelText: "Your pet's name",
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'comment',
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Comment',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState!.save();

                        final bool valid = _formKey.currentState!.validate();

                        if (valid) {
                          debugPrint('Valid');
                        } else {
                          debugPrint('Invalid');
                          return;
                        }

                        debugPrint(_formKey.currentState!.value.toString());

                        final navigator = Navigator.of(context);

                        final success = await submitComment(
                          _formKey.currentState!.value,
                        );

                        if (success) {
                          navigator.push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CommentSubmittedSuccessfullyPage(),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Submit the comment via Formspree.
Future<bool> submitComment(Map<String, dynamic> data) async {
  const url = 'https://formspree.io/f/xvojkgld';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    debugPrint('Comment submitted successfully!');
    debugPrint(response.body);
    return true;
  } else {
    debugPrint('Error submitting comment.');
    debugPrint(response.body);
    return false;
  }
}

class CommentSubmittedSuccessfullyPage extends StatelessWidget {
  const CommentSubmittedSuccessfullyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Comment submitted successfully!'),
      ),
    );
  }
}

// -------- PACKAGES -------- //
import 'package:flutter/material.dart';
import 'dart:convert'; // Pour encoder et décoder
import 'package:http/http.dart' as http;  // Pour envoyer des requêtes HTTP
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Contact extends StatefulWidget {
  const Contact({super.key, required this.title});

  final String title;

  // Créé l'état
  @override
  ContactState createState() {
    return ContactState();
  }
}

class ContactState extends State<Contact> {

  final _formKey = GlobalKey<FormState>(); // Clé globale pour identification unique du formulaire
  // Controlleurs pour récupérer les données saisies
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  List<Map<String, String>> formData = [];
  // Fonction pour envoyer un email avec Mailgun
  Future<void> sendEmail() async {
    final apiKey = dotenv.env['API_KEY'];
    final domain = dotenv.env['DOMAIN'];
    final url = 'https://api.mailgun.net/v3/$domain/messages';

    String tableContent = '''
        <html>
        <head>
      <style>
        table {
          width: 100%;
          border-collapse: collapse;
        }
        th, td {
          padding: 8px;
          text-align: left;
          border: 1px solid #ddd;
        }
        th {
          background-color: #f2f2f2;
        }
      </style>
    </head>
           <body>
      <h2>Formulaire de contact</h2>
      <table>
        <thead>
          <tr>
            <th>Nom</th>
            <th>Email</th>
            <th>Message</th>
          </tr>
        </thead>
        <tbody>
  ''';

    for (var row in formData) {
      tableContent += '''
      <tr>
        <td>${row['name']}</td>
        <td>${row['email']}</td>
        <td>${row['message']}</td>
      </tr>
    ''';
    }

    tableContent += '''
            </tbody>
          </table>
        </body>
      </html>
      ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('api:$apiKey')),
      },
      body: {
        'from': 'Mailgun Sandbox <postmaster@$domain>',
        'to': 'mturco <ptitema07@gmail.com>',
        'subject': 'Hello mturco',
        'html': tableContent,
      },
    );

    if (response.statusCode == 200) {
      print('Email envoyé avec succès!');
    } else {
      print('Erreur lors de l\'envoi de l\'email: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Padding autour de tout le formulaire
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Entrez votre nom',
                    border: OutlineInputBorder(),
                  ),
                  // --- Validation des données ---
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci d\'entrer un nom';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Entrez votre e-mail',
                    border: OutlineInputBorder(),
                  ),
                  // --- Validation des données ---
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci d\'entrer un e-mail';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    hintText: 'Entrez votre message',
                    border: OutlineInputBorder(),
                  ),
                  // --- Validation des données ---
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Merci d\'entrer un message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) { // Validate: true si formulaire validé, false sinon
                        String name = _nameController.text;
                        String email = _emailController.text;
                        String message = _messageController.text;

                        // Création d'un obket map pour le json
                        Map<String, String> newData = {
                          'name': name,
                          'email': email,
                          'message': message,
                        };

                        // Ajout des données du formulaire à formData
                        formData.add(newData);

                        sendEmail();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Données ajoutées')),
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
    );
  }
}
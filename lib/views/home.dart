// -------- PACKAGES -------- //
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'about.dart';
import 'contact.dart';
import 'post_view.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  // Liste des pages (widget) pour le drawer
  final List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'widget': const HomePage()},
    {'title': 'About', 'widget': const About(title: 'About')},
    {'title': 'Contact', 'widget': const Contact(title: 'Contact')},
    {'title': 'Articles', 'widget': const PostView()},

  ];

  // Changement de page lorsque l'utilisateur clique sur le lien du drawer
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Utilisation de l'instance de ThemeNotifier fournie dans le main.dart
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC5CAE9),
        title: Text(_pages[_selectedIndex]['title']),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(child: _pages[_selectedIndex]['widget']),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // retirer le padding
          children: [
            // ---- DRAWER -----
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Color(0xFF7986CB),
                  image: DecorationImage(
                      image: AssetImage('home.jpeg'),
                      fit: BoxFit.cover, // Ajustement de l'image
                  )
              ),
              child: null,
            ),
            // ---- SWITCH MODE -----
            // SwitchListTile : combine le widget Switch (bouton) + ListTile (affichage d'un élément dans une liste avec interaction au clic)
            //value : true (active le bouton) false (désactive le bouton)
            // Ici, on regarde si le mode est en dark ou pas (valeur récupérée dans le notifier)
            //OnChanged : fonction de rappel dès qu'on touche au bouton. Ici on change la valeur en appelant toggletheme()
            SwitchListTile(
              title: Text('Dark Mode'),
              value: themeNotifier.themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                themeNotifier.toggleTheme();
              },
            ),
            // ---- ITEMS MENU -----
            ..._pages.asMap().entries.map((entry) {
              int index = entry.key;
              var page = entry.value;
              // ListTile : affichage d'un élément dans une liste avec interaction au clic
              return ListTile(
                title: Text(page['title']),
                selected: _selectedIndex == index,
                onTap: () {
                  _onItemTapped(index);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bienvenue sur ma première page Flutter !',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
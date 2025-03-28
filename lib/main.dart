// -------- PACKAGES -------- //
import 'package:flutter/material.dart';
import 'views/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Provider : package pour gérer l'état de manière centralisée dans une app


// -------- THEMES -------- //
class MyAppColors {
  static final darkBlue = Color(0xFF1E1E2C);
  static final lightBlue = Color(0xFF2D2D44);
}

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: MyAppColors.lightBlue,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: MyAppColors.darkBlue,
    brightness: Brightness.dark,
  );
}
// ----------------------- //

// -------- SWITCH THEME -------- //
// ChangeNotifier : notifier les widgets qui écoute les changements d'état
class ThemeNotifier extends ChangeNotifier {
  //ThemeMode : enum pour définir le mode d'affichage de thème
  ThemeMode _themeMode = ThemeMode.system; // Initialisation de la valeur (préférence système : light)
  //themeMode = getter
  // getter = méthode pour récupérer la valeur d'un attribut privé ou interne de la classe.
  ThemeMode get themeMode => _themeMode;

  // Méthode pour basculer du thème sombre à clair
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
// ----------------------- //

// -------- APPLICATION -------- //

Future<void> main() async {
  await dotenv.load(); // Charge les variables d'environnement
  runApp(const MyApp()); // Point d'entrée de l'application
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider : widget du package Provider
    // permet de fournir l'instance de ThemeNotifier au widget child (notre app).
    // MAJ automatique des widgets qui ecoutent
    // Le widget enfant pourra accéder à la valeur avec Provider.of<ThemeNotifier>(context)
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        // Consumer : widget qui permet de reconstruire le widget child (materialApp)
        //en  écoutant les changements notifiés par ChangeNotifier
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
              title: appTitle,
              theme: MyAppThemes.lightTheme,
              darkTheme: MyAppThemes.darkTheme,
              themeMode: themeNotifier.themeMode, // Default mode
              home: const Home(title: appTitle),
              debugShowCheckedModeBanner: false,
            );
          }
        ),
    );
  }
}
// ----------------------- //

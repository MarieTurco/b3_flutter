import 'package:flutter/material.dart';

class About extends StatelessWidget {
  // Constructeur avec titre requis
  const About({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------- APPBAR -------- //
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFC5CAE9),
      ),
      // -------- BODY -------- //
      body: Center(
        // Column : empile les widgets verticalement
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer à l'intérieur de la colonne (verticalement ici car on est dans Column)
          children: [
            // ---- Image ----- //
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                'about.png',
                fit: BoxFit.cover, // Ajuste l'image pour couvrir entièrement la zone du SizedBox
              ),
            ),

            const SizedBox(height: 20),

            // ---- Accroche ----- //
            const Text(
              'Bienvenue sur la page About !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 10),

            // ---- Description ----- //
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0), // Espacement horizontal des deux cotés
              child: Text(
                'Nam sole orto magnitudine angusti gurgitis sed profundi a transitu arcebantur et dum piscatorios quaerunt lenunculos vel innare temere contextis cratibus parant, effusae legiones, quae hiemabant tunc apud Siden, isdem impetu occurrere veloci. et signis prope ripam locatis ad manus comminus conserendas denseta scutorum conpage semet scientissime praestruebant, ausos quoque aliquos fiducia.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
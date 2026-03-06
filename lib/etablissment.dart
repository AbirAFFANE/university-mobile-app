import 'package:flutter/material.dart';

class EtablissementScreen extends StatelessWidget {
  final Map<String, dynamic> etablissement = {
    "nom": "Lycée Technique El Qods",
    "adresse": "Rue de l’Indépendance, Alger",
    "contact": "+213 21 45 67 89",
    "email": "contact@elqods.edu.dz",
    "directeur": "Mme. Lyes Amel",
    "image": "images/school3.jpg"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      appBar: AppBar(
        toolbarHeight: 70,
        foregroundColor: Colors.white,
        title: Text("Établissement",style: TextStyle(fontFamily: "sricha"),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image de l’établissement
            Container(decoration: BoxDecoration(border: Border.all(width: 2,),borderRadius: BorderRadius.circular(18)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  etablissement["image"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Carte info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  buildTile(Icons.school, "Nom", etablissement["nom"]),
                  buildTile(Icons.location_on, "Adresse", etablissement["adresse"]),
                  buildTile(Icons.phone, "Contact", etablissement["contact"]),
                  buildTile(Icons.email, "Email", etablissement["email"]),
                  buildTile(Icons.person, "Directeur", etablissement["directeur"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Composant personnalisé
  Widget buildTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 15, color: Colors.black87)),
    );
  }
}

import 'package:flutter/material.dart';

class EmploiEnseignantScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> emploiDuTemps = {
    "Lundi": [
      {
        "heure": "08:00 - 10:00",
        "module": "Physique",
        "salle": "101",
        "groupe": "G2",
      },
      {
        "heure": "10:15 - 12:00",
        "module": "Mathématiques",
        "salle": "104",
        "groupe": "G1",
      },
    ],
    "Mardi": [
      {
        "heure": "09:00 - 11:00",
        "module": "Informatique",
        "salle": "203",
        "groupe": "G3",
      },
    ],
    "Mercredi": [],
    "Jeudi": [
      {
        "heure": "08:00 - 10:00",
        "module": "Chimie",
        "salle": "Lab 2",
        "groupe": "G1",
      },
    ],
    "Vendredi": [],
  };

  final List<Color> colors = [
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.cyan,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text("Emploi du Temps Enseignant",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: emploiDuTemps.keys.length,
        itemBuilder: (context, index) {
          String jour = emploiDuTemps.keys.elementAt(index);
          List<Map<String, String>> cours = emploiDuTemps[jour] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jour,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              cours.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Aucun cours ce jour.",
                        style: TextStyle(
                            color: Colors.grey[600], fontStyle: FontStyle.italic),
                      ),
                    )
                  : Column(
                      children: List.generate(cours.length, (i) {
                        final c = cours[i];
                        final color = colors[i % colors.length];

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: color.withOpacity(0.3)),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: color),
                                    const SizedBox(width: 8),
                                    Text(c['heure']!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                            fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.book, color: color),
                                    const SizedBox(width: 8),
                                    Text("Module : ${c['module']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.room, color: color),
                                    const SizedBox(width: 8),
                                    Text("Salle : ${c['salle']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.group, color: color),
                                    const SizedBox(width: 8),
                                    Text("Groupe : ${c['groupe']}",
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
            ],
          );
        },
      ),
    );
  }
}

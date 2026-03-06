import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bulttin extends StatefulWidget {
  final int iduser;
  const Bulttin({super.key, required this.iduser});

  @override
  State<Bulttin> createState() => _BulttinState();
}

class _BulttinState extends State<Bulttin> {
  List<Map<String, dynamic>> data=[];
  Future<void> getdata()async {
    final response=await Supabase.instance.client.from('note').select('note_test, note_examen, id_module, module (nom, coefficient)').eq('id_etudiant',widget.iduser );
    setState(() {
      data.addAll(response);
    });
      print(data);
  }
void initState(){
  super.initState();
  getdata();
}

  double calculerMoyenne(List<Map<String, dynamic>> notes) {
    double somme = 0;
    int totalCoef = 0;

    for (var note in notes) {
      double moyenneMatiere = (note["note_test"] * 0.4) + (note["note_examen"] * 0.6);
      var module=note["module"];
      int coefficient = module["coefficient"] ?? 0; // Évite les erreurs null

      somme += moyenneMatiere * coefficient;
      totalCoef += coefficient;
    }

    return totalCoef == 0 ? 0 : somme / totalCoef;
  }
  @override
  Widget build(BuildContext context) {
      double moyenneGenerale = calculerMoyenne(data);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      appBar: AppBar(
        toolbarHeight: 70,
        foregroundColor: Colors.white,
        title: Text("Bulletin",style: TextStyle(fontFamily: "sricha"),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // 🏆 Affichage de la moyenne générale en haut
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.teal[400],
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      "Moyenne Générale",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      moyenneGenerale.toStringAsFixed(2),
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            
            // 📋 Liste des matières avec leurs notes
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final note = data[index];
                  final module = note['module'];
                  double moyenneMatiere = (note["note_test"] * 0.4) + (note["note_examen"] * 0.6);
                  int coefficient = module["coefficient"] ?? 0;

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal[200],
                        child: Text(
                          coefficient.toString(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        module["nom"],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Test: ${note["note_test"]} | Examen: ${note["note_examen"]} | Moyenne: ${moyenneMatiere.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

































  
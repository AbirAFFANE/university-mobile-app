import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Note extends StatefulWidget {
  final int iduser;
  const Note({super.key, required this.iduser,});
  @override
  _NoteEnseignantScreenState createState() => _NoteEnseignantScreenState();
}

class _NoteEnseignantScreenState extends State<Note> {
     
     List <Map<String, dynamic>>data=[];
     String ?matiere;
     int ?id_module;
Future<void> remplit() async { 
  try {
    final response = await Supabase.instance.client.from('enseignant').select().eq('id_prof', widget.iduser).maybeSingle();
    setState(() {
      matiere=response!['matiere'];
    });
    print(matiere);
    if (response == null) {
      print("Prof non trouvé");
      return;
    }

    int idProf = response['id_prof'];
    final response2 = await Supabase.instance.client.from('module').select().eq('id_prof', idProf).maybeSingle();
    if (response2 == null) {
      print("Module non trouvé");
      return;
    }

    int idModule = response2['id_module'];
    setState(() {
      id_module=response2['id_module'];
    });
    final response3 = await Supabase.instance.client.from('classe_module').select().eq('id_module', idModule);
    
    
    List<Map<String, dynamic>> allEtudiants = [];

    // 🔁 Pour chaque classe, récupérer les étudiants
    for (var classe in response3) {
      int idClasse = classe['id_classe'];

      final etudiants = await Supabase.instance.client
          .from('etudiant')
          .select()
          .eq('id_classe', idClasse);

      if (etudiants.isNotEmpty) {
        allEtudiants.addAll(etudiants); // 🧩 Ajouter les étudiants à la liste globale
      }
    }

    if (allEtudiants.isNotEmpty) {
      setState(() {
        data = allEtudiants;
      });
      print("Étudiants récupérés : $allEtudiants");
    } else {
      print("Aucun étudiant trouvé dans les classes de ce module");
    }
  } catch (e) {
    print("Erreur : $e");
  }
      
  } 
void initState(){
  super.initState();
  remplit();
}
  

  final _formKey = GlobalKey<FormState>();

  void enregistrerNotes() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      for (var e in data) {
        print(
            "${e['nom']} ${e['prenom']} (Groupe ${e['groupe']}) ➜ Test: ${e['test']} | Examen: ${e['examen']}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Notes enregistrées avec succès")),
      );
    }
  }

  String? validerNote(String? value) {
    if (value == null || value.isEmpty) return 'Obligatoire';
    final note = double.tryParse(value);
    if (note == null || note < 0 || note > 20) return 'Entre 0 et 20';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      appBar: AppBar(foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: const Text(
          "Saisie des Notes",
          style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'sricha'),
        ),
        centerTitle: true,
      ),
      body: Form (
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            children: [
              Text (
                matiere==null?'Loading':'Module : $matiere',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'sricha',color: Color.fromARGB(255, 68, 68, 68)),
              ),
              const SizedBox(height: 12),
              
               Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    TextEditingController test=TextEditingController(); 
                    TextEditingController examen=TextEditingController();
                    final etu = data[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 239, 239),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${etu['prenom']} ${etu['nom']}  |  Groupe: ${etu['id_classe']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sricha',
                                color: Color.fromARGB(255, 54, 54, 54)
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // Test
                                Expanded(
                                  child: TextFormField(controller: test,
                                    decoration: const InputDecoration(
                                      labelText: "Note Test",
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                    validator: validerNote,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Examen
                                Expanded(
                                  child: TextFormField(controller: examen,
                                    decoration: const InputDecoration(
                                      labelText: "Note Examen",
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                    validator: validerNote,
                                  ),
                                ),
                                IconButton(onPressed: () async{
                                  double? notetest=double.tryParse(test.text);
                                  double? noteexamen=double.tryParse(examen.text);
                                 enregistrerNotes();
                                 if (notetest!=null&&noteexamen!=null) {
                                  if (notetest>=0&&notetest<=20&&noteexamen>=0&&noteexamen<=20) {
                                    final exitingnote= await Supabase.instance.client.from('note').select().eq('id_etudiant',etu['id_etudiant']).eq('id_module', id_module!).maybeSingle();
                                     if (exitingnote!=null) {
                                       await Supabase.instance.client.from('note').update({
                                        'note_test':notetest,
                                        'note_examen':noteexamen
                                       }).eq('id_module', exitingnote['id_module']).eq('id_etudiant', exitingnote['id_etudiant']).maybeSingle();
                                     }
                                     else{
                                      await Supabase.instance.client.from('note').insert({
                                    'note_test':notetest,
                                    'note_examen':noteexamen,
                                    'id_etudiant':etu['id_etudiant'],
                                    'id_module':id_module
                                  });
                                     }
                                     
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("✅ Notes enregistrées avec succès")),
                                    );
                                  }
                                  
                                 }
                                  
                                }, icon: Icon(Icons.task_alt_outlined,color: Colors.green,))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            },
            ),
              ),
              
              // Enregistrer
              // ElevatedButton.icon(
              //   onPressed: enregistrerNotes,
              //   icon: const Icon(Icons.save_alt),
              //   label: const Text("Enregistrer"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.teal,
              //     padding: const EdgeInsets.symmetric(
              //         vertical: 14, horizontal: 30),
              //     textStyle: const TextStyle(
              //         fontSize: 18, fontWeight: FontWeight.bold),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

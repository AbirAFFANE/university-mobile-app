import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SaisieNotes extends StatefulWidget {
  final int idModule;
  final int idClasse;
  final String matiere;

  const SaisieNotes({super.key, required this.idModule, required this.idClasse, required this.matiere});

  @override
  State<SaisieNotes> createState() => _SaisieNotesState();
}

class _SaisieNotesState extends State<SaisieNotes> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> etudiants = [];

  @override
  void initState() {
    super.initState();
    loadEtudiants();
  }

  Future<void> loadEtudiants() async {
    final result = await Supabase.instance.client
        .from('etudiant')
        .select()
        .eq('id_classe', widget.idClasse);

    setState(() {
      etudiants = result;
    });
  }

  void enregistrerNotes() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      for (var e in etudiants) {
        print(
            "${e['nom']} ${e['prenom']} (Groupe ${e['groupe']}) ➜ Test: ${e['test']} | Examen: ${e['examen']}");
      }
    
     
    }
  }
  String? validerNote(String? value) {
    if (value == null || value.isEmpty) return 'vide';
    final note = double.tryParse(value);
    if (note == null || note < 0 || note > 20) return 'Entre 0 et 20';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.white,centerTitle: true,
        title: Text("Saisie - ${widget.matiere}", style: const TextStyle(fontFamily: 'sricha',fontSize: 23)),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: etudiants.length,
          itemBuilder: (context, index) {
            final etu = etudiants[index];
            final test = TextEditingController();
            final examen = TextEditingController();

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
                                    final exitingnote= await Supabase.instance.client.from('note').select().eq('id_etudiant',etu['id_etudiant']).eq('id_module', widget.idModule).maybeSingle();
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
                                    'id_module':widget.idModule
                                  });
                                     }
                                     final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Success!',
                                    message: 'Note Enregistrer avec Succes!',
                                    contentType: ContentType.success,
                                  ),
                                );

                                // Show the SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    );
  }
}

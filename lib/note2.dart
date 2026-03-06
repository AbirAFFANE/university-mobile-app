import 'package:flutter/material.dart';
import 'package:memoire/saisienote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Note2 extends StatefulWidget {
  final int iduser;
  const Note2({super.key, required this.iduser});

  @override
  State<Note2> createState() => _NoteState();
}

class _NoteState extends State<Note2> {
  List<Map<String, dynamic>> classes = [];
  String? matiere;

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    try {
      final prof = await Supabase.instance.client
          .from('enseignant')
          .select()
          .eq('id_prof', widget.iduser)
          .maybeSingle();

      if (prof == null) return;

      matiere = prof['spécialité'];

      final modules = await Supabase.instance.client
          .from('module')
          .select()
          .eq('id_prof', widget.iduser);

      if (modules.isEmpty) return;

      final moduleIds = modules.map((m) => m['id_module']).toList();

      final classeModules = await Supabase.instance.client
          .from('classe_module')
          .select()
          .filter('id_module', 'in', '(${moduleIds.join(",")})');

      final classesUnique = <int, Map<String, dynamic>>{};

      for (var cm in classeModules) {
        final idClasse = cm['id_classe'];
        final module = modules.firstWhere((m) => m['id_module'] == cm['id_module']);
        final classe = await Supabase.instance.client
            .from('classe')
            .select()
            .eq('id_classe', idClasse)
            .maybeSingle();

        if (classe != null) {
          classesUnique[idClasse] = {
            'id_classe': idClasse,
            'nom': classe['nom'],
            'id_module': cm['id_module'],
            'module_nom': module['nom']
          };
        }
      }

      setState(() {
        classes = classesUnique.values.toList();
      });
    } catch (e) {
      print("Erreur chargement classes : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      appBar: AppBar(foregroundColor: Colors.white,
        title: const Text("Saisie des Notes", style: TextStyle(fontFamily: 'sricha',fontSize: 25)),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classe = classes[index];
            return SizedBox(height: 115,
              child: Card(color: const Color.fromARGB(255, 36, 128, 154),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text("Classe: ${classe['nom']}",style: TextStyle(fontFamily: 'sricha',fontSize: 22,color: const Color.fromARGB(255, 239, 234, 234)),),
                  subtitle: Text("Module: ${classe['module_nom']}",style: TextStyle(fontFamily: 'sricha',fontSize: 18,color: const Color.fromARGB(255, 213, 212, 212)),),
                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => SaisieNotes(
                        idModule: classe['id_module'],
                        idClasse: classe['id_classe'],
                        matiere: classe['module_nom'],
                      ),
                    ));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

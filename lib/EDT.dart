import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EdtScreen extends StatefulWidget {
  final int idEtudiant;
  const EdtScreen({Key? key, required this.idEtudiant}) : super(key: key);

  @override
  _EdtScreenState createState() => _EdtScreenState();
}

class _EdtScreenState extends State<EdtScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> edt = [];
  int? idClasse;

  @override
  void initState() {
    super.initState();
    fetchEdt();
  }

  Future<void> fetchEdt() async {
    final studentResponse = await supabase
        .from('etudiant')
        .select('id_classe')
        .eq('id_etudiant', widget.idEtudiant)
        .single();

    idClasse = studentResponse['id_classe'];

    final edtResponse = await supabase
        .from('edt')
        .select('jour, heure_debut, heure_fin, module (nom)')
        .eq('id_classe', idClasse!)
        .not('jour', 'in', ['vendredi', 'samedi']);
    print( 'edt est : $edtResponse');
    setState(() {
      edt = edtResponse;
    });
  }

  List<String> joursOrdres = [
    "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi"
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> edtParJour = {
      for (var jour in joursOrdres) jour: []
    };

    for (var seance in edt) {
      edtParJour[seance['jour']]?.add(seance);
    }

    return Scaffold(backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      appBar: AppBar(foregroundColor: Colors.white,
        title: const Text("Emploi du temps",style: TextStyle(fontFamily: 'sricha',fontSize: 25),),
        backgroundColor: Colors.teal,
      ),
      body: DefaultTabController(
        length: joursOrdres.length,
        child: Column(
          children: [
            Container(
              color: Colors.teal,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: joursOrdres.map((jour) => Tab(text: jour.capitalize())).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: joursOrdres.map((jour) {
                  final jourEdt = edtParJour[jour]!;
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: jourEdt.map((seance) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8,bottom: 10,left: 15,right: 15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 34, 126, 168),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black,blurRadius: 7,offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                          title: Text(
                            seance['module']['nom'],
                            style: const TextStyle(fontFamily: 'sricha',fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 220, 219, 219)),
                          ),
                          subtitle: Text(
                            '${seance['heure_debut']} - ${seance['heure_fin']}',
                            style: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 220, 219, 219),fontFamily: 'sricha'),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
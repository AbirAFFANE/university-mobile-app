import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Infoet extends StatefulWidget {
  final int iduser;
  const Infoet({super.key, required this.iduser});

  @override
  State<Infoet> createState() => _InfoetState();
}

class _InfoetState extends State<Infoet> {
  List <dynamic>data=[];
  List <dynamic>data2=[];
  List <dynamic>data3=[];
Future<void> getdata() async { 
    
    try {
        final response = 
          await Supabase.instance.client.from('etudiant').select().eq('id_etudiant', widget.iduser).maybeSingle(); 
           int classe=response!['id_classe'];
           int parent=response['id_parent'];
           final res = await Supabase.instance.client.from('classe').select().eq('id_classe', classe).maybeSingle(); 
           final resparent = await Supabase.instance.client.from('parent').select().eq('id_parent', parent).maybeSingle(); 
          setState(() {      
            data = [response];
          });
          print("$response");
          print("Data fetched successfully!"); 
          print("$res");
          if (res!=null||resparent!=null) {
            setState(() {
              data2=[res];
              data3=[resparent];
            });
          }
            } catch (e) {
      print("error : ${e}");
    }
      
  } 
void initState(){
  super.initState();
  getdata();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.cyanAccent,toolbarHeight: 34,foregroundColor: const Color.fromARGB(182, 52, 38, 38),),
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),  
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.only( bottom: 20),
            alignment: Alignment.center,
            child: Column(
              children: [
                
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.teal),
                ),
                SizedBox(height: 10),
                Text(
                  data.isEmpty?'loading':'${data[0]['nom']} ${data[0]['prenom']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (data.isEmpty)
            Center(child: CircularProgressIndicator()) // Show loading spinner
    else ...[
          buildProfileItem(Icons.person, "Nom : ${data[0]['nom']}"),
          buildProfileItem(Icons.person, "Prenom : ${data[0]['prenom']}"),
          buildProfileItem(Icons.cake, "Date de Naissance ${data[0]['dateN']}"),
          buildProfileItem(Icons.place, "Adresse : ${data[0]['adresse']}"),
          buildProfileItem(Icons.email, "Email : ${data[0]['email']}"),
          buildProfileItem(Icons.person_4, "Genre : ${data[0]['genre']}"),
          buildProfileItem(Icons.person_4, "Parent : ${data3[0]['nom']}  ${data3[0]['prenom']}"),
          buildProfileItem(Icons.account_circle_rounded, "Classe : ${data2[0]['nom']}"),],
        ],
      ),
    );
  }
}


  Widget buildProfileItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        initialValue: text,
        enabled: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black)
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black38),
          ),
        ),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: const Color.fromARGB(255, 78, 77, 77)),
      ),
    );
  }

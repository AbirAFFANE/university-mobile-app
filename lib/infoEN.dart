import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Infoen extends StatefulWidget {
  final int iduser;
  const Infoen({super.key, required this.iduser});

  @override
  State<Infoen> createState() => _InfoenState();
}

class _InfoenState extends State<Infoen> {
  List <dynamic>data=[];
Future<void> getdata() async { 
    
    try {
        final response = 
          await Supabase.instance.client.from('enseignant').select().eq('id_prof', widget.iduser).maybeSingle(); 
          print("$response");
          print("Data fetched successfully!"); 
          print("$response");
          if (response!=null) {
            setState(() {
              data=[response];
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
      appBar: AppBar(backgroundColor: Colors.purple,toolbarHeight: 34,foregroundColor: Colors.white),
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),  
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurpleAccent],
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
                  child: Icon(Icons.person, size: 40, color: Colors.purple),
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
        // Show loading spinner
        if (data.isEmpty)
            Center(child: CircularProgressIndicator()) 
            else...[
          buildProfileItem(Icons.person, "Nom : ${data[0]['nom']}"),
          buildProfileItem(Icons.person, "Prenom : ${data[0]['prenom']}"),
          buildProfileItem(Icons.cake, "Date de Naissance :${data[0]['dateN']}"),
          buildProfileItem(Icons.place, "Adresse : ${data[0]['adresse']}"),
          buildProfileItem(Icons.email, "Email : ${data[0]['email']}"),
          buildProfileItem(Icons.work, "Date Embauche :${data[0]['dateEM']}"),
          buildProfileItem(Icons.person_4, "Genre : ${data[0]['genre']}"),
          buildProfileItem(Icons.phone, "Telephone : ${data[0]['telephone']}"),
          buildProfileItem(Icons.work, "Matiere : ${data[0]['matiere']}"),]
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
          prefixIcon: Icon(icon, color: Colors.purple),
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
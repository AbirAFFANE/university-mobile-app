import 'package:flutter/material.dart';
import 'package:memoire/bulttin.dart';
import 'package:memoire/etablissment.dart';
import 'package:memoire/infoET.dart';
import 'package:memoire/login.dart';
import 'package:memoire/EDT.dart';
import 'package:memoire/parametreetu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homee extends StatefulWidget {
  final int iduser;
  const Homee({super.key, required this.iduser});

  @override
  State<Homee> createState() => _HomeeState();
}

class _HomeeState extends State<Homee> {
    List <dynamic>data=[];
Future<void> getdata() async { 
    
    try {
        final response = 
          await Supabase.instance.client.from('etudiant').select().eq('id_etudiant', widget.iduser).maybeSingle();  
          if (response!=null) {  
            setState(() {      
              data = [response];
            });
            print("$response");
            print("Data fetched successfully!"); 
            print(data);
          }  
          else{
            print("data not found");
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
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 209, 208, 208),
    endDrawer: Drawer(backgroundColor: const Color.fromARGB(255, 231, 232, 231),child: ListView(children: [
      Container(margin: EdgeInsets.only(bottom: 35),padding: EdgeInsets.only(left: 10,),height: 100,child: Row(children: [
        ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset("images/etudiant2.png",height: 100,width: 100,fit: BoxFit.cover,),
              ),
        Expanded (
          child: ListTile(
            title: Text("Etudiant",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71) ),),
            subtitle: Text (data.isEmpty?'loading':'${data[0]['nom']} ${data[0]['prenom']}',style: TextStyle(fontSize: 18,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71) ),),
          ),
        ),
        
      ],),),
      ListTile(title: Text('Accueil',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.home,color: const Color.fromARGB(255, 71, 71, 71),size: 28,),
      onTap: () {Navigator.pop(context);},
      ),
      ListTile(title: Text('Informations',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.info,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Infoet(iduser: widget.iduser,),));},
      ),
      ListTile(title: Text('Bulletin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.notes_rounded,color: const Color.fromARGB(255, 71, 71, 71),size: 28,),
      onTap: () {Navigator.push(context, MaterialPageRoute(builder:  (context) => Bulttin(iduser: widget.iduser,),));},
      ),
      ListTile(title: Text('Emploi du temps',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.calendar_today,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => EdtScreen(idEtudiant: widget.iduser),));},
      ),
      Container(height: 305,),
      ListTile(title: Text('Deconnexion',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.login,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
      },
      ),
    ],),),
      appBar: AppBar(
        backgroundColor: Colors.teal,toolbarHeight: 70,
        title: Text("Accueil",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,fontFamily: "sricha",),),
        centerTitle: true,foregroundColor: Colors.white,
        ),
      bottomNavigationBar: SafeArea(
  child: Container(
    height: 80,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyanAccent, Colors.teal],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.only(bottom: 25, left: 20, right: 20),
    child: BottomNavigationBar(
      onTap: (index) {
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ParametresEtudiant(idEtudiant: widget.iduser),
          ));
        }
      },
      selectedLabelStyle: TextStyle(
          fontSize: 20, fontFamily: "indian", fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
          fontSize: 22, fontFamily: "indian", fontWeight: FontWeight.bold),
      unselectedItemColor: Colors.white,
      iconSize: 30,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.transparent,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Accueil"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "parametres"),
      ],
    ),
  ),
),
      body: Container(child: ListView(children: [
        Container(height: 20,),
        Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black,blurRadius: 5,)],border: Border.all(width: 1)
          ),
        margin: EdgeInsets.only(right: 20,left: 20,),
        height: 170,
        child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset("images/learn.jpg",fit: BoxFit.fill,)),), 
        Container(margin: EdgeInsets.only(top: 20,left: 10,right: 10),height: 290,child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 135,mainAxisSpacing: 15,crossAxisSpacing: 15),
          children: [
         car(text: "Iformations", icon: Icons.info, color: Colors.green, ontap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => Infoet(iduser: widget.iduser,),)) ;},),
         car(text: "Bulletin", icon: Icons.notes_rounded, color:  Colors.pink, ontap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Bulttin(iduser:widget.iduser),)); },),
         car(text: "Emploi temps", icon: Icons.calendar_today, color: Colors.blue, ontap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => EdtScreen(idEtudiant: widget.iduser))) ;},),
         car(text: "Etablissment", icon: Icons.school, color: Colors.orange, ontap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => EtablissementScreen())) ; },)
        ],),)
      ],),),
    );
  }
}
class car extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final VoidCallback ontap;
  const car({super.key, required this.text, required this.icon, required this.color, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: ontap,
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),border: Border.all(color: const Color.fromARGB(255, 87, 86, 86),width: 2),
            boxShadow: [BoxShadow(color: const Color.fromARGB(255, 51, 51, 51),blurRadius: 9,)],
            ),
              child: Card(color: color,margin: EdgeInsets.zero,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                Icon(icon,color: const Color.fromARGB(255, 218, 217, 217),size: 32,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text,textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontFamily: "sricha",color: const Color.fromARGB(255, 218, 217, 217)),),
                )
              ],),),
            ),
          );
  }
}
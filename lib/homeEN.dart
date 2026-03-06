import 'package:flutter/material.dart';
import 'package:memoire/etablissment.dart';
import 'package:memoire/infoEN.dart';
import 'package:memoire/loginT.dart';
import 'package:memoire/note2.dart';
import 'package:memoire/settingen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homeen extends StatefulWidget {
  final int iduser;
  const Homeen({super.key, required this.iduser,});

  @override
  State<Homeen> createState() => _HomeeState();
}

class _HomeeState extends State<Homeen> {
    List <dynamic>data=[];
Future<void> getdata() async { 
    
    try {
        final response = 
          await Supabase.instance.client.from('enseignant').select().eq('id_prof', widget.iduser).maybeSingle();  
          if (response!=null) {  
            setState(() {      
              data = [response];
            });
            print("$response");
            print("Data fetched successfully!"); 
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
                child: Image.asset("images/prof.png",height: 100,width: 100,fit: BoxFit.fill,),
              ),
        Expanded (
          child: ListTile(
            title: Text("Enseignant",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71) ),),
            subtitle: Text (data.isEmpty?'loading':'${data[0]['nom']} ${data[0]['prenom']}',style: TextStyle(fontSize: 18,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71) ),),
          ),
        ),
        
      ],),),
      ListTile(title: Text('Accueil',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.home,color: const Color.fromARGB(255, 71, 71, 71,),size: 28,),
      onTap: () {Navigator.pop(context);},
      ),
      ListTile(title: Text('Informations',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.info,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {},
      ),
      ListTile(title: Text('Notes',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.notes_rounded,color: const Color.fromARGB(255, 71, 71, 71),size: 28,),
      onTap: () {Navigator.push(context, MaterialPageRoute(builder:  (context) => Note2(iduser: widget.iduser)));},
      ),
      ListTile(title: Text('Parametres',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.settings,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {   
        Navigator.push(context, MaterialPageRoute(builder: (context) => ParametresEnseignant(idenseignant: widget.iduser,)));
       },
      ),
      Container(height: 305,),
      ListTile(title: Text('Deconnexion',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.login,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginT(),));
      },
      ),
    ],),),
      appBar: AppBar(
        backgroundColor: Colors.purple,toolbarHeight: 70,
        title: Text("Accueil",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,fontFamily: "sricha",),),
        centerTitle: true,foregroundColor: Colors.white,
        ),
       bottomNavigationBar: SafeArea(
  child: Container(
    height: 80,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20)),
    margin: EdgeInsets.only(bottom: 25, left: 20, right: 20),
    child: BottomNavigationBar(
      onTap: (index) {
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ParametresEnseignant(idenseignant: widget.iduser),
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
        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black,blurRadius: 5,)],border: Border.all(width: 1)),
        margin: EdgeInsets.only(right: 20,left: 20,),height: 170,child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset("images/teach.jpg",fit: BoxFit.cover,)),), 
        Container(margin: EdgeInsets.only(top: 20,left: 10,right: 10),height: 290,child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 135,mainAxisSpacing: 16,crossAxisSpacing: 16),
          children: [
         car(text: "Iformations", icon: Icons.info, color: Colors.green, ontap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Infoen(iduser: widget.iduser,),)); },),
         car(text: "Notes", icon: Icons.notes_rounded, color:  Colors.orange, ontap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Note2(iduser: widget.iduser))); },),
        //  car(text: "Emploi temps", icon: Icons.calendar_today, color: Colors.blue, ontap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => EmploiEnseignantScreen(),)) ;},),
         car(text: "Etablissment", icon: Icons.school, color: Colors.blue, ontap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => EtablissementScreen())) ; },)
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
    return  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),border: Border.all(color: const Color.fromARGB(255, 87, 86, 86),width: 2),
            boxShadow: [BoxShadow(color: const Color.fromARGB(255, 51, 51, 51),blurRadius: 9,)],),child: InkWell(onTap: ontap,
            child: Card(color: color,margin: EdgeInsets.zero,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Icon(icon,color: const Color.fromARGB(255, 218, 217, 217),size: 32,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontFamily: "sricha",color: const Color.fromARGB(255, 218, 217, 217)),),
              )
            ],),),
          ));
  }
}
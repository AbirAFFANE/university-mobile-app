import 'package:flutter/material.dart';
import 'package:memoire/enfant.dart';
import 'package:memoire/infoparent.dart';
import 'package:memoire/loginP.dart';
import 'package:memoire/settingpare.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Parent extends StatefulWidget {
  final int iduser;
  const Parent({super.key, required this.iduser});

  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  List<Map<String,dynamic>> etudiant=[];
  Map<String,dynamic> parent={};
  Future<void> getdata()async{
    try {
      final response=await Supabase.instance.client.from('etudiant').select().eq('id_parent', widget.iduser);
      final response2=await Supabase.instance.client.from('parent').select('nom,prenom').eq('id_parent', widget.iduser).maybeSingle();
      setState(() {
        etudiant=response;
        parent.addAll(response2!);
      });
       print(parent);

    } catch (e) {
      print('error : $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 209, 208, 208),
      endDrawer: Drawer(backgroundColor: const Color.fromARGB(255, 231, 232, 231),child: ListView(children: [
      Container(margin: EdgeInsets.only(bottom: 35),padding: EdgeInsets.only(left: 10,),height: 100,child: Row(children: [
        ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset("images/parent2.png",height: 100,width: 100,fit: BoxFit.contain,),
              ),
        Expanded (
          child: ListTile(
            title: Text("parent",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71) ),),
            subtitle: Text (parent.isEmpty?'loading..':'${parent['nom']} ${parent['prenom']}',style: TextStyle(fontSize: 18,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71) ),),
          ),
        ),
        
      ],),),
      ListTile(title: Text('Accueil',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.home,color: const Color.fromARGB(255, 71, 71, 71),size: 28,),
      onTap: () {Navigator.pop(context);},
      ),
      ListTile(title: Text('Informations',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.info_rounded,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Infoparent(iduser: widget.iduser)));
      },
      ),
      
      ListTile(title: Text('Settings',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.settings,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {  
        Navigator.push(context, MaterialPageRoute(builder: (context) => Parametresparent(idparent: widget.iduser)));
        },
      ),
      Container(height: 310,),
      ListTile(title: Text('Deconnexion',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),),
      leading: Icon(Icons.logout_outlined,color: const Color.fromARGB(255, 71, 71, 71)),
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginP(),));
      },
      ),
    ],),),
      appBar: AppBar(title: Text('Bienvenue parent',style: TextStyle(fontFamily: 'sricha',fontSize: 25),),backgroundColor: const Color.fromARGB(255, 13, 71, 96),centerTitle: true,foregroundColor: Colors.white,),
      body: Padding(padding: EdgeInsets.all(16),child: 
        Column(
          children: [
            SizedBox(height: 15,),
            Text("S'il Vous plait choisir ",style: TextStyle(fontSize: 24,fontFamily: 'sricha'),),
            Text("un Enfant",style: TextStyle(fontSize: 24,fontFamily: 'sricha'),),
            SizedBox(height: 35,),
            Expanded(
              child: ListView.builder(
                      itemCount: etudiant.length,
                      itemBuilder: (context, index) {
                        final etu=etudiant[index];
                        return InkWell(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Enfant(iduser: etu['id_etudiant']),));
                        },
                          child: Container(
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
                                        title: Text('${etu['nom']} ${etu['prenom']}',
                                          style: const TextStyle(fontFamily: 'sricha',fontSize: 22, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 220, 219, 219)),
                                        ),
                                        subtitle: Text(
                                          'classe ${etu['id_classe']} ',
                                          style: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 220, 219, 219),fontFamily: 'sricha'),
                                        ),
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
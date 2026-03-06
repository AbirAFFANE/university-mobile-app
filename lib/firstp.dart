import 'package:flutter/material.dart';
import 'package:memoire/login.dart';
import 'package:memoire/loginP.dart';
import 'package:memoire/loginT.dart';

class Firstp extends StatefulWidget {
  const Firstp({super.key});

  @override
  State<Firstp> createState() => _FirstpState();
}

class _FirstpState extends State<Firstp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 209, 208, 208),body: Container(margin: const EdgeInsets.all(20),child: ListView(children: [
      SizedBox(height:280,child: Column(children: [
        Container(decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 4),borderRadius: BorderRadius.circular(90)),child: ClipRRect(child: Image.asset("images/school.png",height: 120,width: 120,fit: BoxFit.cover,),borderRadius: BorderRadius.circular(90),)),
        const Padding(padding: EdgeInsets.only(top: 15,bottom: 40),child: Text("M&M SCHOOL",textAlign: TextAlign.center,style: TextStyle(fontSize:28,fontWeight: FontWeight.bold,fontFamily: "sricha"),),),
        const Text("Veuillez sélectionner votre profil ",textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: "indian"),)
      ],),),
      SizedBox(height: 35,),
      role(text: "Etudiant", color: const Color.fromARGB(255, 16, 133, 96),ontap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));},),
      role(text: "Enseignant", color: const Color.fromARGB(255, 6, 105, 65),ontap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginT(),));},),
      role(text: "Parent", color: const Color.fromARGB(255, 6, 99, 122),ontap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginP(),));},)
    ],),),);
  }
}
class role extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback ontap;
  const role({super.key, required this.text, required this.color, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: ontap,
      child: Container(margin: const EdgeInsets.only(bottom: 20),decoration: BoxDecoration(boxShadow: [const BoxShadow(color: Colors.black,blurRadius: 10,spreadRadius: 1,offset: Offset(4, 5))],color: color,borderRadius: BorderRadius.circular(10)),height: 90,child: Padding( padding: const EdgeInsets.only(top: 30),child: 
        Text(text,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color:Color.fromARGB(255, 211, 209, 209)),textAlign: TextAlign.center,),),),
    );
  }
}
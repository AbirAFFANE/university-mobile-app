import 'package:flutter/material.dart';
import 'package:memoire/firstp.dart';
import 'package:memoire/parent.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class LoginP extends StatefulWidget {
  const LoginP({super.key});

  @override
  State<LoginP> createState() => _Loginp();
}

class _Loginp extends State<LoginP> {
  bool verifpass=true;
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  List <dynamic>data=[];
  Future<void> signIn() async {
    String user=username.text.trim();
    String pass=password.text.trim();
    try {
    final response=await Supabase.instance.client.from('compte').select('id_compte').eq('username=',user).eq('profile','parent').eq('password',pass).maybeSingle();
      print(response);
      if (response!=null) {
        print('LogIn succecful');
        int iduser=response['id_compte'];
         final res=await Supabase.instance.client.from('parent').select('id_parent').eq('id_compte',iduser).maybeSingle();
         if (res!=null) {
          int id=res['id_parent'];
          await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'welcome parent',
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
          title: 'Login Successfully!',
        );
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Parent(iduser: id),));
         }
      }
      else{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Login failed!',
          text: 'Invalid username or password.',
          backgroundColor: const Color.fromARGB(255, 69, 69, 69),
          titleColor: Colors.white,
          textColor: Colors.white,
        );
        print("Login failed! Invalid username or password.");

      }
    } catch (e) {
      print("Error: $e");
 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 209, 208, 208),
    body: Container(margin: EdgeInsets.all(12),
      child: ListView(
        children: [
          Title(color: Colors.black, child: Text("Login",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: "sricha",color: const Color.fromARGB(255, 71, 71, 71)),)),
          Container(height: 300,child: Column(children: [
          Container(margin: EdgeInsets.only(left:5 ,top: 15),child: Image.asset("images/parent2.png",height: 220,width: 250,fit: BoxFit.fill,)),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 20),
            child: Text("PARENT",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: "indian",color: Color.fromARGB(255, 71, 71, 71)),),
          ),
        ],),),
      
      Container(margin: EdgeInsets.only(top: 15,bottom: 20,left: 10,right: 10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: TextFormField(controller: username,
          decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: const Color.fromARGB(255, 27, 27, 27),style: BorderStyle.solid,width: 2)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: "username",
           labelStyle: TextStyle(fontSize:18,fontWeight: FontWeight.bold ),
          floatingLabelStyle: TextStyle(color: Colors.black,fontSize: 20,fontFamily: "sricha",fontWeight: FontWeight.bold),
          prefixIcon: Icon(Icons.person_2_rounded,size: 28,),
          prefixIconColor: const Color.fromARGB(255, 87, 86, 86),
          filled: true,
          fillColor: const Color.fromARGB(255, 209, 208, 208),
          ),style: TextStyle(fontFamily: "sricha",color: const Color.fromARGB(255, 0, 0, 0),fontSize: 18),
          ),
      ),
      Container(margin: EdgeInsets.only(bottom: 20,left: 10,right: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: TextFormField(controller: password,
          obscureText: verifpass,
          decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: const Color.fromARGB(255, 27, 27, 27),style: BorderStyle.solid,width: 2)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: "password",
          labelStyle: TextStyle(fontSize:18,fontWeight: FontWeight.bold ),
          floatingLabelStyle: TextStyle(color: Colors.black,fontSize: 20,fontFamily: "sricha",fontWeight: FontWeight.bold),
          suffixIcon: IconButton(onPressed: () {
            setState(() {
              verifpass=!verifpass;
            });
          }, icon: Icon(verifpass ?Icons.visibility_off:Icons.visibility,color: const Color.fromARGB(255, 87, 86, 86),)),
          prefixIcon: Icon(Icons.lock,size: 28,),
          prefixIconColor: const Color.fromARGB(255, 87, 86, 86),
          filled: true,
          fillColor:const Color.fromARGB(255, 209, 208, 208),
          ),style: TextStyle(fontFamily: "sricha",color: const Color.fromARGB(255, 0, 0, 0),fontSize: 18,fontWeight: FontWeight.w100),
          ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        Text("change profile ? ",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,),),
        InkWell(child: Text("click ici",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.bold),),
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Firstp(),));
        },
        ),
      ],),
     Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: const Color.fromARGB(255, 255, 255, 255),blurRadius: 20)],borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.only(left: 80 ,right:80,top: 30 ),
       child: MaterialButton(onPressed: () async{
        signIn();
          },child: Text("Se connecter",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),color: const Color.fromARGB(255, 6, 99, 122),padding: EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
     ),
      
      ],),
    ),);
  }
}
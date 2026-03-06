import 'package:flutter/material.dart';
import 'package:memoire/loginP.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Parametresparent extends StatefulWidget {
  final int idparent;
  const Parametresparent({Key? key, required this.idparent}) : super(key: key);

  @override
  State<Parametresparent> createState() => _ParametresEtudiantState();
}

class _ParametresEtudiantState extends State<Parametresparent> {
  Map<String, dynamic>? userData;
  bool showPassword = false;

  Future<void> fetchUserData() async {
  final response = await Supabase.instance.client
      .from('parent')
      .select('nom, prenom, id_compte, compte (username, password)')
      .eq('id_parent', widget.idparent)
      .maybeSingle();

  setState(() {
    userData = response;
  });
}


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color.fromARGB(255, 209, 208, 208), Color.fromARGB(255, 2, 108, 122)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context)),
                          const SizedBox(width: 10),
                          const Text(
                            "Paramètres du profil",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 84, 85, 85),fontFamily: "sricha"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Profile image
                    CircleAvatar(
                      radius: 50,
                      
                      child: Icon(Icons.settings,size: 70,color: const Color.fromARGB(255, 112, 111, 111),),
                    ),

                    const SizedBox(height: 20),

                    // Nom complet
                    paramCard(
                      icon: Icons.person,
                      title: "${userData!['nom']} ${userData!['prenom']}",
                      subtitle: "Nom complet",
                    ),

                    // Username
                    paramCard(
                      icon: Icons.alternate_email,
                      title: userData!['compte']['username'] ?? 'non défini',
                      subtitle: "Nom d'utilisateur",
                    ),

                    // Mot de passe
                    paramCard(
                      icon: Icons.lock,
                      title: showPassword
                          ? userData!['compte']['password'] ?? "non défini"
                          : "********",
                      subtitle: "Mot de passe",
                      trailing: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),

                    const Spacer(),

                    // Bouton déconnexion
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                           MaterialPageRoute(builder: (context) => LoginP()),
                          (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Se déconnecter", style: TextStyle(fontSize: 18)),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget paramCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(255, 118, 118, 118), blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          if (trailing != null) trailing
        ],
      ),
    );
  }
}


import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:proyek_3/detail_pembayaran.dart';
import 'package:proyek_3/main.dart';
import 'package:proyek_3/mid_test.dart';
import 'package:http/http.dart' as http;

class HalamanProfil extends StatefulWidget{

  final PersistentTabController controller;

  const HalamanProfil({super.key, required this.controller});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();

}

class _HalamanProfilState extends State<HalamanProfil> {

  TextEditingController controllerNama = TextEditingController(text: "Load");
  TextEditingController controllerEmail = TextEditingController(text: "Load");
  TextEditingController controllerAlamat = TextEditingController(text: "Load");
  TextEditingController controllerNomorHP = TextEditingController(text: "Load");

  TextEditingController controllerEditNama = TextEditingController(text: "Load");
  TextEditingController controllerEditEmail = TextEditingController(text: "Load");
  TextEditingController controllerEditAlamat = TextEditingController(text: "Load");
  TextEditingController controllerEditNomorHP = TextEditingController(text: "Load");

  List<Map<String, dynamic>> dataUser = [
    {
      'nama': 'Load',
      'alamat': 'Load',
    }
  ];
  
    @override
    void initState() {
      super.initState();
      getData();
    }

    Future<void> refreshData() async {
      setState(() {
        dataUser = [];
        controllerNama.text =  "Load";
        controllerEmail.text =  "Load";
        controllerAlamat.text =  "Load";
        controllerNomorHP.text =  "Load";
      });
      getData();
    }

    void ubahValueController(){
      setState(() {  
        controllerNama.text = dataUser[0]['nama'];
        controllerAlamat.text = dataUser[0]['alamat'];
        controllerNomorHP.text = dataUser[0]['nomor_hp'];
        controllerEmail.text = dataUser[0]['email'];
      });
    }

    Future<void> getData() async {
      try {
      final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uid = user.uid;
          print("HREEEEEEEEEEEEEEEEE");

          // 1. Get Firestore Snapshot
          var snapshotAkun = await FirebaseFirestore.instance
            .collection('akun')
            .get();


          List<Map<String, dynamic>> temporaryAkun = [];

          for (var doc in snapshotAkun.docs) {
            Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
          
            if(user.email == data['email']){
              print("HREEEEEEEEEEEEEEEEE");
              temporaryAkun.add(data);
              print(data);
            }
          }



          // 3. Safety check before updating UI
          if (mounted) {
            setState(() {
              dataUser = temporaryAkun;
              print(dataUser);
              ubahValueController();
            });
          }
        }
      } catch (globalError) {
        print("GLOBAL ERROR in getData: $globalError");
      }
    }

  Future<void> resetPassword(String email) async {
    String msg = "";
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      msg = "Link reset password sudah dikirim ke email: $email";
    } catch (e) {
      msg = "Error: $e";
    }
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage()),
    (route) => false,
  );
  }

  Future<void> saveData(
    BuildContext context,
  ) async {
    String msg = "";
    try{
      await FirebaseFirestore.instance
        .collection('akun')
        .doc(dataUser[0]['id'])
        .update({
          'alamat': controllerEditAlamat.text,
          'nomor_hp': controllerEditNomorHP.text,
          'nama': controllerEditNama.text,
        });
      refreshData();
      msg = "Data profil berhasil di update";
    } catch(e){
      msg = "Data profil gagal di update: $e";
    }
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void close(BuildContext contexts){
    Navigator.pop(contexts);
  }

  void save(BuildContext contexts){
    saveData(
      contexts
    );
    Navigator.pop(contexts);
  }
  
  void updateControllerEditProfil(){
    setState(() {
      controllerEditNama.text = dataUser[0]['nama'];
      controllerEditAlamat.text = dataUser[0]['alamat'];
      controllerEditNomorHP.text =  dataUser[0]['nomor_hp'];
    });
  }

  @override
  Widget build(BuildContext context) {

  double divacieHeight = (MediaQuery.of(context).size.height)/600;


  Widget customInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            readOnly: true,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
  Widget formDeskripsi(String title, TextEditingController textControll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0), // sama kayak customInputField
            borderRadius: BorderRadius.circular(12),
          ),

          child: TextFormField(
            controller: textControll,
            maxLines: 5,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            readOnly: true,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              hintText: "Masukkan $title",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget edit1({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
  Widget edit2(String title, TextEditingController textControll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
        const SizedBox(height: 6),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0), // sama kayak customInputField
            borderRadius: BorderRadius.circular(12),
          ),

          child: TextFormField(
            controller: textControll,
            maxLines: 5,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              hintText: "Masukkan $title",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget actionButtons(BuildContext contexts) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  close(contexts);
                },
                child: const Center(
                  child: Text(
                    "Batalkan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => save(contexts),
                child: const Center(
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void popupEditProfil(){
    updateControllerEditProfil();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color.fromARGB(93, 0, 0, 0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 63, 95, 111),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: const Color.fromARGB(156, 7, 18, 16),
                    child: 
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          edit1(label: "Nama", controller: controllerEditNama),
                          const SizedBox(height: 10),
                          edit1(label: "Nomor HP", controller: controllerEditNomorHP),
                          const SizedBox(height: 10),
                          edit2("Alamat", controllerEditAlamat),
                          const SizedBox(height: 10),
                          actionButtons(context)
                        ]
                      )
                    )
                  )
                )
              )
            );
          }
        );
      }
    );
  }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          height: 33 * divacieHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 118, 224, 131),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            children: [
              Spacer(),
              Text(
                "Profil",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
            ],
          ),
        )
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromARGB(156, 0, 0, 0),
          child: RefreshIndicator(
            onRefresh: () async {
              refreshData();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                customInputField(label: "Nama", controller: controllerNama),
                const SizedBox(height: 10),
                customInputField(label: "Email", controller: controllerEmail),
                const SizedBox(height: 10),
                customInputField(label: "Nomor HP", controller: controllerNomorHP),
                const SizedBox(height: 10),
                formDeskripsi("Alamat", controllerAlamat),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                  height: 33 * divacieHeight,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 139, 245, 122),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: InkWell(
                    onTap: (){
                      popupEditProfil();
                    },
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Edit profil",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                  height: 33 * divacieHeight,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 255, 118),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: InkWell(
                    onTap: (){
                      resetPassword(dataUser[0]['email']);
                    },
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Reset password",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                  height: 33 * divacieHeight,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 98, 98),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: InkWell(
                    onTap: (){
                      logout(context);
                    },
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                )
              ],
            ),
          )
        )
      )
    );


  }
}

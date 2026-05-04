
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyek_3/login/auth_service.dart';
import 'package:proyek_3/login/daftar.dart';
import 'package:proyek_3/login/login.dart';
import 'package:proyek_3/navbar.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class HalamanResetPassword extends StatefulWidget{

  const HalamanResetPassword({super.key});

  @override
  State<HalamanResetPassword> createState() => _HalamanResetPasswordState();

}

class _HalamanResetPasswordState extends State<HalamanResetPassword> {

  void pindahKeHalamanLogin(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanLogin(),
      ),
    );

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

  Widget formEmailPassword(
      double divacieHeight,
      double maxWidth
  ){
    return Container( color: Colors.transparent, 
      height: 90 * divacieHeight,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: 
      Form(

      child: Column(
        children: [ 
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text("Email", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * divacieHeight,
                    color: Colors.white),)
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: 30 * divacieHeight,
                width: maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Color.fromRGBO(216, 216, 221, 100),
                ),
                child:  TextFormField(
                  textAlignVertical: TextAlignVertical.center, 
                  controller: emailController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Email tidak boleh kosong";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 112, 112, 112), width: 2), // saat diklik
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10), // atur padding
                  )
                ),
              ),
            ],
          ),
          
        ]
      ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    double divacieWidth = (MediaQuery.of(context).size.width)/300;
    double divacieHeight = (MediaQuery.of(context).size.height)/600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      body: 
      ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromARGB(156, 7, 18, 16),
          child: 
          SingleChildScrollView(
          child: Container(
            height: 600 * divacieHeight,
            //color: Color.fromRGBO(203, 12, 13, 100),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/background/background_1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                  const Color.fromARGB(255, 56, 56, 56).withOpacity(0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 450 * divacieHeight,
                width: 250 * divacieWidth,
                color: const Color.fromARGB(121, 0, 0, 0),
                margin: EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    
                    //logo
                    Container( 
                      height: 80 * divacieHeight,
                      width: 80 * divacieHeight,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo_umkm/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              
                    //input email dan password
                    formEmailPassword(divacieHeight, maxWidth),

                    //button login
                    Container(
                      height: 45 * divacieHeight,
                      width: maxWidth,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 113, 238, 75), 
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child: ElevatedButton(onPressed: (){
                        resetPassword(emailController.text);
                      }, 
                        style: TextButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        child: Text("Kirim link", style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold, fontSize: 18 ),)
                      )
                    ),

                    //Button dan text membuat akun
                   Container(
                    margin: EdgeInsets.only(top: 5),
                      child: ElevatedButton(
                        onPressed: () { pindahKeHalamanLogin(); },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah selesai? Mau kembali ke halaman login?",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12 * divacieHeight,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            Text(
                              " Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12 * divacieHeight,
                                color: Color.fromRGBO(96, 255, 48, 1),
                              ),
                            ),
                          ],
                        ),
                    ),
                  )
                  ],
                ),
              ),
            ),
          ),
          )
        )
      )
      )
    );

  }


}

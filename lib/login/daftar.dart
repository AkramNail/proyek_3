import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyek_3/login/login.dart';

TextEditingController namaController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nohpController = TextEditingController();
TextEditingController alamatController = TextEditingController();

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class InputData extends StatelessWidget {
  //double DivacieWidth;
  double divacieHeight;
  double maxWidth;
  //double maxHeight;

  String judul;
  TextEditingController controllers;

  InputData({
    super.key,
    required this.divacieHeight,
    required this.maxWidth,
    required this.judul,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // input nama
        Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            judul,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12 * divacieHeight,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          height: 30 * divacieHeight,
          width: maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Color.fromRGBO(216, 216, 221, 100),
          ),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: controllers,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email tidak boleh kosong";
              }
              return null;
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 112, 112, 112),
                  width: 2,
                ), // saat diklik
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
              ), // atur padding
            ),
          ),
        ),
      ],
    );
  }
}

class FormData extends StatelessWidget {
  //double DivacieWidth;
  double divacieHeight;
  double maxWidth;
  //double maxHeight;

  FormData({super.key, required this.divacieHeight, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 410 * divacieHeight,
      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
      child: Form(
        child: Column(
          children: [
            //input nama
            InputData(
              divacieHeight: divacieHeight,
              maxWidth: maxWidth,
              judul: "Nama",
              controllers: namaController,
            ),

            //input email
            InputData(
              divacieHeight: divacieHeight,
              maxWidth: maxWidth,
              judul: "Email",
              controllers: emailController,
            ),

            //input password
            InputData(
              divacieHeight: divacieHeight,
              maxWidth: maxWidth,
              judul: "Passowrd",
              controllers: passwordController,
            ),

            //input no hp
            InputData(
              divacieHeight: divacieHeight,
              maxWidth: maxWidth,
              judul: "No hp",
              controllers: nohpController,
            ),

            //input deskripsi
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12 * divacieHeight,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 120 * divacieHeight,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color.fromRGBO(216, 216, 221, 100),
                  ),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: alamatController,
                    maxLines: 5, // bisa lebih dari 1 → jadi textarea
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Masukkan alamat...",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      fontSize: 13, // ukuran font
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLoginGoogle extends StatelessWidget {
  double divacieHeight;
  double maxWidth;

  ButtonLoginGoogle({
    super.key,
    required this.divacieHeight,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45 * divacieHeight,
      width: maxWidth,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: SvgPicture.asset(
          'assets/icon/google.svg',
          width: 17,
          height: 17,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _HalamanDaftarState extends State<HalamanDaftar> {


  void pindahKeHalamanLogin(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanLogin(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    double divacieWidth = (MediaQuery.of(context).size.width) / 300;
    double divacieHeight = (MediaQuery.of(context).size.height) / 600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromARGB(156, 7, 18, 16),
          child: SingleChildScrollView(
            child: Container(
              height: 760 * divacieHeight,
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
                    height: 650 * divacieHeight,
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
                        FormData(
                          divacieHeight: divacieHeight,
                          maxWidth: maxWidth,
                        ),

                        //button login
                        Container(
                          height: 45 * divacieHeight,
                          width: maxWidth,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 113, 238, 75),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              "Buat akun",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        //Button dan text login
                        Container(
                          height: 20,
                          margin: EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            onPressed: () { pindahKeHalamanLogin(); },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * divacieHeight,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                                Text(
                                  " Log in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * divacieHeight,
                                    color: Color.fromRGBO(96, 255, 48, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyek_3/login/daftar.dart';
import 'package:proyek_3/navbar.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class HalamanLogin extends StatefulWidget{

  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();

}

class FormEmailPassword extends StatelessWidget{

  //double DivacieWidth;
  double divacieHeight;
  double maxWidth;
  //double maxHeight;

  FormEmailPassword({super.key, required this.divacieHeight, required this.maxWidth,});

  @override
  Widget build(BuildContext context){
    return 
      Container( color: Colors.transparent, 
        height: 160 * divacieHeight,
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text("Password", 
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
                    controller: passwordController,
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
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: Text(
                  "Forget password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * divacieHeight,
                    color: Color.fromRGBO(96, 255, 48, 1)
                  ),
                ),
              ),
            )
            
          ]
        ),
        )
      );
  }

}

class ButtonLoginGoogle extends StatelessWidget{
  
  double divacieHeight;
  double maxWidth;

  ButtonLoginGoogle({super.key, required this.divacieHeight, required this.maxWidth});

  @override
  Widget build(BuildContext context){
    return Container(
      height: 45 * divacieHeight,
      width: maxWidth,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey, 
        borderRadius: BorderRadius.circular(7)
      ),
      child: ElevatedButton(onPressed: (){}, 
        style: TextButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: SvgPicture.asset(
          'assets/icon/google.svg',
          width: 17,
          height: 17,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        )
      )
    );
  }

}



class _HalamanLoginState extends State<HalamanLogin> {

  void pindahKeHalamanDaftar(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanDaftar(),
      ),
    );

  }

  void mengverivikasiEmailDanPassword(String inputEmail, String inputPassword){

    if(inputEmail == "udin@gmail.com" && inputPassword == "123"){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavbarUser(),
        ),
      );

    }

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
                    FormEmailPassword(divacieHeight: divacieHeight, maxWidth: maxWidth),

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
                        mengverivikasiEmailDanPassword(emailController.text, passwordController.text);
                      }, 
                        style: TextButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        child: Text("Login", style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold, fontSize: 18 ),)
                      )
                    ),

                    //text login with
                    Container(
                      margin: EdgeInsets.only(top: 5),  
                      child: Text("Or login with:", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12 * divacieHeight,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          )
                        ),
                      
                    ),
                    

                    //Button login with google
                    ButtonLoginGoogle(divacieHeight: divacieHeight, maxWidth: maxWidth),

                    //Button dan text membuat akun
                    Container(
                      height: 20,
                      margin: EdgeInsets.only(top: 5),
                      child: ElevatedButton(onPressed: (){ pindahKeHalamanDaftar(); }, 
                        style: TextButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12 * divacieHeight,
                              color: Color.fromRGBO(255, 255, 255, 1),)),
                            Text(" Sign up", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12 * divacieHeight,
                                color: Color.fromRGBO(96, 255, 48, 1),)) , 
                          ],
                      )    
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


import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyek_3/api.dart';

class HalamanOrder extends StatelessWidget {

  final PersistentTabController controller;

  HalamanOrder({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    Api api = Api();

    double divacieWidth = (MediaQuery.of(context).size.width)/300;
    double divacieHeight = (MediaQuery.of(context).size.height)/600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

    Widget buttonKategoriOrder(String titleButton){
      return Container(
        margin: const EdgeInsets.only(right: 8),
        padding: EdgeInsets.only(left: 5, right: 5),
        height: 30 * divacieHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Center(
          child: Text(titleButton, style: TextStyle(
            color: const Color.fromARGB(255, 70, 253, 158),
          ),),
        ),
      );
    }

    Widget kategoriOrder(){

      return  Container(
        margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buttonKategoriOrder("Semua"),
              buttonKategoriOrder("Diproses"),
              buttonKategoriOrder("Dikirim"),
              buttonKategoriOrder("Selesai"),
              buttonKategoriOrder("Dibuat"),
            ]
          ),
        )
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
              
              IconButton(
                onPressed: () {
                  controller.jumpToTab(0);
                },
                icon: SvgPicture.asset(
                  "assets/icon/back.svg",
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(const Color.fromARGB(255, 0, 0, 0), BlendMode.srcIn),
                ),
              ),

              Text(
                "Orders",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ),
      body: Container(
        color: Color.fromRGBO(29, 255, 210, 1),
        child: kategoriOrder(),
      ),
    );


  }
}


import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

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

  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromARGB(156, 0, 0, 0),
          child: RefreshIndicator(
            onRefresh: () async {
              //refreshData();
            },
            child: Column(children: [
              customInputField(label: "Nama", controller: controllerNama),
              customInputField(label: "Email", controller: controllerNama),
              customInputField(label: "Nomor HP", controller: controllerNama),
              customInputField(label: "Alamat", controller: controllerNama),
            ],)
          )
        )
      )
    );


  }
}

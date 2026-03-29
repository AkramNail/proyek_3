
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HalamanProduk extends StatefulWidget{

  final String namaProduk;
  final String kategoriProduk;
  final String bahanProduk;
  final String deskripsiProduk;
  final String hargaProduk;
  final List<String> ukuranProduk;
  final List<String> daftarGambar;

  const HalamanProduk({super.key, 
    required this.namaProduk, 
    required this.kategoriProduk, 
    required this.bahanProduk, 
    required this.deskripsiProduk, 
    required this.hargaProduk, 
    required this.ukuranProduk,
    required this.daftarGambar,

  });

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();

}

class _HalamanProdukState extends State<HalamanProduk> {



  Widget gambarProduk(double divacieHeight){
    return Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: CarouselSlider(items: widget.daftarGambar.map((item)
          => Container(
            height: 100 * divacieHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(item),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ).toList()
        ,options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayInterval: Duration(seconds: 5),
          viewportFraction: 0.8

        )),
      ),
    );
  }

  Widget textKategori(double divacieHeight) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 8, start: 20, end: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5.0,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(top: 10),
            child: Text(
              widget.kategoriProduk,
              style: TextStyle(
                fontSize: 12 * divacieHeight,
                color: const Color.fromARGB(255, 94, 94, 94),
                fontWeight: FontWeight.normal,
              ),
            ), 
          ),
          Text(widget.namaProduk,
            style: TextStyle(
              fontSize: 15 * divacieHeight,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Size",
            style: TextStyle(
              fontSize: 12 * divacieHeight,
              color: const Color.fromARGB(255, 123, 123, 123),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetUkuranProduk(double divacieHeight) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsetsDirectional.only(bottom: 8, start: 20, end: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: 
        Row(
          children: [
            Row(
              children: widget.ukuranProduk.map((ukuran) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 35 * divacieHeight,
                  width: 35 * divacieHeight,
                  color: const Color.fromARGB(255, 212, 227, 224),
                  child: Center(
                    child: Text(ukuran),
                  ),
                );
              }).toList(),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 35 * divacieHeight,
              width: 80 * divacieHeight,
              color: const Color.fromARGB(255, 212, 227, 224),
              child: Center(
                child: Text("Check size detail", style: TextStyle(
                  color: Colors.black,
                  fontSize: 8 * divacieHeight
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textBahan(double divacieHeight){
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsetsDirectional.only(bottom: 3, start: 20, end: 20),
          child: Text("Bahan: ${widget.bahanProduk}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15 * divacieHeight
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsetsDirectional.only(bottom: 8, start: 20, end: 20),
          child: Text(widget.deskripsiProduk,
            style: TextStyle(
              color: const Color.fromARGB(255, 84, 84, 84),
              fontSize: 13 * divacieHeight
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    double divacieWidth = (MediaQuery.of(context).size.width)/300;
    double divacieHeight = (MediaQuery.of(context).size.height)/600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            "assets/icon/back.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(const Color.fromARGB(255, 0, 0, 0), BlendMode.srcIn),
          ),
        ),
        title: Text(
          "Detail produk",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: 
      
      ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromARGB(156, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              children:[
                //Gambar produk
                gambarProduk(divacieHeight),
                textKategori(divacieHeight),
                widgetUkuranProduk(divacieHeight),
                textBahan(divacieHeight),
              ]
            ),
          )
        )
      )
    );


  }
}

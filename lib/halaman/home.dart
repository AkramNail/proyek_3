
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proyek_3/halaman/cart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:proyek_3/halaman/produk/produk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class HalamanHome extends StatefulWidget {
  final PersistentTabController controller;

  const HalamanHome({super.key, required this.controller});

  @override
  State<HalamanHome> createState() => _HalamanHomeState();
}

class _HalamanHomeState extends State<HalamanHome> {

  List<Map<String, dynamic>> listProduk = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getSnapToken(int amount) async {
    final response = await http.post(
      Uri.parse("https://us-central1-proyek3-37bb7.cloudfunctions.net/createTransaction"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"amount": amount}),
    );

    final data = jsonDecode(response.body);
    return data["token"];
  }

  Future<void> getData() async {
    try {
      // 1. Get Firestore Snapshot
      var snapshot = await FirebaseFirestore.instance
        .collection('produk')
        .limit(6)
        .get();

      List<Map<String, dynamic>> temporaryList = [];

      for (var doc in snapshot.docs) {
        try {
          Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;

          if (data['foto'] != null && data['foto'] is List && (data['foto'] as List).isNotEmpty) {
            List<String> fileNames = List<String>.from(data['foto']);
            
            // 2. Fetch URLs with individual error handling
            List<String> fullUrls = await Future.wait(
              fileNames.map((name) async {
                try {
                  return await getImageUrl(name);
                } catch (e) {
                  print("Error getting URL for $name: $e");
                  return "https://via.placeholder.com/150"; // Fallback URL
                }
              }),
            );
            
            data['foto'] = fullUrls;
          } else {
            data['foto'] = []; // Ensure it's an empty list, not null
          }

          temporaryList.add(data);
        } catch (itemError) {
          print("Error processing document ${doc.id}: $itemError");
        }
      }

      // 3. Safety check before updating UI
      if (mounted) {
        setState(() {
          listProduk = temporaryList;
          print(listProduk);
          final user = FirebaseAuth.instance.currentUser;
          print(user);
        });
      }
    } catch (globalError) {
      print("GLOBAL ERROR in getData: $globalError");
    }
  }

  Future<String> getImageUrl(String imageName) async {
    // If imageName is empty or null, return a placeholder immediately
    if (imageName.isEmpty) return "https://via.placeholder.com/150";

    final ref = FirebaseStorage.instance.ref().child(imageName);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {

    double divacieWidth = (MediaQuery.of(context).size.width)/300;
    double divacieHeight = (MediaQuery.of(context).size.height)/600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

    List<String> banners = [
      'assets/banner/Banner_1.png',
      'assets/banner/Banner_2.png',
      'assets/banner/Banner_3.png',
      'assets/banner/Banner_4.png'
    ];

    //List<String> listYanto = ["L", "XXL", "XXXL"];
    List<String> listGambar = ["assets/baju/1.jpg", "assets/baju/2.jpg"];

    void pindahHalamanKeCart(){
      widget.controller.jumpToTab(3);
    }
    void pindahHalamanKeInfo(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanCart(controller: widget.controller),
        ),
      );
    }
    void pindahHalamanKeSearch(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanCart(controller: widget.controller),
        ),
      );
    }
    
    void pindahHalamanProduk(
      String id,
      String namaProduk,
      String kategoriProduk,
      String bahanProduk,
      String deskripsiProduk,
      String hargaProduk,
      List<dynamic> stock,
      List<dynamic> ukuranProduk,
      List<dynamic> daftarGambar,
    ){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanProduk(
            id: id,
            namaProduk: namaProduk, 
            kategoriProduk: kategoriProduk,
            bahanProduk: bahanProduk,
            deskripsiProduk: deskripsiProduk,
            hargaProduk: hargaProduk,
            stock: stock,
            ukuranProduk: ukuranProduk,
            daftarGambar: daftarGambar,
          ),
        ),
      );
    }

    Widget iconTopBar(String path, Function halaman) {
      return 
      SizedBox(
        width: 25,
        child: ElevatedButton(
          onPressed: () {
            halaman();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
          ),
          child: SvgPicture.asset(
            path,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      );
    }

    Widget buttonKategori(String text){

      return Container(
        height: 20,
        width: 60,
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(text, style: TextStyle(
            fontSize: 11,
            color: Colors.white, 
            fontWeight: FontWeight.bold),),
        )
      );
    }

    Widget textKategori() {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 8, start: 20, end: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Category",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("See All",
              style: TextStyle(
                fontSize: 13,
                color: const Color.fromARGB(255, 255, 15, 15),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    Widget cardProduk(
      String id,
      String namaProduk,
      String kategoriProduk,
      String bahanProduk,
      String deskripsiProduk,
      String hargaProduk,
      List<dynamic> stock,
      List<dynamic> ukuranProduk,
      List<dynamic> daftarGambar,
    ){

      return 
      Container(
        margin: const EdgeInsets.all(7.0),
        padding: EdgeInsets.only(bottom: 7),
        width: 0.4 * maxWidth,
        color: const Color.fromARGB(42, 175, 175, 175),
        child: ElevatedButton(
            onPressed: () { pindahHalamanProduk(
              id,
              namaProduk,
              kategoriProduk,
              bahanProduk,
              deskripsiProduk,
              hargaProduk,
              stock,
              ukuranProduk,
              daftarGambar
            ); },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              minimumSize: Size(double.infinity, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(7.0),
                  height: 0.2 * maxHeight,
                  width: 0.3 * maxHeight,
                  child: Image.network(
                    (daftarGambar.isNotEmpty && daftarGambar[0].toString().startsWith('http'))
                      ? daftarGambar[0]
                      : 'https://via.placeholder.com/150',
                      cacheWidth: 300, // Limits the resolution in memory
                      cacheHeight: 300,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                ),

                Text(kategoriProduk, style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),),

                Text(namaProduk, style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),),

                Text(hargaProduk, style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.redAccent,
                ),),

              ], 

            ),

          ),

        );

    }

    Widget kumpulanProduk(){
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 15, top: 0),
        child: 
        Column(
          children: 
          List.generate(listProduk.length, (index) {

            if (index % 2 != 0) return SizedBox();

            return Row(
              //disini
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                cardProduk(
                  listProduk[index]['id'],
                  listProduk[index]['nama_produk'],
                  listProduk[index]['kategori'],
                  listProduk[index]['bahan_produk'],
                  listProduk[index]['deskripsi_produk'],
                  listProduk[index]['harga_produk'].toString(),
                  listProduk[index]['jumlah_produk'],
                  listProduk[index]['ukuran'],
                  listProduk[index]['foto']
                ),

                (index < listProduk.length - 1)
                
                ? cardProduk(
                  listProduk[index + 1]['id'],
                  listProduk[index + 1]['nama_produk'],
                  listProduk[index + 1]['kategori'],
                  listProduk[index + 1]['bahan_produk'],
                  listProduk[index + 1]['deskripsi_produk'],
                  listProduk[index + 1]['harga_produk'].toString(),
                  listProduk[index + 1]['jumlah_produk'],
                  listProduk[index + 1]['ukuran'],
                  listProduk[index + 1]['foto']
                )
                : Container()
            ],);
           }),
        )
      );      
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Container( 
              height: 38 * divacieHeight,
              width: 38 * divacieHeight,
              margin: EdgeInsets.only(left: 1, right: 1, top: 1),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo_umkm/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 160.0,
                ), 
                child: SizedBox(
                  width: 500,
                  child: Text(" Vibes.Ind", style: 
                    TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
            ),
  
            Row(
              children: [
                iconTopBar("assets/icon/search.svg", pindahHalamanKeSearch),
                iconTopBar("assets/icon/cart.svg", pindahHalamanKeCart),
                iconTopBar("assets/icon/bell.svg", pindahHalamanKeInfo),
              ],
            )
          ],
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
              children: [
                
                //banner
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                      const Color.fromARGB(255, 56, 56, 56).withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                  child: Center(
                    child: CarouselSlider(items: banners.map((item)
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
                      height: 100,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayInterval: Duration(seconds: 7),
                      viewportFraction: 0.8

                    )),
                  ),
                ),

                //nav kategori
                Column(
                  children: [
                    textKategori(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buttonKategori("T-shirt"), 
                        buttonKategori("Pants"),
                        buttonKategori("Shirt"),
                        buttonKategori("Cap"),
                      ]
                    ),
                  ],
                ),

                //Text sepecial offer
                Container(
                  margin: EdgeInsetsDirectional.only(bottom: 4, start: 20, end: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Special for you",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("See All",
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 255, 15, 15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //kumpulan produk
                kumpulanProduk()
              ],
            )
          )
        )
      )
    );

  }

}
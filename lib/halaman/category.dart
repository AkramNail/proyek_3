
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyek_3/halaman/home.dart';
import 'package:proyek_3/halaman/produk/produk.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


class HalamanKategori extends StatefulWidget {
  final PersistentTabController controller;

  const HalamanKategori({super.key, required this.controller});

  @override
  State<HalamanKategori> createState() => _HalamanKategori();
}

class _HalamanKategori extends State<HalamanKategori> {

  List<Map<String, dynamic>> listProduk = [];
  List<String> listKategori = ["0"];

  List<int> listTextIndikator = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void ubahKategori(String kategori){
    if(kategori == ""){
      List<int> temporaryList = [];
      int index = 0;
      listProduk.forEach((produk) {
        temporaryList.add(index);
        index += 1;
      });
      setState(() {
        listTextIndikator = temporaryList;
        print(listTextIndikator);
      });
    }else{
      List<int> temporaryList = [];
      int index = 0;
      listProduk.forEach((produk) {
        if(produk['kategori'] == kategori){
          temporaryList.add(index);
        }
        index += 1;
      });
      setState(() {
        listTextIndikator = temporaryList;
        print(listTextIndikator);
      });
    }
  }

    Future<String> getImageUrl(String imageName) async {
      // If imageName is empty or null, return a placeholder immediately
      if (imageName.isEmpty) return "https://via.placeholder.com/150";

      final ref = FirebaseStorage.instance.ref().child(imageName);
      return await ref.getDownloadURL();
    }

    Future<void> getData() async {
      try {
        // 1. Get Firestore Snapshot
        var snapshot = await FirebaseFirestore.instance
          .collection('produk')
          .limit(12)
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

        var dataKategori = await FirebaseFirestore.instance
          .collection('kategori')
          .get();

        List<String> temporaryListKategori = [];

        for (var doc in dataKategori.docs) {
          try {
            temporaryListKategori.add(doc['kategori']);
          
          } catch (itemError) {
            print("Error processing document ${doc.id}: $itemError");
          }
        }

        // 3. Safety check before updating UI
        if (mounted) {
          setState(() {
            listProduk = temporaryList;
            listKategori = temporaryListKategori;
            ubahKategori("");
            print(listProduk);
            print(listKategori);
          });
        }
      } catch (globalError) {
        print("GLOBAL ERROR in getData: $globalError");
      }
    }

  @override
  Widget build(BuildContext context) {

    double divacieWidth = (MediaQuery.of(context).size.width)/300;
    double divacieHeight = (MediaQuery.of(context).size.height)/600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

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
            ukuranProduk: ukuranProduk,
            daftarGambar: daftarGambar,
            stock: stock,
          ),
        ),
      );
    }

    Widget buttonKategoriPopup(String namaKategori){
      return GestureDetector(
        onTap: () {
          ubahKategori(namaKategori);
        },
        child: Container(
          height: 30,
          width: double.infinity,
          margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
            child: Text(
              namaKategori,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      );
    }

    void popupSemuaKategori() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 214, 214, 214),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: listKategori
                              .map((kategori) =>
                                  buttonKategoriPopup(kategori))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: const Color.fromARGB(255, 216, 255, 242),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          minimumSize: Size(double.infinity, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("Tutup", style: TextStyle(
                          color: Colors.black,
                          fontSize: 15
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Widget buttonKategori(String namaKategori){

      return GestureDetector(
        onTap: () {
          ubahKategori(namaKategori);
        },
        child: Container(
          height: 20,
          width: 60,
          margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
            child: Text(
              namaKategori,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      );
    }

    Widget lihatSemuaKategori(){

      return GestureDetector(
        onTap: () {
          //popupSemuaKategori();
          ubahKategori("");
        },
        child: Container(
          height: 20,
          width: 60,
          margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
            child: Text(
              "See all",
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      );
    }

    Widget kategori() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(listKategori.length, (index) {
                  return buttonKategori(listKategori[index]);  
                })
              ),
            ),
          ),
          lihatSemuaKategori()
        ],
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
              daftarGambar,
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

    Widget daftarProduk(List listIndikator){
      
      return Column(
        children: 
          List.generate(listIndikator.length, (index) {

            if (listProduk.isEmpty) return SizedBox();

            return 
            (index % 2 == 0)
            ? Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                cardProduk(
                  listProduk[listIndikator[index]]['id'],
                  listProduk[listIndikator[index]]['nama_produk'],
                  listProduk[listIndikator[index]]['kategori'],
                  listProduk[listIndikator[index]]['bahan_produk'],
                  listProduk[listIndikator[index]]['deskripsi_produk'],
                  listProduk[listIndikator[index]]['harga_produk'].toString(),
                  listProduk[listIndikator[index]]['jumlah_produk'],
                  listProduk[listIndikator[index]]['ukuran'],
                  listProduk[listIndikator[index]]['foto']
                ),

                (index < listIndikator.length - 1)
                
                ? cardProduk(
                  listProduk[listIndikator[index + 1]]['id'],
                  listProduk[listIndikator[index + 1]]['nama_produk'],
                  listProduk[listIndikator[index + 1]]['kategori'],
                  listProduk[listIndikator[index + 1]]['bahan_produk'],
                  listProduk[listIndikator[index + 1]]['deskripsi_produk'],
                  listProduk[listIndikator[index + 1]]['harga_produk'].toString(),
                  listProduk[listIndikator[index + 1]]['jumlah_produk'],
                  listProduk[listIndikator[index + 1]]['ukuran'],
                  listProduk[listIndikator[index + 1]]['foto']
                )
                : Container()
            ],)
            : Container();
           }),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            widget.controller.jumpToTab(0);
          },
          icon: SvgPicture.asset(
            "assets/icon/back.svg",
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(const Color.fromARGB(255, 0, 0, 0), BlendMode.srcIn),
          ),
        ),
        title: Text(
          "Category",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: 
          Column(
            children: [
              kategori(),
              daftarProduk(listTextIndikator)
            ],
          )
      ),
    );


  }
}

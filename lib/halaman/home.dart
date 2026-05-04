
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
  
  TextEditingController aiTextController = TextEditingController(text: "");

  List<Map<String, dynamic>> listProduk = [];
  Map<String, List<String>> aiListKategori = {};
  Map<String, List<String>> aiListBahan = {};
  Map<String, List<String>> aiListUkuran = {};
  Map<int, List<String>> aiListHarga = {};
  Map<int, List<String>> aiListJumlah = {};

  Map<String, List<String>> positifKategori = {};
  Map<String, List<String>> positifBahan = {};
  Map<String, List<String>> positifUkuran = {};
  Map<String, List<String>> positifHarga = {};
  Map<String, List<String>> positifJumlah = {};

  List<Map<String, dynamic>> produkYangDitampilkanDiAI = [];
  List<String> idProdukYangDitampilkanDiAISementara = [];

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
        .get();

      List<Map<String, dynamic>> temporaryList = [];

      Map<String, List<String>> temporaryListKategori = {};
      Map<String, List<String>> temporaryListBahan = {};
      Map<String, List<String>> temporaryListUkuran = {};
      Map<int, List<String>> temporaryListHarga = {};
      Map<int, List<String>> temporaryListJumlah = {};

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

          //bagian ai
          temporaryListBahan.putIfAbsent('${data['bahan_produk'].toLowerCase()}', () => []);
          temporaryListBahan.putIfAbsent('${data['bahan_produk'].toLowerCase()},', () => []);
          temporaryListBahan['${data['bahan_produk'].toLowerCase()}']!.add(data['id'].toString());
          temporaryListBahan['${data['bahan_produk'].toLowerCase()},']!.add(data['id'].toString());


          temporaryListKategori.putIfAbsent('${data['kategori'].toLowerCase()}', () => []);
          temporaryListKategori.putIfAbsent('${data['kategori'].toLowerCase()},', () => []);
          temporaryListKategori['${data['kategori'].toLowerCase()}']!.add(data['id'].toString());
          temporaryListKategori['${data['kategori'].toLowerCase()},']!.add(data['id'].toString());

          int harga = (data['harga_produk'] as num).toInt();
          temporaryListHarga.putIfAbsent(harga, () => []);
          temporaryListHarga[harga]!.add(data['id'].toString());

          // jumlah
          List<int> dataJumlah = List<int>.from(data['jumlah_produk']);
          for (var item in dataJumlah) {
            temporaryListJumlah.putIfAbsent(item, () => []);
            temporaryListJumlah[item]!.add(data['id'].toString());
          }

          // ukuran
          List<String> dataUkuran = List<String>.from(data['ukuran']);
          for (var item in dataUkuran) {
            temporaryListUkuran.putIfAbsent(item.toLowerCase(), () => []);
            temporaryListUkuran.putIfAbsent('${item.toLowerCase()},', () => []);
            temporaryListUkuran[item.toLowerCase()]!.add(data['id'].toString());
            temporaryListUkuran['${item.toLowerCase()},']!.add(data['id'].toString());
          }

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
          aiListUkuran = temporaryListUkuran;
          aiListJumlah = temporaryListJumlah;
          aiListBahan = temporaryListBahan;
          aiListKategori = temporaryListKategori;
          aiListHarga = temporaryListHarga;
          print("ukuran: $aiListUkuran");
          print("Jumlah: $aiListJumlah");
          print("Bahan: $aiListBahan");
          print("Kategori: $aiListKategori");
          print("Harga: $aiListHarga");
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

  Widget _productCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber
                /*
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/150"),
                  fit: BoxFit.cover,
                ),
                */
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "T-Shirt",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Black Vibes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "Rp. 70.000",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void cekListKategori(String input){
    aiListKategori.forEach((key, item){
      if(key == input){
        item.forEach((id){
          positifKategori[key] ??= []; 
          positifKategori[key]?.add(id);
        });
      }
    });
  }
  void cekListBahan(String input){
    aiListBahan.forEach((key, item){
      if(key == input){
        item.forEach((id){
          positifBahan[key] ??= []; 
          positifBahan[key]?.add(id);
        });
      }
    });
  }
  void cekListUkuran(String input){
    aiListUkuran.forEach((key, item){
      if(key == input){
        item.forEach((id){
          positifUkuran[key] ??= []; 
          positifUkuran[key]?.add(id);
        });
      }
    });
  }
  void cekListHarga(String input, int inputHarga){
    print("info: $input dan, Harga: $inputHarga");
    if(inputHarga != 9999999999999978){
      aiListHarga.forEach((key, item){
        switch(input){
          case('dibawah' || 'bawah'):
            if(inputHarga >= key){
              item.forEach((id){
                positifHarga['dibawah'] ??= []; 
                positifHarga['dibawah']?.add(id);
              });
            }
          break;
          case('' || 'kisaran' || 'antara'):
            if(
              inputHarga >= (key + 40000) &&
              inputHarga <= (key + 40000)
            ){
              item.forEach((id){
                positifHarga['kisaran'] ??= []; 
                positifHarga['kisaran']?.add(id);
              });
            }
          break;
          case('diatas' || 'atas'):
            if(inputHarga <= key){
              item.forEach((id){
                positifHarga['diatas'] ??= []; 
                positifHarga['diatas']?.add(id);
              });
            }
          break;
        }
      });
    }
  }
  void cekListJumlah(String input, int inputJumlah){
    if(inputJumlah != 9999999999999978){
      aiListJumlah.forEach((key, item){
        switch(input){
          case('dibawah' || 'bawah'):
            if(inputJumlah >= key){
              item.forEach((id){
                positifJumlah['dibawah'] ??= []; 
                positifJumlah['dibawah']?.add(id);
              });
            }
          break;
          case('' || 'kisaran' || 'antara'):
            if(
              inputJumlah >= (key + 40000) &&
              inputJumlah <= (key + 40000)
            ){
              item.forEach((id){
                positifJumlah['kisaran'] ??= []; 
                positifJumlah['kisaran']?.add(id);
              });
            }
          break;
          case('diatas' || 'atas'):
            if(inputJumlah <= key){
              item.forEach((id){
                positifJumlah['diatas'] ??= []; 
                positifJumlah['diatas']?.add(id);
              });
            }
          break;
        }
      });
    }
  }
  void memasukanKedataSementara(Map<String, List<String>> listnya){
    listnya.forEach((key, value) {
      value.forEach((idAda){
        if(idProdukYangDitampilkanDiAISementara.isEmpty){
          idProdukYangDitampilkanDiAISementara.add(idAda);
        }else{
          bool isIdBisaMasuk = true;
          idProdukYangDitampilkanDiAISementara.forEach((item){
            if(item == idAda){
              isIdBisaMasuk = false;
            }
          });
          if(isIdBisaMasuk == true){
            idProdukYangDitampilkanDiAISementara.add(idAda);
          }
        }
      });
      print(value);
    });
  }
  Future<void> algoritmaPencarian(String input) async{

    produkYangDitampilkanDiAI = [];
    idProdukYangDitampilkanDiAISementara = [];

    positifKategori = {};
    positifBahan = {};
    positifUkuran = {};
    positifHarga = {};
    positifJumlah = {};

    print("yang masuk: $input");
    int indexStart = 0;
    int indexSekarang = 0;
    input.toLowerCase();
    List<String> dataInput = input.split(" ");
    dataInput.forEach((item){
      
      print("word: $item");
      if(item == 'kategori' || item == 'kategori,'){
        for (var i = indexStart; i < dataInput.length; i++) {
          if(dataInput[i] == 'jangan'){
            break;
          }
          cekListKategori(dataInput[i]);
        }
      }

      if(item == 'bahan' || item == 'bahan,'){
        indexStart = indexSekarang;
        for (var i = indexStart; i < dataInput.length; i++) {
          if(dataInput[i] == 'jangan'){
            break;
          }
          cekListBahan(dataInput[i]);
        }
      }

      if(item == 'ukuran' || item == 'ukuran,'){
        indexStart = indexSekarang;
        for (var i = indexStart; i < dataInput.length; i++) {
          if(dataInput[i] == 'jangan'){
            break;
          }
          cekListUkuran(dataInput[i]);
        }
      }

      if(item == 'harga' || item == 'harga,'){
        indexStart = indexSekarang;
        String casenya = "";
        for (var i = indexStart; i < dataInput.length; i++) {
          switch(dataInput[i]){
            case('dibawah' || 'bawah'):
              casenya = "bawah";
            break;
            case('kisaran' || 'antara'):
              casenya = "antara";
            break;
            case('diatas' || 'atas'):
              casenya = "atas";
            break;
          }
          cekListHarga(casenya, int.tryParse(dataInput[i]) ?? 9999999999999978);
        }
      }

      if(item == 'jumlah' || item == 'jumlah,' || item == 'stock' || item == 'stock,'){
        indexStart = indexSekarang;
        String casenya = "";
        for (var i = indexStart; i < dataInput.length; i++) {
          switch(dataInput[i]){
            case('dibawah' || 'bawah'):
              casenya = "bawah";
            break;
            case('kisaran' || 'antara'):
              casenya = "antara";
            break;
            case('diatas' || 'atas'):
              casenya = "atas";
            break;
          }
          cekListJumlah(casenya, int.tryParse(dataInput[i]) ?? 9999999999999978);
        }
      }

      indexSekarang += 1;
    });

    memasukanKedataSementara(positifKategori);

    print("Kategori: $positifKategori");
    print("Harga: $positifHarga");
    print("ukuran: $positifUkuran");
    print("Jumlah: $positifJumlah");
    print("Bahan: $positifBahan");

  }
  void popupAi(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color.fromARGB(47, 0, 0, 0),
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // 🔍 SEARCH BAR
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: aiTextController,
                                decoration: InputDecoration(
                                  hintText: "Ketik apa yang anda cari",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                algoritmaPencarian(aiTextController.text);
                              },
                              child: Icon(Icons.send),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 💬 CONTENT
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Chat Bubble
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.smart_toy, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Saya menemukan 5 produk dengan kriteria yang anda sampaikan",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 🛍️ GRID
                              Expanded(
                                child: GridView.builder(
                                  itemCount: 5,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.72,
                                  ),
                                  itemBuilder: (context, index) {
                                    return _productCard();
                                  },
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
            );
          }
        );
      }
    );
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

    void showAiDialog(BuildContext context) {
      popupAi();
    }

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
      showAiDialog(context);
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
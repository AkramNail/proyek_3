
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HalamanProduk extends StatefulWidget{

  final String id;
  final String namaProduk;
  final String kategoriProduk;
  final String bahanProduk;
  final String deskripsiProduk;
  final String hargaProduk;
  final List<dynamic> stock;
  final List<dynamic> ukuranProduk;
  final List<dynamic> daftarGambar;

  const HalamanProduk({super.key, 
    required this.id, 
    required this.namaProduk, 
    required this.kategoriProduk, 
    required this.bahanProduk, 
    required this.deskripsiProduk, 
    required this.hargaProduk, 
    required this.ukuranProduk,
    required this.daftarGambar,
    required this.stock,

  });

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();

}

class _HalamanProdukState extends State<HalamanProduk> {
  
  TextEditingController jumlahController = TextEditingController(text: "0");
  int selectedIndex = 0;
  int stockIndexSekarang = 0;

  Future<void> tambahCart(String tipe) async{

    String msg = "";
    if(int.parse(jumlahController.text) <= widget.stock[selectedIndex]){
      if(int.parse(jumlahController.text) > 0){

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String idDoc = DateTime.now().millisecondsSinceEpoch.toString();
        await FirebaseFirestore.instance
          .collection('cart')
          .doc(idDoc)
          .set({
            'jumlah': int.parse(jumlahController.text),
            'pembeli': user.uid,
            'produk': widget.id,
            'ukuran': widget.ukuranProduk[selectedIndex],
            'tipe': tipe
          });
        msg = "Produk berhasil di tambah ke cart";
      }

      }else{
        msg = "Mohon maaf jumlah produk tidak boleh 0";
      }
    }else{
      msg = "Mohon maaf jumlah yang anda pilih melebihi stock";
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

  void showPopupPenjualan(BuildContext context, List<dynamic> sizes) {
    selectedIndex = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F5F6F),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    const Text(
                      "Klik ukuran yang ingin anda beli",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 16),

                    /// SIZE BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(sizes.length, (index) {
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              sizes[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    /// TEXT
                    const Text(
                      "Masukan berapa banyak yang ingin anda beli",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 12),

                    /// INPUT QTY
                    Container(
                      width: 90,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        controller: jumlahController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTONS
                    Row(
                      children: [
                        /// KEMBALI (MERAH)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF3D57),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Kembali",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// TAMBAH (HIJAU)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tambahCart("penjualan");
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10A56F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Tambah",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void updateJumlahStock(String ukuran){
    int index = 0;
    widget.ukuranProduk.forEach((item){
      if(item == ukuran){
        setState(() {        
          stockIndexSekarang = index;
        });
      }
      index += 1;
    });
  }

  void showPopupOrder(BuildContext context, List<dynamic> sizes) {
    selectedIndex = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F5F6F),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    const Text(
                      "Klik ukuran yang ingin anda order",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 16),

                    /// SIZE BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(sizes.length, (index) {
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              sizes[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    /// TEXT
                    const Text(
                      "Masukan berapa banyak yang ingin anda order",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 12),

                    /// INPUT QTY
                    Container(
                      width: 90,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        controller: jumlahController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTONS
                    Row(
                      children: [
                        /// KEMBALI (MERAH)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF3D57),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Kembali",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// TAMBAH (HIJAU)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              tambahCart("order");
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10A56F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Tambah",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget gambarProduk(double divacieHeight){
    return Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: CarouselSlider(items: widget.daftarGambar.map((item)
          => Container(
            height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
            width: double.infinity,
            child: ClipRRect( // To keep the "BoxDecoration" rounded corner look
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item,
                fit: BoxFit.cover,
                // VERY IMPORTANT: This prevents freezing by resizing image in memory
                cacheWidth: 400, 
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          )
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
      margin: EdgeInsetsDirectional.only(bottom: 8, start: 20, end: 10),
      child: Row(
        children: [
          SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: 
            Row(
              children: widget.ukuranProduk.map((ukuran) {
                return InkWell(
                  onTap: (){
                    updateJumlahStock(ukuran);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 35 * divacieHeight,
                    width: 35 * divacieHeight,
                    color: const Color.fromARGB(255, 212, 227, 224),
                    child: Center(
                      child: Text(ukuran),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          Spacer(),

          InkWell(
            onTap: () {
              
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              height: 35 * divacieHeight,
              width: 100 * divacieHeight,
              color: const Color.fromARGB(0, 212, 227, 224),
              child: Center(
                child: Text("Check size detail", style: TextStyle(
                  color: Colors.black,
                  fontSize: 10 * divacieHeight
                ),),
              ),
            ),
          )
        ]
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
      ],
    );
  }

  Widget textStock(double divacieHeight){
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsetsDirectional.only(bottom: 3, start: 20, end: 20),
          child: Text("Stock: ${widget.stock[stockIndexSekarang]}",
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

  Widget bagianHarga() {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 8, start: 20, end: 20),
      child: Row(
        children: [

          // Text total dan harga
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.hargaProduk,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 61, 61),
                ),
              ),
            ],
          ),

          Spacer(),
          widget.stock[stockIndexSekarang] > 0
          // Button Add to Cart (full clickable)
            ? InkWell(
              onTap: () {
                showPopupPenjualan(context, widget.ukuranProduk);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 10, 207, 131),
                ),
                child: Row(
                  children: [
                    Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      "assets/icon/shope.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : InkWell(
              onTap: () {
                showPopupOrder(context, widget.ukuranProduk);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 10, 207, 131),
                ),
                child: Row(
                  children: [
                    Text(
                      "Order produk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      "assets/icon/shope.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double divacieHeight = (MediaQuery.of(context).size.height)/600;

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
                textStock(divacieHeight),
                bagianHarga(),
              ]
            ),
          )
        )
      )
    );


  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyek_3/api.dart';

class HalamanOrder extends StatefulWidget {
  final PersistentTabController controller;

  const HalamanOrder({super.key, required this.controller});

  @override
  State<HalamanOrder> createState() => _HalamanOrderState();
}

class _HalamanOrderState extends State<HalamanOrder> {

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  List<Map<String, dynamic>> listOrder = [];
  List<Map<String, dynamic>> listPenjualan = [];
  List<int> indikatorOrder = [];
  List<int> indikatorPenjualan = [];
  String idPunyaUser = "";

  Future<void> refreshData() async {
    setState(() {
      indikatorPenjualan = [];
      indikatorOrder = [];
      listOrder = [];
      listPenjualan = [];
    });
    getData();
  }
  
  Future<String> getImageUrl(String imageName) async {
    // If imageName is empty or null, return a placeholder immediately
    if (imageName.isEmpty) return "https://via.placeholder.com/150";

    final ref = FirebaseStorage.instance.ref().child(imageName);
    return await ref.getDownloadURL();
  }

  Future<void> getData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        idPunyaUser = user.uid;
        print('Current User ID: $uid');


        // 1. Get Firestore Snapshot
        var snapshot = await FirebaseFirestore.instance
          .collection('order')
          .limit(12)
          .get();
        var snapshotPenjualan = await FirebaseFirestore.instance
          .collection('penjualan')
          .limit(12)
          .get();

        List<Map<String, dynamic>> temporaryList = [];
        List<Map<String, dynamic>> temporaryListPenjualan = [];


        for (var doc in snapshot.docs) {
          try {
            if(doc['id_pembeli'] == uid){
              Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
              data['id'] = doc.id;

              if (data['foto'] != null) {
                String urlFoto = await getImageUrl(data['foto']);
                data['foto'] = urlFoto;
              } else {
                data['foto'] = [];
              }

              temporaryList.add(data);
            }
          } catch (itemError) {
            print("Error processing document ${doc.id}: $itemError");
          }
        }

        for (var doc in snapshotPenjualan.docs) {
          try {
            if(doc['id_pembeli'] == uid){
              Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
              data['id'] = doc.id;

              if (data['foto'] != null) {
                String urlFoto = await getImageUrl(data['foto']);
                data['foto'] = urlFoto;
              } else {
                data['foto'] = [];
              }

              temporaryListPenjualan.add(data);
            }
          } catch (itemError) {
            print("Error processing document ${doc.id}: $itemError");
          }
        }

        // 3. Safety check before updating UI
        if (mounted) {
          setState(() {
            listOrder = temporaryList;
            listPenjualan = temporaryListPenjualan;
            print(listOrder);
            ubahYangDitampilkan("");
          });
        }
      }
      
    } catch (globalError) {
      print("GLOBAL ERROR in getData: $globalError");
    }
  }

  void ubahYangDitampilkan(String status){
    if (status == ""){
      //order
      List<int> indexValid = [];
      int index = 0;
      listOrder.forEach((item){
        indexValid.add(index);
        index += 1;
      });
      setState(() {
        indikatorOrder = indexValid;
      });

      //penjualan
      indexValid = [];
      index = 0;
      listPenjualan.forEach((item){
        indexValid.add(index);
        index += 1;
      });
      setState(() {
        indikatorPenjualan = indexValid;
      });
    }else{
      //order
      List<int> indexValid = [];
      int index = 0;
      listOrder.forEach((item){
        if(item['status'] == status){
          indexValid.add(index);
        }
        index += 1;
      });
      setState(() {
        indikatorOrder = indexValid;
      });

      //penjualan
      indexValid = [];
      index = 0;
      listPenjualan.forEach((item){
        if(item['status'] == status){
          indexValid.add(index);
        }
        index += 1;
      });
      setState(() {
        indikatorPenjualan = indexValid;
      });
    }

  }

  Widget buttonKategoriOrder(String titleButton, double divacieHeight, String status) {
    return InkWell(
      onTap: (){
        ubahYangDitampilkan(status);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.only(left: 5, right: 5),
        height: 30 * divacieHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Center(
          child: Text(
            titleButton,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget kategoriOrder(double divacieHeight) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buttonKategoriOrder("Semua", divacieHeight, ""),
            buttonKategoriOrder("Diproses", divacieHeight, "Produk sedang diproses"),
            buttonKategoriOrder("Dikirim", divacieHeight, "Produk sedang dikirim"),
            buttonKategoriOrder("Selesai", divacieHeight, "Produk sudah diterima pembeli"),
            buttonKategoriOrder("Dibuat", divacieHeight, "Produk sedang dibuat"),
          ],
        ),
      ),
    );
  }

  Widget cardPesanan(
    String status,
    String foto,
    String namaProduk,
    String ukuran,
    String jumlah,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar produk
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    foto,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Detail produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaProduk,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ukuran: $ukuran",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Jumlah: $jumlah",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Footer
          /*
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // aksi ke detail
              },
              child: const Text(
                "Detail Pesanan  >>",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double divacieWidth = MediaQuery.of(context).size.width / 300;
    double divacieHeight = MediaQuery.of(context).size.height / 600;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          height: 33 * divacieHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 118, 224, 131),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.controller.jumpToTab(0);
                },
                icon: SvgPicture.asset(
                  "assets/icon/back.svg",
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 0, 0, 0),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const Text(
                "Orders",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),


      body: RefreshIndicator(
        onRefresh: () async {
          await refreshData();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            kategoriOrder(divacieHeight),

            /// LIST ORDER
            ...List.generate(indikatorOrder.length, (index) {
              final item = listOrder[indikatorOrder[index]];
              return cardPesanan(
                item["status"],
                item["foto"],
                item["nama_produk"],
                item["ukuran"],
                item["jumlah"],
              );
            }),

            /// LIST PENJUALAN
            ...List.generate(indikatorPenjualan.length, (index) {
              final item = listPenjualan[indikatorPenjualan[index]];
              return cardPesanan(
                item["status"],
                item["foto"],
                item["nama_produk"],
                item["ukuran"],
                item["jumlah"],
              );
            }),
          ],
        ),
      ),
    );
  }
}
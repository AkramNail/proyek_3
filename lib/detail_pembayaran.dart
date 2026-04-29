
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_3/mid_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HalamanHitungPembayaran extends StatefulWidget{

  HalamanHitungPembayaran({super.key});

  @override
  State<HalamanHitungPembayaran> createState() => _HalamanHitungPembayaranState();

}

class _HalamanHitungPembayaranState extends State<HalamanHitungPembayaran> {

  List<Map<String, dynamic>> dataUser = [
    {
      'nama': 'Load',
      'alamat': 'Load',
    }
  ];
  List<Map<String, dynamic>> listCart = [];
  TextEditingController controllerHarga = TextEditingController(text: "");
  int totalBayar = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> refreshData() async {
    listCart = [];
    getData();
  }

  Future<void> getData() async {
    try {
    final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        print('Current User ID: $uid');

        // 1. Get Firestore Snapshot
        var snapshot = await FirebaseFirestore.instance
          .collection('produk')
          .get();
        var snapshotCart = await FirebaseFirestore.instance
          .collection('cart')
          .get();
        var snapshotAkun = await FirebaseFirestore.instance
          .collection('akun')
          .get();


        List<Map<String, dynamic>> temporaryList = [];
        List<Map<String, dynamic>> temporaryCartList = [];
        List<Map<String, dynamic>> temporaryAkun = [];

        for (var doc in snapshot.docs) {
          try {
            Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
            data['idproduk'] = doc.id;
            data['nama_foto'] = data['foto'];

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

        int totalHargaTempoary = 0;
        for (var doc in snapshotCart.docs) {
          Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          
          temporaryList.forEach((item){
            if(data['produk'] == item['idproduk'] && uid == data['pembeli']){
              data['nama_produk'] = item['nama_produk'];
              data['harga_produk'] = item['harga_produk'];
              data['deskripsi_produk'] = item['deskripsi_produk'];
              data['foto'] = item['foto'][0];
              data['nama_foto'] = item['nama_foto'][0];
              temporaryCartList.add(data);
              final jumlah = (data['jumlah'] ?? 0);
              final harga = (data['harga_produk'] ?? 0);
              totalHargaTempoary += (harga is int ? harga : int.tryParse(harga.toString()) ?? 0)*(jumlah is int ? jumlah : int.tryParse(jumlah.toString()) ?? 0);
            }
          });
        }

        for (var doc in snapshotAkun.docs) {
          Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
        
          if(user.email == data['email']){
            print("HREEEEEEEEEEEEEEEEE");
            temporaryAkun.add(data);
            print(data);
          }
        }



        // 3. Safety check before updating UI
        if (mounted) {
          setState(() {
            listCart = temporaryCartList;
            controllerHarga.text = totalHargaTempoary.toString();
            totalBayar = totalHargaTempoary + 10000;
            dataUser = [];
            dataUser = temporaryAkun;
            print(listCart);
            //final user = FirebaseAuth.instance.currentUser;
            print(dataUser);
          });
        }
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

  Future<void> kirimDataProduk(
    String alamat,
    String foto,
    String id_pembeli,
    String jumlah,
    String nama_pembeli,
    String nama_produk,
    String nomor_hp,
    String ukuran,
    String tipe,
    String status
  ) async{
    String idDoc = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
      .collection('produk_tunggu_bayar')
      .doc(idDoc)
      .set({
        'alamat': alamat,
        'foto': foto,
        'id_pembeli': id_pembeli,
        'jumlah': jumlah,
        'nama_pembeli': nama_pembeli,
        'nama_produk': nama_produk,
        'nomor_hp': nomor_hp,
        'ukuran': ukuran,
        'tipe': tipe,
        'status': status
      });
  }
  Future<void> kirimDataSedangDalamTransaksi(
    String idUser,
    String harga
  ) async{
    String idOrder = DateTime.now().millisecondsSinceEpoch.toString();

    // Ambil token dari Firebase Function
    final response = await http.post(
      Uri.parse('https://us-central1-proyek3-37bb7.cloudfunctions.net/createTransaction'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_id': idOrder,
        'gross_amount': harga,
      }),
    );

    final data = jsonDecode(response.body);
    final redirectUrl = data['redirect_url'];

    if (!mounted) return;

    await FirebaseFirestore.instance
      .collection('sedang_transaksi')
      .doc(idOrder)
      .set({
        'id_pembeli': idUser,
        'status': "menunggu",
        'harga': harga,
        'redirect_url': redirectUrl
      });

    listCart.forEach((item){
      String tipe = "";
      if(item['tipe'] == "order"){
        tipe = "Produk sedang dibuat";
      } else{
        tipe = "Produk sedang diproses";
      }
      kirimDataProduk(
        dataUser[0]['alamat'],
        item['nama_foto'],
        dataUser[0]['id'],
        item['jumlah'].toString(),
        dataUser[0]['nama'],
        item['nama_produk'],
        dataUser[0]['nomor_hp'],
        item['ukuran'],
        item['tipe'],
        tipe
      );
    });

    // 2. Buka WebView
    /*
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MidtransWebView(
          url: redirectUrl,
          orderId: idOrder,
          controller: widget.c,
        ),
      ),
    );
    */
  }
  void lakukanPembayaran(){
    kirimDataSedangDalamTransaksi(
      dataUser[0]['id'],
      totalBayar.toString()
    );
  }

  void detailProduk(){
    print("test1");
  }

  void popupKomfirmasi() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3F5F6F),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TEXT
                const Text(
                  "Pembayaran akan dilakukan menggunakan QRIS apakah anda mau melanjutkan?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [
                    /// BATALKAN
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF476F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Batalkan",
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

                    /// LANJUT
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: aksi lanjut
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1ABC9C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Lanjut",
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
  }

  Widget totalHarga() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // abu-abu
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00C853), // hijau
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          "Total: Rp ${controllerHarga.text}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buttonLanjutkanPembayaran() {
    return GestureDetector(
      onTap: (){
        lakukanPembayaran();
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1ABC9C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Lanjutkan pembayaran",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget cardPesananUI(
    String foto,
    String namaProduk,
    String ukuran,
    String jumlah,
    String harga,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: (){
            detailProduk();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),

                /// CONTENT
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// IMAGE
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          foto, // 🔥 sekarang pakai parameter
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// TEXT DETAIL
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaProduk,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Ukuran: $ukuran",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Jumlah: $jumlah",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Total: $harga",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// FOOTER
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Detail Pesanan  >>",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardAlamat(
    String nama,
    String alamat,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          const Icon(
            Icons.location_on_outlined,
            size: 22,
            color: Colors.black87,
          ),

          const SizedBox(width: 10),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alamat,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rowItem(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
  Widget ringkasanPembayaran({
    required String subtotal,
    required String ongkir,
    required String total,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Ringkasan Pembayaran",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          /// SUBTOTAL
          rowItem("Subtotal", subtotal),

          const SizedBox(height: 4),

          /// ONGKIR
          rowItem("Ongkir", ongkir),

          const SizedBox(height: 6),

          /// TOTAL
          rowItem(
            "Total",
            total,
            isBold: true,
          ),
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
        title: 
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          height: 33 * divacieHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 118, 224, 131),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(child: 
            Text(
            "Pembayaran",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )
          ,)
        )
      ),
      body: 
      ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromARGB(156, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(children: [
              cardAlamat(
                dataUser[0]['nama'],
                dataUser[0]['alamat'],
              ),
              Column(
                children: List.generate(listCart.length, (index) {
                  return cardPesananUI(
                    listCart[index]['foto'],
                    listCart[index]['nama_produk'],
                    listCart[index]['ukuran'],
                    listCart[index]['jumlah'].toString(),
                    listCart[index]['harga_produk'].toString()
                  );
                })
              ),
              ringkasanPembayaran(
                ongkir: "10000", 
                subtotal: (totalBayar - 10000).toString(), 
                total: totalBayar.toString()),
              totalHarga(),
              buttonLanjutkanPembayaran()
            ],)
          )
        )
      )      
    );

  }
}

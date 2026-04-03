import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyek_3/halaman/home.dart';
import 'package:proyek_3/halaman/produk/produk.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HalamanKategori extends StatelessWidget {

  final PersistentTabController controller;

  HalamanKategori({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    double divacieWidth = (MediaQuery.of(context).size.width)/300;
    double divacieHeight = (MediaQuery.of(context).size.height)/600;
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.width;

    List<String> listNamaProduk     = ["Baju hitam", "Baju putih", "Baju merah", "Baju abu-abu", "Baju 5"];
    List<String> listKategoriProduk = ["T-Shirt", "Pants", "Shirt", "Pants", "Pants"];
    List<String> listBahanProduk    = ["Steal", "Steal", "Steal", "Steal", "Steal"];
    List<String> listDeskripsiProduk = ["Test", "Test", "Test", "Test", "Test"];
    List<String> listHargaProduk    = ["185.000", "200.000", "120.000", "80.000", "90.000"];
    List<String> listYanto          = ["L", "XXL", "XXXL"];
    List<String> listGambar         = ["assets/baju/1.jpg", "assets/baju/2.jpg"];

    List<int> listTextIndikator = [0, 2, 3, 4];

    void pindahHalamanProduk(
      String namaProduk,
      String kategoriProduk,
      String bahanProduk,
      String deskripsiProduk,
      String hargaProduk,
      List<String> ukuranProduk,
      List<String> daftarGambar,
    ){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanProduk(
            namaProduk: namaProduk, 
            kategoriProduk: kategoriProduk,
            bahanProduk: bahanProduk,
            deskripsiProduk: deskripsiProduk,
            hargaProduk: hargaProduk,
            ukuranProduk: ukuranProduk,
            daftarGambar: daftarGambar
          ),
        ),
      );
    }

    Widget buttonKategori(String text){

      return Container(
        height: 20,
        width: 60,
        margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
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

    Widget kategori(){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonKategori("T-Shirt"), 
              buttonKategori("Pants"),
              buttonKategori("Shirt"),
              buttonKategori("Cap"),
            ]
          ),
        ],
      );
    }

    Widget cardProduk(
      String namaProduk,
      String kategoriProduk,
      String bahanProduk,
      String deskripsiProduk,
      String hargaProduk,
      List<String> ukuranProduk,
      List<String> daftarGambar,
    ){

      return 
      Container(
        margin: const EdgeInsets.all(7.0),
        padding: EdgeInsets.only(bottom: 7),
        width: 0.4 * maxWidth,
        color: const Color.fromARGB(42, 175, 175, 175),
        child: ElevatedButton(
            onPressed: () { pindahHalamanProduk(
              namaProduk,
              kategoriProduk,
              bahanProduk,
              deskripsiProduk,
              hargaProduk,
              listYanto,
              listGambar
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(daftarGambar[0]),
                      fit: BoxFit.cover
                    ),
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

            return 
            (index % 2 == 0)
            ? Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                cardProduk(
                  listNamaProduk[listIndikator[index]],
                  listKategoriProduk[listIndikator[index]],
                  listBahanProduk[listIndikator[index]],
                  listDeskripsiProduk[listIndikator[index]],
                  listHargaProduk[listIndikator[index]],
                  listYanto,
                  listGambar
                ),

                (index < listIndikator.length - 1)
                
                ? cardProduk(
                  listNamaProduk[listIndikator[index + 1]],
                  listKategoriProduk[listIndikator[index + 1]],
                  listBahanProduk[listIndikator[index + 1]],
                  listDeskripsiProduk[listIndikator[index + 1]],
                  listHargaProduk[listIndikator[index + 1]],
                  listYanto,
                  listGambar
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
            controller.jumpToTab(0);
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

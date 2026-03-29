
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:proyek_3/halaman/cart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:proyek_3/halaman/produk/produk.dart';

class HalamanHome extends StatelessWidget{
  final PersistentTabController controller;

  HalamanHome({super.key, required this.controller});

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

    List<String> listYanto = ["L", "XXL", "XXXL", "L", "XXL", "XXXL", ];
    List<String> listGambar = ["assets/baju/1.jpg", "assets/baju/2.jpg"];

    void pindahHalamanKeCart(){
      controller.jumpToTab(3);
    }
    void pindahHalamanKeInfo(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanCart(),
        ),
      );
    }
    void pindahHalamanKeSearch(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanCart(),
        ),
      );
    }

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
                        buttonKategori("T-Shirt"), 
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
                Container(
                  margin: EdgeInsetsDirectional.only(bottom: 15, top: 0),
                  child: 
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          cardProduk(
                            "baju yanto",
                            "T-shirt",
                            "Steal",
                            "Tahan lama gan",
                            "Rp. 70.000",
                            listYanto,
                            listGambar
                          ),
                          cardProduk(
                            "baju asep",
                            "T-shirt",
                            "Steal",
                            "Tahan lama gan",
                            "Rp. 70.000",
                            listYanto,
                            listGambar
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          cardProduk(
                            "baju yanto",
                            "T-shirt",
                            "Steal",
                            "Tahan lama gan",
                            "Rp. 70.000",
                            listYanto,
                            listGambar
                          ),
                          cardProduk(
                            "baju yanto",
                            "T-shirt",
                            "Steal",
                            "Tahan lama gan",
                            "Rp. 70.000",
                            listYanto,
                            listGambar
                          ),
                        ]
                      ),
                    ]
                  ),                
                )
              ],
            )
          )
        )
      )
    );

  }

}

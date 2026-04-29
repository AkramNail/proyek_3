import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:proyek_3/halaman/home.dart';
import 'package:proyek_3/halaman/order.dart';
import 'package:proyek_3/halaman/category.dart';
import 'package:proyek_3/halaman/cart.dart';
import 'package:proyek_3/halaman/profile.dart';

class NavbarUser extends StatefulWidget {
  const NavbarUser({super.key});

  @override
  State<NavbarUser> createState() => _NavbarUserState();
}

class _NavbarUserState extends State<NavbarUser> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // Key untuk rebuild HalamanCart
  Key _cartKey = UniqueKey();

  final Color colorIconAktif = Colors.green;
  final Color colorIconMati = const Color.fromRGBO(230, 230, 230, 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget navIcon(String path, Color color) {
    return SvgPicture.asset(
      path,
      width: 17,
      height: 17,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  List<PersistentTabConfig> _navBarsItems() {
    return [

      // home
      PersistentTabConfig(
        screen: HalamanHome(controller: _controller),
        item: ItemConfig(
          icon: navIcon('assets/icon/home.svg', colorIconAktif),
          inactiveIcon: navIcon('assets/icon/home.svg', colorIconMati),
          title: "Home",
          activeForegroundColor: colorIconAktif,
          inactiveForegroundColor: colorIconMati,
        ),
      ),

      // kategori
      PersistentTabConfig(
        screen: HalamanKategori(controller: _controller),
        item: ItemConfig(
          icon: navIcon('assets/icon/category.svg', colorIconAktif),
          inactiveIcon: navIcon('assets/icon/category.svg', colorIconMati),
          title: "Kategori",
          activeForegroundColor: colorIconAktif,
          inactiveForegroundColor: colorIconMati,
        ),
      ),

      // order
      PersistentTabConfig(
        screen: HalamanOrder(controller: _controller),
        item: ItemConfig(
          icon: navIcon('assets/icon/order.svg', colorIconAktif),
          inactiveIcon: navIcon('assets/icon/order.svg', colorIconMati),
          title: "Order",
          activeForegroundColor: colorIconAktif,
          inactiveForegroundColor: colorIconMati,
        ),
      ),

      // cart ← pakai _cartKey
      PersistentTabConfig(
        screen: HalamanCart(key: _cartKey, controller: _controller),
        item: ItemConfig(
          icon: navIcon('assets/icon/cart.svg', colorIconAktif),
          inactiveIcon: navIcon('assets/icon/cart.svg', colorIconMati),
          title: "Cart",
          activeForegroundColor: colorIconAktif,
          inactiveForegroundColor: colorIconMati,
        ),
      ),

      // profil
      PersistentTabConfig(
        screen: const HalamanProfil(),
        item: ItemConfig(
          icon: navIcon('assets/icon/profil.svg', colorIconAktif),
          inactiveIcon: navIcon('assets/icon/profil.svg', colorIconMati),
          title: "Profil",
          activeForegroundColor: colorIconAktif,
          inactiveForegroundColor: colorIconMati,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _navBarsItems(),    
      onTabChanged: (index) {
        if (index == 3) {
          setState(() {
            _cartKey = UniqueKey();
          });
        }
      },
      backgroundColor: const Color.fromARGB(0, 255, 0, 0),
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: const Color.fromARGB(255, 27, 27, 27),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: 60,
      ),
    );
  }
}
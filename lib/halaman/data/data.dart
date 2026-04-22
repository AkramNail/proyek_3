import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proyek_3/halaman/cart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:proyek_3/halaman/produk/produk.dart';

class DataFirebase {

  List<Map<String, dynamic>> listProduk = [];

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

    listProduk = temporaryList;
    print(listProduk);

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

}
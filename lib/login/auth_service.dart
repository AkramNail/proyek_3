import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyek_3/halaman/home.dart';
import 'package:proyek_3/login/login.dart';
import 'package:proyek_3/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  Future<void> signup({
    required String nama,
    required String alamat,
    required String nohp,
    required String email,
    required String password,
    required BuildContext context
  }) async {

    try {

      // ✅ VALIDASI INPUT
      if (nama.isEmpty) throw Exception("Nama wajib diisi");
      if (alamat.isEmpty) throw Exception("Alamat wajib diisi");
      if (email.isEmpty) throw Exception("Email wajib diisi");
      if (password.isEmpty) throw Exception("Password wajib diisi");
      if (nohp.isEmpty) throw Exception("No HP wajib diisi");

      // ✅ BUAT USER DULU DI FIREBASE AUTH
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      // ✅ SIMPAN KE FIRESTORE (pakai UID biar rapi)
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(userCredential.user!.uid)
          .set({
        'nama': nama,
        'email': email,
        'alamat': alamat,
        'nomor_hp': nohp,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NavbarUser()
        )
      );

    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah digunakan';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid';
      } else {
        message = 'Terjadi kesalahan: ${e.code}';
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );

    } catch (e) {
      // ✅ ERROR VALIDASI MASUK KE SINI
      Fluttertoast.showToast(
        msg: e.toString().replaceAll("Exception: ", ""),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      if (email.isEmpty) throw Exception("Email wajib diisi");
      if (password.isEmpty) throw Exception("Password wajib diisi");

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NavbarUser()
        )
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Mohon maaf sandi atau password salah.';
      } else if (e.code == 'invalid-credential') {
        message = 'Mohon maaf sandi atau password salah.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    catch(e){
      Fluttertoast.showToast(
        msg: e.toString().replaceAll("Exception: ", ""),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }

  }

  Future<void> signout({
    required BuildContext context
  }) async {
    
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>HalamanLogin()
        )
      );
  }
}
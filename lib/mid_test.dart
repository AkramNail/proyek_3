import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_3/navbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

// WebView Page
class MidtransWebView extends StatefulWidget {
  final String url;
  final String orderId;
  final PersistentTabController controller;

  const MidtransWebView({
    super.key,
    required this.url,
    required this.orderId,
    required this.controller
  });

  @override
  State<MidtransWebView> createState() => _MidtransWebViewState();
}

class _MidtransWebViewState extends State<MidtransWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          final url = request.url;

          // Deteksi halaman finish dari Midtrans
          if (url.contains('/finish') ||
              url.contains('/unfinish') ||
              url.contains('/error')) {
            Navigator.pop(context); // tutup WebView
          }

          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: Text("Midtrans"),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        widget.controller.jumpToTab(0);
      },
    ),
  ),
      body: WebViewWidget(controller: controller),
    );
  }
}
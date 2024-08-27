import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/views/pin_change/pin_change_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RevealCardInfoView extends StatefulWidget {
  final String url; // The URL to the web app page
  final String cardId; // The card ID

  RevealCardInfoView({required this.url, required this.cardId});

  @override
  _RevealCardInfoViewState createState() => _RevealCardInfoViewState();
}

class _RevealCardInfoViewState extends State<RevealCardInfoView> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: const Text(
          "View Card Info",
          style: TextStyle(color: kcButtonTextColor),
        ),
        backgroundColor: kcPrimaryColor,
        centerTitle: false,
        elevation: 5,
        iconTheme: const IconThemeData(color: kcButtonTextColor),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PinChangeView(cardId: widget.cardId)),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Frame_43540-2.svg',
                    width: 30,
                    height: 30,
                  ),
                  const Text(
                    'Change Pin',
                    style: TextStyle(color: kcButtonTextColor, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
      ),
    );
  }
}

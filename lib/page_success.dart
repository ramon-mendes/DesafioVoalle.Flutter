import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageSuccess extends StatefulWidget {
  static const routeName = '/pagesuccess';

  @override
  _PageSuccessState createState() => _PageSuccessState();
}

class _PageSuccessState extends State<PageSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5F0F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Lottie.asset('assets/complete.json'),
          ),
          Text('Reivindicação enviada com sucesso!', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

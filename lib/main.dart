import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desafio_voalle/services/login_notifier.dart';

import 'page_home.dart';
import 'page_login_register.dart';
import 'page_product_createedit.dart';
import 'page_product_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: PageHome.routeName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          PageLoginRegister.routeName: (BuildContext context) => PageLoginRegister(),
          PageHome.routeName: (BuildContext context) => PageHome(),
          PageProductView.routeName: (BuildContext context) => PageProductView(),
          PageProductCreateEdit.routeName: (BuildContext context) => PageProductCreateEdit(),
        },
      ),
    );
  }
}

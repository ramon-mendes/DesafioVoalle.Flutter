import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desafio_voalle/page_home.dart';
import 'package:desafio_voalle/page_login_register.dart';
import 'package:desafio_voalle/services/login_notifier.dart';

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
          PageStep1.routeName: (BuildContext context) => PageStep1(),
          PageStep2.routeName: (BuildContext context) => PageStep2(),
          PageStep3.routeName: (BuildContext context) => PageStep3(),
          PageStep4.routeName: (BuildContext context) => PageStep4(),
          PageStep5.routeName: (BuildContext context) => PageStep5(),
          PageStep6.routeName: (BuildContext context) => PageStep6(),
          PageStep7.routeName: (BuildContext context) => PageStep7(),
          PageSuccess.routeName: (BuildContext context) => PageSuccess(),
          PageReviewShow.routeName: (BuildContext context) => PageReviewShow(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:desafio_voalle/page_login.dart';
import 'package:desafio_voalle/services/login_notifier.dart';
import 'package:desafio_voalle/page_list.dart';

class PageHome extends StatefulWidget {
  static const routeName = '/pagehome';

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, model, child) {
        var status = model.signStatus();
        if (status == ESignStatus.LOADING)
          return LoadingOverlay(
            isLoading: true,
            child: Container(),
          );
        else if (status == ESignStatus.SIGNED)
          return PageList();
        else
          return PageLogin();
      },
    );
  }
}

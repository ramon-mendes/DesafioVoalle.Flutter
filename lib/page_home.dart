import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:desafio_voalle/page_login.dart';
import 'package:desafio_voalle/services/api.dart';
import 'package:desafio_voalle/services/login_notifier.dart';

class PageHome extends StatefulWidget {
  static const routeName = '/pagehome';

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _selectedIndex = 0;

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
          return _loggedInUI();
        else
          return PageLogin();
      },
    );
  }

  Widget _loggedInUI() {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: _selectedIndex == 0 ? _tab1() : _tab2(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker_phone),
            label: 'Nova',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker_notes),
            label: 'Em andamento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _tab1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Selecione a empresa que deseja contatar'),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: Image(image: AssetImage('assets/logo-dark.png')),
                onTap: () async {
                  await Navigator.of(context).pushNamed(PageStep1.routeName, arguments: 1);
                },
              ),
              ListTile(
                title: Image(image: AssetImage('assets/topo_logo.png')),
                onTap: () async {
                  await Navigator.of(context).pushNamed(PageStep1.routeName, arguments: 2);
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _tab2() {
    return PageReviewsOpen();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      API.logout();
      Provider.of<LoginNotifier>(context, listen: false).logOut();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:reivindique_new/page_home.dart';
import 'package:reivindique_new/page_login_register.dart';
import 'package:reivindique_new/services/api.dart';
import 'package:reivindique_new/services/login_notifier.dart';
import 'consts.dart' as Consts;

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _saving = false;
  final TextEditingController _txtEmail = TextEditingController(text: 'ramon@misoftware.com.br');
  final TextEditingController _txtPwd = TextEditingController(text: 'SEnha123');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _saving,
        color: Consts.LOADING_OVERLAY_COLOR,
        progressIndicator: Consts.LOADING_INDICATOR,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email'),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _txtEmail,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('Senha'),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _txtPwd,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      child: const Text('Login'),
                      onPressed: loginClicked,
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      child: const Text('Cadastre-se'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(PageLoginRegister.routeName);
                      },
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        var res = await Provider.of<LoginNotifier>(context, listen: false).logInByGoogle(context);
                        if (res == ESignStatus.NOT_SIGNED) {
                          final snackBar = SnackBar(
                            content: Text('Não foi possível completar seu login, tente novamente.'),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Image(
                        image: AssetImage('assets/google-signin.png'),
                        fit: BoxFit.cover,
                        width: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginClicked() async {
    setState(() {
      this._saving = true;
    });

    var res = await API.of(context).login(_txtEmail.text, _txtPwd.text);
    if (res == ELoginResult.OK) {
      Navigator.of(context).pushReplacementNamed(PageHome.routeName);
    } else if (res == ELoginResult.LOGIN_INVALID) {
      final snackBar = SnackBar(
        content: Text('Usuário ou senha inválidos.'),
        duration: Duration(milliseconds: 2000),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else if (res == ELoginResult.ERROR) {
      final snackBar = SnackBar(
        content: Text('Não foi possível completar esta ação.'),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    setState(() {
      this._saving = false;
    });
  }
}

import 'package:desafio_voalle/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:desafio_voalle/page_home.dart';
import 'package:desafio_voalle/page_login_register.dart';
import 'package:desafio_voalle/services/api.dart';
import 'package:desafio_voalle/services/login_notifier.dart';
import 'consts.dart' as Consts;

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _saving = false;
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _saving,
        color: Consts.LOADING_OVERLAY_COLOR,
        progressIndicator: Consts.LOADING_INDICATOR,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/voalle.png',
                        width: 300,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _txtEmail,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                      ),
                    ),
                    SizedBox(height: 15),
                    PasswordField(_txtPwd),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ButtonTheme(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: loginClicked,
                            child: Text(
                              "LOGIN",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ButtonTheme(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(PageLoginRegister.routeName);
                            },
                            child: Text(
                              "CADASTRE-SE",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ButtonTheme(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              var res = await Provider.of<LoginNotifier>(context, listen: false).logInByGoogle(context);
                              if (res == ESignStatus.NOT_SIGNED) {
                                final snackBar = SnackBar(
                                  content: Text('Não foi possível completar seu login, tente novamente.'),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                            child: Text(
                              "ENTRAR COM O GOOGLE",
                            ),
                          ),
                        ),
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

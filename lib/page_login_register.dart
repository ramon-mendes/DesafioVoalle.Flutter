import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:desafio_voalle/page_home.dart';
import 'package:desafio_voalle/services/api.dart';
import 'consts.dart' as Consts;

class PageLoginRegister extends StatefulWidget {
  static const routeName = '/pageloginregister';

  @override
  _PageLoginRegisterState createState() => _PageLoginRegisterState();
}

class _PageLoginRegisterState extends State<PageLoginRegister> {
  bool _saving = false;
  late BuildContext _context;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _txtName = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPwd = TextEditingController();
  final TextEditingController _txtPwd2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _saving,
        color: Consts.LOADING_OVERLAY_COLOR,
        progressIndicator: Consts.LOADING_INDICATOR,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cadastre-se',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 15),
                      Text('Nome:'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _txtName,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira o nome';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      Text('E-mail:'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira o e-mail';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      Text('Senha:'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _txtPwd,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira a senha';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      Text('Confirme a senha:'),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _txtPwd2,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira a senha';
                          }
                          if (value != _txtPwd.text) {
                            return 'Senhas não correspondem';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        child: const Text('Cadastrar'),
                        onPressed: _onRegisterPress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onRegisterPress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _saving = true;
      });

      API.of(context).userRegister(_txtName.text, _txtEmail.text, _txtPwd.text).then((value) async {
        if (value == ERegisterResult.ERROR) {
          final snackBar = SnackBar(content: Text('Erro ao criar seu usuário.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (value == ERegisterResult.EMAIL_ALREADY_EXISTS) {
          final snackBar = SnackBar(content: Text('Este e-mail já está cadastrado.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // loga usuário e muda a tela
          var res = await API.of(_context).login(_txtEmail.text, _txtPwd.text);
          if (res == ELoginResult.OK) {
            final snackBar = SnackBar(content: Text('Cadastro realizado com sucesso'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pushReplacementNamed(PageHome.routeName);
          } else {
            final snackBar = SnackBar(
              content: Text('Não foi possível completar esta ação.'),
              duration: Duration(milliseconds: 2000),
            );
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        }
        setState(() {
          _saving = false;
        });
      });
    }
  }
}

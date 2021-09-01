import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController _c;

  PasswordField(this._c);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._c,
      obscureText: !this._showPassword,
      decoration: InputDecoration(
        hintText: 'Senha',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: this._showPassword ? Colors.blue : Colors.grey,
          ),
          onPressed: () {
            setState(() => this._showPassword = !this._showPassword);
          },
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:desafio_voalle/services/api.dart';

enum ESignStatus { LOADING, SIGNED, NOT_SIGNED }

class LoginNotifier with ChangeNotifier {
  var _googleSignIn = GoogleSignIn();
  ESignStatus _isSigned = ESignStatus.LOADING;
  GoogleSignInAccount? googleAccount;

  LoginNotifier() {
    notifyListeners(); // for ESignStatus.LOADING

    API.isLogged().then((value) {
      if (value) {
        _isSigned = ESignStatus.SIGNED;
        notifyListeners();
        return;
      }
    });
    _isSigned = ESignStatus.NOT_SIGNED;
    notifyListeners();
    return;
  }

  signStatus() {
    return _isSigned;
  }

  logInByUserPwd() {
    _isSigned = ESignStatus.SIGNED;
  }

  Future<ESignStatus> logInByGoogle(BuildContext context) async {
    this.googleAccount = await _googleSignIn.signIn();
    if (this.googleAccount != null) {
      var auth = await this.googleAccount!.authentication;
      var value =
          await API.of(context).googleLogin(auth.idToken!, this.googleAccount!.email, this.googleAccount!.displayName!);
      if (value == ELoginResult.OK) {
        _isSigned = ESignStatus.SIGNED;
      } else {
        _isSigned = ESignStatus.NOT_SIGNED;
      }
      notifyListeners();
    } else {
      _isSigned = ESignStatus.SIGNED;
      notifyListeners();
    }
    return _isSigned;
  }

  logOut() async {
    if (this.googleAccount != null) {
      this.googleAccount = await _googleSignIn.signOut();
    }

    _isSigned = ESignStatus.NOT_SIGNED;
    notifyListeners();
  }
}

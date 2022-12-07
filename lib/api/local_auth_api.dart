import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (ex) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvaiable = await hasBiometrics();
    if (!isAvaiable) return false;

    return await _auth.authenticate(
        localizedReason: "Teste autenticação",
        options: AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ));
  }
}

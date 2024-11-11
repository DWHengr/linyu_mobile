import 'package:pointycastle/asymmetric/api.dart';
import 'package:linyu_mobile/api/user_api.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

final _useApi = UserApi();

Future<String> passwordEncrypt(String password) async {
  final publicKeyResult = await _useApi.publicKey();
  if (publicKeyResult['code'] == 0) {
    String key = publicKeyResult['data'];
    final parsedKey = encrypt.RSAKeyParser().parse(key) as RSAPublicKey;
    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: parsedKey));
    final encryptedPassword = encrypter.encrypt(password).base64;
    return encryptedPassword;
  }
  return "-1";
}

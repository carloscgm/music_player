import 'package:music_player/data/remote/credentials_wallet.dart';
import 'package:music_player/data/remote/error/remote_error_mapper.dart';
import 'package:music_player/data/remote/http_client.dart';
import 'package:music_player/data/remote/network_endpoints.dart';

class AuthRemoteImpl {
  final HttpClient _httpClient;
  AuthRemoteImpl(this._httpClient);

  Future<void> login(String user, String password) async {
    try {
      dynamic response = await _httpClient.dio.post(
        NetworkEndpoints.loginUrl,
        data: {'user': user, 'password': password},
      );

      await CredentialsWallet.saveAll(response.data);
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<bool> isAuthenticated() async {
    final refreshToken = await CredentialsWallet.getRefreshToken();
    return !refreshToken.isEmpty;
  }

  Future<void> signOut() async {
    CredentialsWallet.clearAll();
  }
}

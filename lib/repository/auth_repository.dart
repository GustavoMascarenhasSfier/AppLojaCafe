import 'package:flutter/foundation.dart';

import './../models/models.dart';
import './repository.dart';

class AuthRepository {
  final AuthLocalRepository localRepository;
  // Mantemos o remoteRepository aqui para compatibilidade com o construtor,
  // mas ele não será usado para a lógica de login LOCAL.
  final AuthRemoteRepository remoteRepository;

  AuthRepository(this.localRepository, this.remoteRepository);

  Future<LoginResponseModel?> findUserByUsername(String username) async {
    return await localRepository.getAuthByUsername(username);
  }

  Future<LoginResponseModel?> login(LoginRequestModel request) async {
    LoginResponseModel? auth = await localRepository.login(request);

    if (auth != null) {
      if (kDebugMode) {
        print('Login LOCAL bem-sucedido para ${request.username}');
      }
      return auth; // Retorna o token local se as credenciais estiverem corretas
    } else {
      if (kDebugMode) {
        print('Falha no login local para ${request.username}.');
      }
      return null; // Retorna nulo se as credenciais locais forem inválidas
    }
  }
}

// lib/repository/user_local_repository.dart
import 'package:sqflite/sqlite_api.dart';

import '../database/app_database.dart';
import '../models/models.dart';

class UserLocalRepository {
  Future<UserModel?> getUserById(int id) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return UserModel(
        id: map['id'] as int,
        email: map['email'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        name: NameModel(
          firstname: map['firstname'] as String,
          lastname: map['lastname'] as String,
        ),
        address: AddressModel(
          city: map['city'] as String,
          street: map['street'] as String,
          number: map['number'] as int,
          zipcode: map['zipcode'] as String,
          geolocation: GeolocationModel(
            lat: map['lat'] as String,
            long: map['long'] as String,
          ),
        ),
        phone: map['phone'] as String,
      );
    }

    return null;
  }

  // Este método login em UserLocalRepository não é mais usado diretamente pelo AuthRepository,
  // mas é um bom lugar para ter uma função de verificação de usuário para outros propósitos.
  // O AuthLocalRepository tem o método login principal.
  Future<UserModel?> login(LoginRequestModel request) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users', // Verifica na tabela 'users'
      where: 'username = ? AND password = ?',
      whereArgs: [request.username, request.password],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return UserModel(
        id: map['id'] as int,
        email: map['email'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        name: NameModel(
          firstname: map['firstname'] as String,
          lastname: map['lastname'] as String,
        ),
        address: AddressModel(
          city: map['city'] as String,
          street: map['street'] as String,
          number: map['number'] as int,
          zipcode: map['zipcode'] as String,
          geolocation: GeolocationModel(
            lat: map['lat'] as String,
            long: map['long'] as String,
          ),
        ),
        phone: map['phone'] as String,
      );
    }

    return null;
  }

  Future<UserModel?> getUserByName(String userName) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [userName],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return UserModel(
        id: map['id'] as int,
        email: map['email'] as String,
        username: map['username'] as String,
        password: map['password'] as String,
        name: NameModel(
          firstname: map['firstname'] as String,
          lastname: map['lastname'] as String,
        ),
        address: AddressModel(
          city: map['city'] as String,
          street: map['street'] as String,
          number: map['number'] as int,
          zipcode: map['zipcode'] as String,
          geolocation: GeolocationModel(
            lat: map['lat'] as String,
            long: map['long'] as String,
          ),
        ),
        phone: map['phone'] as String,
      );
    }

    return null;
  }

  Future<void> saveUser(UserModel user) async {
    final db = await AppDatabase().database;

    // Salva na tabela 'users'
    await db.insert(
      'users',
      {
        'id': user.id,
        'email': user.email,
        'username': user.username,
        'password': user.password,
        'firstname': user.name.firstname,
        'lastname': user.name.lastname,
        'city': user.address.city,
        'street': user.address.street,
        'number': user.address.number,
        'zipcode': user.address.zipcode,
        'lat': user.address.geolocation.lat,
        'long': user.address.geolocation.long,
        'phone': user.phone,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Adiciona ou atualiza na tabela 'auth' (ESSENCIAL para o login local)
    await db.insert(
      'auth',
      {
        // Se o id do user não for 0, usa-o. Caso contrário, deixa o AUTOINCREMENT cuidar.
        'id': user.id == 0
            ? null
            : user.id, // O id na tabela 'auth' pode ser independente ou linkado
        'username': user.username,
        'password': user.password,
        'token': 'mock_token_${user.username}', // Gerar um token simples
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

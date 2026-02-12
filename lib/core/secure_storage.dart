import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage instance = SecureStorage.internal();

  final FlutterSecureStorage storage;

  SecureStorage.internal() : storage = const FlutterSecureStorage();

  factory SecureStorage() {
    return instance;
  }

  // Future<String?> readData(String key) async {
  //   return await storage.read(key: key);
  // }

  Future<String> readData(String key) async {
    return await storage.read(key: key) ?? '';
  }

  Future<void> writeData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<void> deleteData(String key) async {
    await storage.delete(key: key);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/database_service.dart';
import 'package:shared_core/services/location_service.dart';
import 'package:shared_core/services/storage_service.dart';

final authServiceProvider = Provider((ref) => AuthService());
final databaseServiceProvider = Provider((ref) => DatabaseService());
final locationServiceProvider = Provider((ref) => LocationService());
final storageServiceProvider = Provider((ref) => StorageService());

// User State Provider
final userStateProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).userStream;
});

// Restaurants List Provider
final restaurantsProvider = StreamProvider((ref) {
  return ref.watch(databaseServiceProvider).getCollection('restaurants');
});

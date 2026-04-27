import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/database_service.dart';
import 'package:shared_core/services/printer_service.dart';

final authServiceProvider = Provider((ref) => AuthService());
final databaseServiceProvider = Provider((ref) => DatabaseService());
final printerServiceProvider = Provider((ref) => PrinterService());

// Notifications Stream Provider
final notificationsProvider = StreamProvider((ref) {
  return ref.watch(databaseServiceProvider).getCollection('notifications');
});

// Tables Stream Provider
final tablesProvider = StreamProvider((ref) {
  return ref.watch(databaseServiceProvider).getCollection('tables');
});

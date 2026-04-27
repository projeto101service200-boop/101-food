import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/services/database_service.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());

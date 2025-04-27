import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/services/dio_service.dart';

final dioServiceProvider = Provider((ref) => DioService());

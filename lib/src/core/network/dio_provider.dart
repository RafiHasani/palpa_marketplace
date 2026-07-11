import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_service.dart';

final dioServiceProvider = Provider<DioService>((ref) {
  return DioService(ref);
});

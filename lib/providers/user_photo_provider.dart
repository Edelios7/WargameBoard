import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/user_photo_service.dart';

final userPhotoServiceProvider = Provider<UserPhotoService>(
  (ref) => const UserPhotoService(),
);

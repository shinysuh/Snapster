import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapster_app/features/authentication/initializers/token_auth_initializer.dart';
import 'package:snapster_app/features/authentication/providers/auth_provider.dart';

final tokenAuthInitializerProvider =
    Provider<TokenAuthInitializer>((ref) => TokenAuthInitializer(
          storage: const FlutterSecureStorage(),
          authRepository: ref.read(authRepositoryProvider),
        ));

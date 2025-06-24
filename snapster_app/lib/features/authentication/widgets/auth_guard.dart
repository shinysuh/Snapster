import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/view_models/auth_view_model.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

typedef AuthenticatedBuilder = Widget Function(
  BuildContext context,
  AppUser user,
);

/// 로딩 · 비로그인 · 로그인된 상태 공통 처리 위젯
class AuthGuard extends ConsumerWidget {
  /// 로그인된 상태에서 그려줄 실제 콘텐츠
  final AuthenticatedBuilder builder;

  const AuthGuard({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('로그인이 필요합니다.')),
          data: (user) {
            if (user == null) {
              // 로그인 페이지로 아예 밀어버릴 수도 있고,
              // 여기서는 간단히 안내 UI
              return const Center(child: Text('로그인이 필요합니다.'));
            }
            // 실제 화면 빌드
            return builder(context, user);
          },
        );
  }
}

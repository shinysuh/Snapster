import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListScreen extends ConsumerStatefulWidget {
  static const String routeURL = '/chatroom-user-list';
  static const String routeName = 'chatroom-user-list';

  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

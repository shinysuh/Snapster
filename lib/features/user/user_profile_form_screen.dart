import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/view_models/avatar_view_model.dart';
import 'package:tiktok_clone/features/user/view_models/user_view_model.dart';
import 'package:tiktok_clone/features/user/widgets/avatar.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';

class UserProfileFormScreen extends ConsumerStatefulWidget {
  static const String routeName = 'edit_user';
  static const String routeURL = '/edit_user';

  final UserProfileModel profile;

  const UserProfileFormScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<UserProfileFormScreen> createState() =>
      _UserProfileFormScreenState();
}

class _UserProfileFormScreenState extends ConsumerState<UserProfileFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile.toJson();
  }

  void _setNewProfile(String field, String? newValue) {
    setState(() {
      _profile[field] = newValue ?? '';
    });
  }

  void _onTapNext() {}

  void _onTapSave() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() /*invoke validator*/) {
      _formKey.currentState!.save(); // invoke onSaved

      // update firebase
      ref
          .read(userProvider.notifier)
          .updateProfile(context, UserProfileModel.fromJson(_profile));

      goBackToPreviousRoute(context);
    }
  }

  Future<void> _onTapDeleteAvatar() async {
    await ref.read(avatarProvider.notifier).deleteAvatar(widget.profile);
  }

  List<Widget> _getUserPic(UserProfileModel profile) {
    return [
      Gaps.v10,
      Stack(
        children: [
          Avatar(
            isVertical: false,
            user: profile,
          ),
        ],
      ),
      Gaps.v20,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ref.read(userProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          data: (user) => GestureDetector(
            onTap: () => onTapOutsideAndDismissKeyboard(context),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
                child: SafeArea(
                  child: Column(
                    children: [
                      ..._getUserPic(user),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Gaps.v28,
                            TextFormField(
                              initialValue: _profile['name'],
                              autofocus: true,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              onEditingComplete: _onTapNext,
                              onSaved: (newValue) =>
                                  _setNewProfile('name', newValue),
                            ),
                            Gaps.v16,
                            TextFormField(
                              initialValue: _profile['username'],
                              autofocus: true,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              onEditingComplete: _onTapNext,
                              onSaved: (newValue) =>
                                  _setNewProfile('username', newValue),
                            ),
                            Gaps.v16,
                            TextFormField(
                              initialValue: _profile['bio'],
                              autofocus: true,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Bio',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              onEditingComplete: _onTapNext,
                              onSaved: (newValue) =>
                                  _setNewProfile('bio', newValue),
                            ),
                            Gaps.v16,
                            TextFormField(
                              initialValue: _profile['link'],
                              // focusNode: _secondFocus,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Link',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              onEditingComplete: _onTapSave,
                              onSaved: (newValue) =>
                                  _setNewProfile('link', newValue),
                            ),
                            Gaps.v28,
                            FormButton(
                              disabled: ref.watch(userProvider).isLoading,
                              onTapButton: _onTapSave,
                              buttonText: S.of(context).save,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}

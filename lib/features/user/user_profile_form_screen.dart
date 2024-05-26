import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

enum EditableFields { name, username, bio, link }

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

class _UserProfileFormScreenState extends ConsumerState<UserProfileFormScreen>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  late Map<String, dynamic> _profile;

  List<FocusNode> _focusList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _profile = widget.profile.toJson();

    // _focusList = List.generate(
    //   EditableFields.values.length,
    //   (_) => FocusNode(),
    // );
    //
    // for (var focus in _focusList) {
    //   focus.addListener(_scrollToFocusedNode);
    // }

    // textfield 개수만큼 focusNode 생성
    for (var i = 0; i < EditableFields.values.length; i++) {
      var focus = FocusNode();
      focus.addListener(_scrollToFocusedNode);
      _focusList.add(focus);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();

    for (var focus in _focusList) {
      focus.removeListener(_scrollToFocusedNode);
      focus.dispose();
    }

    super.dispose();
  }

  void _scrollToFocusedNode() {
    final focusedNode = _focusList.firstWhere((node) => node.hasFocus);
    Scrollable.ensureVisible(
      focusedNode.context!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.5, // center the focused widget
    );
  }

  void _setNewProfile(String field, String? newValue) {
    setState(() {
      _profile[field] = newValue ?? '';
    });
  }

  void _onTapNext(EditableFields field) {
    var index = EditableFields.values.indexOf(field) + 1;
    index < _focusList.length ? _focusList[index].requestFocus() : _onTapSave();
  }

  FocusNode? _getFocusNode(EditableFields field) {
    if (_focusList.isEmpty) return null;
    return _focusList[EditableFields.values.indexOf(field)];
  }

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
          if (!ref.watch(avatarProvider).isLoading) ...[
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _onTapDeleteAvatar,
                child: Container(
                  width: Sizes.size28 + Sizes.size2,
                  height: Sizes.size28 + Sizes.size2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size5,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 3,
              right: 3,
              child: GestureDetector(
                onTap: _onTapDeleteAvatar,
                child: FaIcon(
                  FontAwesomeIcons.solidCircleXmark,
                  color: Colors.grey.shade600,
                  size: Sizes.size24,
                ),
              ),
            ),
          ]
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
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: true,
                title: Text(S.of(context).editProfile),
              ),
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  _onTapNext(EditableFields.name),
                              onSaved: (newValue) =>
                                  _setNewProfile('name', newValue),
                            ),
                            Gaps.v16,
                            TextFormField(
                              initialValue: _profile['username'],
                              focusNode: _getFocusNode(EditableFields.username),
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  _onTapNext(EditableFields.username),
                              onSaved: (newValue) =>
                                  _setNewProfile('username', newValue),
                            ),
                            Gaps.v16,
                            TextFormField(
                              initialValue: _profile['bio'],
                              focusNode: _getFocusNode(EditableFields.bio),
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Bio',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  _onTapNext(EditableFields.bio),
                              onSaved: (newValue) =>
                                  _setNewProfile('bio', newValue),
                            ),
                            Gaps.v16,
                            TextFormField(
                              initialValue: _profile['link'],
                              focusNode: _getFocusNode(EditableFields.link),
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                hintText: 'Link',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              onEditingComplete: () =>
                                  _onTapNext(EditableFields.link),
                              onSaved: (newValue) =>
                                  _setNewProfile('link', newValue),
                            ),
                            Gaps.v28,
                            FormButton(
                              disabled: ref.watch(userProvider).isLoading,
                              onTapButton: _onTapSave,
                              buttonText: S.of(context).save,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom +
                                  Sizes.size32,
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

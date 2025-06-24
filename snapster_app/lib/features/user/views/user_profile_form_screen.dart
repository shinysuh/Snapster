import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/common/form_button.dart';
import 'package:snapster_app/features/authentication/widgets/auth_guard.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/view_models/http_user_profile_view_model.dart';
import 'package:snapster_app/features/user/view_models/profile_avatar_upload_view_model.dart';
import 'package:snapster_app/features/user/view_models/user_view_model.dart';
import 'package:snapster_app/features/user/widgets/profile_avatar.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';

enum EditableFields { name, username, bio, link }

class UserProfileFormScreen extends ConsumerStatefulWidget {
  static const String routeName = 'edit_user';
  static const String routeURL = '/edit_user';

  final AppUser user;

  const UserProfileFormScreen({
    super.key,
    required this.user,
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

    _profile = widget.user.toJson();

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
    index < _focusList.length
        ? _focusList[index].requestFocus()
        : _focusList[index].unfocus();
  }

  FocusNode? _getFocusNode(EditableFields field) {
    if (_focusList.isEmpty) return null;
    return _focusList[EditableFields.values.indexOf(field)];
  }

  void _onTapSave() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() /*invoke validator*/) {
      _formKey.currentState!.save(); // invoke onSaved

      final updateUser = AppUser.fromJson(_profile);
      ref
          .read(httpUserProfileProvider.notifier)
          .updateUserProfile(context, updateUser);

      goBackToPreviousRoute(context);
    }
  }

  Future<void> _onTapDeleteAvatar(AppUser user) async {
    if (!user.hasProfileImage) return;

    await _getAlert(
      title: S.of(context).deleteProfilePicture,
      destructiveActionCallback: _closeDialog,
      confirmActionCallback: () async {
        await ref
            .read(profileAvatarProvider.notifier)
            .deleteProfileImage(context);
        _closeDialog();
      },
    );
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  Future<void> _getAlert({
    required String title,
    required void Function() confirmActionCallback,
    required void Function() destructiveActionCallback,
  }) async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // content: const Text('Please confirm'),
              actions: [
                CupertinoDialogAction(
                  onPressed: confirmActionCallback,
                  child: const Text("Yes"),
                ),
                CupertinoDialogAction(
                  onPressed: destructiveActionCallback,
                  isDestructiveAction: true,
                  child: const Text("No"),
                ),
              ],
            ));
  }

  List<Widget> _getUserPic(AppUser user) {
    return [
      Gaps.v10,
      Stack(
        children: [
          ProfileAvatar(
            user: user,
            isVertical: false,
            isEditable: true,
          ),
          if (!ref.watch(profileAvatarProvider).isLoading &&
              user.hasProfileImage) ...[
            Positioned(
              bottom: 0,
              right: 0,
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
            Positioned(
              bottom: 3,
              right: 3,
              child: GestureDetector(
                onTap: () => _onTapDeleteAvatar(user),
                child: FaIcon(
                  FontAwesomeIcons.solidCircleXmark,
                  color: Colors.grey.shade600,
                  size: Sizes.size24,
                ),
              ),
            ),
          ],
        ],
      ),
      Gaps.v20,
    ];
  }

  Widget getTextFormFieldByField(
    String field,
    String hintText,
    EditableFields focusField,
    bool isNotFirst,
  ) {
    return TextFormField(
      initialValue: _profile[field],
      focusNode: isNotFirst ? _getFocusNode(focusField) : null,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _onTapNext(focusField),
      onSaved: (newValue) => _setNewProfile(field, newValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = isDarkMode(context);

    return AuthGuard(
      builder: (context, user) => GestureDetector(
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
                        getTextFormFieldByField(
                          'displayName',
                          'Nickname (Name to display)',
                          EditableFields.name,
                          false,
                        ),
                        Gaps.v16,
                        getTextFormFieldByField(
                          'username',
                          'Username',
                          EditableFields.username,
                          true,
                        ),
                        Gaps.v16,
                        getTextFormFieldByField(
                          'bio',
                          'Add bio to your profile',
                          EditableFields.bio,
                          true,
                        ),
                        Gaps.v16,
                        getTextFormFieldByField(
                          'link',
                          'Add a link to your profile',
                          EditableFields.link,
                          true,
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

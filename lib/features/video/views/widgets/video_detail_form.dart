import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/video/view_models/video_upload_view_model.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class VideoDetailForm extends ConsumerStatefulWidget {
  final Map<String, String> videoDetail;
  final Function onChangeVideoDetail;

  const VideoDetailForm({
    super.key,
    required this.videoDetail,
    required this.onChangeVideoDetail,
  });

  @override
  ConsumerState<VideoDetailForm> createState() => _VideoDetailFormState();
}

class _VideoDetailFormState extends ConsumerState<VideoDetailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late FocusNode _secondFocus;

  @override
  void initState() {
    super.initState();
    _secondFocus = FocusNode();
  }

  @override
  void dispose() {
    _secondFocus.dispose();
    super.dispose();
  }

  void _onTapNext() {
    _secondFocus.requestFocus();
  }

  void _closeModal() {
    Navigator.pop(context);
  }

  void _onSubmit() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() /*invoke validator*/) {
      _formKey.currentState!.save();
    }

    _closeModal();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);

    return Positioned(
      // TODO - 키보드 트리거 시, 입력 폼 가려지는 이슈 fix 필요
      bottom: 0,
      child: SizedBox(
        height: size.height * 0.35,
        child: RegulatedMaxWidth(
          maxWidth: Breakpoints.sm,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Sizes.size14,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: isDark ? null : Colors.grey.shade50,
            appBar: AppBar(
              backgroundColor: isDark
                  ? Theme.of(context).appBarTheme.surfaceTintColor
                  : Colors.grey.shade50,
              centerTitle: true,
              title: Text(
                S.of(context).videoDetail,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: _closeModal,
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                    size: Sizes.size22,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () => onTapOutsideAndDismissKeyboard(context),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        initialValue: widget.videoDetail['title'],
                        autofocus: true,
                        // textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          hintText: S.of(context).title,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onEditingComplete: _onTapNext,
                        onSaved: (description) =>
                            widget.onChangeVideoDetail('title', description),
                      ),
                      Gaps.v16,
                      TextFormField(
                        initialValue: widget.videoDetail['description'],
                        autofocus: true,
                        // textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          hintText: S.of(context).description,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onEditingComplete: _onSubmit,
                        onSaved: (description) => widget.onChangeVideoDetail(
                            'description', description),
                      ),
                      Gaps.v28,
                      FormButton(
                        disabled: ref.watch(videoUploadProvider).isLoading,
                        onTapButton: _onSubmit,
                        buttonText: S.of(context).save,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

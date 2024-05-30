import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/common/form_button.dart';
import 'package:tiktok_clone/features/video/view_models/video_upload_view_model.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils/theme_mode.dart';

class VideoDetailForm extends ConsumerStatefulWidget {
  final Map<String, String> videoDetail;
  final void Function(Map<String, String> detail) onChangeVideoDetail;
  final bool isAutoValidationTriggered;

  const VideoDetailForm({
    super.key,
    required this.videoDetail,
    required this.onChangeVideoDetail,
    required this.isAutoValidationTriggered,
  });

  @override
  ConsumerState<VideoDetailForm> createState() => _VideoDetailFormState();
}

class _VideoDetailFormState extends ConsumerState<VideoDetailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const String title = 'title';
  static const String description = 'description';
  Map<String, String> detail = {
    title: '',
    description: '',
  };

  late FocusNode _secondFocus;

  @override
  void initState() {
    super.initState();
    _secondFocus = FocusNode();
    _initVideoDetail();
  }

  @override
  void dispose() {
    _secondFocus.dispose();
    super.dispose();
  }

  void _initVideoDetail() {
    detail = {
      title: widget.videoDetail[title] ?? '',
      description: widget.videoDetail[description] ?? '',
    };
  }

  void _setVideoDetail(String field, String? info) {
    if (info != null) {
      setState(() {
        detail[field] = info;
      });
    }
  }

  void _onTapNext() {
    _secondFocus.requestFocus();
  }

  void _closeModal(bool isSaved) {
    if (isSaved) {
      widget.onChangeVideoDetail(detail);
    }
    Navigator.pop(context);
  }

  void _onSubmit() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() /*invoke validator*/) {
      _formKey.currentState!.save();
      _closeModal(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    var bgColor = isDark ? null : Colors.grey.shade50;

    return AlertDialog(
      alignment: Alignment.center,
      surfaceTintColor: bgColor,
      backgroundColor: bgColor,
      title: Text(
        S.of(context).videoDetail,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: Sizes.size16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.md,
          minWidth: Breakpoints.sm,
          maxHeight: 150,
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: detail[title],
                  autofocus: true,
                  // textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: S.of(context).title,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  autovalidateMode: widget.isAutoValidationTriggered
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  validator: (value) => value == null || value.trim() == ''
                      ? S.of(context).enterVideoTitle
                      : null,
                  onEditingComplete: _onTapNext,
                  onSaved: (description) => _setVideoDetail(title, description),
                ),
                Gaps.v16,
                TextFormField(
                  initialValue: detail[description],
                  focusNode: _secondFocus,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: S.of(context).description,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onFieldSubmitted: (_) => _onSubmit(),
                  onSaved: (desc) => _setVideoDetail(description, desc),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FormButton(
          disabled: ref.watch(videoUploadProvider).isLoading,
          onTapButton: _onSubmit,
          buttonText: S.of(context).save,
        ),
      ],
    );
  }
}

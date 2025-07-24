import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/common/form_button.dart';
import 'package:snapster_app/features/video/view_models/http_video_upload_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/theme_mode.dart';

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
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _closeModal(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final bgColor = isDark ? Colors.grey.shade900 : Colors.grey.shade50;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size24,
          horizontal: Sizes.size20,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).videoDetail,
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v20,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: detail[title],
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: S.of(context).title,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                    ),
                    autovalidateMode: widget.isAutoValidationTriggered
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? S.of(context).enterVideoTitle
                        : null,
                    onEditingComplete: _onTapNext,
                    onSaved: (value) => _setVideoDetail(title, value),
                  ),
                  Gaps.v16,
                  TextFormField(
                    initialValue: detail[description],
                    focusNode: _secondFocus,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: S.of(context).description,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                    ),
                    onFieldSubmitted: (_) => _onSubmit(),
                    onSaved: (value) => _setVideoDetail(description, value),
                  ),
                ],
              ),
            ),
            Gaps.v20,
            FormButton(
              disabled: ref.watch(httpVideoUploadProvider).isLoading,
              onTapButton: _onSubmit,
              buttonText: S.of(context).save,
            ),
          ],
        ),
      ),
    );
  }
}

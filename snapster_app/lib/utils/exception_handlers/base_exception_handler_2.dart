import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';

void basicExceptions(BuildContext context, Object e, String prefix) {
  String errMessage = '####### $prefix :: $e';
  showCustomErrorSnack(context, errMessage);
  debugPrint(errMessage);
}

void handleDioException(BuildContext context, DioException e, String prefix) {
  String errMessage = '####### $prefix :: <DioError>: ${e.message}';
  if (e.response != null) {
    errMessage += '\n<Response>: ${e.response?.data}';
  }
  showCustomErrorSnack(context, errMessage);
  debugPrint(errMessage);
}

Future<void> runFutureWithExceptionHandler({
  required BuildContext context,
  required String errMsgPrefix,
  required Future<void> Function() callBackFunction,
}) async {
  try {
    await callBackFunction();
  } on DioException catch (e) {
    if (context.mounted) handleDioException(context, e, errMsgPrefix);
  } catch (e) {
    if (context.mounted) basicExceptions(context, e, errMsgPrefix);
  }
}

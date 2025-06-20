import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';

void sessionExceptionHandler(BuildContext context, Object e, String prefix) {
  // TODO - 토큰 이상 에러 발생 시(백엔드), 토큰 삭제 후 홈으로 redirect
}

void basicExceptions(BuildContext context, Object e, String prefix) {
  String errMessage = '####### $prefix 오류 :: $e';
  sessionExceptionHandler(context, e, prefix);
  showCustomErrorSnack(context, errMessage);
  debugPrint(errMessage);
}

void handleDioException(BuildContext context, DioException e, String prefix) {
  String errMessage = '####### $prefix 오류 :: <DioError>: ${e.message}';
  if (e.response != null) {
    errMessage += '\n<Response>: ${e.response?.data}';
  }
  showCustomErrorSnack(context, errMessage);
  debugPrint(errMessage);
}

Future<void> runFutureVoidWithExceptionHandler({
  required BuildContext context,
  required String errorPrefix,
  required Future<void> Function() requestFunction,
}) async {
  try {
    await requestFunction();
  } on DioException catch (e) {
    if (context.mounted) handleDioException(context, e, errorPrefix);
  } catch (e) {
    if (context.mounted) basicExceptions(context, e, errorPrefix);
  }
}

Future<T> runFutureWithExceptionHandler<T>({
  required BuildContext context,
  required String errorPrefix,
  required Future<T> Function() requestFunction,
  required T fallback,
}) async {
  try {
    return await requestFunction();
  } on DioException catch (e) {
    if (context.mounted) handleDioException(context, e, errorPrefix);
  } catch (e) {
    if (context.mounted) basicExceptions(context, e, errorPrefix);
  }
  return fallback;
}

Future<T> runFutureWithExceptionLogs<T>({
  required String errorPrefix,
  required Future<T> Function() requestFunction,
  required T fallback,
}) async {
  try {
    return await requestFunction();
  } catch (e) {
    String errMessage = '❌ERROR: $errorPrefix 오류 :: $e';
    debugPrint(errMessage);
  }
  return fallback;
}

import 'package:flutter/material.dart';
import 'package:snapster_app/features/authentication/constants/authorization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuthWebViewPage extends StatefulWidget {
  final String initialUrl; // ex: https://.../oauth2/authroization/kakao

  const OAuthWebViewPage({
    required this.initialUrl,
    super.key,
  });

  @override
  State<OAuthWebViewPage> createState() => _OAuthWebViewPageState();
}

class _OAuthWebViewPageState extends State<OAuthWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // 플랫폼별 생성 파라미터
    const params = PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript 허용
      ..setNavigationDelegate(
        // 네비게이션 콜백
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            // snapster://auth?accessToken=xxx
            if (uri.scheme == 'snapster' && uri.host == 'auth') {
              final token = uri.queryParameters[Authorizations.accessTokenKey];
              Navigator.of(context).pop(token);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl)); // 로드할 URL 지정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인 중...')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

import 'dart:convert';

String escapeSpecialCharacters(String text) {
  return text
      .replaceAll('"', '\\"')
      .replaceAll("'", "\\'")
      .replaceAll("<", "\\<")
      .replaceAll(">", "\\>");
}

// 문자열 깨짐 방지
String getUtfDecodedBody(text) {
  return utf8.decode(text);
}

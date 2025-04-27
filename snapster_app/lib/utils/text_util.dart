String escapeSpecialCharacters(String text) {
  return text
      .replaceAll('"', '\\"')
      .replaceAll("'", "\\'")
      .replaceAll("<", "\\<")
      .replaceAll(">", "\\>");
}

String unescapeSpecialCharacters(String text) {
  return text
      .replaceAll(r'\"', '"')
      .replaceAll(r"\'", "'")
      .replaceAll(r'\<', '<')
      .replaceAll(r'\>', '>');
}

bool validateEmailAddress(String email) {
  final regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  return email.isNotEmpty && regExp.hasMatch(email);
  // if (_email.isEmpty) return null;
  // if (!regExp.hasMatch(_email)) return 'Invalid Email Format';
}

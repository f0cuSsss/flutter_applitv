bool isArray(String str) {
  RegExp exp = RegExp(r"\[]");
  return exp.hasMatch(str);
}

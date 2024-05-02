String? cnicValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'CNIC number is required';
  }
  var regEx = RegExp(r"^\d{5}-\d{7}-\d{1}$");
  if (!regEx.hasMatch(value)) {
    return 'Enter a valid CNIC number (e.g., 12345-1234567-1)';
  }
  return null;
}

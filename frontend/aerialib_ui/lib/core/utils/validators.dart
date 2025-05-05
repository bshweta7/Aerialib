String? requiredFieldValidator(String? value, {
  String message = 'This field cannot be empty'
}) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

// TODO emailValidator, numberValidator
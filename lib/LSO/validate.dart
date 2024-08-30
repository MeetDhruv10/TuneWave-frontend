

String validateUsername(String username) {
  if (username.isEmpty) {
    return 'Enter a valid Username';
  }
  return '';
}

String validatePassword(String password) {
  if (password.isEmpty) {
    return 'Enter a valid Password';
  }
  String? validatePassword(String value) {
    RegExp regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter a password';
    } else {
      if (value.length < 8 || !regex.hasMatch(value)) {
        return 'Enter a valid password with at least one uppercase letter, one lowercase letter, one digit, and one special character.';
      } else {
        return null;
      }
    }
  }

  return '';

}

String validatePhoneNumber(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return 'Enter a valid Phone Number';
  }
  return '';
}

String validateEmail(String emailId) {
  if (emailId.isEmpty) {
    return 'Enter a valid Email ID';
  }
  return '';
}

String validateName(String name) {
  if (name.isEmpty) {
    return 'Enter a valid Name';
  }
  return '';
}

String validateInput(String username, String password, String name, String emailId) {
  String usernameValidation = validateUsername(username);
  if (usernameValidation.isNotEmpty) {
    return usernameValidation;
  }
  String passwordValidation = validatePassword(password);
  if (passwordValidation.isNotEmpty) {
    return passwordValidation;
  }

  return '';
}
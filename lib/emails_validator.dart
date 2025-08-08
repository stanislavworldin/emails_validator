/// Simple and efficient email address validator
/// Validates email syntax without using regular expressions
///
/// This class provides static methods for validating email addresses
/// according to RFC standards without using regular expressions.
/// It includes detailed debug information and supports both single
/// email validation and batch validation of email lists.
class EmailsValidator {
  /// Controls debug output from this package
  static bool debugEnabled = true;

  /// Default constructor for EmailsValidator
  ///
  /// This constructor is provided for completeness, though the class
  /// is designed to be used with static methods.
  const EmailsValidator();

  /// Validates email address
  ///
  /// [email] - string to validate
  /// Returns true if email is valid, false otherwise
  static bool validate(String? email) {
    debugPrint('EmailsValidator: Starting email validation: $email');

    // Check that email is not null or empty
    if (email == null || email.isEmpty) {
      debugPrint('EmailsValidator: Email is empty or null');
      return false;
    }

    // Remove leading and trailing spaces
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      debugPrint('EmailsValidator: Email is empty after trim');
      return false;
    }
    debugPrint('EmailsValidator: Email after trim: "$trimmedEmail"');

    // Check minimum length
    if (trimmedEmail.length < 5) {
      debugPrint(
          'EmailsValidator: Email too short (${trimmedEmail.length} characters)');
      return false;
    }

    // Check maximum length (254 characters according to RFC)
    if (trimmedEmail.length > 254) {
      debugPrint(
          'EmailsValidator: Email too long (${trimmedEmail.length} characters)');
      return false;
    }

    // Look for @ symbol
    final atIndex = trimmedEmail.indexOf('@');
    if (atIndex == -1) {
      debugPrint('EmailsValidator: Missing @ symbol');
      return false;
    }

    // There must be exactly one @ symbol
    if (atIndex != trimmedEmail.lastIndexOf('@')) {
      debugPrint('EmailsValidator: More than one @ symbol found');
      return false;
    }

    // Check that @ is not at the beginning
    if (atIndex == 0) {
      debugPrint('EmailsValidator: @ is at the beginning of email');
      return false;
    }

    // Check that @ is not at the end
    if (atIndex == trimmedEmail.length - 1) {
      debugPrint('EmailsValidator: @ is at the end of email');
      return false;
    }

    // Split into local part and domain
    final localPart = trimmedEmail.substring(0, atIndex);
    final domain = trimmedEmail.substring(atIndex + 1);

    debugPrint('EmailsValidator: Local part: "$localPart"');
    debugPrint('EmailsValidator: Domain: "$domain"');

    // Validate local part
    if (!_isValidLocalPart(localPart)) {
      debugPrint('EmailsValidator: Invalid local part');
      return false;
    }

    // Validate domain
    if (!_isValidDomain(domain)) {
      debugPrint('EmailsValidator: Invalid domain');
      return false;
    }

    debugPrint('EmailsValidator: Email is valid!');
    return true;
  }

  /// Validates local part of email
  static bool _isValidLocalPart(String localPart) {
    // Local part cannot be empty
    if (localPart.isEmpty) {
      debugPrint('EmailsValidator: Local part is empty');
      return false;
    }

    // Local part cannot be longer than 64 characters
    if (localPart.length > 64) {
      debugPrint(
          'EmailsValidator: Local part too long (${localPart.length} characters)');
      return false;
    }

    // Check first character
    final firstChar = localPart[0];
    if (!_isValidLocalChar(firstChar, isFirst: true)) {
      debugPrint(
          'EmailsValidator: Invalid first character in local part: $firstChar');
      return false;
    }

    // Check last character
    final lastChar = localPart[localPart.length - 1];
    if (!_isValidLocalChar(lastChar, isLast: true)) {
      debugPrint(
          'EmailsValidator: Invalid last character in local part: $lastChar');
      return false;
    }

    // Check for consecutive dots
    for (int i = 0; i < localPart.length - 1; i++) {
      if (localPart[i] == '.' && localPart[i + 1] == '.') {
        debugPrint('EmailsValidator: Consecutive dots in local part');
        return false;
      }
    }

    // Check for consecutive hyphens
    for (int i = 0; i < localPart.length - 1; i++) {
      if (localPart[i] == '-' && localPart[i + 1] == '-') {
        debugPrint('EmailsValidator: Consecutive hyphens in local part');
        return false;
      }
    }

    // Check all characters
    for (int i = 0; i < localPart.length; i++) {
      final char = localPart[i];
      if (!_isValidLocalChar(char)) {
        debugPrint('EmailsValidator: Invalid character in local part: $char');
        return false;
      }
    }

    return true;
  }

  /// Validates character in local part
  static bool _isValidLocalChar(String char,
      {bool isFirst = false, bool isLast = false}) {
    // Allowed characters for local part
    const allowedChars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#\$%&\'*+-/=?^_`{|}~.';

    // Dot cannot be first or last character
    if (char == '.' && (isFirst || isLast)) {
      return false;
    }

    // Hyphen cannot be first or last character
    if (char == '-' && (isFirst || isLast)) {
      return false;
    }

    // Check that character is in allowed set
    return allowedChars.contains(char);
  }

  /// Validates domain
  static bool _isValidDomain(String domain) {
    // Domain cannot be empty
    if (domain.isEmpty) {
      debugPrint('EmailsValidator: Domain is empty');
      return false;
    }

    // Domain cannot be longer than 253 characters
    if (domain.length > 253) {
      debugPrint(
          'EmailsValidator: Domain too long (${domain.length} characters)');
      return false;
    }

    // Check IP addresses (they should not be valid)
    if (_isIpAddress(domain)) {
      debugPrint('EmailsValidator: IP address not supported');
      return false;
    }

    // Split domain into parts by dots
    final parts = domain.split('.');

    // Must have at least 2 parts
    if (parts.length < 2) {
      debugPrint('EmailsValidator: Domain must contain at least 2 parts');
      return false;
    }

    // Check each domain part
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];

      // Part cannot be empty
      if (part.isEmpty) {
        debugPrint('EmailsValidator: Empty domain part');
        return false;
      }

      // Part cannot be longer than 63 characters
      if (part.length > 63) {
        debugPrint(
            'EmailsValidator: Domain part too long (${part.length} characters)');
        return false;
      }

      // Check characters in domain part
      for (int j = 0; j < part.length; j++) {
        final char = part[j];
        if (!_isValidDomainChar(char, j == 0, j == part.length - 1)) {
          debugPrint('EmailsValidator: Invalid character in domain: $char');
          return false;
        }
      }
    }

    // Last part (TLD) must be at least 1 character (for test/dev domains)
    final tld = parts.last;
    if (tld.isEmpty) {
      debugPrint('EmailsValidator: TLD too short (${tld.length} characters)');
      return false;
    }

    return true;
  }

  /// Checks if domain is an IP address
  static bool _isIpAddress(String domain) {
    // Simple IP address check (format x.x.x.x)
    final parts = domain.split('.');
    if (parts.length != 4) {
      return false;
    }

    for (final part in parts) {
      if (part.isEmpty) return false;

      // Check that part consists only of digits
      for (int i = 0; i < part.length; i++) {
        final char = part[i];
        if (!'0123456789'.contains(char)) {
          return false;
        }
      }

      // Check range (0-255)
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) {
        return false;
      }
    }

    return true;
  }

  /// Validates character in domain
  static bool _isValidDomainChar(String char, bool isFirst, bool isLast) {
    // Allowed characters for domain
    const allowedChars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-';

    // Hyphen cannot be first or last character
    if (char == '-' && (isFirst || isLast)) {
      return false;
    }

    // Check that character is in allowed set
    return allowedChars.contains(char);
  }

  /// Validates list of email addresses
  ///
  /// [emails] - list of strings to validate
  /// Returns Map with validation results for each email
  static Map<String, bool> validateList(List<String> emails) {
    debugPrint(
        'EmailsValidator: Starting validation of ${emails.length} email addresses');

    final results = <String, bool>{};

    for (final email in emails) {
      // If email already exists in results, add suffix for uniqueness
      String key = email;
      int counter = 1;
      while (results.containsKey(key)) {
        key = '$email (${counter++})';
      }
      results[key] = validate(email);
    }

    debugPrint('EmailsValidator: List validation completed');
    return results;
  }

  /// Gets list of invalid email addresses
  ///
  /// [emails] - list of strings to validate
  /// Returns list of invalid email addresses
  static List<String> getInvalidEmails(List<String> emails) {
    debugPrint('EmailsValidator: Getting list of invalid email addresses');

    final invalidEmails = <String>[];

    for (final email in emails) {
      if (!validate(email)) {
        invalidEmails.add(email);
      }
    }

    debugPrint(
        'EmailsValidator: Found ${invalidEmails.length} invalid email addresses');
    return invalidEmails;
  }

  /// Gets list of valid email addresses
  ///
  /// [emails] - list of strings to validate
  /// Returns list of valid email addresses
  static List<String> getValidEmails(List<String> emails) {
    debugPrint('EmailsValidator: Getting list of valid email addresses');

    final validEmails = <String>[];

    for (final email in emails) {
      if (validate(email)) {
        validEmails.add(email);
      }
    }

    debugPrint(
        'EmailsValidator: Found ${validEmails.length} valid email addresses');
    return validEmails;
  }
}

/// Function for debug output
void debugPrint(String message) {
  if (EmailsValidator.debugEnabled) {
    print('[DEBUG] $message');
  }
}

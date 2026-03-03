/// Validation errors for a single email address.
enum EmailValidationError {
  emptyInput,
  tooShort,
  tooLong,
  controlCharacterFound,
  nonAsciiCharacterFound,
  missingAtSymbol,
  multipleAtSymbols,
  localPartIsEmpty,
  localPartTooLong,
  localPartStartsWithInvalidCharacter,
  localPartEndsWithInvalidCharacter,
  consecutiveDotsInLocalPart,
  consecutiveHyphensInLocalPart,
  invalidLocalCharacter,
  unterminatedQuotedLocalPart,
  invalidEscapeInQuotedLocalPart,
  domainIsEmpty,
  domainTooLong,
  emptyDomainLabel,
  domainMustContainAtLeastTwoLabels,
  domainLabelTooLong,
  domainLabelStartsWithHyphen,
  domainLabelEndsWithHyphen,
  invalidDomainCharacter,
  tldTooShort,
  bareIpAddressDomainNotAllowed,
  invalidDomainLiteral,
}

extension EmailValidationErrorMessage on EmailValidationError {
  /// Human-readable reason for validation failure.
  String get message {
    switch (this) {
      case EmailValidationError.emptyInput:
        return 'Email is empty or contains only whitespace';
      case EmailValidationError.tooShort:
        return 'Email is too short';
      case EmailValidationError.tooLong:
        return 'Email is too long';
      case EmailValidationError.controlCharacterFound:
        return 'Control character is not allowed';
      case EmailValidationError.nonAsciiCharacterFound:
        return 'Only ASCII characters are supported';
      case EmailValidationError.missingAtSymbol:
        return 'Missing @ symbol';
      case EmailValidationError.multipleAtSymbols:
        return 'More than one @ symbol found';
      case EmailValidationError.localPartIsEmpty:
        return 'Local part is empty';
      case EmailValidationError.localPartTooLong:
        return 'Local part is longer than 64 characters';
      case EmailValidationError.localPartStartsWithInvalidCharacter:
        return 'Local part starts with invalid character';
      case EmailValidationError.localPartEndsWithInvalidCharacter:
        return 'Local part ends with invalid character';
      case EmailValidationError.consecutiveDotsInLocalPart:
        return 'Consecutive dots in local part are not allowed';
      case EmailValidationError.consecutiveHyphensInLocalPart:
        return 'Consecutive hyphens in local part are not allowed';
      case EmailValidationError.invalidLocalCharacter:
        return 'Local part contains unsupported character';
      case EmailValidationError.unterminatedQuotedLocalPart:
        return 'Quoted local part is not terminated';
      case EmailValidationError.invalidEscapeInQuotedLocalPart:
        return 'Invalid escape sequence in quoted local part';
      case EmailValidationError.domainIsEmpty:
        return 'Domain is empty';
      case EmailValidationError.domainTooLong:
        return 'Domain is longer than 253 characters';
      case EmailValidationError.emptyDomainLabel:
        return 'Domain contains empty label';
      case EmailValidationError.domainMustContainAtLeastTwoLabels:
        return 'Domain must contain at least two labels';
      case EmailValidationError.domainLabelTooLong:
        return 'Domain label is longer than 63 characters';
      case EmailValidationError.domainLabelStartsWithHyphen:
        return 'Domain label cannot start with hyphen';
      case EmailValidationError.domainLabelEndsWithHyphen:
        return 'Domain label cannot end with hyphen';
      case EmailValidationError.invalidDomainCharacter:
        return 'Domain contains unsupported character';
      case EmailValidationError.tldTooShort:
        return 'Top-level domain is too short';
      case EmailValidationError.bareIpAddressDomainNotAllowed:
        return 'Raw IPv4 domain is not allowed';
      case EmailValidationError.invalidDomainLiteral:
        return 'Domain literal is invalid';
    }
  }
}

/// Detailed validation output with normalized email for valid results.
class EmailValidationResult {
  const EmailValidationResult._({
    required this.isValid,
    required this.error,
    required this.normalizedEmail,
  });

  const EmailValidationResult.valid(String normalizedEmail)
      : this._(isValid: true, error: null, normalizedEmail: normalizedEmail);

  const EmailValidationResult.invalid(EmailValidationError error)
      : this._(isValid: false, error: error, normalizedEmail: null);

  /// Whether the email address is valid.
  final bool isValid;

  /// Validation error when [isValid] is `false`.
  final EmailValidationError? error;

  /// Trimmed + normalized email (domain lowercased) for valid addresses.
  final String? normalizedEmail;

  /// Human-readable message for invalid result.
  String? get message => error?.message;
}

/// Validation behavior configuration.
class EmailValidationOptions {
  const EmailValidationOptions({
    this.trimInput = true,
    this.allowQuotedLocalPart = true,
    this.allowDomainLiteral = false,
    this.allowConsecutiveHyphensInLocalPart = false,
    this.allowEdgeHyphenInLocalPart = false,
    this.allowUnicode = false,
    this.allowBareIpAddressDomain = false,
    this.minDomainLabels = 2,
    this.minTopLevelDomainLength = 1,
  })  : assert(minDomainLabels >= 1),
        assert(minTopLevelDomainLength >= 1);

  /// Trim leading and trailing ASCII whitespace before validation.
  final bool trimInput;

  /// Allow local part in quotes, e.g. `"name"@example.com`.
  final bool allowQuotedLocalPart;

  /// Allow domain literals, currently IPv4 format: `user@[127.0.0.1]`.
  final bool allowDomainLiteral;

  /// Keep legacy behavior when false (`user--name@...` is rejected).
  final bool allowConsecutiveHyphensInLocalPart;

  /// Keep legacy behavior when false (`-user@...` and `user-@...` are rejected).
  final bool allowEdgeHyphenInLocalPart;

  /// Allow non-ASCII characters.
  final bool allowUnicode;

  /// Allow bare IPv4 domain (`user@127.0.0.1`).
  final bool allowBareIpAddressDomain;

  /// Minimum amount of domain labels.
  final int minDomainLabels;

  /// Minimum length of top-level domain label.
  final int minTopLevelDomainLength;

  /// Backward-compatible profile.
  static const standard = EmailValidationOptions();

  /// More permissive profile for internal tooling.
  static const relaxed = EmailValidationOptions(
    allowDomainLiteral: true,
    allowConsecutiveHyphensInLocalPart: true,
    allowEdgeHyphenInLocalPart: true,
    allowBareIpAddressDomain: true,
    minDomainLabels: 1,
  );

  EmailValidationOptions copyWith({
    bool? trimInput,
    bool? allowQuotedLocalPart,
    bool? allowDomainLiteral,
    bool? allowConsecutiveHyphensInLocalPart,
    bool? allowEdgeHyphenInLocalPart,
    bool? allowUnicode,
    bool? allowBareIpAddressDomain,
    int? minDomainLabels,
    int? minTopLevelDomainLength,
  }) {
    return EmailValidationOptions(
      trimInput: trimInput ?? this.trimInput,
      allowQuotedLocalPart: allowQuotedLocalPart ?? this.allowQuotedLocalPart,
      allowDomainLiteral: allowDomainLiteral ?? this.allowDomainLiteral,
      allowConsecutiveHyphensInLocalPart: allowConsecutiveHyphensInLocalPart ??
          this.allowConsecutiveHyphensInLocalPart,
      allowEdgeHyphenInLocalPart:
          allowEdgeHyphenInLocalPart ?? this.allowEdgeHyphenInLocalPart,
      allowUnicode: allowUnicode ?? this.allowUnicode,
      allowBareIpAddressDomain:
          allowBareIpAddressDomain ?? this.allowBareIpAddressDomain,
      minDomainLabels: minDomainLabels ?? this.minDomainLabels,
      minTopLevelDomainLength:
          minTopLevelDomainLength ?? this.minTopLevelDomainLength,
    );
  }
}

typedef _OnValidBounds = void Function(int start, int end, int atIndex);

/// High-performance email validator focused on low allocations and fast exits.
class EmailsValidator {
  /// Controls debug output from this package.
  ///
  /// Defaults to `false` to avoid performance overhead in production.
  static bool debugEnabled = false;

  static const int _atCodeUnit = 64;
  static const int _dotCodeUnit = 46;
  static const int _hyphenCodeUnit = 45;
  static const int _quoteCodeUnit = 34;
  static const int _backslashCodeUnit = 92;
  static const int _openBracketCodeUnit = 91;
  static const int _closeBracketCodeUnit = 93;
  static const int _spaceCodeUnit = 32;
  static const int _zeroCodeUnit = 48;

  static const int _maxEmailLength = 254;
  static const int _maxLocalPartLength = 64;
  static const int _maxDomainLength = 253;
  static const int _maxDomainLabelLength = 63;
  static const int _minEmailLength = 5;

  /// Default constructor for API completeness.
  const EmailsValidator();

  /// Fast validation with backward-compatible default rules.
  static bool validate(String? email) {
    return validateWithOptions(email, options: EmailValidationOptions.standard);
  }

  /// Validation with custom rules.
  static bool validateWithOptions(
    String? email, {
    EmailValidationOptions options = EmailValidationOptions.standard,
  }) {
    final error = _validateError(email, options);
    if (debugEnabled) {
      if (error == null) {
        debugPrint('EmailsValidator: Email is valid');
      } else {
        debugPrint('EmailsValidator: ${error.message}');
      }
    }
    return error == null;
  }

  /// Detailed validation result with normalized value and reason on failure.
  static EmailValidationResult validateDetailed(
    String? email, {
    EmailValidationOptions options = EmailValidationOptions.standard,
  }) {
    var start = 0;
    var end = 0;
    var atIndex = 0;

    final error = _validateError(
      email,
      options,
      onValidBounds: (validStart, validEnd, validAtIndex) {
        start = validStart;
        end = validEnd;
        atIndex = validAtIndex;
      },
    );

    if (error != null) {
      return EmailValidationResult.invalid(error);
    }

    final normalized = _normalizeEmail(email!, start, end, atIndex);
    return EmailValidationResult.valid(normalized);
  }

  /// Validates list of email addresses.
  ///
  /// Keeps duplicate values by suffixing keys: `email (1)`, `email (2)`, ...
  static Map<String, bool> validateList(List<String> emails) {
    return validateListWithOptions(
      emails,
      options: EmailValidationOptions.standard,
    );
  }

  /// Validates list with custom validation options.
  static Map<String, bool> validateListWithOptions(
    List<String> emails, {
    EmailValidationOptions options = EmailValidationOptions.standard,
  }) {
    final results = <String, bool>{};
    final seen = <String, int>{};

    for (final email in emails) {
      final duplicateIndex = seen[email] ?? 0;
      seen[email] = duplicateIndex + 1;

      final key = duplicateIndex == 0 ? email : '$email ($duplicateIndex)';
      results[key] = validateWithOptions(email, options: options);
    }

    return results;
  }

  /// Gets list of invalid email addresses using default rules.
  static List<String> getInvalidEmails(List<String> emails) {
    return getInvalidEmailsWithOptions(
      emails,
      options: EmailValidationOptions.standard,
    );
  }

  /// Gets list of invalid email addresses with custom options.
  static List<String> getInvalidEmailsWithOptions(
    List<String> emails, {
    EmailValidationOptions options = EmailValidationOptions.standard,
  }) {
    final invalidEmails = <String>[];
    for (final email in emails) {
      if (!validateWithOptions(email, options: options)) {
        invalidEmails.add(email);
      }
    }
    return invalidEmails;
  }

  /// Gets list of valid email addresses using default rules.
  static List<String> getValidEmails(List<String> emails) {
    return getValidEmailsWithOptions(
      emails,
      options: EmailValidationOptions.standard,
    );
  }

  /// Gets list of valid email addresses with custom options.
  static List<String> getValidEmailsWithOptions(
    List<String> emails, {
    EmailValidationOptions options = EmailValidationOptions.standard,
  }) {
    final validEmails = <String>[];
    for (final email in emails) {
      if (validateWithOptions(email, options: options)) {
        validEmails.add(email);
      }
    }
    return validEmails;
  }

  static EmailValidationError? _validateError(
    String? email,
    EmailValidationOptions options, {
    _OnValidBounds? onValidBounds,
  }) {
    if (email == null || email.isEmpty) {
      return EmailValidationError.emptyInput;
    }

    final source = email;
    final sourceLength = source.length;

    var start = 0;
    var end = sourceLength;

    if (options.trimInput) {
      while (start < end && _isAsciiWhitespace(source.codeUnitAt(start))) {
        start++;
      }
      while (end > start && _isAsciiWhitespace(source.codeUnitAt(end - 1))) {
        end--;
      }
    }

    final length = end - start;
    if (length <= 0) {
      return EmailValidationError.emptyInput;
    }
    if (length < _minEmailLength) {
      return EmailValidationError.tooShort;
    }
    if (length > _maxEmailLength) {
      return EmailValidationError.tooLong;
    }

    var atIndex = -1;
    var inQuotedLocalPart = false;
    var escapedInQuotedLocalPart = false;

    for (var i = start; i < end; i++) {
      final code = source.codeUnitAt(i);

      if (_isAsciiControl(code)) {
        return EmailValidationError.controlCharacterFound;
      }
      if (!options.allowUnicode && code > 0x7F) {
        return EmailValidationError.nonAsciiCharacterFound;
      }

      if (atIndex == -1 && options.allowQuotedLocalPart) {
        if (escapedInQuotedLocalPart) {
          escapedInQuotedLocalPart = false;
          continue;
        }
        if (inQuotedLocalPart && code == _backslashCodeUnit) {
          escapedInQuotedLocalPart = true;
          continue;
        }
        if (code == _quoteCodeUnit) {
          inQuotedLocalPart = !inQuotedLocalPart;
          continue;
        }
      }

      if (code == _atCodeUnit) {
        if (inQuotedLocalPart) {
          continue;
        }
        if (atIndex != -1) {
          return EmailValidationError.multipleAtSymbols;
        }
        atIndex = i;
      }
    }

    if (inQuotedLocalPart) {
      return EmailValidationError.unterminatedQuotedLocalPart;
    }

    if (atIndex == -1) {
      return EmailValidationError.missingAtSymbol;
    }
    if (atIndex == start) {
      return EmailValidationError.localPartIsEmpty;
    }
    if (atIndex == end - 1) {
      return EmailValidationError.domainIsEmpty;
    }

    final localStart = start;
    final localEnd = atIndex;
    final domainStart = atIndex + 1;
    final domainEnd = end;

    final localLength = localEnd - localStart;
    if (localLength > _maxLocalPartLength) {
      return EmailValidationError.localPartTooLong;
    }

    final domainLength = domainEnd - domainStart;
    if (domainLength > _maxDomainLength) {
      return EmailValidationError.domainTooLong;
    }

    final localError =
        _validateLocalPart(source, localStart, localEnd, options);
    if (localError != null) {
      return localError;
    }

    final domainError =
        _validateDomain(source, domainStart, domainEnd, options);
    if (domainError != null) {
      return domainError;
    }

    if (onValidBounds != null) {
      onValidBounds(start, end, atIndex);
    }
    return null;
  }

  static EmailValidationError? _validateLocalPart(
    String source,
    int start,
    int end,
    EmailValidationOptions options,
  ) {
    final first = source.codeUnitAt(start);
    final last = source.codeUnitAt(end - 1);

    if (options.allowQuotedLocalPart && first == _quoteCodeUnit) {
      if (last != _quoteCodeUnit || end - start < 2) {
        return EmailValidationError.unterminatedQuotedLocalPart;
      }
      return _validateQuotedLocalPart(source, start + 1, end - 1, options);
    }

    if (first == _dotCodeUnit ||
        (!options.allowEdgeHyphenInLocalPart && first == _hyphenCodeUnit)) {
      return EmailValidationError.localPartStartsWithInvalidCharacter;
    }

    if (last == _dotCodeUnit ||
        (!options.allowEdgeHyphenInLocalPart && last == _hyphenCodeUnit)) {
      return EmailValidationError.localPartEndsWithInvalidCharacter;
    }

    var previousDot = false;
    var previousHyphen = false;

    for (var i = start; i < end; i++) {
      final code = source.codeUnitAt(i);

      if (code == _dotCodeUnit) {
        if (previousDot) {
          return EmailValidationError.consecutiveDotsInLocalPart;
        }
        previousDot = true;
        previousHyphen = false;
        continue;
      }

      if (code == _hyphenCodeUnit) {
        if (!options.allowConsecutiveHyphensInLocalPart && previousHyphen) {
          return EmailValidationError.consecutiveHyphensInLocalPart;
        }
        previousHyphen = true;
        previousDot = false;
        continue;
      }

      if (code == _spaceCodeUnit || !_isValidLocalCharacter(code)) {
        return EmailValidationError.invalidLocalCharacter;
      }

      previousDot = false;
      previousHyphen = false;
    }

    return null;
  }

  static EmailValidationError? _validateQuotedLocalPart(
    String source,
    int start,
    int end,
    EmailValidationOptions options,
  ) {
    var escaped = false;

    for (var i = start; i < end; i++) {
      final code = source.codeUnitAt(i);

      if (escaped) {
        if (_isAsciiControl(code)) {
          return EmailValidationError.invalidEscapeInQuotedLocalPart;
        }
        escaped = false;
        continue;
      }

      if (code == _backslashCodeUnit) {
        escaped = true;
        continue;
      }

      if (code == _quoteCodeUnit) {
        return EmailValidationError.invalidLocalCharacter;
      }

      if (_isAsciiControl(code)) {
        return EmailValidationError.invalidLocalCharacter;
      }

      if (!options.allowUnicode && code > 0x7F) {
        return EmailValidationError.nonAsciiCharacterFound;
      }
    }

    if (escaped) {
      return EmailValidationError.invalidEscapeInQuotedLocalPart;
    }

    return null;
  }

  static EmailValidationError? _validateDomain(
    String source,
    int start,
    int end,
    EmailValidationOptions options,
  ) {
    if (options.allowDomainLiteral &&
        source.codeUnitAt(start) == _openBracketCodeUnit &&
        source.codeUnitAt(end - 1) == _closeBracketCodeUnit) {
      return _validateDomainLiteral(source, start + 1, end - 1);
    }

    var labelLength = 0;
    var labelsCount = 1;

    for (var i = start; i < end; i++) {
      final code = source.codeUnitAt(i);

      if (code == _dotCodeUnit) {
        if (labelLength == 0) {
          return EmailValidationError.emptyDomainLabel;
        }
        if (source.codeUnitAt(i - 1) == _hyphenCodeUnit) {
          return EmailValidationError.domainLabelEndsWithHyphen;
        }
        labelsCount++;
        labelLength = 0;
        continue;
      }

      if (code == _hyphenCodeUnit) {
        if (labelLength == 0) {
          return EmailValidationError.domainLabelStartsWithHyphen;
        }
        labelLength++;
        if (labelLength > _maxDomainLabelLength) {
          return EmailValidationError.domainLabelTooLong;
        }
        continue;
      }

      if (code == _spaceCodeUnit || !_isAsciiAlphaNumeric(code)) {
        return EmailValidationError.invalidDomainCharacter;
      }

      labelLength++;
      if (labelLength > _maxDomainLabelLength) {
        return EmailValidationError.domainLabelTooLong;
      }
    }

    if (labelLength == 0) {
      return EmailValidationError.emptyDomainLabel;
    }

    if (source.codeUnitAt(end - 1) == _hyphenCodeUnit) {
      return EmailValidationError.domainLabelEndsWithHyphen;
    }

    if (labelsCount < options.minDomainLabels) {
      return EmailValidationError.domainMustContainAtLeastTwoLabels;
    }

    if (labelLength < options.minTopLevelDomainLength) {
      return EmailValidationError.tldTooShort;
    }

    if (!options.allowBareIpAddressDomain && _isBareIpv4(source, start, end)) {
      return EmailValidationError.bareIpAddressDomainNotAllowed;
    }

    return null;
  }

  static EmailValidationError? _validateDomainLiteral(
    String source,
    int start,
    int end,
  ) {
    if (start >= end) {
      return EmailValidationError.invalidDomainLiteral;
    }

    if (_isBareIpv4(source, start, end)) {
      return null;
    }

    return EmailValidationError.invalidDomainLiteral;
  }

  static bool _isBareIpv4(String source, int start, int end) {
    var value = 0;
    var digits = 0;
    var dotsCount = 0;

    for (var i = start; i < end; i++) {
      final code = source.codeUnitAt(i);

      if (code == _dotCodeUnit) {
        if (digits == 0 || value > 255) {
          return false;
        }
        dotsCount++;
        if (dotsCount > 3) {
          return false;
        }
        value = 0;
        digits = 0;
        continue;
      }

      if (!_isAsciiDigit(code)) {
        return false;
      }

      value = (value * 10) + (code - _zeroCodeUnit);
      digits++;
      if (digits > 3) {
        return false;
      }
    }

    return digits > 0 && value <= 255 && dotsCount == 3;
  }

  static bool _isAsciiWhitespace(int codeUnit) {
    return codeUnit == _spaceCodeUnit ||
        codeUnit == 9 ||
        codeUnit == 10 ||
        codeUnit == 11 ||
        codeUnit == 12 ||
        codeUnit == 13;
  }

  static bool _isAsciiControl(int codeUnit) {
    return codeUnit < _spaceCodeUnit || codeUnit == 127;
  }

  static bool _isAsciiDigit(int codeUnit) {
    return codeUnit >= 48 && codeUnit <= 57;
  }

  static bool _isAsciiAlphaNumeric(int codeUnit) {
    return (codeUnit >= 48 && codeUnit <= 57) ||
        (codeUnit >= 65 && codeUnit <= 90) ||
        (codeUnit >= 97 && codeUnit <= 122);
  }

  static bool _isValidLocalCharacter(int codeUnit) {
    if (_isAsciiAlphaNumeric(codeUnit)) {
      return true;
    }

    switch (codeUnit) {
      case 33: // !
      case 35: // #
      case 36: // $
      case 37: // %
      case 38: // &
      case 39: // '
      case 42: // *
      case 43: // +
      case 47: // /
      case 61: // =
      case 63: // ?
      case 94: // ^
      case 95: // _
      case 96: // `
      case 123: // {
      case 124: // |
      case 125: // }
      case 126: // ~
        return true;
      default:
        return false;
    }
  }

  static String _normalizeEmail(
    String source,
    int start,
    int end,
    int atIndex,
  ) {
    final localPart = source.substring(start, atIndex);
    final domain = source.substring(atIndex + 1, end).toLowerCase();
    return '$localPart@$domain';
  }
}

/// Debug helper for consumers that rely on package logging.
void debugPrint(String message) {
  if (EmailsValidator.debugEnabled) {
    print('[DEBUG] $message');
  }
}

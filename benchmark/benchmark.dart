import 'package:emails_validator/emails_validator.dart';

void main() {
  EmailsValidator.debugEnabled = false;

  final compatibilityInputs = <String?>[
    'user@example.com',
    'User.Name+tag@example.co.uk',
    'a@b.c',
    'test@sub.domain.org',
    'invalid',
    null,
    'user@@example.com',
    'user@.com',
    'user@example..com',
    'user@127.0.0.1',
    ' user@example.com ',
    'user--name@example.com',
  ];

  final extendedInputs = <String?>[
    ...compatibilityInputs,
    '"john doe"@example.com',
    'user@[127.0.0.1]',
    'user@localhost',
  ];

  const warmupRounds = 100000;
  const measureRounds = 1000000;

  _runSuite(
    title: 'Compatibility suite',
    inputs: compatibilityInputs,
    warmupRounds: warmupRounds,
    measureRounds: measureRounds,
  );

  print('');

  _runSuite(
    title: 'Extended suite',
    inputs: extendedInputs,
    warmupRounds: warmupRounds,
    measureRounds: measureRounds,
  );
}

void _runSuite({
  required String title,
  required List<String?> inputs,
  required int warmupRounds,
  required int measureRounds,
}) {
  print(title);

  _warmup(inputs, warmupRounds);

  final optimized = _runBenchmark(
    'optimized validate()',
    measureRounds,
    inputs,
    (email) => EmailsValidator.validate(email),
  );

  final optimizedDetailed = _runBenchmark(
    'optimized validateDetailed()',
    measureRounds,
    inputs,
    (email) => EmailsValidator.validateDetailed(email).isValid,
  );

  final legacy = _runBenchmark(
    'legacy validate()',
    measureRounds,
    inputs,
    (email) => _LegacyEmailsValidator.validate(email),
  );

  print('Summary');
  print(
      'optimized validate(): ${optimized.microsPerOp.toStringAsFixed(6)} us/op');
  print(
    'optimized validateDetailed(): '
    '${optimizedDetailed.microsPerOp.toStringAsFixed(6)} us/op',
  );
  print('legacy validate(): ${legacy.microsPerOp.toStringAsFixed(6)} us/op');
  print(
    'speedup vs legacy: '
    '${(legacy.microsPerOp / optimized.microsPerOp).toStringAsFixed(2)}x',
  );
  print('');
}

void _warmup(List<String?> inputs, int rounds) {
  for (var i = 0; i < rounds; i++) {
    EmailsValidator.validate(inputs[i % inputs.length]);
    _LegacyEmailsValidator.validate(inputs[i % inputs.length]);
  }
}

_BenchmarkResult _runBenchmark(
  String label,
  int rounds,
  List<String?> inputs,
  bool Function(String?) validate,
) {
  var validCount = 0;
  final sw = Stopwatch()..start();
  for (var i = 0; i < rounds; i++) {
    if (validate(inputs[i % inputs.length])) {
      validCount++;
    }
  }
  sw.stop();

  final micros = sw.elapsedMicroseconds;
  final microsPerOp = micros / rounds;

  print(
    '$label -> ${micros}us total | ${microsPerOp.toStringAsFixed(3)} us/op | '
    'valid=$validCount',
  );

  return _BenchmarkResult(microsPerOp);
}

class _BenchmarkResult {
  const _BenchmarkResult(this.microsPerOp);
  final double microsPerOp;
}

/// Lightweight copy of pre-optimization logic for comparison.
class _LegacyEmailsValidator {
  static bool validate(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return false;
    }
    if (trimmedEmail.length < 5 || trimmedEmail.length > 254) {
      return false;
    }

    final atIndex = trimmedEmail.indexOf('@');
    if (atIndex == -1 || atIndex != trimmedEmail.lastIndexOf('@')) {
      return false;
    }
    if (atIndex == 0 || atIndex == trimmedEmail.length - 1) {
      return false;
    }

    final localPart = trimmedEmail.substring(0, atIndex);
    final domain = trimmedEmail.substring(atIndex + 1);

    if (!_isValidLocalPart(localPart)) {
      return false;
    }
    if (!_isValidDomain(domain)) {
      return false;
    }

    return true;
  }

  static bool _isValidLocalPart(String localPart) {
    if (localPart.isEmpty || localPart.length > 64) {
      return false;
    }

    final firstChar = localPart[0];
    if (!_isValidLocalChar(firstChar, isFirst: true)) {
      return false;
    }

    final lastChar = localPart[localPart.length - 1];
    if (!_isValidLocalChar(lastChar, isLast: true)) {
      return false;
    }

    for (var i = 0; i < localPart.length - 1; i++) {
      if (localPart[i] == '.' && localPart[i + 1] == '.') {
        return false;
      }
    }

    for (var i = 0; i < localPart.length - 1; i++) {
      if (localPart[i] == '-' && localPart[i + 1] == '-') {
        return false;
      }
    }

    for (var i = 0; i < localPart.length; i++) {
      if (!_isValidLocalChar(localPart[i])) {
        return false;
      }
    }

    return true;
  }

  static bool _isValidLocalChar(
    String char, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    const allowedChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#\$%&'*+-/=?^_`{|}~.";

    if (char == '.' && (isFirst || isLast)) {
      return false;
    }
    if (char == '-' && (isFirst || isLast)) {
      return false;
    }
    return allowedChars.contains(char);
  }

  static bool _isValidDomain(String domain) {
    if (domain.isEmpty || domain.length > 253) {
      return false;
    }

    if (_isIpAddress(domain)) {
      return false;
    }

    final parts = domain.split('.');
    if (parts.length < 2) {
      return false;
    }

    for (final part in parts) {
      if (part.isEmpty || part.length > 63) {
        return false;
      }
      for (var i = 0; i < part.length; i++) {
        if (!_isValidDomainChar(part[i], i == 0, i == part.length - 1)) {
          return false;
        }
      }
    }

    return parts.last.isNotEmpty;
  }

  static bool _isIpAddress(String domain) {
    final parts = domain.split('.');
    if (parts.length != 4) {
      return false;
    }

    for (final part in parts) {
      if (part.isEmpty) return false;
      for (var i = 0; i < part.length; i++) {
        if (!'0123456789'.contains(part[i])) {
          return false;
        }
      }
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) {
        return false;
      }
    }

    return true;
  }

  static bool _isValidDomainChar(String char, bool isFirst, bool isLast) {
    const allowedChars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-';
    if (char == '-' && (isFirst || isLast)) {
      return false;
    }
    return allowedChars.contains(char);
  }
}

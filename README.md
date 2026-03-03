# Emails Validator

Fast and strict email validator for Dart and Flutter.

The validator uses a low-allocation parser (no regular expressions), keeps
legacy-compatible behavior by default, and now also supports detailed error
codes and configurable validation profiles.

## Features

- High-performance parser (`codeUnitAt`, early exits, no `split` in hot path)
- Backward-compatible default validation behavior
- Detailed validation result with exact failure reason
- Custom validation options (`standard` and `relaxed` profiles)
- Batch APIs for map/list validation with custom options
- Optional debug logs (`debugEnabled`, disabled by default)

## Installation

```yaml
dependencies:
  emails_validator: ^1.1.0
```

```bash
dart pub get
```

## Quick start

```dart
import 'package:emails_validator/emails_validator.dart';

void main() {
  final isValid = EmailsValidator.validate('user@example.com');
  print(isValid); // true
}
```

## Detailed validation

```dart
final result = EmailsValidator.validateDetailed('  User.Name+tag@EXAMPLE.COM  ');

print(result.isValid);          // true
print(result.normalizedEmail);  // User.Name+tag@example.com
print(result.error);            // null
```

For invalid input:

```dart
final result = EmailsValidator.validateDetailed('user@@example.com');
print(result.isValid); // false
print(result.error);   // EmailValidationError.multipleAtSymbols
print(result.message); // More than one @ symbol found
```

## Validation options

```dart
// Backward-compatible defaults.
final standard = EmailsValidator.validate('user@localhost'); // false

// Relaxed profile for internal tooling.
final relaxed = EmailsValidator.validateWithOptions(
  'user@localhost',
  options: EmailValidationOptions.relaxed,
); // true

// Custom profile.
final custom = EmailValidationOptions.standard.copyWith(
  allowQuotedLocalPart: false,
);
final ok = EmailsValidator.validateWithOptions(
  '"john doe"@example.com',
  options: custom,
); // false
```

## Batch APIs

```dart
final emails = [
  'user@example.com',
  'invalid-email',
  'user@localhost',
];

final results = EmailsValidator.validateList(emails);
// {'user@example.com': true, 'invalid-email': false, 'user@localhost': false}

final relaxedResults = EmailsValidator.validateListWithOptions(
  emails,
  options: EmailValidationOptions.relaxed,
);
// {'user@example.com': true, 'invalid-email': false, 'user@localhost': true}

final valid = EmailsValidator.getValidEmailsWithOptions(
  emails,
  options: EmailValidationOptions.relaxed,
);
```

## Performance benchmark

Run:

```bash
dart run benchmark/benchmark.dart
```

Current local benchmark (March 3, 2026) shows `~3x+` speedup versus legacy
implementation on both compatibility and extended datasets.

## Debug logs

Debug logging is disabled by default:

```dart
EmailsValidator.debugEnabled = true;
```

## Validation limits

- Total length: 5..254
- Local part: up to 64 chars
- Domain: up to 253 chars
- Domain label: up to 63 chars
- Standard profile requires at least two domain labels (`example.com`)

## Testing

```bash
dart test
```

## License

MIT

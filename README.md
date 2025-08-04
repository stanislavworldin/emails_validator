# Emails Validator

Simple and efficient email address validator for Dart. Validates email syntax without using regular expressions.

## Features

- ✅ Simple and clear validation logic
- ✅ No external dependencies
- ✅ Detailed debug information
- ✅ Support for validating lists of email addresses
- ✅ RFC standards compliance
- ✅ High performance

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  emails_validator: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Validation

```dart
import 'package:emails_validator/emails_validator.dart';

void main() {
  // Validate single email
  final isValid = EmailsValidator.validate('user@example.com');
  print(isValid); // true
  
  // Validate invalid email
  final isInvalid = EmailsValidator.validate('invalid-email');
  print(isInvalid); // false
}
```

### Validating List of Email Addresses

```dart
final emails = [
  'user@example.com',
  'invalid-email',
  'test@domain.co.uk',
  '@example.com',
];

// Get validation results for all emails
final results = EmailsValidator.validateList(emails);
// Result: {'user@example.com': true, 'invalid-email': false, ...}

// Get only valid emails
final validEmails = EmailsValidator.getValidEmails(emails);
// Result: ['user@example.com', 'test@domain.co.uk']

// Get only invalid emails
final invalidEmails = EmailsValidator.getInvalidEmails(emails);
// Result: ['invalid-email', '@example.com']
```

### Debug Information

The validator outputs detailed debug information to the console:

```
[DEBUG] EmailsValidator: Starting email validation: user@example.com
[DEBUG] EmailsValidator: Email after trim: "user@example.com"
[DEBUG] EmailsValidator: Local part: "user"
[DEBUG] EmailsValidator: Domain: "example.com"
[DEBUG] EmailsValidator: Email is valid!
```

## Supported Formats

### Valid Email Addresses

- `user@example.com`
- `test.email@domain.co.uk`
- `user+tag@example.org`
- `user.name@example.com`
- `user_name@example.com`
- `user-name@example.com`
- `user123@example.com`
- `user@subdomain.example.com`

### Invalid Email Addresses

- `invalid-email` (no @)
- `@example.com` (@ at beginning)
- `user@` (no domain)
- `user@.com` (empty domain part)
- `user..name@example.com` (consecutive dots)
- `user@-example.com` (hyphen at beginning of domain)
- `user@example-.com` (hyphen at end of domain)

## Validation Rules

1. **General Rules:**
   - Email cannot be null or empty
   - Minimum length: 5 characters
   - Maximum length: 254 characters
   - Must contain exactly one @ symbol

2. **Local Part (before @):**
   - Cannot be empty
   - Maximum length: 64 characters
   - Allowed characters: letters, numbers, `!#$%&'*+-/=?^_`{|}~.`
   - Dot cannot be first or last character

3. **Domain (after @):**
   - Cannot be empty
   - Maximum length: 253 characters
   - Must contain at least 2 parts (e.g., example.com)
   - Each part no longer than 63 characters
   - Allowed characters: letters, numbers, hyphen
   - Hyphen cannot be first or last character of part
   - Last part (TLD) minimum 2 characters

## Testing

Run tests:

```bash
dart test
```

## Performance

The validator is optimized for high performance:
- No regular expressions used
- Minimal string operations
- Efficient character checking

## License

MIT License 
# Changelog

## 1.0.2

- Added `EmailsValidator.debugEnabled` flag to control DEBUG output
- Strengthened validation: now ensures exactly one `@` symbol
- Fixed documentation about minimum TLD length (minimum 1 character)
- Example Flutter app: use `withValues` instead of `withOpacity`

## 1.0.1

Updated example to use Flutter web application instead of console example.

## 1.0.0

Initial release of the emails_validator package.

### Features
- Simple and efficient email address validation
- No external dependencies
- RFC standards compliance
- Detailed debug information
- Support for validating lists of email addresses
- High performance without regular expressions

### API
- `EmailsValidator.validate(String email)` - Validate single email
- `EmailsValidator.validateList(List<String> emails)` - Validate list of emails
- `EmailsValidator.getValidEmails(List<String> emails)` - Get only valid emails
- `EmailsValidator.getInvalidEmails(List<String> emails)` - Get only invalid emails

### Examples
- Basic validation
- List validation
- Debug information output
- Interactive Flutter Web demo 
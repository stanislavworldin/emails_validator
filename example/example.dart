import 'package:emails_validator/emails_validator.dart';

/// Example demonstrating the usage of the emails_validator package
///
/// This example shows how to use the EmailsValidator class to validate
/// single email addresses and lists of email addresses.
void main() {
  print('=== Email Validator Example ===\n');

  // Example 1: Validate single email addresses
  print('1. Single Email Validation:');
  print('-' * 30);

  final testEmails = [
    'user@example.com',
    'invalid-email',
    'user@domain',
    'user.name@company.co.uk',
    'user+tag@example.com',
    'user@.com',
    'user@domain.',
    'user@domain.com.',
  ];

  for (final email in testEmails) {
    final isValid = EmailsValidator.validate(email);
    final status = isValid ? '✅ VALID' : '❌ INVALID';
    print('$email -> $status');
  }

  // Example 2: Validate list of emails
  print('\n2. List Validation:');
  print('-' * 30);

  final emailList = [
    'john.doe@company.com',
    'jane@test.org',
    'invalid-email-format',
    'user@domain',
    'admin@example.net',
    'user@.invalid',
  ];

  final results = EmailsValidator.validateList(emailList);

  print('Validation results:');
  for (final entry in results.entries) {
    final status = entry.value ? '✅ VALID' : '❌ INVALID';
    print('${entry.key} -> $status');
  }

  // Example 3: Get valid emails only
  print('\n3. Get Valid Emails Only:');
  print('-' * 30);

  final validEmails = EmailsValidator.getValidEmails(emailList);
  print('Valid emails (${validEmails.length}):');
  for (final email in validEmails) {
    print('  ✅ $email');
  }

  // Example 4: Get invalid emails only
  print('\n4. Get Invalid Emails Only:');
  print('-' * 30);

  final invalidEmails = EmailsValidator.getInvalidEmails(emailList);
  print('Invalid emails (${invalidEmails.length}):');
  for (final email in invalidEmails) {
    print('  ❌ $email');
  }

  // Example 5: Edge cases
  print('\n5. Edge Cases:');
  print('-' * 30);

  final edgeCases = [
    '', // Empty string
    null, // Null value
    'a@b.c', // Very short but valid
    '${'a' * 64}@example.com', // Local part exactly 64 chars
    'user@${'a' * 63}.com', // Domain part exactly 63 chars
    'user@${'a' * 64}.com', // Domain part too long
  ];

  for (final email in edgeCases) {
    final isValid = EmailsValidator.validate(email);
    final status = isValid ? '✅ VALID' : '❌ INVALID';
    final displayEmail = email ?? 'null';
    print('$displayEmail -> $status');
  }

  print('\n=== Example completed ===');
}

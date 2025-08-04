import 'package:test/test.dart';
import 'package:emails_validator/emails_validator.dart';

void main() {
  group('EmailsValidator', () {
    group('validate()', () {
      test('should return true for valid email addresses', () {
        final validEmails = [
          'user@example.com',
          'test.email@domain.co.uk',
          'user+tag@example.org',
          'user.name@example.com',
          'user_name@example.com',
          'user-name@example.com',
          'user123@example.com',
          'user@subdomain.example.com',
          'user@example.co.uk',
          'user@example.org',
          'user@example.net',
          'user@example.info',
          'user@example.biz',
          'user@example.name',
          'user@example.pro',
          'user@example.museum',
          'user@example.travel',
          'user@example.jobs',
          'user@example.mobi',
          'user@example.tel',
          'user@example.asia',
          'user@example.eu',
          'user@example.int',
          'user@example.post',
          'user@example.xxx',
          'user@example.aero',
          'user@example.coop',
          'user@example.gov',
          'user@example.mil',
          'user@example.edu',
          'user@example.com',
          'user@example.net',
          'user@example.org',
          'user@example.int',
          'user@example.arpa',
          'user@example.root',
          'user@example.test',
          'user@example.example',
          'user@example.invalid',
          'user@example.localhost',
          'user@example.onion',
        ];

        for (final email in validEmails) {
          expect(EmailsValidator.validate(email), isTrue,
              reason: 'Email should be valid: $email');
        }
      });

      test('should return false for invalid email addresses', () {
        final invalidEmails = [
          '', // empty string
          null, // null
          'invalid-email', // no @
          '@example.com', // @ at beginning
          'user@', // no domain
          'user@.com', // empty domain part
          'user..name@example.com', // consecutive dots in local part
          'user@example..com', // consecutive dots in domain
          'user@-example.com', // hyphen at beginning of domain part
          'user@example-.com', // hyphen at end of domain part
          'user@example.com.', // dot at end of domain
          '.user@example.com', // dot at beginning of local part
          '${'a' * 65}@example.com', // too long local part
          'user@${'a' * 64}.com', // too long domain part
          'user@example.com${'a' * 200}', // too long email
          'a@b', // too short domain
          'user@example', // no TLD
          'user@.example.com', // empty domain part
          'user@example..com', // empty domain part
          'user@example.com..', // dot at end
          '..user@example.com', // dot at beginning
          'user@example.com..', // consecutive dots at end
          'user@example..com', // consecutive dots in domain
          'user@example.com.', // dot at end
          '.user@example.com', // dot at beginning
          'user@example.com${'a' * 200}', // too long
        ];

        for (final email in invalidEmails) {
          expect(EmailsValidator.validate(email), isFalse,
              reason: 'Email should be invalid: $email');
        }
      });

      test('should handle spaces correctly', () {
        expect(EmailsValidator.validate('  user@example.com  '), isTrue);
        expect(EmailsValidator.validate(' user@example.com'), isTrue);
        expect(EmailsValidator.validate('user@example.com '), isTrue);
        expect(EmailsValidator.validate('  '), isFalse); // only spaces
        expect(EmailsValidator.validate(''), isFalse); // empty string
      });

      test('should handle special characters correctly', () {
        // Valid special characters
        expect(EmailsValidator.validate('user.tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user_tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user-tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user!tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user#tag@example.com'), isTrue);
        expect(EmailsValidator.validate(r'user$tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user%tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user&tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user\'tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user*tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user+tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user-tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user/tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user=tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user?tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user^tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user_tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user`tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user{tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user|tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user}tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user~tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user.tag@example.com'), isTrue);

        // Invalid characters
        expect(
            EmailsValidator.validate('user@tag@example.com'), isFalse); // two @
        expect(
            EmailsValidator.validate('user tag@example.com'), isFalse); // space
        expect(
            EmailsValidator.validate('user,tag@example.com'), isFalse); // comma
        expect(EmailsValidator.validate('user;tag@example.com'),
            isFalse); // semicolon
        expect(
            EmailsValidator.validate('user:tag@example.com'), isFalse); // colon
        expect(EmailsValidator.validate('user"tag@example.com'),
            isFalse); // quotes
        expect(EmailsValidator.validate('user(tag@example.com'),
            isFalse); // parentheses
        expect(EmailsValidator.validate('user)tag@example.com'),
            isFalse); // parentheses
        expect(EmailsValidator.validate('user[tag@example.com'),
            isFalse); // square brackets
        expect(EmailsValidator.validate('user]tag@example.com'),
            isFalse); // square brackets
        expect(EmailsValidator.validate(r'user\tag@example.com'),
            isFalse); // backslash
      });

      test('should handle dots in local part correctly', () {
        // Valid cases with dots
        expect(EmailsValidator.validate('user.name@example.com'), isTrue);
        expect(EmailsValidator.validate('user.name.test@example.com'), isTrue);
        expect(
            EmailsValidator.validate('user.name.test.123@example.com'), isTrue);

        // Invalid cases with dots
        expect(EmailsValidator.validate('.user@example.com'),
            isFalse); // dot at beginning
        expect(EmailsValidator.validate('user.@example.com'),
            isFalse); // dot at end
        expect(EmailsValidator.validate('user..name@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user...name@example.com'),
            isFalse); // three consecutive dots
        expect(EmailsValidator.validate('user.name..test@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user..name.test@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user.name..test@example.com'),
            isFalse); // consecutive dots
      });

      test('should handle domains correctly', () {
        // Valid domains
        expect(EmailsValidator.validate('user@example.com'), isTrue);
        expect(EmailsValidator.validate('user@subdomain.example.com'), isTrue);
        expect(
            EmailsValidator.validate('user@sub.subdomain.example.com'), isTrue);
        expect(EmailsValidator.validate('user@example.co.uk'), isTrue);
        expect(EmailsValidator.validate('user@example.org'), isTrue);
        expect(EmailsValidator.validate('user@example.net'), isTrue);
        expect(EmailsValidator.validate('user@example.info'), isTrue);
        expect(EmailsValidator.validate('user@example.biz'), isTrue);
        expect(EmailsValidator.validate('user@example.name'), isTrue);
        expect(EmailsValidator.validate('user@example.pro'), isTrue);
        expect(EmailsValidator.validate('user@example.museum'), isTrue);
        expect(EmailsValidator.validate('user@example.travel'), isTrue);
        expect(EmailsValidator.validate('user@example.jobs'), isTrue);
        expect(EmailsValidator.validate('user@example.mobi'), isTrue);
        expect(EmailsValidator.validate('user@example.tel'), isTrue);
        expect(EmailsValidator.validate('user@example.asia'), isTrue);
        expect(EmailsValidator.validate('user@example.eu'), isTrue);
        expect(EmailsValidator.validate('user@example.int'), isTrue);
        expect(EmailsValidator.validate('user@example.post'), isTrue);
        expect(EmailsValidator.validate('user@example.xxx'), isTrue);
        expect(EmailsValidator.validate('user@example.aero'), isTrue);
        expect(EmailsValidator.validate('user@example.coop'), isTrue);
        expect(EmailsValidator.validate('user@example.gov'), isTrue);
        expect(EmailsValidator.validate('user@example.mil'), isTrue);
        expect(EmailsValidator.validate('user@example.edu'), isTrue);
        expect(EmailsValidator.validate('user@example.arpa'), isTrue);
        expect(EmailsValidator.validate('user@example.root'), isTrue);
        expect(EmailsValidator.validate('user@example.test'), isTrue);
        expect(EmailsValidator.validate('user@example.example'), isTrue);
        expect(EmailsValidator.validate('user@example.invalid'), isTrue);
        expect(EmailsValidator.validate('user@example.localhost'), isTrue);
        expect(EmailsValidator.validate('user@example.onion'), isTrue);

        // Invalid domains
        expect(EmailsValidator.validate('user@example'), isFalse); // no TLD
        expect(EmailsValidator.validate('user@.com'),
            isFalse); // empty domain part
        expect(
            EmailsValidator.validate('user@example.'), isFalse); // dot at end
        expect(EmailsValidator.validate('user@.example.com'),
            isFalse); // empty domain part
        expect(EmailsValidator.validate('user@example..com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user@example.com.'),
            isFalse); // dot at end
        expect(EmailsValidator.validate('user@example.com..'),
            isFalse); // consecutive dots at end
        expect(EmailsValidator.validate('user@-example.com'),
            isFalse); // hyphen at beginning
        expect(EmailsValidator.validate('user@example-.com'),
            isFalse); // hyphen at end
        expect(EmailsValidator.validate('user@example.com-'),
            isFalse); // hyphen at end
        expect(EmailsValidator.validate('user@example-.com'),
            isFalse); // hyphen at end
      });

      test('should handle long domains correctly', () {
        // Valid long domains
        final validLongDomain =
            'user@${'a' * 63}.com'; // 63 characters in domain part
        expect(EmailsValidator.validate(validLongDomain), isTrue);

        // Invalid long domains
        final invalidLongDomain =
            'user@${'a' * 64}.com'; // 64 characters in domain part
        expect(EmailsValidator.validate(invalidLongDomain), isFalse);

        // Very long domain
        final veryLongDomain = 'user@${'a' * 100}.com';
        expect(EmailsValidator.validate(veryLongDomain), isFalse);
      });

      test('should handle long local parts correctly', () {
        // Valid long local part
        final validLongLocal = '${'a' * 64}@example.com'; // 64 characters
        expect(EmailsValidator.validate(validLongLocal), isTrue);

        // Invalid long local part
        final invalidLongLocal = '${'a' * 65}@example.com'; // 65 characters
        expect(EmailsValidator.validate(invalidLongLocal), isFalse);

        // Very long local part
        final veryLongLocal = '${'a' * 100}@example.com';
        expect(EmailsValidator.validate(veryLongLocal), isFalse);
      });

      test('should handle total email length correctly', () {
        // Valid length (local part 64 characters + domain)
        final validLength =
            '${'a' * 64}@example.com'; // 64 + 12 = 76 characters
        expect(EmailsValidator.validate(validLength), isTrue);

        // Invalid length (local part 65 characters)
        final invalidLength =
            '${'a' * 65}@example.com'; // 65 + 12 = 77 characters
        expect(EmailsValidator.validate(invalidLength), isFalse);

        // Maximum length
        final maxLength = 'a' * 254;
        expect(EmailsValidator.validate(maxLength), isFalse); // no @
      });

      test('should handle multiple @ symbols correctly', () {
        expect(EmailsValidator.validate('user@tag@example.com'), isFalse);
        expect(EmailsValidator.validate('user@@example.com'), isFalse);
        expect(EmailsValidator.validate('user@@@example.com'), isFalse);
        expect(EmailsValidator.validate('user@example@com'), isFalse);
        expect(EmailsValidator.validate('user@example.com@'), isFalse);
        expect(EmailsValidator.validate('@user@example.com'), isFalse);
      });

      test('should handle numbers correctly', () {
        expect(EmailsValidator.validate('user123@example.com'), isTrue);
        expect(EmailsValidator.validate('123user@example.com'), isTrue);
        expect(EmailsValidator.validate('user@123example.com'), isTrue);
        expect(EmailsValidator.validate('user@example123.com'), isTrue);
        expect(EmailsValidator.validate('user@example.com123'), isTrue);
        expect(EmailsValidator.validate('123@example.com'), isTrue);
        expect(EmailsValidator.validate('user@123.com'), isTrue);
      });

      test('should handle mixed characters correctly', () {
        expect(EmailsValidator.validate('user.name+tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user_name-tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user.name_tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user-name.tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user+name-tag@example.com'), isTrue);
        expect(
            EmailsValidator.validate('user.name_tag-tag@example.com'), isTrue);
      });

      test('should handle edge cases of length correctly', () {
        // Minimum valid
        expect(EmailsValidator.validate('a@b.c'), isTrue);

        // Too short
        expect(EmailsValidator.validate('a@b'), isFalse);
        expect(EmailsValidator.validate('ab'), isFalse);
        expect(EmailsValidator.validate('a'), isFalse);
        expect(EmailsValidator.validate(''), isFalse);
      });

      test('should handle null and empty values correctly', () {
        expect(EmailsValidator.validate(null), isFalse);
        expect(EmailsValidator.validate(''), isFalse);
        expect(EmailsValidator.validate('   '), isFalse);
        expect(EmailsValidator.validate('\t'), isFalse);
        expect(EmailsValidator.validate('\n'), isFalse);
        expect(EmailsValidator.validate('\r'), isFalse);
      });

      test('should handle spaces and special characters correctly', () {
        expect(EmailsValidator.validate(' user@example.com'), isTrue);
        expect(EmailsValidator.validate('user@example.com '), isTrue);
        expect(EmailsValidator.validate('  user@example.com  '), isTrue);
        expect(EmailsValidator.validate('\tuser@example.com'), isTrue);
        expect(EmailsValidator.validate('user@example.com\t'), isTrue);
        expect(EmailsValidator.validate('\nuser@example.com'), isTrue);
        expect(EmailsValidator.validate('user@example.com\n'), isTrue);
        expect(EmailsValidator.validate('\ruser@example.com'), isTrue);
        expect(EmailsValidator.validate('user@example.com\r'), isTrue);
      });

      test('should handle Unicode characters correctly', () {
        // Test with Cyrillic (should be invalid)
        expect(EmailsValidator.validate('пользователь@example.com'), isFalse);
        expect(EmailsValidator.validate('user@пример.com'), isFalse);
        expect(EmailsValidator.validate('user@example.рф'), isFalse);

        // Test with emoji (should be invalid)
        expect(EmailsValidator.validate('user😀@example.com'), isFalse);
        expect(EmailsValidator.validate('user@example😀.com'), isFalse);
        expect(EmailsValidator.validate('user@example.com😀'), isFalse);
      });

      test('should handle special domain cases correctly', () {
        // IP addresses (should be invalid in current implementation)
        expect(EmailsValidator.validate('user@192.168.1.1'), isFalse);
        expect(EmailsValidator.validate('user@127.0.0.1'), isFalse);
        expect(EmailsValidator.validate('user@10.0.0.1'), isFalse);

        // Local domains (should be invalid)
        expect(EmailsValidator.validate('user@localhost'), isFalse);
        expect(EmailsValidator.validate('user@local'), isFalse);
        expect(EmailsValidator.validate('user@internal'), isFalse);
      });

      test('should handle complex cases correctly', () {
        expect(
            EmailsValidator.validate('user.name+tag@subdomain.example.co.uk'),
            isTrue);
        expect(EmailsValidator.validate('user_name-tag@example-domain.com'),
            isTrue);
        expect(EmailsValidator.validate('user.name_tag@example-domain.co.uk'),
            isTrue);

        expect(EmailsValidator.validate('user..name+tag@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user.name+tag@example..com'),
            isFalse); // consecutive dots in domain
        expect(EmailsValidator.validate('user.name+tag@-example.com'),
            isFalse); // hyphen at beginning
        expect(EmailsValidator.validate('user.name+tag@example-.com'),
            isFalse); // hyphen at end
      });
    });

    group('validateList()', () {
      test('should return Map with validation results', () {
        final emails = [
          'user@example.com',
          'invalid-email',
          'test@domain.co.uk',
          '@example.com',
        ];

        final results = EmailsValidator.validateList(emails);

        expect(results.length, equals(4));
        expect(results['user@example.com'], isTrue);
        expect(results['invalid-email'], isFalse);
        expect(results['test@domain.co.uk'], isTrue);
        expect(results['@example.com'], isFalse);
      });

      test('should handle empty list correctly', () {
        final results = EmailsValidator.validateList([]);
        expect(results.length, equals(0));
      });

      test('should handle list with duplicate emails correctly', () {
        final emails = [
          'user@example.com',
          'user@example.com',
          'invalid-email',
          'invalid-email',
        ];

        final results = EmailsValidator.validateList(emails);

        expect(results.length, equals(4));
        expect(results['user@example.com'], isTrue);
        expect(results['user@example.com (1)'], isTrue);
        expect(results['invalid-email'], isFalse);
        expect(results['invalid-email (1)'], isFalse);
      });
    });

    group('getValidEmails()', () {
      test('should return only valid email addresses', () {
        final emails = [
          'user@example.com',
          'invalid-email',
          'test@domain.co.uk',
          '@example.com',
          'valid@test.org',
        ];

        final validEmails = EmailsValidator.getValidEmails(emails);

        expect(validEmails.length, equals(3));
        expect(validEmails, contains('user@example.com'));
        expect(validEmails, contains('test@domain.co.uk'));
        expect(validEmails, contains('valid@test.org'));
        expect(validEmails, isNot(contains('invalid-email')));
        expect(validEmails, isNot(contains('@example.com')));
      });

      test('should return empty list for invalid emails', () {
        final emails = [
          'invalid-email',
          '@example.com',
          'user@',
          'user@.com',
        ];

        final validEmails = EmailsValidator.getValidEmails(emails);

        expect(validEmails.length, equals(0));
      });

      test('should return empty list for empty list', () {
        final validEmails = EmailsValidator.getValidEmails([]);
        expect(validEmails.length, equals(0));
      });
    });

    group('getInvalidEmails()', () {
      test('should return only invalid email addresses', () {
        final emails = [
          'user@example.com',
          'invalid-email',
          'test@domain.co.uk',
          '@example.com',
          'valid@test.org',
        ];

        final invalidEmails = EmailsValidator.getInvalidEmails(emails);

        expect(invalidEmails.length, equals(2));
        expect(invalidEmails, contains('invalid-email'));
        expect(invalidEmails, contains('@example.com'));
        expect(invalidEmails, isNot(contains('user@example.com')));
        expect(invalidEmails, isNot(contains('test@domain.co.uk')));
        expect(invalidEmails, isNot(contains('valid@test.org')));
      });

      test('should return empty list for valid emails', () {
        final emails = [
          'user@example.com',
          'test@domain.co.uk',
          'valid@test.org',
        ];

        final invalidEmails = EmailsValidator.getInvalidEmails(emails);

        expect(invalidEmails.length, equals(0));
      });

      test('should return empty list for empty list', () {
        final invalidEmails = EmailsValidator.getInvalidEmails([]);
        expect(invalidEmails.length, equals(0));
      });
    });

    group('Edge cases', () {
      test('should handle null correctly', () {
        expect(EmailsValidator.validate(null), isFalse);
      });

      test('should handle empty string correctly', () {
        expect(EmailsValidator.validate(''), isFalse);
      });

      test('should handle string with only spaces correctly', () {
        expect(EmailsValidator.validate('   '), isFalse);
      });

      test('should handle maximum allowed length correctly', () {
        final maxLengthEmail = 'a' * 1000;
        expect(EmailsValidator.validate(maxLengthEmail), isFalse); // no @

        final maxLengthValidEmail =
            '${'a' * 60}@example.com'; // 60 + 12 = 72 characters
        expect(EmailsValidator.validate(maxLengthValidEmail), isTrue);
      });

      test('should handle minimum allowed length correctly', () {
        expect(EmailsValidator.validate('a@b.c'), isTrue); // 5 characters
        expect(EmailsValidator.validate('a@b'), isFalse); // 4 characters
        expect(EmailsValidator.validate('a@'), isFalse); // 3 characters
        expect(EmailsValidator.validate('ab'), isFalse); // 2 characters
        expect(EmailsValidator.validate('a'), isFalse); // 1 character
        expect(EmailsValidator.validate(''), isFalse); // 0 characters
      });

      test('should handle special characters at beginning and end correctly',
          () {
        // Local part
        expect(EmailsValidator.validate('.user@example.com'),
            isFalse); // dot at beginning
        expect(EmailsValidator.validate('user.@example.com'),
            isFalse); // dot at end
        expect(EmailsValidator.validate('-user@example.com'),
            isFalse); // hyphen at beginning
        expect(EmailsValidator.validate('user-@example.com'),
            isFalse); // hyphen at end

        // Domain
        expect(EmailsValidator.validate('user@-example.com'),
            isFalse); // hyphen at beginning of domain
        expect(EmailsValidator.validate('user@example-.com'),
            isFalse); // hyphen at end of domain part
        expect(EmailsValidator.validate('user@example.com-'),
            isFalse); // hyphen at end of domain
      });

      test('should handle multiple special characters correctly', () {
        expect(EmailsValidator.validate('user..name@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user--name@example.com'),
            isFalse); // consecutive hyphens
        expect(EmailsValidator.validate('user..name@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user@example..com'),
            isFalse); // consecutive dots in domain
        expect(EmailsValidator.validate('user@example--com'),
            isFalse); // consecutive hyphens in domain
      });

      test('should handle very long strings correctly', () {
        final veryLongEmail = '${'a' * 1000}@example.com';
        expect(EmailsValidator.validate(veryLongEmail), isFalse);

        final veryLongLocal = '${'a' * 100}@example.com';
        expect(EmailsValidator.validate(veryLongLocal), isFalse);

        final veryLongDomain = 'user@${'a' * 100}.com';
        expect(EmailsValidator.validate(veryLongDomain), isFalse);
      });

      test('should handle special characters in different positions correctly',
          () {
        // Valid cases
        expect(EmailsValidator.validate('user.name@example.com'), isTrue);
        expect(EmailsValidator.validate('user-name@example.com'), isTrue);
        expect(EmailsValidator.validate('user_name@example.com'), isTrue);
        expect(EmailsValidator.validate('user+name@example.com'), isTrue);

        // Invalid cases
        expect(EmailsValidator.validate('.user.name@example.com'),
            isFalse); // dot at beginning
        expect(EmailsValidator.validate('user.name.@example.com'),
            isFalse); // dot at end
        expect(EmailsValidator.validate('user..name@example.com'),
            isFalse); // consecutive dots
        expect(EmailsValidator.validate('user...name@example.com'),
            isFalse); // three consecutive dots
      });

      test('should handle different encodings and characters correctly', () {
        // ASCII characters
        expect(EmailsValidator.validate('user@example.com'), isTrue);
        expect(EmailsValidator.validate('USER@EXAMPLE.COM'), isTrue);
        expect(EmailsValidator.validate('User@Example.Com'), isTrue);

        // Numbers
        expect(EmailsValidator.validate('user123@example.com'), isTrue);
        expect(EmailsValidator.validate('123user@example.com'), isTrue);
        expect(EmailsValidator.validate('user@123example.com'), isTrue);

        // Mixed characters
        expect(EmailsValidator.validate('user.name+tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user_name-tag@example.com'), isTrue);
        expect(EmailsValidator.validate('user.name_tag@example.com'), isTrue);
      });
    });
  });
}

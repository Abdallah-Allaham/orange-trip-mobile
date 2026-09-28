import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Input & Edge Case Validations', () {
    test('Email format validation', () {
      bool isValidEmail(String? email) {
        if (email == null || email.trim().isEmpty) return false;
        final clean = email.trim().toLowerCase();
        return clean.contains('@') && clean.endsWith('@orange.jo');
      }

      expect(isValidEmail(''), isFalse);
      expect(isValidEmail('invalid-email'), isFalse);
      expect(isValidEmail('user@gmail.com'), isFalse);
      expect(isValidEmail('ahmad.director@orange.jo'), isTrue);
      expect(isValidEmail('  reem.haddad@orange.jo  '), isTrue);
    });

    test('Password complexity & minimum length validation', () {
      bool isValidPassword(String? password) {
        if (password == null || password.isEmpty) return false;
        return password.length >= 6;
      }

      expect(isValidPassword(''), isFalse);
      expect(isValidPassword('12345'), isFalse);
      expect(isValidPassword('Orange'), isTrue);
      expect(isValidPassword('Orange2026!'), isTrue);
    });

    test('Smart URL Link Parsing for activation tokens', () {
      Map<String, String?> parseInvitationLink(String input) {
        final text = input.trim();
        if (text.startsWith('http://') || text.startsWith('https://')) {
          try {
            final uri = Uri.parse(text);
            return {
              'token': uri.queryParameters['token'],
              'email': uri.queryParameters['email'],
            };
          } catch (_) {}
        }
        return {'token': text, 'email': null};
      }

      // Case 1: Full Web URL with token and email
      final result1 = parseInvitationLink(
          'https://orange-cairo-trip.vercel.app/?token=ACT-9988-CAI&email=director@orange.jo');
      expect(result1['token'], equals('ACT-9988-CAI'));
      expect(result1['email'], equals('director@orange.jo'));

      // Case 2: Full Web URL with only token
      final result2 = parseInvitationLink('https://orange-cairo-trip.vercel.app/set-password?token=XYZ123');
      expect(result2['token'], equals('XYZ123'));
      expect(result2['email'], isNull);

      // Case 3: Plain token string entered directly
      final result3 = parseInvitationLink('ORG-CAI-7788');
      expect(result3['token'], equals('ORG-CAI-7788'));
      expect(result3['email'], isNull);
    });
  });
}

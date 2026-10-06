import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/core/utils/name_formatter.dart';

void main() {
  group('NameFormatter Unit Tests', () {
    test('formats clean English name with Eng. in English mode', () {
      expect(NameFormatter.formatWithTitle('Rana Dababneh', isArabic: false), 'Eng. Rana Dababneh');
    });

    test('formats clean English name with م. in Arabic mode', () {
      expect(NameFormatter.formatWithTitle('Rana Dababneh', isArabic: true), 'م. Rana Dababneh');
    });

    test('strips existing Eng. prefix before formatting', () {
      expect(NameFormatter.formatWithTitle('Eng. Rana Dababneh', isArabic: false), 'Eng. Rana Dababneh');
      expect(NameFormatter.formatWithTitle('Eng. Rana Dababneh', isArabic: true), 'م. Rana Dababneh');
      expect(NameFormatter.formatWithTitle('Eng Rana Dababneh', isArabic: true), 'م. Rana Dababneh');
    });

    test('strips existing Arabic prefix before formatting', () {
      expect(NameFormatter.formatWithTitle('م. رنا دبابنة', isArabic: true), 'م. رنا دبابنة');
      expect(NameFormatter.formatWithTitle('م. رنا دبابنة', isArabic: false), 'Eng. رنا دبابنة');
      expect(NameFormatter.formatWithTitle('م رنا دبابنة', isArabic: false), 'Eng. رنا دبابنة');
    });

    test('handles null or empty names gracefully', () {
      expect(NameFormatter.formatWithTitle(null, isArabic: false), 'Eng. Participant');
      expect(NameFormatter.formatWithTitle('', isArabic: true), 'م. مشارك');
      expect(NameFormatter.formatWithTitle('   ', isArabic: false), 'Eng. Participant');
    });

    test('getInitial returns correct first letter skipping title prefixes', () {
      expect(NameFormatter.getInitial('Rana Dababneh'), 'R');
      expect(NameFormatter.getInitial('Eng. Rana Dababneh'), 'R');
      expect(NameFormatter.getInitial('م. رنا دبابنة'), 'ر');
      expect(NameFormatter.getInitial('Eng Rana'), 'R');
      expect(NameFormatter.getInitial(null), 'U');
      expect(NameFormatter.getInitial(''), 'U');
    });
  });
}

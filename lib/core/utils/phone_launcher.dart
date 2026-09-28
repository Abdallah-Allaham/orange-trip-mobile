import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneCall(String phoneNumber) async {
  final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  final uri = Uri.parse('tel:$cleanNumber');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

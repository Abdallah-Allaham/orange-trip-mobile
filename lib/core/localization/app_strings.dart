import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  final String language;

  AppStrings(this.language);

  bool get isArabic => language == 'ar';

  String get appTitle => 'app_title'.tr();
  String get brandOrange => 'brand_orange'.tr();
  String get home => 'home'.tr();
  String get dashboard => isArabic ? 'لوحة القيادة' : 'Dashboard';
  String get travel => 'travel'.tr();
  String get itinerary => 'itinerary'.tr();
  String get profile => 'profile'.tr();
  String get logout => isArabic ? 'تسجيل الخروج' : 'Sign Out';
  String get languageToggle => 'language_toggle'.tr();
  String get emailLabel => 'email_label'.tr();
  String get emailHint => 'email_hint'.tr();
  String get emailRequired => 'email_required'.tr();
  String get passwordLabel => 'password_label'.tr();
  String get passwordHint => 'password_hint'.tr();
  String get passwordRequired => 'password_required'.tr();
  String get enableBiometrics => 'quick_sign_in'.tr();
  String get signInButton => 'sign_in_button'.tr();
  String get setPasswordPrompt => 'first_time_prompt'.tr();
  String get biometricUnlock => 'biometric_unlock'.tr();
  String get setPasswordTitle => 'account_activation_title'.tr();
  String get setPasswordDescription => 'activation_description'.tr();
  String get tokenLabel => 'activation_token_label'.tr();
  String get tokenHint => 'activation_token_hint'.tr();
  String get newPasswordLabel => 'new_password_label'.tr();
  String get confirmPasswordLabel => 'confirm_password_label'.tr();
  String get savePasswordButton => 'save_password_button'.tr();
  String get backToLogin => 'back_to_login'.tr();
  String get passwordsDoNotMatch => 'passwords_do_not_match'.tr();
  String get passwordTooShort => 'password_too_short'.tr();
}

# Orange Jordan — O-Trip Mobile Application

تطبيق الموبايل الرسمي لرحلة مدراء أورنج الأردن إلى القاهرة 2026، مبني باستخدام **Flutter** متوافق مع نظامي **Android** و **iOS**.

---

## 📱 مميزات التطبيق (Features)

* **واجهة مستخدم متوافقة مع هوية أورنج (Orange Design System):**
  * دعم اللغتين العربية (RTL) والإنجليزية (LTR).
  * عد تنازلي تفاعلي للرحلة (Trip Countdown).
* **إدارة الرحلة للمشاركين:**
  * تفاصيل تذاكر الطيران (الذهاب والعودة) ومعلومات الفندق والحافلة المخصصة.
  * البرنامج اليومي للرحلة (Itinerary) مع تنبيهات الفعاليات القادمة.
  * بطاقة الصعود الرقمية ودليل أرقام الطوارئ السريعة (SOS).
* **الأمان والمصادقة:**
  * تسجيل الدخول المشفر وحفظ الجلسات محلياً بأمان عبر `flutter_secure_storage`.
  * حماية وتشفير الاتصال مع خادم API.

---

## 🛠️ متطلبات التشغيل (Prerequisites)

* **Flutter SDK:** الإصدار 3.24+ أو أحدث
* **Dart SDK:** الإصدار 3.5+
* **Android Studio** أو **VS Code** مع إضافات Flutter/Dart
* **Android SDK:** API 21 كحد أدنى

---

## 🚀 التشغيل السريع (Getting Started)

1. **تثبيت الحزم والمكتبات:**
   ```bash
   flutter pub get
   ```

2. **تشغيل الفحوصات والاختبارات (Tests):**
   ```bash
   flutter test
   ```

3. **تشغيل التطبيق على المحاكي أو جهاز حقيقي:**
   ```bash
   flutter run
   ```

4. **بناء نسخة APK نهائية (Release APK):**
   ```bash
   flutter build apk --release
   ```
   النسخة الجاهزة ستكون في المسار:
   `build/app/outputs/flutter-apk/app-release.apk`

class ApiConstants {
  // Configurable base URL:
  // If tested remotely, will hit the hosted cloud API URL.
  // Can be overridden at runtime via SecureStorage or in-app developer toggle.
  static const String defaultRemoteUrl = 'https://orange-cairo-trip.onrender.com/api'; 
  static const String defaultLocalAndroid = 'http://10.0.2.2:5000/api';
  static const String defaultLocalIos = 'http://localhost:5000/api';

  // Active base URL (points to live Render cloud backend)
  static String activeBaseUrl = defaultRemoteUrl;

  // Auth Endpoints
  static const String login = '/Auth/login';
  static const String checkEligibility = '/Auth/check-eligibility';
  static const String setPassword = '/Auth/set-password';
  static const String forgotPassword = '/Auth/forgot-password';
  static const String resetPassword = '/Auth/reset-password';
  static const String me = '/Auth/me';

  // Profile Endpoints
  static const String profile = '/Profile';
  static const String emergencyContact = '/Profile/emergency-contact';
  static const String health = '/Profile/health';

  // Travel & Logistics
  static const String flight = '/Travel/flight';
  static const String hotel = '/Travel/hotel';

  // Itinerary & Timeline
  static const String itinerary = '/Itinerary';
  static const String itinerarySummary = '/Itinerary/summary';

  // Communication & Alerts
  static const String announcements = '/Communication/announcements';
  static String acknowledgeAnnouncement(int id) => '/Communication/announcements/$id/acknowledge';
  static const String help = '/Communication/help';
  static const String faqs = '/Communication/faqs';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

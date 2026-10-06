import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../domain/entities/bus_entity.dart';
import '../../domain/entities/dashboard_data_entity.dart';
import '../../domain/entities/flight_entity.dart';
import '../../domain/entities/hotel_entity.dart';
import '../../domain/entities/itinerary_item_entity.dart';
import '../../domain/entities/itinerary_summary_entity.dart';
import '../../domain/entities/trip_settings_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/announcement_model.dart';
import '../models/flight_model.dart';
import '../models/hotel_model.dart';
import '../models/itinerary_item_model.dart';
import '../models/itinerary_summary_model.dart';
import '../models/trip_settings_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<TripSettingsEntity> getActiveTrip() async {
    try {
      return await remoteDataSource.getActiveTrip();
    } catch (_) {
      return TripSettingsModel.defaultSettings;
    }
  }

  @override
  Future<FlightEntity> getFlightDetails() async {
    try {
      return await remoteDataSource.getFlight();
    } catch (_) {
      return const FlightModel(
        airline: 'Royal Jordanian',
        flightNumberOutbound: 'RJ 501',
        outboundRoute: 'Amman (AMM) → Cairo (CAI)',
        outboundDepartureTime: '2026-11-02 09:30',
        outboundArrivalTime: '2026-11-02 10:55',
        outboundAirport: 'Queen Alia International Airport',
        outboundTerminal: 'Terminal 1',
        outboundBaggage: '1 x 23kg checked + 7kg cabin',
        flightNumberReturn: 'RJ 506',
        returnRoute: 'Cairo (CAI) → Amman (AMM)',
        returnDepartureTime: '2026-11-05 19:00',
        returnArrivalTime: '2026-11-05 21:15',
        returnAirport: 'Cairo International Airport',
        returnTerminal: 'Terminal 2',
        returnBaggage: '1 x 23kg checked + 7kg cabin',
        bookingReference: 'RJ-ORG-7788',
        ticketStatus: 'Ticketed',
      );
    }
  }

  @override
  Future<HotelEntity> getHotelDetails() async {
    try {
      return await remoteDataSource.getHotel();
    } catch (_) {
      return const HotelModel(
        hotelName: 'The St. Regis Cairo',
        hotelAddressEn: '1189 Nile Corniche, Cairo, Egypt',
        hotelAddressAr: '1189 كورنيش النيل، القاهرة، مصر',
        hotelPhone: '+20 2 2597 9000',
        hotelReceptionContact: 'Dial 0 from room',
        emergencyContact: '+20 100 000 9999',
        checkInDate: '2 Nov 2026, 14:00',
        checkOutDate: '5 Nov 2026, 12:00',
        roomNumber: 'Assigned upon arrival',
        roomCategory: 'Deluxe Nile View',
        confirmationReference: 'HTL-ORG-7788',
        wifiInstructions: 'Network: StRegis_Guest | Pass: OrangeCairo2026',
        operationalNotes: 'Keycards available at Orange Welcome Desk in lobby.',
      );
    }
  }

  @override
  Future<ItinerarySummaryEntity> getItinerarySummary() async {
    try {
      return await remoteDataSource.getItinerarySummary();
    } catch (_) {
      return const ItinerarySummaryModel(
        nextActivity: 'Official Welcome Dinner — Nile Cruise',
        nextActivityAr: 'عشاء الترحيب الافتتاحي بنيل القاهرة',
        nextActivityTime: '8:00 PM',
        gatheringPoint: 'Hotel Lobby',
        gatheringPointAr: 'بهو الفندق (اللوبي)',
        gatheringTime: '7:30 PM',
        dressCode: 'Smart Casual',
        dressCodeAr: 'رسمي أنيق',
        weatherCity: 'Cairo',
        weatherTemp: '27°C',
        weatherCondition: 'Warm / Sunny',
        tripStatus: 'Ready',
        countdownDays: 34,
      );
    }
  }

  @override
  Future<List<ItineraryItemEntity>> getItineraryItems() async {
    try {
      final items = await remoteDataSource.getItineraryItems();
      if (items.isNotEmpty) return items;
    } catch (_) {}

    // 4-Day complete itinerary defaults aligned with web frontend
    return const [
      // Day 1: 2 Nov
      ItineraryItemModel(
        id: 1,
        date: '2026-11-02',
        startTime: '09:30',
        endTime: '10:55',
        titleEn: 'Flight Amman to Cairo (RJ 501)',
        titleAr: 'رحلة الطيران: عمّان إلى القاهرة (RJ 501)',
        descriptionEn: 'Outbound flight RJ 501 from Queen Alia Airport to Cairo.',
        descriptionAr: 'رحلة الذهاب RJ 501 من مطار الملكة علياء الدولي إلى مطار القاهرة.',
        locationEn: 'Queen Alia Int Airport (AMM)',
        locationAr: 'مطار الملكة علياء الدولي',
        gatheringPointEn: 'Orange Desk, AMM Terminal 1',
        gatheringPointAr: 'مكتب أورنج، مبنى 1',
        dressCodeEn: 'Smart Casual',
        dressCodeAr: 'سمارت كاجوال',
        targetGroup: 'All',
      ),
      ItineraryItemModel(
        id: 2,
        date: '2026-11-02',
        startTime: '14:00',
        endTime: '16:00',
        titleEn: 'Hotel Check-in & Orange Welcome Desk',
        titleAr: 'تسجيل الوصول بفندق سانت ريجيس ومكتب الاستقبال',
        descriptionEn: 'Check-in at The St. Regis Cairo, welcome drinks, and room keys.',
        descriptionAr: 'تسجيل الدخول في فندق سانت ريجيس، استلام الغرف، ومشروب الترحيب الخاص.',
        locationEn: 'The St. Regis Cairo Lobby',
        locationAr: 'بهو فندق سانت ريجيس القاهرة',
        gatheringPointEn: 'Hotel Main Reception',
        gatheringPointAr: 'الاستقبال الرئيسي للفندق',
        dressCodeEn: 'Casual',
        dressCodeAr: 'كاجوال مريح',
        targetGroup: 'All',
      ),
      ItineraryItemModel(
        id: 3,
        date: '2026-11-02',
        startTime: '19:30',
        endTime: '22:30',
        titleEn: 'Welcome Nile Dinner Cruise',
        titleAr: 'عشاء ترحيبي فاخر على ضفاف النيل',
        descriptionEn: 'Official opening dinner welcoming Orange Jordan Directors to Cairo.',
        descriptionAr: 'عشاء الترحيب الرسمي بمدراء أورنج الأردن في القاهرة بأجواء نيلية ساحرة.',
        locationEn: 'The St. Regis Ballroom & Terrace',
        locationAr: 'قاعة وتراس فندق سانت ريجيس',
        gatheringPointEn: 'Hotel Lobby (19:00 Departure)',
        gatheringPointAr: 'بهو الفندق (الساعة 19:00)',
        dressCodeEn: 'Formal / Smart Casual',
        dressCodeAr: 'رسمي / سمارت كاجوال',
        targetGroup: 'All',
      ),

      // Day 2: 3 Nov
      ItineraryItemModel(
        id: 4,
        date: '2026-11-03',
        startTime: '09:30',
        endTime: '13:30',
        titleEn: 'Grand Egyptian Museum (GEM) VIP Tour',
        titleAr: 'جولة خاصة في المتحف المصري الكبير والأهرامات',
        descriptionEn: 'Exclusive VIP guided tour of the Grand Egyptian Museum and Giza Plateau.',
        descriptionAr: 'جولة إرشادية حصرية خاصة لوفد أورنج في المتحف المصري الكبير وهضبة الأهرامات.',
        locationEn: 'Grand Egyptian Museum, Giza',
        locationAr: 'المتحف المصري الكبير، الجيزة',
        gatheringPointEn: 'Hotel Main Lobby (Bus Gathering 09:00 AM)',
        gatheringPointAr: 'بهو الفندق (تجمع الحافلات 09:00 صباحاً)',
        dressCodeEn: 'Comfortable / Walking Shoes',
        dressCodeAr: 'ملابس وحذاء مشي مريح',
        targetGroup: 'All',
      ),
      ItineraryItemModel(
        id: 5,
        date: '2026-11-03',
        startTime: '15:30',
        endTime: '18:00',
        titleEn: 'Orange Leadership & Digital Horizons Session',
        titleAr: 'جلسة قيادات أورنج: آفاق التحول الرقمي',
        descriptionEn: 'Interactive strategic leadership workshop and group discussions.',
        descriptionAr: 'ورشة عمل استراتيجية تفاعلية ونقاشات القيادة للمرحلة القادمة.',
        locationEn: 'St. Regis Nile Meeting Pavilion',
        locationAr: 'قاعة المؤتمرات بفندق سانت ريجيس',
        gatheringPointEn: 'Meeting Room A',
        gatheringPointAr: 'قاعة الاجتماعات أ',
        dressCodeEn: 'Business Casual',
        dressCodeAr: 'بزنس كاجوال',
        targetGroup: 'All',
      ),

      // Day 3: 4 Nov
      ItineraryItemModel(
        id: 6,
        date: '2026-11-04',
        startTime: '10:00',
        endTime: '14:00',
        titleEn: 'New Administrative Capital Innovation Tour',
        titleAr: 'جولة الابتكار في العاصمة الإدارية الجديدة',
        descriptionEn: 'Visit to Egypt Knowledge City and smart infrastructure landmarks.',
        descriptionAr: 'زيارة مدينة المعرفة وأبرز معالم البنية التحتية الذكية في العاصمة الإدارية.',
        locationEn: 'New Administrative Capital',
        locationAr: 'العاصمة الإدارية الجديدة',
        gatheringPointEn: 'Hotel Lobby (09:30 AM Departure)',
        gatheringPointAr: 'بهو الفندق (الانطلاق 09:30 صباحاً)',
        dressCodeEn: 'Smart Casual',
        dressCodeAr: 'سمارت كاجوال',
        targetGroup: 'All',
      ),
      ItineraryItemModel(
        id: 7,
        date: '2026-11-04',
        startTime: '19:30',
        endTime: '23:00',
        titleEn: 'Orange Directors Gala Dinner & Recognition Awards',
        titleAr: 'الحفل الاحتفالي السنوي وتكريم مدراء أورنج',
        descriptionEn: 'The grand gala evening celebrating achievements, leadership milestones, and awards.',
        descriptionAr: 'حفل العشاء الختامي الرسمي لتكريم إنجازات المدراء وتوزيع الجوائز التقديرية.',
        locationEn: 'Historic Cairo Palace Venue',
        locationAr: 'قصر تاريخي عريق بالقاهرة',
        gatheringPointEn: 'Hotel Lobby (19:00 Departure)',
        gatheringPointAr: 'بهو الفندق (التجمع 19:00 للانطلاق)',
        dressCodeEn: 'Black Tie / Elegant Evening',
        dressCodeAr: 'بدلة رسمية / ملابس سهرة أنيقة',
        targetGroup: 'All',
      ),

      // Day 4: 5 Nov
      ItineraryItemModel(
        id: 8,
        date: '2026-11-05',
        startTime: '10:00',
        endTime: '13:00',
        titleEn: 'Old Cairo & Khan el-Khalili Cultural Walk',
        titleAr: 'جولة القاهرة التاريخية وخان الخليلي',
        descriptionEn: 'Cultural walking tour through Khan el-Khalili, heritage coffee shops, and artisan souks.',
        descriptionAr: 'جولة تراثية في خان الخليلي ومقاهي القاهرة القديمة وأسواق الحرف اليدوية.',
        locationEn: 'Khan el-Khalili, Historic Cairo',
        locationAr: 'خان الخليلي، القاهرة التاريخية',
        gatheringPointEn: 'Hotel Lobby (09:45 AM)',
        gatheringPointAr: 'بهو الفندق (09:45 صباحاً)',
        dressCodeEn: 'Comfortable Walking',
        dressCodeAr: 'ملابس خفيفة ومريحة',
        targetGroup: 'All',
      ),
      ItineraryItemModel(
        id: 9,
        date: '2026-11-05',
        startTime: '15:30',
        endTime: '16:30',
        titleEn: 'Hotel Check-out & Airport Shuttle Departure',
        titleAr: 'تسجيل المغادرة من الفندق والانطلاق للمطار',
        descriptionEn: 'Check-out procedures, baggage loading, and transfer to Cairo International Airport.',
        descriptionAr: 'تسجيل الخروج، تحميل الحقائب، والانطلاق بالحافلات إلى مطار القاهرة الدولي.',
        locationEn: 'The St. Regis Cairo Main Entrance',
        locationAr: 'المدخل الرئيسي لفندق سانت ريجيس',
        gatheringPointEn: 'Hotel Lobby & Concierge',
        gatheringPointAr: 'بهو الفندق',
        dressCodeEn: 'Travel Clothes',
        dressCodeAr: 'ملابس سفر مريحة',
        targetGroup: 'All',
      ),
      ItineraryItemModel(
        id: 10,
        date: '2026-11-05',
        startTime: '19:00',
        endTime: '21:15',
        titleEn: 'Return Flight to Amman (RJ 506)',
        titleAr: 'رحلة العودة إلى عمّان (RJ 506)',
        descriptionEn: 'Return flight RJ 506 from Cairo (Terminal 2) arriving at Queen Alia Airport Amman.',
        descriptionAr: 'رحلة العودة الملكية الأردنية RJ 506 وصولاً إلى مطار الملكة علياء الدولي عمّان.',
        locationEn: 'Cairo Int Airport (CAI) Terminal 2',
        locationAr: 'مطار القاهرة الدولي مبنى 2',
        gatheringPointEn: 'Departure Gate, Terminal 2',
        gatheringPointAr: 'بوابة المغادرة، مبنى 2',
        dressCodeEn: 'Travel Clothes',
        dressCodeAr: 'ملابس سفر',
        targetGroup: 'All',
      ),
    ];
  }

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async {
    try {
      final list = await remoteDataSource.getAnnouncements();
      if (list.isNotEmpty) return list;
    } catch (_) {}

    return [
      AnnouncementModel(
        id: 1,
        titleEn: 'Gathering Time for Evening Departure',
        titleAr: 'تنبيه هام: موعد التجمع للمغادرة المسائية',
        contentEn: 'Please be at the hotel lobby 30 minutes before the evening departure.',
        contentAr: 'يرجى التواجد في بهو الفندق قبل 30 دقيقة من موعد المغادرة المسائية.',
        type: 'CriticalAlert',
        requiresAcknowledgment: true,
        targetAudience: 'All',
        createdAt: DateTime.now().toIso8601String(),
        isAcknowledged: false,
      ),
      AnnouncementModel(
        id: 2,
        titleEn: 'Welcome to Cairo 2026 Directors Trip',
        titleAr: 'أهلاً وسهلاً بكم في رحلة مدراء أورنج القاهرة 2026',
        contentEn: 'Orange Jordan warmly welcomes all directors. Please make sure your profile and passport verification are complete.',
        contentAr: 'ترحب أورنج الأردن بجميع المدراء الأفاضل. يرجى التأكد من استكمال بيانات الملف الشخصي والتحقق من الجواز.',
        type: 'General',
        requiresAcknowledgment: false,
        targetAudience: 'All',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        isAcknowledged: true,
      ),
    ];
  }

  @override
  Future<bool> acknowledgeAnnouncement(int id) async {
    return await remoteDataSource.acknowledgeAnnouncement(id);
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await storageService.setBiometricsEnabled(enabled);
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    return await storageService.isBiometricsEnabled();
  }

  @override
  Future<DashboardDataEntity> getDashboardData() async {
    final results = await Future.wait([
      getActiveTrip(),
      getFlightDetails(),
      getHotelDetails(),
      getItinerarySummary(),
      getItineraryItems(),
      getAnnouncements(),
      remoteDataSource.getProfile(),
      storageService.getUserData(),
      isBiometricsEnabled(),
    ]);

    final tripSettings = results[0] as TripSettingsEntity;
    final flight = results[1] as FlightEntity;
    final hotel = results[2] as HotelEntity;
    final summary = results[3] as ItinerarySummaryEntity;
    final allItems = results[4] as List<ItineraryItemEntity>;
    final announcements = results[5] as List<AnnouncementEntity>;
    final profileMap = results[6] as Map<String, dynamic>?;
    final cachedUserMap = results[7] as Map<String, dynamic>?;
    final biometricsEnabled = results[8] as bool;

    final assignedBus = profileMap?['assignedBus'] ??
        profileMap?['AssignedBus'] ??
        cachedUserMap?['assignedBus'] ??
        'Bus 1';

    final assignedGroup = profileMap?['assignedGroup'] ??
        profileMap?['AssignedGroup'] ??
        cachedUserMap?['assignedGroup'] ??
        'Group A';

    final fullName = profileMap?['fullName'] ??
        profileMap?['FullName'] ??
        cachedUserMap?['fullName'] ??
        'Ahmad Al-Mansoor';

    final role = profileMap?['title'] ??
        profileMap?['role'] ??
        cachedUserMap?['role'] ??
        'Customer Experience Director';

    final completionScore = profileMap?['completionScore'] ??
        profileMap?['CompletionScore'] ??
        cachedUserMap?['completionScore'] ??
        80;

    // Define VIP Coach fleet matching web frontend
    const buses = [
      BusEntity(
        id: 1,
        busNumber: 'Bus 1',
        busNameEn: 'Bus 1',
        busNameAr: 'حافلة 1',
        driverName: 'Mohammad Al-Sayed',
        driverPhone: '+20 100 111 2233',
        coordinatorName: 'Tariq Al-Hamad',
        coordinatorPhone: '+962 7 7111 2233',
        gatheringPointEn: 'The St. Regis Main Lobby (Gate 1)',
        gatheringPointAr: 'بهو فندق سانت ريجيس الرئيسي (بوابة 1)',
        gatheringTime: '08:45 AM',
        departureTime: '09:00 AM',
        capacity: 35,
        assignedGroup: '',
        status: 'On Schedule',
      ),
      BusEntity(
        id: 2,
        busNumber: 'Bus 2',
        busNameEn: 'Bus 2',
        busNameAr: 'حافلة 2',
        driverName: 'Ahmed Mostafa',
        driverPhone: '+20 100 444 5566',
        coordinatorName: 'Rania Haddad',
        coordinatorPhone: '+962 7 7444 5566',
        gatheringPointEn: 'The St. Regis Main Lobby (Gate 2)',
        gatheringPointAr: 'بهو فندق سانت ريجيس الرئيسي (بوابة 2)',
        gatheringTime: '08:45 AM',
        departureTime: '09:00 AM',
        capacity: 35,
        assignedGroup: '',
        status: 'On Schedule',
      ),
    ];

    return DashboardDataEntity(
      tripSettings: tripSettings,
      flight: flight,
      hotel: hotel,
      itinerarySummary: summary,
      allItineraryItems: allItems,
      announcements: announcements,
      buses: buses,
      assignedBus: assignedBus.toString(),
      assignedGroup: assignedGroup.toString(),
      fullName: fullName.toString(),
      role: role.toString(),
      completionScore: (completionScore is int) ? completionScore : int.tryParse(completionScore.toString()) ?? 80,
      isBiometricsEnabled: biometricsEnabled,
    );
  }
}

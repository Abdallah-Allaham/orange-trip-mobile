import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/orange_button.dart';

class DashboardShellScreen extends StatefulWidget {
  final UserEntity user;

  const DashboardShellScreen({super.key, required this.user});

  @override
  State<DashboardShellScreen> createState() => _DashboardShellScreenState();
}

class _DashboardShellScreenState extends State<DashboardShellScreen> {
  int _currentTabIndex = 0;
  String _language = 'en';

  void _toggleLanguage() {
    setState(() {
      _language = _language == 'en' ? 'ar' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_language);
    final isAr = strings.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: OrangeColors.lightGrey,
        appBar: AppBar(
          backgroundColor: OrangeColors.coreBlack,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2.0),
                child: Image.asset(
                  'assets/images/orange_logo.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.appTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: OrangeColors.coreWhite,
                    ),
                  ),
                  Text(
                    widget.user.fullName,
                    style: const TextStyle(
                      fontSize: 11,
                      color: OrangeColors.mediumGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _toggleLanguage,
              child: Text(
                strings.languageToggle,
                style: const TextStyle(
                  color: OrangeColors.brandOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: OrangeColors.coreWhite, size: 20),
              tooltip: strings.logout,
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
            ),
          ],
        ),
        body: _buildCurrentTab(strings),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) => setState(() => _currentTabIndex = index),
          selectedItemColor: OrangeColors.brandOrange,
          unselectedItemColor: OrangeColors.mediumGrey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: OrangeColors.coreWhite,
          elevation: 8,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: strings.dashboard,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.flight_outlined),
              activeIcon: const Icon(Icons.flight),
              label: strings.travel,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon: const Icon(Icons.calendar_month),
              label: strings.itinerary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: strings.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab(AppStrings strings) {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab(strings);
      case 1:
        return _buildTravelTab(strings);
      case 2:
        return _buildItineraryTab(strings);
      case 3:
        return _buildProfileTab(strings);
      default:
        return _buildHomeTab(strings);
    }
  }

  Widget _buildHomeTab(AppStrings strings) {
    final isAr = strings.isArabic;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OrangeColors.coreBlack,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'مرحباً، ${widget.user.fullName}' : 'Welcome, ${widget.user.fullName}',
                      style: const TextStyle(
                        color: OrangeColors.coreWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: OrangeColors.brandOrange,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Text(
                        widget.user.role,
                        style: const TextStyle(
                          color: OrangeColors.coreBlack,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isAr
                      ? 'رحلة تكريم كبار المدراء · القاهرة 2026'
                      : 'Executive Celebration Trip · Cairo 2026',
                  style: const TextStyle(
                    color: OrangeColors.borderGrey,
                    fontSize: 12,
                  ),
                ),
                const Divider(color: OrangeColors.darkGrey, height: 20),
                Row(
                  children: [
                    _buildPill(
                      label: isAr ? 'الحافلة:' : 'Bus:',
                      value: widget.user.assignedBus,
                      accentColor: OrangeColors.brandOrange,
                    ),
                    const SizedBox(width: 12),
                    _buildPill(
                      label: isAr ? 'المجموعة:' : 'Group:',
                      value: widget.user.assignedGroup,
                      accentColor: OrangeColors.coreWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Next Activity Card ("شو في عنا كمان ساعه")
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: OrangeColors.coreWhite,
              borderRadius: BorderRadius.circular(4.0),
              border: const Border(
                left: BorderSide(color: OrangeColors.brandOrange, width: 4.0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.alarm, color: OrangeColors.brandOrange, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          isAr ? 'الفعالية القادمة (خلال ساعة)' : 'Upcoming Activity (Next Hour)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: OrangeColors.accessibleOrange,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: OrangeColors.lightGrey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: const Text(
                        '07:30 PM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: OrangeColors.coreBlack,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isAr ? 'عشاء الترحيب الرسمي بنيل القاهرة' : 'Official Welcome Dinner — Nile Cruise',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: OrangeColors.coreBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: OrangeColors.mediumGrey),
                    const SizedBox(width: 4),
                    Text(
                      isAr ? 'نقطة التجمع: بهو فندق The St. Regis' : 'Gathering Point: St. Regis Lobby',
                      style: const TextStyle(fontSize: 12, color: OrangeColors.darkGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.checkroom_outlined, size: 14, color: OrangeColors.mediumGrey),
                    const SizedBox(width: 4),
                    Text(
                      isAr ? 'قواعد اللباس: رسمي أنيق (Smart Casual)' : 'Dress Code: Smart Casual',
                      style: const TextStyle(fontSize: 12, color: OrangeColors.darkGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Flight Brief Card
          _buildSummaryCard(
            title: isAr ? 'رحلة الملكية الأردنية RJ 501' : 'Royal Jordanian RJ 501',
            subtitle: isAr ? 'عمّان (AMM) T1 → القاهرة (CAI) T2' : 'Amman (AMM) T1 → Cairo (CAI) T2',
            icon: Icons.flight_takeoff,
            trailing: '2 Nov · 09:30',
          ),
          const SizedBox(height: 12),

          // Hotel Brief Card
          _buildSummaryCard(
            title: 'The St. Regis Cairo',
            subtitle: isAr ? 'الغرفة: يتم الاستلام عند الوصول' : 'Room: Assigned on arrival',
            icon: Icons.hotel,
            trailing: 'Wi-Fi: OrangeCairo2026',
          ),
        ],
      ),
    );
  }

  Widget _buildTravelTab(AppStrings strings) {
    final isAr = strings.isArabic;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isAr ? 'تفاصيل السفر والإقامة' : 'Travel & Ground Logistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),

          // Outbound Flight
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RJ 501 · Outbound',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: OrangeColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: const Text(
                          'CONFIRMED',
                          style: TextStyle(
                            color: OrangeColors.success,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Royal Jordanian Airlines · PNR: RJ-ORG-7788'),
                  const Divider(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AMM · 09:30', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text('Terminal 1 · QAIA', style: TextStyle(fontSize: 11, color: OrangeColors.mediumGrey)),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: OrangeColors.brandOrange),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('CAI · 10:55', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text('Terminal 2 · Cairo Intl', style: TextStyle(fontSize: 11, color: OrangeColors.mediumGrey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Return Flight
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RJ 506 · Return',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      Text('5 Nov · 19:00', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Cairo (CAI) T2 → Amman (AMM) T1'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Hotel Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The St. Regis Cairo',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1189 Nile Corniche, Cairo, Egypt',
                    style: TextStyle(fontSize: 12, color: OrangeColors.mediumGrey),
                  ),
                  const Divider(height: 20),
                  const Text(
                    'Wi-Fi Credentials:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: OrangeColors.lightGrey,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SSID: StRegis_Guest', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('Pass: OrangeCairo2026', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryTab(AppStrings strings) {
    final isAr = strings.isArabic;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          isAr ? 'برنامج الرحلة والفعاليات' : 'Summit Agenda & Timeline',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _buildAgendaItem(
          time: '09:30 AM',
          title: isAr ? 'الانطلاق من مطار الملكة علياء (RJ 501)' : 'Departure from AMM (RJ 501)',
          location: 'Queen Alia International Airport T1',
          dressCode: isAr ? 'مريح للسفر' : 'Travel Casual',
        ),
        _buildAgendaItem(
          time: '11:30 AM',
          title: isAr ? 'الوصول واستقبال وفد أورنج الأردن' : 'Arrival & VIP Reception',
          location: 'Cairo International Airport T2',
          dressCode: isAr ? 'رسمي أنيق' : 'Smart Casual',
        ),
        _buildAgendaItem(
          time: '02:00 PM',
          title: isAr ? 'الوصول إلى الفندق وتسليم الغرف' : 'Hotel Check-In & Room Key Handover',
          location: 'The St. Regis Cairo',
          dressCode: 'Casual',
        ),
        _buildAgendaItem(
          time: '07:30 PM',
          title: isAr ? 'عشاء الترحيب الرسمي بنيل القاهرة' : 'Welcome Nile Gala Dinner',
          location: 'St. Regis Lobby → Nile Yacht',
          dressCode: isAr ? 'بدلة عمل رسمية' : 'Formal Business Suit',
        ),
      ],
    );
  }

  Widget _buildProfileTab(AppStrings strings) {
    final isAr = strings.isArabic;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: OrangeColors.coreBlack,
                    child: Text(
                      widget.user.fullName.isNotEmpty ? widget.user.fullName[0] : 'U',
                      style: const TextStyle(color: OrangeColors.brandOrange, fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.fullName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          widget.user.email,
                          style: const TextStyle(fontSize: 12, color: OrangeColors.mediumGrey),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: OrangeColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: const Text(
                            'VERIFIED DELEGATE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: OrangeColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Assignments
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileRow(isAr ? 'الرقم الوظيفي' : 'Employee ID', widget.user.employeeId),
                  const Divider(height: 18),
                  _buildProfileRow(isAr ? 'الحافلة المخصصة' : 'Assigned Bus', widget.user.assignedBus),
                  const Divider(height: 18),
                  _buildProfileRow(isAr ? 'المجموعة' : 'Assigned Group', widget.user.assignedGroup),
                  const Divider(height: 18),
                  _buildProfileRow(isAr ? 'اكتمال الملف' : 'Profile Completion', '${widget.user.completionScore}%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          OrangeButton(
            text: strings.logout,
            isOutlined: true,
            icon: Icons.logout,
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: OrangeColors.mediumGrey, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(color: OrangeColors.coreBlack, fontSize: 13, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildAgendaItem({
    required String time,
    required String title,
    required String location,
    required String dressCode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OrangeColors.coreWhite,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: OrangeColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: OrangeColors.accessibleOrange,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: OrangeColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Text(
                  dressCode,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 14, color: OrangeColors.mediumGrey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 12, color: OrangeColors.mediumGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill({required String label, required String value, required Color accentColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: OrangeColors.darkGrey,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: OrangeColors.borderGrey, fontSize: 11),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(color: accentColor, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OrangeColors.coreWhite,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: OrangeColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OrangeColors.lightGrey,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Icon(icon, color: OrangeColors.coreBlack, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: OrangeColors.mediumGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: OrangeColors.accessibleOrange,
            ),
          ),
        ],
      ),
    );
  }
}

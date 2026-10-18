import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../widgets/itinerary_card.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  String _selectedItineraryDay = 'all';

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state is DashboardLoaded ? state.data : null;
        final allItems = data?.allItineraryItems ?? [];
        final tripSettings = data?.tripSettings;

        String normalizeDateStr(String raw) {
          return forceEnglishTime(raw.trim()).split('T').first.trim();
        }

        // Generate official trip days from tripSettings.startDate to tripSettings.endDate using ASCII digits
        final tripDates = <String>[];
        if (tripSettings != null && tripSettings.startDate.isNotEmpty && tripSettings.endDate.isNotEmpty) {
          try {
            final start = DateTime.parse(normalizeDateStr(tripSettings.startDate));
            final end = DateTime.parse(normalizeDateStr(tripSettings.endDate));
            if (!end.isBefore(start)) {
              for (var d = DateTime(start.year, start.month, start.day);
                  !d.isAfter(DateTime(end.year, end.month, end.day));
                  d = d.add(const Duration(days: 1))) {
                final yyyy = d.year.toString().padLeft(4, '0');
                final mm = d.month.toString().padLeft(2, '0');
                final dd = d.day.toString().padLeft(2, '0');
                tripDates.add('$yyyy-$mm-$dd');
              }
            }
          } catch (_) {}
        }

        // Use official tripDates when available (matching Web behavior); fallback to item dates only if tripDates is empty
        final distinctDates = tripDates.isNotEmpty
            ? tripDates
            : (allItems
                .map((i) => normalizeDateStr(i.date))
                .where((d) => d.isNotEmpty)
                .toSet()
                .toList()
              ..sort());

        final validItems = tripDates.isNotEmpty
            ? allItems.where((i) => distinctDates.contains(normalizeDateStr(i.date))).toList()
            : allItems;

        final effectiveSelectedDay = (distinctDates.contains(_selectedItineraryDay) || _selectedItineraryDay == 'all')
            ? _selectedItineraryDay
            : 'all';

        // Filter items by selected day
        final filteredItems = effectiveSelectedDay == 'all'
            ? validItems
            : validItems.where((i) => normalizeDateStr(i.date) == effectiveSelectedDay).toList();

        final dayFilters = <Map<String, String>>[
          {
            'key': 'all',
            'label': 'all_days'.tr(),
            'sub': '${validItems.length} ${'events'.tr()}',
          },
          ...distinctDates.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final dateStr = entry.value;
            String sub = dateStr;
            try {
              final parsed = DateTime.parse(dateStr);
              sub = forceEnglishTime(DateFormat('d MMM', 'en_US').format(parsed));
            } catch (_) {}
            return {
              'key': dateStr,
              'label': '${'day'.tr()} $index',
              'sub': sub,
            };
          }),
        ];

        return ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          children: [
            Text(
              'official_agenda_timeline'.tr(),
              style: AppTypography.font(fontSize: 18.sp, fontWeight: FontWeight.w700, color: OrangeColors.black),
            ),
            SizedBox(height: 14.h),

            // Day Selector Chips
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dayFilters.map((df) {
                  final isSelected = _selectedItineraryDay == df['key'];
                  return Padding(
                    padding: EdgeInsetsDirectional.only(end: 10.w),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedItineraryDay = df['key']!;
                        });
                      },
                      borderRadius: BorderRadius.circular(18.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? OrangeColors.primaryOrange : OrangeColors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: isSelected ? OrangeColors.primaryOrange : OrangeColors.lightBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              df['label']!,
                              style: AppTypography.font(
                                fontSize: 12.sp,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected ? OrangeColors.white : OrangeColors.black,
                              ),
                            ),
                            Text(
                              df['sub']!,
                              style: AppTypography.font(
                                fontSize: 10.sp,
                                color: isSelected ? OrangeColors.white.withValues(alpha: 0.85) : OrangeColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.h),

            // Filtered Itinerary Timeline Items
            if (filteredItems.isEmpty) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 40.sp, color: OrangeColors.secondaryText),
                      SizedBox(height: 12.h),
                      Text(
                        'no_events_today'.tr(),
                        style: AppTypography.font(color: OrangeColors.secondaryText, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              ...filteredItems.map((item) => ItineraryCard(item: item, isArabic: isAr)),
            ],
          ],
        );
      },
    );
  }
}

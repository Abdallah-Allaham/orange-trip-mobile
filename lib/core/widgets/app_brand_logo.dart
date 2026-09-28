import 'package:flutter/material.dart';
import 'package:orange_trip_mobile/core/constants/colors.dart';

/// Clean, vector-based executive travel emblem.
/// Completely independent of any trademarked brand assets, rendering a crisp
/// ascending flight emblem inside a modern rounded container.
class AppBrandLogo extends StatelessWidget {
  final double size;
  final double? borderRadius;
  final double? iconSize;

  const AppBrandLogo({
    super.key,
    this.size = 32,
    this.borderRadius,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? (size * 0.28);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: OrangeColors.primaryOrange,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: OrangeColors.primaryOrange.withValues(alpha: 0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.flight_takeoff_rounded,
          color: Colors.white,
          size: iconSize ?? (size * 0.55),
        ),
      ),
    );
  }
}

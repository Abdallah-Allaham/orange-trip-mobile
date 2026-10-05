import 'package:flutter/material.dart';
import 'package:orange_trip_mobile/core/constants/colors.dart';

/// Clean, official O-Trip brand logo widget.
/// Renders the official 1024x1024 O-Trip emblem inside a smooth rounded container with subtle elevation.
class AppBrandLogo extends StatelessWidget {
  final double size;
  final double? borderRadius;

  const AppBrandLogo({
    super.key,
    this.size = 32,
    this.borderRadius,
    double? iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? (size * 0.24);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: OrangeColors.primaryOrange,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: OrangeColors.primaryOrange.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/images/app_icon_1024.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.flight_takeoff_rounded,
                color: Colors.white,
                size: size * 0.55,
              ),
            );
          },
        ),
      ),
    );
  }
}

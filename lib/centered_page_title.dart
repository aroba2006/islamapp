import 'package:flutter/material.dart';
import 'l10n/app_strings.dart';

/// Reusable centered page title widget for all pages
class CenteredPageTitle extends StatelessWidget {
  final String title;
  final AppStrings strings;
  final double fontSize;
  final double bottomPadding;

  const CenteredPageTitle({
    super.key,
    required this.title,
    required this.strings,
    this.fontSize = 24.0,
    this.bottomPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: bottomPadding),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade800,
          fontFamily: strings.lang.fontFamily,
        ),
      ),
    );
  }
}

/// Example usage in your pages:
/// 
/// SingleChildScrollView(
///   child: Column(
///     children: [
///       CenteredPageTitle(
///         title: strings.prayerTimesTitle,
///         strings: strings,
///       ),
///       // Your page content here
///     ],
///   ),
/// )
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import '../l10n/app_localizations.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblahFinderScreen extends StatefulWidget {
  const QiblahFinderScreen({super.key});

  @override
  State<QiblahFinderScreen> createState() => _QiblahFinderScreenState();
}

class _QiblahFinderScreenState extends State<QiblahFinderScreen> {
  // Using the correct android method we fixed earlier!
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'اتجاه القبلة' : 'Qiblah Compass'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          if (snapshot.data == true) {
            return QiblahCompassWidget(isArabic: isArabic);
          } else {
            return const Center(
              child: Text(
                "Your device does not support the compass sensor.",
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  final bool isArabic;
  const QiblahCompassWidget({super.key, required this.isArabic});

  // Custom widget to draw the Kaaba
  Widget _buildKaaba() {
    return Container(
      width: 32,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            height: 6,
            color: const Color(0xFFD4AF37), // The Gold Band
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return const Center(child: Text("Waiting for compass data..."));
        }

        // CORRECT MATH - Only rotate the compass to keep North up
        // The Kaaba needle angle is relative to the compass
        final compassAngle = (qiblahDirection.direction * (Math.pi / 180) * -1);
        // Calculate relative angle and flip with -1 to get correct direction
        final qiblahAngle = ((qiblahDirection.qiblah - qiblahDirection.direction) * (Math.pi / 180) * -1);

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The entire compass + needle system rotates together to keep North up
              Transform.rotate(
                angle: compassAngle,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. The Compass Background
                      Image.asset(
                        'assets/compass-icon.png',
                        fit: BoxFit.contain,
                      ),

                      // 2. The Kaaba Needle (rotates INSIDE the compass)
                      Transform.rotate(
                        angle: qiblahAngle,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 20, // Pushes it to the edge of the compass
                              child: Column(
                                children: [
                                  _buildKaaba(), // Your custom Kaaba icon!
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3. Center Pin
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4AF37),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Debug text showing actual Qiblah angle
              Positioned(
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Qiblah: ${qiblahDirection.qiblah.toStringAsFixed(1)}° | Direction: ${qiblahDirection.direction.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
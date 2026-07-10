import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ShareImageGenerator {
  /// Enhanced version that uses a widget to generate the image
  static Future<void> generateAndShareImageWithWidget({
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required String lang,
    required BuildContext context,
  }) async {
    try {
      // Create a widget to render
      final widget = _ShareImageWidget(
        title: title,
        subtitle: subtitle,
        isDarkMode: isDarkMode,
        lang: lang,
      );

      final imageBytes = await _widgetToImage(widget);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/duaa_share_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(imageBytes);

      // Share the image
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: lang == 'ar' ? 'مشاركة' : 'Share',
      );
    } catch (e) {
      print('Error generating share image: $e');
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text('Error sharing: $e')),
        );
      }
    }
  }

  /// Converts a widget to an image by rendering it to a picture offline
  static Future<Uint8List> _widgetToImage(Widget widget) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    const Size logicalSize = Size(1080, 1350); // Instagram story size

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    final RenderView renderView = RenderView(
      view: ui.PlatformDispatcher.instance.views.first,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize), // Fixed for modern Flutter
        devicePixelRatio: 1.0,
      ),
    );

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    // Fixed adapter syntax
    final RenderObjectToWidgetAdapter<RenderBox> adapter =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material( // Ensures text styling renders correctly outside the main tree
          color: Colors.transparent,
          child: widget,
        ),
      ),
    );

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        adapter.attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage(pixelRatio: 1.0);
    final ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return byteData.buffer.asUint8List();
  }
}

/// Widget that represents the shareable image
class _ShareImageWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDarkMode;
  final String lang;

  const _ShareImageWidget({
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = lang == 'ar';

    return Container(
      width: 1080,
      height: 1350,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDarkMode ? const Color(0xFF0B3D2E) : const Color(0xFFFDFBF7),
            isDarkMode ? const Color(0xFF144D32) : const Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles in corners
          Positioned(
            top: 50,
            left: 50,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 50,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top decorative line
                Container(
                  width: 200,
                  height: 2,
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                  margin: const EdgeInsets.only(bottom: 40),
                ),
                // Main title (Arabic)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: isArabic
                        ? GoogleFonts.amiri(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                            height: 1.8,
                          )
                        : GoogleFonts.arefRuqaa(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                            height: 1.8,
                          ),
                  ),
                ),
                const SizedBox(height: 50),
                // Divider
                Container(
                  width: 200,
                  height: 1.5,
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                  margin: const EdgeInsets.symmetric(vertical: 30),
                ),
                const SizedBox(height: 30),
                // Subtitle (Translation)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: GoogleFonts.elMessiri(
                      fontSize: 26,
                      fontStyle: FontStyle.italic,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.85)
                          : Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom decorative line
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Container(
              height: 2,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
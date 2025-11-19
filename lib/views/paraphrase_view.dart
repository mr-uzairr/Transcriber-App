import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/paraphrase_controller.dart';

class ParaphraseView extends GetView<ParaphraseController> {
  ParaphraseView({super.key});
  final GlobalKey _settingsKey = GlobalKey();

  void _showSettingsPopover(BuildContext context) {
    final keyContext = _settingsKey.currentContext;
    if (keyContext == null) return;

    final renderBox = keyContext.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
        final popWidth = math.min(280.0, screenSize.width - 24);
        final availableBelow = screenSize.height - (offset.dy + size.height) - 24.0;
        final popHeight = math.min(250.0, math.max(100.0, availableBelow));
      double left = offset.dx;
      if (left + popWidth + 12 > screenSize.width) {
        left = screenSize.width - popWidth - 12;
      }
      if (left < 12) left = 12;

      return SizedBox.expand(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => entry.remove(),
          child: Material(
            color: Colors.transparent,
            child: Stack(
            children: [
              Positioned(
                left: left,
                top: offset.dy + size.height,
                width: popWidth,
                height: popHeight,
                child: Builder(builder: (ctx) {
                  final iconCenterX = offset.dx + size.width / 2;
                  const arrowW = 24.0;
                  double arrowLeft = iconCenterX - left - (arrowW / 2);
                 
                  final minArrow = 12.0;
                  final maxArrow = popWidth - arrowW - 12.0;
                  if (arrowLeft < minArrow) arrowLeft = minArrow;
                  if (arrowLeft > maxArrow) arrowLeft = maxArrow;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // arrow
                      Positioned(
                        left: arrowLeft,
                        top: 0,
                        child: ClipPath(
                          clipper: _TriangleClipper(),
                          child: Container(
                            width: arrowW,
                            height: 12,
                            color: isDark ? const Color(0xFF0F1425).withOpacity(0.95) : Colors.white.withOpacity(0.98),
                          ),
                        ),
                      ),
                            Positioned(
                              top: 10,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    constraints: BoxConstraints(maxHeight: popHeight - 6),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.black.withOpacity(0.45) : Colors.white.withOpacity(0.70),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(isDark ? 0.6 : 0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                      border: Border.all(color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.08)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.settings, size: 18, color: isDark ? Colors.white : Colors.black),
                                              const SizedBox(width: 8),
                                              Text('Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1, thickness: 1),
                                        StatefulBuilder(builder: (ctx, setState) {
                                          final isDarkNow = Get.isDarkMode;
                                          return SwitchListTile.adaptive(
                                            title: const Text('Change Theme', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                            value: isDarkNow,
                                            onChanged: (v) async {
                                              // persist selection
                                              final prefs = await SharedPreferences.getInstance();
                                              await prefs.setString('themeMode', v ? 'dark' : 'light');
                                              Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                                              try {
                                                entry.markNeedsBuild();
                                              } catch (_) {}
                                              setState(() {});
                                            },
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                          );
                                        }),
                                        ListTile(
                                          title: const Text('Terms & Privacy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                          trailing: const Icon(Icons.chevron_right),
                                          onTap: () {
                                            entry.remove();
                                            Get.snackbar('Info', 'Terms & Privacy not implemented yet', snackPosition: SnackPosition.BOTTOM);
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('Contact Us', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                          trailing: const Icon(Icons.chevron_right),
                                          onTap: () {
                                            entry.remove();
                                            Get.snackbar('Info', 'Contact Us not implemented yet', snackPosition: SnackPosition.BOTTOM);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      )
      );
    });

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ParaphraseController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
          key: _settingsKey,
          onPressed: () => _showSettingsPopover(context),
        ),
        // title: Image.asset(
        //   'assets/app_logo.png',
        //   height: 36,
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.crown,
                color: const Color(0xFFFFB800),
                size: 20,
              ),
              onPressed: () {
                // Get.to(() => const PremiumView());
                Get.snackbar('Premium', 'Premium feature comming soon', snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF262629), Color(0xFF2C2C2E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFF7FBFA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.6) : Colors.grey.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEDEFF0),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.text_snippet,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Paste URL',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.paste,
                                icon: const Icon(
                                  Icons.content_paste,
                                  size: 16,
                                ),
                                label: const Text('Paste'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Obx(() => controller.inputNotEmpty.value
                                  ? InkWell(
                                      onTap: controller.clear,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    )
                                  : const SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Text field area
                    Container(
                      constraints: const BoxConstraints(minHeight: 120, maxHeight: 200),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Obx(() => TextField(
                        controller: controller.inputController,
                        maxLines: null,
                        style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          hintText: controller.showResult.value ? '' : 'Paste your video URL here...',
                          hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                        enabled: true,
                      )),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.paraphrase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C896),
                        disabledBackgroundColor: const Color(0xFF00C896),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Transcribe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                    )),
              ),

              Obx(() => controller.showResult.value
                  ? Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5E5), width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(controller.transcription.value, style: TextStyle(fontSize: 16, height: 1.5, color: isDark ? Colors.white : Colors.black)),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(children: [
                                    InkWell(
                                      onTap: () {
                                        final text = controller.transcription.value.trim();
                                        if (text.isEmpty) {
                                          Get.snackbar('Nothing to share', 'Transcription is empty', snackPosition: SnackPosition.BOTTOM);
                                          return;
                                        }
                                        Share.share(text);
                                      },
                                      child: Icon(Icons.open_in_new, color: isDark ? Colors.grey[400] : Colors.grey[600], size: 24),
                                    ),
                                    const Spacer(),
                                    InkWell(onTap: controller.copyToClipboard, child: Icon(Icons.content_copy, color: isDark ? Colors.grey[400] : Colors.grey[600], size: 24)),
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

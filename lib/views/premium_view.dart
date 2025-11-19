import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/premium_controller.dart';
import 'paraphrase_view.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PremiumController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;
    final matchedGapPx = (screenH * 0.12).clamp(36.0, 100.0).toDouble();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(backgroundColor: Colors.transparent, automaticallyImplyLeading: false, actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () => Get.off(() => ParaphraseView()),
                    icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color, size: 20),
                    splashRadius: 20,
                    padding: const EdgeInsets.all(8),
                  ),
                )
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  const SizedBox(height: 8),
                  Builder(builder: (context) {
                    final w = MediaQuery.of(context).size.width;
                    final starSize = (w * 0.05).clamp(12.0, 28.0);
                    final titleSize = (w * 0.06).clamp(14.0, 28.0);
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.star,
                                color: const Color(0xFFFFB800),
                                size: starSize,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            children: [
                              TextSpan(text: 'Unlock ', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                              TextSpan(text: 'Premium', style: TextStyle(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: matchedGapPx),
                  Center(child: _featureItem(context, 'Unlimited Transciption')),
                  const SizedBox(height: 12),
                  _featureItem(context, '10+ languages supported'),
                  const SizedBox(height: 12),
                  _featureItem(context, 'Sync with iPad and Mac'),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        const SizedBox(height: 8),
                        Builder(builder: (context) {
                          final w = MediaQuery.of(context).size.width;
                          final cardWidth = (w * 0.8).clamp(220.0, 320.0);
                          return Center(
                            child: SizedBox(
                              width: cardWidth,
                              child: Obx(() {
                                final selected = controller.selectedPlan.value == 0;
                                return GestureDetector(
                                  onTap: () => controller.select(0),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: selected ? Theme.of(context).primaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08)),
                                            width: selected ? 2.5 : 1.5,
                                          ),
                                        ),
                                        child: Row(children: [Expanded(child: Text('Yearly Rs 7,900', style: TextStyle(fontWeight: FontWeight.w600))), const SizedBox(width: 8), Text('Rs 151.92 per week')]),
                                      ),
                                      Positioned(
                                        top: -10,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                            child: const Text(
                                              'MOST POPULAR',
                                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Builder(builder: (context) {
                          final w = MediaQuery.of(context).size.width;
                          final cardWidth = (w * 0.8).clamp(220.0, 320.0);
                          return Center(
                            child: SizedBox(
                              width: cardWidth,
                              child: Obx(() {
                                final selected = controller.selectedPlan.value == 1;
                                return GestureDetector(
                                  onTap: () => controller.select(1),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: selected ? Theme.of(context).primaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08)),
                                            width: selected ? 2.5 : 1.5,
                                          ),
                                        ),
                                        child: Row(children: [Expanded(child: Text('Monthly Rs 2,999', style: TextStyle(fontWeight: FontWeight.w600))), const SizedBox(width: 8), Text('Rs 749.75 per week')]),
                                      ),
                                      // No badge for monthly plan
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Builder(builder: (context) {
                          final w = MediaQuery.of(context).size.width;
                          final cardWidth = (w * 0.8).clamp(220.0, 320.0);
                          return Center(
                            child: SizedBox(
                              width: cardWidth,
                              child: Obx(() {
                                final selected = controller.selectedPlan.value == 2;
                                return GestureDetector(
                                  onTap: () => controller.select(2),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: selected ? Theme.of(context).primaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08)),
                                            width: selected ? 2.5 : 1.5,
                                          ),
                                        ),
                                        child: Row(children: [Expanded(child: Text('Weekly Rs 999', style: TextStyle(fontWeight: FontWeight.w600))), const SizedBox(width: 8), Text('Rs 999 per week')]),
                                      ),
                                      // No badge for weekly plan
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                        SizedBox(height: matchedGapPx - 12),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('3 days for free, then Rs 7,900/year', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14)),
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  final w = MediaQuery.of(context).size.width;
                  final btnWidth = (w * 0.6).clamp(180.0, 320.0);
                  final btnHeight = (w * 0.095).clamp(40.0, 56.0);
                  final fontSize = (w * 0.045).clamp(13.0, 18.0);
                  return Center(
                    child: SizedBox(
                      width: btnWidth,
                      height: btnHeight,
                      child: ElevatedButton(
                        onPressed: () => Get.off(() => ParaphraseView()),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C896), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                        child: Text('Start Free Trial', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                const Text('Terms & Privacy', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 16),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(BuildContext context, String text) {
    final w = MediaQuery.of(context).size.width;
    final iconSize = (w * 0.05).clamp(12.0, 24.0);
    final fontSize = (w * 0.037).clamp(10.0, 14.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: iconSize, height: iconSize, decoration: const BoxDecoration(color: Color(0xFF00C896), shape: BoxShape.circle), child: Icon(Icons.check, color: Colors.white, size: iconSize * 0.6)),
      SizedBox(width: iconSize * 0.5),
      Text(text, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: fontSize, fontWeight: FontWeight.w500)),
    ]);
  }
}

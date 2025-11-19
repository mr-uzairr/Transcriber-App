import 'package:get/get.dart';

class PremiumController extends GetxController {
  final selectedPlan = 0.obs;

  void select(int i) => selectedPlan.value = i;
}

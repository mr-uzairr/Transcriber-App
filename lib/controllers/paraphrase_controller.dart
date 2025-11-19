import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ParaphraseController extends GetxController {
  final TextEditingController inputController = TextEditingController();
  final transcription = ''.obs;
  final isLoading = false.obs;
  final showResult = false.obs;
  final inputNotEmpty = false.obs;

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    inputController.addListener(() {
      inputNotEmpty.value = inputController.text.trim().isNotEmpty;
    });
  }

  Future<void> paraphrase() async {
    final input = inputController.text.trim();
    if (input.isEmpty) return;

    isLoading.value = true;
    showResult.value = false;
    transcription.value = '';

    try {
      final result = await ApiService.transcribe(input);
      if (result != null && result.isNotEmpty) {
        transcription.value = result;
        showResult.value = true;
      } else {
        Get.snackbar('No transcription', 'No transcription returned', snackPosition: SnackPosition.BOTTOM);
        showResult.value = false;
      }
    } catch (e) {
      Get.snackbar('Request error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      showResult.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    inputController.clear();
    transcription.value = '';
    showResult.value = false;
  }

  Future<void> paste() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null) inputController.text = data.text ?? '';
    inputNotEmpty.value = inputController.text.trim().isNotEmpty;
  }

  Future<void> copyToClipboard() async {
    if (transcription.value.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: transcription.value));
    Get.snackbar('Copied', 'Copied to clipboard', snackPosition: SnackPosition.BOTTOM);
  }
}

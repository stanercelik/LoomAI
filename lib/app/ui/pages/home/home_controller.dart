import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'package:fal_client/fal_client.dart';

class HomeController extends GetxController {
  var remainingCredits = 3.obs;
  var isLoading = false.obs;
  var generatedImageUrl = ''.obs;

  // TextField Controller'ları
  final promptController = TextEditingController();
  final renkPaletiController = TextEditingController();
  final kenarMotifleriController = TextEditingController();
  final merkezMotifiController = TextEditingController();

  // Halının boyutu için seçenekler
  final List<String> sizeOptions = ['16:9', '1:1', '4:3'];
  var selectedSize = '16:9'.obs;

  @override
  void onClose() {
    promptController.dispose();
    renkPaletiController.dispose();
    kenarMotifleriController.dispose();
    merkezMotifiController.dispose();
    super.onClose();
  }

  // TextField'lardan prompt oluşturma metodu
  String generatePromptFromFields() {
    String renkPaleti = renkPaletiController.text;
    String kenarMotifleri = kenarMotifleriController.text;
    String merkezMotifi = merkezMotifiController.text;
    String boyut = selectedSize.value;

    String prompt = 'An Iranian carpet with ';
    if (renkPaleti.isNotEmpty) prompt += 'colors: $renkPaleti, ';
    if (kenarMotifleri.isNotEmpty) prompt += 'border motifs: $kenarMotifleri, ';
    if (merkezMotifi.isNotEmpty) prompt += 'center motif: $merkezMotifi, ';
    if (boyut.isNotEmpty) prompt += 'size: $boyut.';

    return prompt;
  }

  // API'den görüntü oluşturma metodu
  Future<List<String>> generateImage(String prompt) async {
    try {
      final fal = Get.find<FalClient>();

      // İsteği gönderin
      final output = await fal.subscribe(
        "fal-ai/flux/schnell",
        input: {
          "prompt": prompt,
          "image_size": "landscape_4_3",
          "num_inference_steps": 4,
          "num_images": 1,
          "enable_safety_checker": true,
        },
        logs: true,
        onQueueUpdate: (update) {
          print('Queue Update: $update');
        },
      );

      // Çıktıları alın
      if (output.data['images'] != null) {
        List images = output.data['images'];
        List<String> imageUrls =
            images.map((image) => image['url'] as String).toList();
        return imageUrls;
      } else {
        throw Exception("No images generated");
      }
    } catch (e, stackTrace) {
      print('Error occurred during image generation: $e');
      print('Stack trace: $stackTrace');
      throw Exception("Image generation failed: $e");
    }
  }

  // Create Carpet Method
  void createCarpet() async {
    if (remainingCredits.value > 0) {
      // Kredi düş
      remainingCredits.value--;
      // Loading göstergesi için
      isLoading.value = true;

      // Prompt oluşturma
      String prompt;
      if (promptController.text.isNotEmpty) {
        prompt = promptController.text;
      } else {
        prompt = generatePromptFromFields();
      }

      try {
        // API'den görüntüyü al
        List<String> imageUrls = await generateImage(prompt);

        if (imageUrls.isNotEmpty) {
          generatedImageUrl.value = imageUrls[0]; // İlk görüntüyü kullan
        } else {
          throw Exception("No image generated");
        }

        // Başarılı mesajı göster
        Get.snackbar('Başarılı', 'Görüntü başarıyla oluşturuldu.');
      } catch (e) {
        // Hata durumunda kredi geri ekle
        remainingCredits.value++;
        // Hata mesajı göster
        Get.snackbar('Hata', 'Görüntü oluşturulamadı.');
        // Hata detaylarını konsola yazdır
        print('Error: $e');
      } finally {
        // Loading göstergesini kapat
        isLoading.value = false;
      }
    } else {
      // Kredi yok, market sayfasına yönlendir
      Get.snackbar('Kredi Yetersiz', 'Lütfen kredi satın alın.');
      Get.toNamed(Routes.MARKET);
    }
  }
}

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'package:fal_client/fal_client.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';


enum ImageSize {
  squareHD,
  square,
  portrait_4_3,
  portrait_16_9,
  landscape_4_3,
  landscape_16_9;

  @override
  String toString() {
    switch (this) {
      case ImageSize.squareHD:
        return 'square_hd';
      case ImageSize.square:
        return 'square';
      case ImageSize.portrait_4_3:
        return 'portrait_4_3';
      case ImageSize.portrait_16_9:
        return 'portrait_16_9';
      case ImageSize.landscape_4_3:
        return 'landscape_4_3';
      case ImageSize.landscape_16_9:
        return 'landscape_16_9';
    }
  }
}

class HomeController extends GetxController {
  // Observable state
  final RxInt remainingCredits = 3.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSharingLoading = false.obs;
  final RxBool isSavingLoading = false.obs;
  final RxString generatedImageUrl = ''.obs;
  final Rx<ImageSize> selectedSize = ImageSize.landscape_4_3.obs;
  final Map<ImageSize, String> imageSizeOptions = {
    ImageSize.squareHD: 'home.imageSize.squareHD'.tr,
    ImageSize.square: 'home.imageSize.square'.tr,
    ImageSize.portrait_4_3: 'home.imageSize.portrait_4_3'.tr,
    ImageSize.portrait_16_9: 'home.imageSize.portrait_16_9'.tr,
    ImageSize.landscape_4_3: 'home.imageSize.landscape_4_3'.tr,
    ImageSize.landscape_16_9: 'home.imageSize.landscape_16_9'.tr,
  };
  final RxString imageUrl = ''.obs;

  // Form controllers
  final TextEditingController promptController = TextEditingController();
  final TextEditingController renkPaletiController = TextEditingController();
  final TextEditingController kenarMotifleriController = TextEditingController();
  final TextEditingController merkezMotifiController = TextEditingController();

  // Constants
  final List<String> sizeOptions = ['16:9', '1:1', '4:3'];

  @override
  void onInit() {
    super.onInit();
    remainingCredits.value = StorageService.to.credits;

  } 

  @override
  void onClose() {
    promptController.dispose();
    renkPaletiController.dispose();
    kenarMotifleriController.dispose();
    merkezMotifiController.dispose();

    super.onClose();
  }

String _generatePromptFromFields() {
  // Check if all input fields are empty
  if (promptController.text.isEmpty &&
      renkPaletiController.text.isEmpty &&
      kenarMotifleriController.text.isEmpty &&
      merkezMotifiController.text.isEmpty) {
      return "A vibrant Turkish carpet with intricate traditional patterns, featuring symmetrical floral and geometric designs, featuring a mix of rich colors. The edges of the carpet are adorned with an elegant border of repeating floral motifs. The background patterns are inspired by Ottoman and Persian art, with high detail and texture resembling a handmade rug.";
  }

  // Initialize the base prompt
  StringBuffer prompt = StringBuffer(
      'A vibrant Turkish carpet with intricate traditional patterns, featuring symmetrical floral and geometric designs');

  // Append user's own prompt if provided
  if (promptController.text.isNotEmpty) {
    prompt.write(' ${promptController.text}');
  }

  // Append color palette details
  if (renkPaletiController.text.isNotEmpty) {
    prompt.write(
        ', featuring a mix of rich colors such as ${renkPaletiController.text}');
  }

  // Append central motif details
  if (merkezMotifiController.text.isNotEmpty) {
    prompt.write(
        '. In the center of the carpet, a beautifully detailed ${merkezMotifiController.text} motif blends seamlessly into the design');
    prompt.write(
        '. The ${merkezMotifiController.text} is styled to match the traditional motifs, with decorative patterns, harmonizing with the overall aesthetic of the carpet');
  }

  // Append edge motifs details
  if (kenarMotifleriController.text.isNotEmpty) {
    prompt.write(
        '. The edges of the carpet are adorned with ${kenarMotifleriController.text} motifs');
  } else {
    prompt.write(
        '. The edges of the carpet are adorned with an elegant border of repeating floral motifs');
  }

  // Append background patterns
  prompt.write(
      '. The background patterns are inspired by Ottoman and Persian art, with high detail and texture resembling a handmade rug.');

  debugPrint(prompt.toString());
  // Return the final prompt as a string
  return prompt.toString();
}

  Future<List<String>> _generateImage(String prompt) async {
    try {
      final fal = Get.find<FalClient>();
      final output = await fal.subscribe(
  "fal-ai/flux/schnell",
  input: {
    "prompt": prompt,
    "image_size": selectedSize.value.toString(),
    "num_inference_steps": 4,
    "num_images": 1,
    "enable_safety_checker": true,
  },
  logs: true,
  onQueueUpdate: (update) {
    debugPrint('Queue Update: $update');
  },
);

      if (output.data['images'] != null) {
        final List images = output.data['images'];
        return images.map((image) => image['url'] as String).toList();
      } else {
        throw Exception("No images generated");
      }
    } catch (e, stackTrace) {
      debugPrint('Error occurred during image generation: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception("Image generation failed: $e");
    }
  }

  // User Actions
  void navigateToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void resetGeneratedImage() {
    generatedImageUrl.value = '';
  }

    Future<void> updateCredits(int newValue) async {
    remainingCredits.value = newValue;
    await StorageService.to.updateCredits(newValue);
  }

  Future<void> createCarpet() async {
    if (remainingCredits.value <= 0) {
      Get.snackbar(
        'home.error.title.notEnoughCredit'.tr,
        'home.error.message.notEnoughCredit'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      // Uncomment the line below when your market page is ready
      // Get.toNamed(Routes.MARKET);
      return;
    }

    isLoading.value = true;

    try {
      final String prompt = _generatePromptFromFields();
      if (prompt.isEmpty) {
        return;
      }
      
      debugPrint(prompt);

      final List<String> imageUrls = await _generateImage(prompt);
      if (imageUrls.isNotEmpty) {
        generatedImageUrl.value = imageUrls.first;

        remainingCredits.value--;

        await updateCredits(remainingCredits.value); // Başarılı durumda kredileri kaydet
      }
    } catch (e) {
      Get.snackbar(
        'home.error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareImage() async {
    isSharingLoading.value = true;
    try {
      final uri = Uri.parse(generatedImageUrl.value);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/image.jpg';
      File(path).writeAsBytesSync(bytes);
      await Share.shareXFiles([XFile(path)]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isSharingLoading.value = false;
    }
  }

  Future<void> saveImageToGallery() async {
    isSavingLoading.value = true;
    try {
      final uri = Uri.parse(generatedImageUrl.value);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/image.jpg';
      File(path).writeAsBytesSync(bytes);

      var status = await Permission.photos.status;
      if (!status.isGranted) {
        await Permission.photos.request();
      }
      
      await Gal.putImage(path);
      Get.snackbar(
        'home.success'.tr,
        'home.imageSaved'.tr,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isSavingLoading.value = false;
    }
  }
}

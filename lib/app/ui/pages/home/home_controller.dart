import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'package:fal_client/fal_client.dart';
import 'package:loom_ai_app/app/services/purchase_service.dart';
import 'package:loom_ai_app/app/services/storage_service.dart';
import 'package:loom_ai_app/app/ui/pages/carpet_result/carpet_result_view.dart';
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
  final RxBool isLoading = false.obs;
  final RxBool isSharingLoading = false.obs;
  final RxBool isSavingLoading = false.obs;
  final RxString generatedImageUrl = ''.obs;
  final Rx<ImageSize> selectedSize = ImageSize.landscape_4_3.obs;

  final PurchaseService service = Get.put(PurchaseService());

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
  final TextEditingController kenarMotifleriController =
      TextEditingController();
  final TextEditingController merkezMotifiController = TextEditingController();

  // Constants
  final List<String> sizeOptions = ['16:9', '1:1', '4:3'];

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
      return "A vibrant Turkish carpet with intricate traditional patterns. The design features symmetrical floral and geometric elements with a harmonious and cohesive style. The edges of the carpet are highlighted by distinct, detailed border motifs that frame the design seamlessly. The color palette includes rich and vivid tones, applied densely to enhance the carpet's overall texture and aesthetic. At the center, a refined pattern is integrated smoothly into the design, appearing as an organic part of the carpet rather than a separate entity. Background details draw inspiration from Ottoman and Persian art, with intricate handmade-style textures that add depth and authenticity.";
    }

    // Initialize the base prompt
    StringBuffer prompt = StringBuffer(
        'A vibrant Turkish carpet with intricate traditional patterns. The design features symmetrical floral and geometric elements with a harmonious and cohesive style');

    // Append user's own prompt if provided
    if (promptController.text.isNotEmpty) {
      prompt.write(' ${promptController.text}');
    }

    // Append color palette details
    if (renkPaletiController.text.isNotEmpty) {
      prompt.write(
          ', with a densely applied color palette featuring ${renkPaletiController.text}');
    }

    // Append central motif details
    if (merkezMotifiController.text.isNotEmpty) {
      prompt.write(
          '. The center of the carpet is adorned with a ${merkezMotifiController.text} motif that integrates seamlessly into the overall design, appearing as a natural extension of the carpet\'s intricate patterns');
    }

    // Append edge motifs details
    if (kenarMotifleriController.text.isNotEmpty) {
      prompt.write(
          '. The edges of the carpet are highlighted by ${kenarMotifleriController.text} motifs, creating a bold and defined frame that complements the central design');
    } else {
      prompt.write(
          '. The edges of the carpet are highlighted by distinct, detailed border motifs that frame the design seamlessly');
    }

    // Append background patterns
    prompt.write(
        '. Background details draw inspiration from Ottoman and Persian art, with intricate handmade-style textures that add depth and authenticity.');

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

  void navigateToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void navigateToHome() {
    Get.toNamed(Routes.HOME);
  }

  void navigateToResultScreen() {
    Get.toNamed(Routes.RESULT);
  }

  void navigateToCreditsScreen() {
    Get.toNamed(Routes.CREDITS);
  }

  void resetGeneratedImage() {
    generatedImageUrl.value = '';
  }

  Future<void> createCarpet() async {
    if (StorageService.to.credits <= 0) {
      navigateToCreditsScreen();
      return;
    }

    isLoading.value = true;

    try {
      final String prompt = _generatePromptFromFields();
      if (prompt.isEmpty) {
        return;
      }

      debugPrint(prompt);
      Get.to(() => CarpetResultView());
      final List<String> imageUrls = await _generateImage(prompt);
      if (imageUrls.isNotEmpty) {
        generatedImageUrl.value = imageUrls.first;

        await StorageService.to.updateCredits(StorageService.to.credits - 1);
        promptController.clear();
        renkPaletiController.clear();
        kenarMotifleriController.clear();
        merkezMotifiController.clear();
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

  void addDebugCredits() {
    final currentCredits = StorageService.to.credits;
    StorageService.to.setCredits(currentCredits + 5);
  }
}

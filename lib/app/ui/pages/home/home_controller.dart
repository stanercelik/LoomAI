import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loom_ai_app/app/routes/app_routes.dart';
import 'package:fal_client/fal_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  // Observable state
  final RxInt remainingCredits = 3.obs;
  final RxBool isLoading = false.obs;
  final RxString generatedImageUrl = ''.obs;
  final RxString selectedSize = '16:9'.obs;
  final RxString imageUrl = ''.obs;

  // Form controllers
  final TextEditingController promptController = TextEditingController();
  final TextEditingController renkPaletiController = TextEditingController();
  final TextEditingController kenarMotifleriController = TextEditingController();
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
  //Business Logic
  //TODO: Buranın sonradan düzenlenmesi gerekiyor
  String _generatePromptFromFields() {

    if (promptController.text.isNotEmpty && (renkPaletiController.text.isEmpty || kenarMotifleriController.text.isEmpty || merkezMotifiController.text.isEmpty)) {
      return promptController.text;
    } else if (promptController.text.isEmpty && (renkPaletiController.text.isNotEmpty || kenarMotifleriController.text.isNotEmpty || merkezMotifiController.text.isNotEmpty)){
      final StringBuffer prompt = StringBuffer(
      'A vibrant Turkish carpet with intricate traditional patterns, featuring symmetrical floral and geometric designs, ${
        merkezMotifiController.text.isNotEmpty ? 
      "In the center of the carpet, a beautifully detailed ${
        merkezMotifiController.text} motif": ""} blends seamlessly into the design. The ${
        merkezMotifiController.text.isNotEmpty ? merkezMotifiController.text: ""} is styled to match the traditional motifs, with decorative patterns on its body, harmonizing with the overall aesthetic of the carpet. The background patterns are inspired by Ottoman and Persian art, with high detail and texture resembling a handmade rug. The edges of the carpet are adorned with an elegant border of repeating floral motifs.');
    
    if (renkPaletiController.text.isNotEmpty) {
      prompt.write('colors: ${renkPaletiController.text}, ');
    }
    if (kenarMotifleriController.text.isNotEmpty) {
      prompt.write('border motifs: ${kenarMotifleriController.text}, ');
    }
    if (merkezMotifiController.text.isNotEmpty) {
      prompt.write('center motif: ${merkezMotifiController.text}, ');
    }
    if (selectedSize.isNotEmpty) {
      prompt.write('size: ${selectedSize.value}.');
    }

    return prompt.toString();
  }
  else {
    return promptController.text;
    
  }
    }

    

  Future<List<String>> _generateImage(String prompt) async {
    try {
      final fal = Get.find<FalClient>();
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

      if (output.data['images'] != null) {
        final List images = output.data['images'];
        return images.map((image) => image['url'] as String).toList();
      } else {
        throw Exception("No images generated");
      }
    } catch (e, stackTrace) {
      print('Error occurred during image generation: $e');
      print('Stack trace: $stackTrace');
      throw Exception("Image generation failed: $e");
    }
  }

  // User Actions
  void navigateToMarket() {
    Get.toNamed(Routes.MARKET);
  }

  void resetGeneratedImage() {
    generatedImageUrl.value = '';
  }

  Future<void> createCarpet() async {
    if (remainingCredits.value <= 0) {
      Get.snackbar(
        'home.error.title.notEnoughCredit'.tr,
        'home.error.message.notEnoughCredit'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    remainingCredits.value--;
    isLoading.value = true;

    try {
      final String prompt = promptController.text.isNotEmpty
          ? promptController.text
          : _generatePromptFromFields();

      final List<String> imageUrls = await _generateImage(prompt);
      if (imageUrls.isNotEmpty) {
        generatedImageUrl.value = imageUrls.first;
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

  Future<void> shareImage(RxString imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl.value));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/carpet_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile(file.path)], text: 'Generated Carpet Image');
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      Get.snackbar(
        'home.error'.tr,
        'home.shareFailed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
          PermissionStatus result;
          
          try {
              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
              AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

              if (androidInfo.version.sdkInt >= 33) {
                  result = await Permission.photos.request();
              } else {
                  result = await Permission.storage.request();
              }
          } catch (e) {
              result = await Permission.storage.request();
          }
          return result.isGranted;
      } else if (Platform.isIOS) {
          final photos = await Permission.photos.request();
          return photos.isGranted;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveImageToGallery() async {
    if (generatedImageUrl.value.isEmpty) {
      Get.snackbar('home.error'.tr, 'home.noImageToSave'.tr);
      return;
    }

    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        Get.snackbar(
          'home.permissionRequired'.tr,
          'home.storagePermissionDenied'.tr,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () => openAppSettings(),
            child: Text('home.settings'.tr),
          ),
        );
        return;
      }

      isLoading.value = true;
      // Download image
      final response = await http.get(Uri.parse(generatedImageUrl.value));
      if (response.statusCode != 200) {
        throw Exception('home.downloadError'.tr);
      }

      // Get temporary directory to save the image first
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp_image.png';
      
      // Save image to temporary file
      File tempFile = File(tempPath);
      await tempFile.writeAsBytes(response.bodyBytes);
      
      // Save to gallery using gal
      await Gal.putImage(tempPath);
      
      Get.snackbar(
        'home.success'.tr,
        'home.imageSaved'.tr,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'home.error'.tr,
        'home.saveFailed'.tr,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

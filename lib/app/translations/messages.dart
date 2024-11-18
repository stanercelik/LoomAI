import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'home.title': 'LoomAI',
          'home.remainingCredits': 'Remaining Credits',
          'home.promptLabel': 'Enter Prompt',
          'home.promptHint': 'Describe the carpet...',
          'home.colorPaletteLabel': 'Color Palette',
          'home.colorPaletteHint': 'Example: Red, Blue, Green',
          'home.borderPatternLabel': 'Border Patterns',
          'home.borderPatternHint': 'Example: Floral designs',
          'home.tasselLabel': 'Tassels',
          'home.tasselHint': 'Yes or No',
          'home.centerPatternLabel': 'Center Pattern',
          'home.centerPatternHint': 'Example: Geometric shapes',
          'home.sizeLabel': 'Carpet Size',
          'home.createButton': 'Create Carpet',
          'home.error.title.notEnoughCredit': 'Insufficient Credits',
          'home.error.message.notEnoughCredit':
              'Please purchase more credits to create a carpet.',
          'splash.title': 'LoomAI',
          'splash.startButton': 'Start',
        },
        'tr_TR': {
          'home.title': 'LoomAI',
          'home.remainingCredits': 'Kalan Kredi',
          'home.promptLabel': 'Prompt Girin',
          'home.promptHint': 'Halınız için açıklama yazın...',
          'home.colorPaletteLabel': 'Renk Paleti',
          'home.colorPaletteHint': 'Örnek: Kırmızı, Mavi, Yeşil',
          'home.borderPatternLabel': 'Kenar Motifleri',
          'home.borderPatternHint': 'Örnek: Çiçek desenleri',
          'home.tasselLabel': 'Püskül',
          'home.tasselHint': 'Evet veya Hayır',
          'home.centerPatternLabel': 'Merkez Motifi',
          'home.centerPatternHint': 'Örnek: Geometrik şekiller',
          'home.sizeLabel': 'Halının Boyutu',
          'home.createButton': 'Halını Oluştur',
          'home.error.title.notEnoughCredit': 'Yetersiz Kredi',
          'home.error.message.notEnoughCredit':
              'Lütfen halı oluşturmak için kredi satın alın.',
          'splash.title': 'LoomAI',
          'splash.startButton': 'Kullanmaya Başla',
        },
      };
}

# LoomAI

An innovative Flutter application that allows users to create personalized Iranian carpet designs using AI technology.

## Description

**LoomAI** empowers users to design their own Iranian carpets by inputting custom prompts or selecting from various design options. The app leverages advanced AI models to generate unique carpet designs based on user input.

---

## Features

- **Custom Carpet Creation**: Enter prompts or fill out fields like color palette, border motifs, fringes, central motif, and carpet size to create unique carpets.
- **Multi-language Support**: Supports both English and Turkish languages.
- **Dark Mode and Light Mode**: Toggle between dark and light themes.
- **Credit System**: Utilize credits to generate carpet designs.
- **Advertisement Integration**: Ads are displayed after carpet generation to support the app.
- **Subscription Model**: Offers ad-free experience, daily generation limits, and advanced features.
- **Push Notifications**: Receive updates and notifications.
- **User Preferences**: Customize app settings including language and theme.

---

## Technologies Used

- **Flutter**: Cross-platform app development framework.
  - **GetX**: For state management and dependency injection.
  - **MVVM Pattern**: To separate business logic from UI.
- **Replicate API**: Utilizes the [black-forest-labs/flux-schnell](https://replicate.com/black-forest-labs/flux-schnell) model for AI-powered carpet generation.
- **RevenueCat**: Manages in-app purchases and subscriptions.
- **AdMob**: Integrates advertisements within the app.

---

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architectural pattern facilitated by **GetX** for efficient state management. All textual content is centralized in a single file for easy localization and internationalization.

---

## Screens

### 1. Splash Screen

- Displays the app logo with an animation and a "Get Started" button.

### 2. Home Screen

- **Before Carpet Creation**:
  - **AppBar**:
    - Shows remaining credits.
    - Displays the app name.
    - Includes a marketplace icon leading to the marketplace or opening a bottom sheet.
  - **Body**:
    - Prompt text field for direct input.
    - Design fields:
      - Color Palette
      - Border Motifs
      - Fringes Option
      - Central Motif
      - Carpet Size (Dropdown: 16:9, 1:1, etc.)
    - "Create Carpet" button.
- **During Carpet Creation**:
  - Shows a carpet-themed loading animation.
  - Displays a "Creating your carpet..." message.
- **After Carpet Creation**:
  - **If unsuccessful**:
    - Displays an error message without showing an ad.
  - **If successful**:
    - Displays an advertisement.
    - Shows the generated carpet image.
    - **Buttons**:
      - Save Image
      - Share Image
      - Copy Image
    - "Create New Carpet" button below the image options.

### 3. Marketplace Screen

- **Credit Packages**:
  - Various credit bundles available for purchase.
- **Subscription Plans**:
  - Details of available subscriptions.
- **Payment Methods**:
  - Purchases facilitated via Google Play Store or App Store.

### 4. Settings Screen

- **Notification Settings**: Toggle push notifications.
- **Language Options**: Switch between English and Turkish.
- **Theme Settings**: Choose between dark mode and light mode.

---

## Installation

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Set up an emulator or connect a physical device.

### Clone the Repository

```bash
git clone https://github.com/yourusername/LoomAI.git
```

### Navigate to the Project Directory

```bash
cd LoomAI
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

---

## Usage

### Generating a Carpet

- Open the app and navigate to the **Home Screen**.
- Enter a custom prompt or fill out the design fields.
- Tap on **"Create Carpet"** to generate your design.

### Managing Credits

- View remaining credits in the **AppBar**.
- Purchase additional credits or subscriptions from the **Marketplace**.

### Customization

- Access **Settings** to change language preferences and toggle between dark and light themes.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the Repository**

   ```bash
   git fork https://github.com/yourusername/LoomAI.git
   ```

2. **Clone Your Fork**

   ```bash
   git clone https://github.com/yourusername/LoomAI.git
   ```

3. **Create a Feature Branch**

   ```bash
   git checkout -b feature/YourFeature
   ```

4. **Make Your Changes**
   Ensure your changes adhere to the coding standards of the project.


5. **Commit Your Changes**

   ```bash
   git commit -m "Add your feature"
   ```

6. **Push Your Branch**

   ```bash
   git push origin feature/YourFeature
   ```

7. **Open a Pull Request**
   Go to the repository on GitHub and click “New Pull Request” to submit your changes.


---

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software as long as proper credit is given to the original creators.

---

## Contact

- **Email**: tanercelik2001@gmail.com.com
- **LinkedIn**: [Salim Taner Çelik](https://www.linkedin.com/in/tanerc/)

---

## Resources

For additional help and resources:

- [Flutter Documentation](https://docs.flutter.dev/)
- [Replicate API Documentation](https://replicate.com/docs)
- [GetX Package](https://pub.dev/packages/get)





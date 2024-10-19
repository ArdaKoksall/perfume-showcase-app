# fragrancex

This project is a Flutter application that showcases a collection of perfumes. It integrates with Firebase for data storage and retrieval, and uses various packages for enhanced UI and functionality.

## Features

- **Video Background**: The home screen features a looping video background.
- **Perfume List**: Displays a list of perfumes fetched from Firebase Firestore.
- **Perfume Details**: Detailed view of each perfume with image, description, and specifications.
- **Smooth Page Indicator**: Provides a smooth page indicator for the image carousel.
- **Firebase Integration**: Uses Firebase Firestore for storing perfume data and Firebase Storage for storing images.

## Technologies Used

- **Flutter**: For building the cross-platform mobile application.
- **Firebase**: For backend services including Firestore and Storage.
- **Dart**: Programming language used for Flutter development.
- **Cached Network Image**: For efficient image loading and caching.
- **Video Player**: For playing video backgrounds.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Firebase account

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/ArdaKoksall/perfume-showcase-app.git
    cd perfume-showcase-app
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Set up Firebase**:
    - Follow the instructions to set up Firebase for your Flutter project: [Firebase Setup](https://firebase.flutter.dev/docs/overview)
    - Add your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to the respective directories.

4. **Run the app**:
    ```sh
    flutter run
    ```

## Project Structure

- `lib/main.dart`: Entry point of the application.
- `lib/itempage.dart`: Contains the detailed view of a perfume.
- `lib/creator.dart`: Script to add empty perfume data to Firestore.
- `assets/`: Directory containing video and other static assets.

## Firebase Configuration

Ensure you have the correct Firebase configuration in `lib/firebase_options.dart`. This file is generated when you set up Firebase for your Flutter project.

## Usage

- **Home Screen**: Displays a video background with a list of perfumes.
- **Perfume Details**: Tap on a perfume to view its details.
- **Add Perfume**: Use the `lib/creator.dart` script to add empty perfume data to Firestore.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgements

- Flutter
- Firebase
- Contributors

For any questions or issues, please open an issue on GitHub.
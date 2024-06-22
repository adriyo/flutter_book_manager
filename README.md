# Flutter Book Manager

A simple Flutter application to manage a list of books. Users can add, edit, and delete books, as well as search for books by title or description.

## Features
- View a list of books
- Add a new book
- Edit an existing book
- Delete a book
- Search for books by title or description

## Getting Started

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/flutter_book_manager.git
   cd flutter_book_manager
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

### Running the Application

1. **Start the application:**

   ```bash
   flutter run
   ```

   This will launch the application on the connected device or emulator.

### Running Tests

1. **Run unit tests:**

   ```zsh
   flutter test
   flutter test integration_test/app_test.dart
   ```

   This will execute the unit tests.

2. **Run integration tests:**

   ```zsh
   flutter test integration_test/app_test.dart
   ```

   This will execute the integration test.

## Main Libraries Used

- `flutter_riverpod` - For state management
- `sqflite` - For local database management
- `path_provider` - To provide paths to store database files
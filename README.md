# Swifty Companion

A mobile application developed as part of the 42 Network curriculum. This project introduces mobile development by creating an app that interfaces with the **42 Intra API** to retrieve and display student information in a user-friendly interface.

---

## Overview

**Swifty Companion** allows users to search for any student in the 42 network by their login. It provides a detailed view of their progress, skills, and projects, effectively acting as a mobile companion to the Intra.

### Key Features
* **User Search**: Search for any 42 student by their intra login.
* **Profile Overview**: Display of profile picture, full name, login, email, and level.
* **Progress Tracking**: Specialized **Level Bar** showing exact cursus progress.
* **Dynamic Cursus Selection**: Switch between **Common Core** and **Piscine** data using a tabbed interface.
* **Detailed Stats**:
    * **Skills**: List of skills with levels and visual progress bars.
    * **Projects**: Complete project history with status (Validated/Failed) and final marks.
* **Identity Details**: Quick view of Wallet (₳) and Evaluation Points.

---

## Tech Stack

* **Framework**: [Flutter](https://flutter.dev/) (Dart).
* **Networking**: [Dio](https://pub.dev/packages/dio) with interceptors for OAuth2.
* **State Management**: [Provider](https://pub.dev/packages/provider).
* **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it).
* **Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) for OAuth tokens.
* **Logging**: [Pretty Dio Logger](https://pub.dev/packages/pretty_dio_logger).

---

## Setup & Installation

### Prerequisites
* Flutter SDK (v3.0.0+).
* A 42 API Application (UID and Secret).

### 1. Environment Configuration
Create a `.env` file in the project root and add your 42 API credentials:
```env
API_UID=your_uid_here
API_SECRET=your_secret_here
```

### 2. Run Setup Script
Use the provided setup script to regenerate platform folders and fetch dependencies:
```
chmod +x setup.sh
./setup.sh
```
### 3. Launch the Application
```
flutter run -d linux
```

---

## Bonus (Token Refresh)
This project implements the **Automatic Token Refresh** bonus. If an OAuth2 token expires (returns a 401 error), the app automatically re-authenticates in the background and retries the original request seamlessly.

To test this functionality, use the included test script
```
chmod +x test_bonus.sh
./test_bonus.sh
```

The script will temporarily sabotage the local token to force a 401 error, allowing the evaluator to observe the automatic recovery in the terminal logs.

---

### Maintenance
To completely reset the project environment and remove all platform-specific generated files:
```
chmod +x remove.sh
./remove.sh
```

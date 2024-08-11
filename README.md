# PhotoEditorApp

## Overview

PhotoEditorApp is a mobile application that allows users to register and edit images using various tools. Users can sign up using Firebase authentication through either email and password or Google authentication. The app offers a range of image editing features, including applying filters, drawing with PencilKit, and adding customizable text overlays.

## Features

- **User Authentication:**
  - Register and log in using Firebase authentication.
  - Support for email/password and Google authentication.
  - Password recovery functionality.

- **Image Editing:**
  - Select images from the gallery or capture them using the camera.
  - Apply filters to images.
  - Utilize PencilKit for freehand drawing on images.
  - Add and customize text overlays on images.

- **Export:**
  - Export edited images to share or save.

## Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern, providing a clear separation between the UI, business logic, and data management layers. This architecture enhances code maintainability, scalability, and testability.

### Application Modules

The app is divided into two independent modules:

1. **Auth Module:**
   - Manages user authentication and registration.
   - Contains two screens: Login and Registration.
   - Includes a password recovery form.

2. **PhotoEditor Module:**
   - Manages the image editing functionality.
   - Contains three screens:
     1. **Profile Screen:** Allows users to view their profile and log out.
     2. **Image Selection Screen:** Enables users to choose an image from the gallery or take a new photo using the camera.
     3. **Image Editing Screen:** Provides tools to apply filters, draw, and add text to images, with an option to export the final result.

### Application Flow

- **RootScreenView:**
  - The root of the application that manages the main modules.
  - Controlled by the Auth Service, which monitors the user's authentication state (`.loggedOut`, `.loggedIn`, `.initial`).

- **Startup Process:**
  - On app launch, the app checks the user's authentication state via Firebase.
  - During this check, a SplashScreen is displayed.

- **Navigation:**
  - If the user is not logged in, they are directed to the Auth module.
  - If the user is logged in, they are taken to the PhotoEditor module.

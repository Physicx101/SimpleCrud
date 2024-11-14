# SimpleCRUD Flutter Application

A basic CRUD (Create, Read, Update, Delete) Flutter app that interacts with a REST API for managing items. The app follows clean architecture principles with proper state management using Cubit from the Bloc package.

## How to Run the Project

### Prerequisites
Ensure you have Flutter installed. You can follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) if you haven’t already done so.

### Steps to Run

1. **Clone the repository:**

    ```bash
    git clone https://github.com/physicx101/simplecrud.git
    cd simplecrud
    ```

2. **Install Dependencies:**

   Run this command to install all necessary packages:

    ```bash
    flutter pub get
    ```

3. **Run the app:**

   Connect an emulator or a physical device, and run the app by executing:

    ```bash
    flutter run
    ```

## Project Architecture

The app follows Clean Architecture and is structured into three main layers:

- **Data Layer**:
    - Handles API calls using Dio.
    - Contains models for mapping API responses (e.g., `ItemModel`).
    - Communicates with the REST API via services (e.g., `ItemApiService`).

- **Domain Layer**:
    - Contains core business logic.
    - Defines entities and use cases (e.g., `FetchItem`, `CreateItem`, etc.).

- **Presentation Layer**:
    - Manages UI and state.
    - Uses Cubit for state management, with separate states for loading, success, and error.
    - Contains widgets and screens for displaying the list of items, item details, and forms for item creation/updating.

## Key Features

- **Create** items with form inputs.
- **Read** items from the API and display them in a list.
- **Update** items via the UI.
- **Delete** items from the API or locally.

## License

This project is licensed under the MIT License.

---

That's it! You now have a simple overview as well as the necessary steps to run the project. Feel free to modify any parts to fit your project better. Let me know if you need further details!

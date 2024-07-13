# Student Management

Student Management application for managing students in mobile app and managing teachers, courses, assignments in Cli. 
Using Java as managing server and database and Flutter for mobile application.

## Features

### Cli
- **Admin Menu**:
  - Add/Remove/Update/Show students, teachers, classes
- **Teacher Menu**:
  - Add students to their courses
  - Remove students from their courses
  - Add/Remove assignments to/from their classes
  - Modify assignments

### Mobile App for Students
- **Sign Up & Login**: Student authentication
- **User Profile**: Avatar upload, account deletion, password/data change
- **Home Screen**: Summary of records and assignments
- **To-Do List**: Task management
- **Classes**: Class management
- **News**: University news updates
- **Assignments**: Assignment details

## Installation

### Prerequisites
- Java Development Kit (JDK)
- Flutter SDK

### Steps
1. Clone the repository:
    ```bash
    git clone https://github.com/Arriaw/Student-Management
    ```
2. Navigate to the project directory:
    ```bash
    cd Student-Management
    ```
3. Follow specific setup instructions for the backend and frontend as per the documentation.

## Usage

### Running the CLI
1. Compile and run the Main
	```bash
	cd Backend/src/miniP
	
	javac Cli.java
	
	java Cli.class
	```


### Running the Backend
1. Compile and run the Java server.
	```bash
	cd Backend/src/miniP
	
	javac Server.java
	
	java Server.class
	```


### Running the Mobile App
1. Open the Flutter project.
2. Run the app on an emulator or a physical device.

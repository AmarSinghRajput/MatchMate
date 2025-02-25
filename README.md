# MatchMate App

## Overview
MatchMate is an iOS application built using **SwiftUI**, **Combine**, and **Core Data**. It allows users to browse and interact with profiles by accepting or declining them. The app supports offline mode and automatically syncs changes when the internet is available.

## Features
- **Fetch Profiles:** Retrieve profiles from an API or load cached data from Core Data.
- **Accept/Decline Matches:** Update the status of a profile.
- **Offline Mode:** View and update profiles even without an internet connection.
- **Unit Tests:** Includes tests for ViewModel XCTest.

##Future Enhancement
- **Auto-Sync:** Changes sync automatically when the network is restored - POST API for sync not available currently.
- Snapshot tests
- UI tests 

## Installation
1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/MatchMate.git](https://github.com/AmarSinghRajput/MatchMate/edit/main/README.md)
   cd MatchMate
   ```
2. Open `MatchMate.xcodeproj` in Xcode.
3. Install needed dependencies (e.g., Alamofire, SDWebImage etc).
4. Run the project on a simulator or device.

## Running Tests
To run unit and UI tests:
```bash
CMD + U (Run Tests in Xcode)
```

## Technologies Used
- **SwiftUI** for UI components.
- **Combine** for handling async operations.
- **Core Data** for local data persistence.
- **Alamofire** for API requests.

## License
This project is licensed under the MIT License.


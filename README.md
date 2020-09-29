# Lachie's Sudoku Solver

To run the app:
`flutter run`

To run unit & widget tests:
`flutter test`

To run integration tests:

1.  Open 2 terminals
2.  In terminal 1, enter:
    `flutter run --observatory-port 8888 --disable-service-auth-codes lib/main.dart`
3.  In terminal 2, enter:
    ```
    dart test_driver/screen_navigation_tests.dart; 
    dart test_driver/solve_with_camera_screen_tests.dart; 
    dart test_driver/just_play_screen_tests.dart; 
    dart test_driver/play_all_games_tests.dart;
    ```

To run SonarQube quality scan

1. Start SonarQube server
   `C:\Users\Lachie\SonarQube\Server\bin\windows-x86-64\StartSonar.bat`
2. Run SonarQube scan
   `sonar-scanner`

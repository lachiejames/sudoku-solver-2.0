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
    `dart test_driver/run_app_test.dart`

To run SonarQube quality scan

1. Start SonarQube server
   `C:\Users\Lachie\SonarQube\Server\bin\windows-x86-64\StartSonar.bat`
2. Run SonarQube scan
   `sonar-scanner`

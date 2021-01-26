import 'tests/just_play_screen_tests.dart' as just_play_screen_tests;
import 'tests/play_all_games_tests.dart' as play_all_games_tests;
import 'tests/screen_navigation_tests.dart' as screen_navigation_tests;
import 'tests/solve_with_camera_screen_tests.dart' as solve_with_camera_screen_tests;

void main() {
  screen_navigation_tests.main();
  solve_with_camera_screen_tests.main();
  just_play_screen_tests.main();
  play_all_games_tests.main();
}

import 'package:meta/meta.dart';

/// All state relating to the NumberWidgets
@immutable
class NumberState {
  final int number;

  final bool isActive;

  const NumberState({@required this.number, this.isActive = false});

  @override
  String toString() => 'NumberState($number)';

  NumberState copyWith({
    int number,
    bool isActive,
  }) =>
      NumberState(
        number: number ?? this.number,
        isActive: isActive ?? this.isActive,
      );

  static List<NumberState> initNumberStateList() {
    final List<NumberState> _numberStateList = <NumberState>[];
    for (int n = 1; n <= 9; n++) {
      _numberStateList.add(NumberState(number: n));
    }
    return _numberStateList;
  }
}

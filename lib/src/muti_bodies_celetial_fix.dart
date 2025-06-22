import 'package:celestial_position_solver/src/normal_gradient_descent.dart';
import 'package:celestial_position_solver/src/position_object/position_information.dart';
import 'package:navigation/navigation.dart';

class MutiBodiesCeletialFix {
  ShipInformation initPosition;
  List<StarInformation> star;
  double learningRate;
  double? runningFixTiem;
  bool needRFix;
  MutiBodiesCeletialFix(
      {required this.initPosition,
      required this.star,
      this.learningRate = 0.01,
      this.needRFix = true,
      this.runningFixTiem});
  List<Position> solveEachPosition() {
    int i, j;
    List<Position> ansSet = [];
    for (i = 0; i < star.length; i++) {
      for (j = i + 1; j < star.length; j++) {
        GradientDescent gd = GradientDescent(
            initPosition: initPosition.clone(),
            star: [star[i].clone(), star[j].clone()],
            batchSize: 2,
            learningRate: learningRate,
            runningFixTiem: runningFixTiem,
            needRFix: needRFix);
        ansSet.add(gd.gradientDescent());
      }
    }
    return ansSet;
  }
}

import 'dart:io';

import 'package:celestial_position_solver/celestial_position_solver.dart';
import 'package:navigation/navigation.dart';

import 'data_set.dart';

void main() {
  for (int i = 0; i < star.length; i++) {
    final lrFile = File('learning_rate/que${i}.txt').openWrite();
    for (double learningRate = 0.001;
        learningRate < 0.1;
        learningRate += 0.001) {
      GradientDescent gd = GradientDescent(
          initPosition: dr[i],
          learningRate: learningRate,
          star: star[i],
          batchSize: star.length,
          needRFix: true);
      Position ans = gd.gradientDescent();
      lrFile.writeln(
          '${learningRate} ${gd.currentIteration} ${ans.lat} ${ans.long}');
    }
    lrFile.close();
  }
}

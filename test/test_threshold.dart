import 'dart:io';
import 'dart:math';

import 'package:celestial_position_solver/celestial_position_solver.dart';
import 'package:navigation/navigation.dart';
import 'package:vector_math/vector_math.dart';

import 'data_set.dart';

void main() {
  final thresholdFile = File('threshold_dutton.txt').openWrite();
  for (double threshold = 1e-16; threshold < 1e-4; threshold *= 5) {
    GradientDescent gd = GradientDescent(
        initPosition: dr[8].clone(),
        star: star[8],
        batchSize: 2,
        learningRate: 0.01,
        threshold: threshold,
        needRFix: true);
    print(threshold);
    print(gd.gradientDescent());
    Position ans = gd.gradientDescent();
    int iter = gd.currentIteration;
    thresholdFile.writeln(
        '$threshold ${degrees(lossFunction(ans, star[8])) * 60} $iter');
  }
  thresholdFile.close();
}

double lossFunction(Position position, List<StarInformation> star) {
  double sum = 0;
  for (final star in star) {
    final diff = sin(star.ho) - (hc(position, star));
    sum += diff * diff;
    //print(sum);
  }
  //have sqrt or not it doesn't matter
  return sqrt((sum) / star.length); //-(pow(0.5, 4*x)+1);
}

double hc(Position position, StarInformation star) {
  return sin(position.lat) * sin(star.dec) +
      cos(position.lat) * cos(star.dec) * cos(star.gha + position.long);
}

import 'dart:io';

import 'package:celestial_position_solver/celestial_position_solver.dart';
import 'package:navigation/navigation.dart';
import 'package:vector_math/vector_math.dart';

import 'data_set.dart';

void main() {
  double total = 0;
  int countminiWin = 0;
  final miniBatchWinFile = File('mini_batch_win.txt').openWrite();
  for (int batchSize = 1; batchSize < 7; batchSize++) {
    total = 0;
    countminiWin = 0;
    double totalMiniToCorrected = 0;
    double fullToCorrected = 0;
    for (int i = 0; i < 1000; i++) {
      GradientDescent miniGd = GradientDescent(
          initPosition: dr.last,
          star: star.last,
          batchSize: batchSize,
          threshold: 1e-8);
      Position miniAns = miniGd.gradientDescent();
      double miniToCorrected = degrees(miniAns
              .greatCircleDistanceTo(Position(radians(27.5), radians(179)))) *
          60;
      //print(miniToCorrected);
      // print(
      //     "lat:${degrees(miniAns.lat).toInt()}°${degrees(miniAns.lat).abs() % 1 * 60}'");
      // print(
      //     "long:${degrees(miniAns.long).toInt()}°${degrees(miniAns.long).abs() % 1 * 60}'");
      GradientDescent gd = GradientDescent(
          initPosition: dr.last,
          star: star.last,
          batchSize: star.length,
          threshold: 1e-13);
      Position ans = gd.gradientDescent();
      fullToCorrected = degrees(ans
              .greatCircleDistanceTo(Position(radians(27.5), radians(179)))) *
          60;
      print(fullToCorrected);
      if (miniToCorrected < fullToCorrected) {
        countminiWin++;
      }
      totalMiniToCorrected += miniToCorrected;
      total += (miniToCorrected - fullToCorrected);
      //print(miniToCorrected - fullToCorrected);
    }
    total /= 1000;
    print(total);
    print(countminiWin);
    print(fullToCorrected);
    miniBatchWinFile.writeln(
        '${batchSize} ${totalMiniToCorrected / 1000} $total  ${countminiWin / 1000}');
  }
}

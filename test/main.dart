import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:celestial_position_solver/celestial_position_solver.dart';
import 'package:vector_math/vector_math_64.dart';
import 'data_set.dart';
import 'package:navigation/navigation.dart';

import 'seven_star_data_set.dart';

enum GDType { GD, momentum, adam }

void compareDiffGD(ShipInformation initPosition, List<StarInformation> star,
    int batchSize, double learningRate) {
  GradientDescent gd = GradientDescent(
      initPosition: initPosition,
      star: star,
      batchSize: batchSize,
      learningRate: learningRate,
      needRFix: true);
  Position ans = gd.gradientDescent();
  print("lat:${degrees(ans.lat).toInt()}°${degrees(ans.lat).abs() % 1 * 60}'");
  print(
      "long:${degrees(ans.long).toInt()}°${degrees(ans.long).abs() % 1 * 60}'");
  print("loss:${lossFunction(ans, star)}");

  GradientDescent momentumGD = GradientDescent(
      initPosition: initPosition,
      star: star,
      batchSize: batchSize,
      learningRate: learningRate,
      needRFix: true);
  Position momentumAns = momentumGD.momentum();
  print(
      "lat:${degrees(momentumAns.lat).toInt()}°${degrees(momentumAns.lat).abs() % 1 * 60}'");
  print(
      "long:${degrees(momentumAns.long).toInt()}°${degrees(momentumAns.long).abs() % 1 * 60}'");
  print("loss:${lossFunction(momentumAns, star)}");

  GradientDescent adamGD = GradientDescent(
      initPosition: initPosition,
      star: star,
      batchSize: batchSize,
      learningRate: learningRate,
      needRFix: true);
  Position adamAns = adamGD.adam();
  print(
      "lat:${degrees(adamAns.lat).toInt()}°${degrees(adamAns.lat).abs() % 1 * 60}'");
  print(
      "long:${degrees(adamAns.long).toInt()}°${degrees(adamAns.long).abs() % 1 * 60}'");
  print("loss:${lossFunction(adamAns, star)}");

  print("GD vs Momentum");
  double norm = sqrt(
      pow(ans.lat - momentumAns.lat, 2) + pow(ans.long - momentumAns.long, 2));
  print(norm);

  print("GD vs Adam");
  norm = sqrt(pow(ans.lat - adamAns.lat, 2) + pow(ans.long - adamAns.long, 2));
  print(norm);

  print("Momentum vs Adam");
  norm = sqrt(pow(momentumAns.lat - adamAns.lat, 2) +
      pow(momentumAns.long - adamAns.long, 2));
  print(norm);
  print("///////////////////////////////");
}

void createConvergeSituation() {
  String path = "converge/";
  int question = 9;
  final GDconvergeFile = File('${path}GD_$question.txt').openWrite();
  print('StartGD');
  for (int long = -180; long <= 180; long += 1) {
    for (int lat = -90; lat <= 90; lat += 1) {
      GradientDescent gd = GradientDescent(
          initPosition: ShipInformation(
              lat: radians(lat.toDouble()),
              long: radians(long.toDouble()),
              time: dr[question].time,
              speed: dr[question].speed,
              course: dr[question].course),
          star: star[question],
          batchSize: star[question].length,
          learningRate: 0.01,
          needRFix: true);
      Position gdAns = gd.gradientDescent();
      GDconvergeFile.writeln('${long} ${lat} ${gd.currentIteration}');
    }
  }
  print('EndGD');
  GDconvergeFile.close();

  final momentumConvergeFile =
      File('${path}momentum_${question}.txt').openWrite();
  for (int long = -180; long <= 180; long += 1) {
    for (int lat = -90; lat <= 90; lat += 1) {
      GradientDescent gd = GradientDescent(
          initPosition: ShipInformation(
              lat: radians(lat.toDouble()),
              long: radians(long.toDouble()),
              time: dr[question].time,
              speed: dr[question].speed,
              course: dr[question].course),
          star: star[question],
          batchSize: star[question].length,
          learningRate: 0.01,
          needRFix: true);
      Position momentumAns = gd.momentum();
      momentumConvergeFile.writeln('${long} ${lat} ${gd.currentIteration}');
    }
  }
  momentumConvergeFile.close();

  final adamConvergeFile = File('${path}adam_${question}.txt').openWrite();
  for (int long = -180; long <= 180; long += 1) {
    for (int lat = -90; lat <= 90; lat += 1) {
      GradientDescent gd = GradientDescent(
          initPosition: ShipInformation(
              lat: radians(lat.toDouble()),
              long: radians(long.toDouble()),
              time: dr[question].time,
              speed: dr[question].speed,
              course: dr[question].course),
          star: star[question],
          batchSize: star[question].length,
          learningRate: 0.01,
          needRFix: true);
      Position adamAns = gd.adam();
      adamConvergeFile.writeln('${long} ${lat} ${gd.currentIteration}');
    }
  }
  adamConvergeFile.close();
}

void recordIterationHistory(
    ShipInformation initPosition, int question, int batchSize, GDType gdType) {
  GradientDescent gd = GradientDescent(
      initPosition: initPosition,
      star: star[question],
      batchSize: batchSize,
      learningRate: 0.01,
      needRFix: true);
  Position ans;
  if (gdType == GDType.momentum) {
    ans = gd.momentum();
  } else if (gdType == GDType.adam) {
    ans = gd.adam();
  } else if (gdType == GDType.GD) {
    ans = gd.gradientDescent();
  } else {
    ans = gd.gradientDescent();
  }
  print("lat:${degrees(ans.lat).toInt()}°${degrees(ans.lat).abs() % 1 * 60}'");
  print(
      "long:${degrees(ans.long).toInt()}°${degrees(ans.long).abs() % 1 * 60}'");
  print("loss:${lossFunction(ans, star[question])}");
  final gdTypeStr = gdType.toString().split('.').last;
  String latStr = degrees(ans.lat).toStringAsFixed(2);
  String lonStr = degrees(ans.long).toStringAsFixed(2);
  String dirPath = 'history/que${question}_la${latStr}_lo$lonStr';
  final history =
      File('${dirPath}_${gdTypeStr}_l_bS$batchSize.txt').openWrite();
  for (int i = 0; i < gd.historyPosition.length; i++) {
    history
        .writeln('${gd.historyPosition[i].long} ${gd.historyPosition[i].lat}');
  }
  history.close();

  // final historyGradient =
  //     File('history_gradient_${gdType}_batchSize$batchSize.txt').openWrite();
  // for (int i = 0; i < gd.historyGradient.length; i++) {
  //   historyGradient
  //       .writeln('${gd.historyGradient[i][1]} ${gd.historyGradient[i][0]}');
  // }
  // historyGradient.close();
}

void main() {
  // for (int i = 0; i < dr.length; i++) {
  //   compareDiffGD(dr[i], star[i], star[i].length, 0.01);
  // }

  //createConvergeSituation();

  // recordIterationHistory(
  //     ShipInformation(
  //         lat: radians(-50),
  //         long: radians(-50.5),
  //         speed: dr[8].speed,
  //         course: dr[8].course,
  //         time: dr[8].time),
  //     8,
  //     2,
  //     GDType.GD);

  // GradientDescent gd = GradientDescent(
  //     initPosition: dr[10],
  //     star: star[10],
  //     batchSize: star[10].length,
  //     learningRate: 0.01,
  //     needRFix: true);
  // Position ans = gd.gradientDescent();
  // List<StarInformation> starOffset =
  //     gd.runningFix(initPosition: dr[9], star: star[9], time: dr[9].time);
  // print(lossFunction(ans, starOffset));

  // Position psoAns =
  //     Position(radians(44 + 49.46458 / 60), radians(-30 - 15.48982 / 60));
  // print(lossFunction(psoAns, starOffset));

  print('5start');
  GradientDescent gd = GradientDescent(
      initPosition: dr.last,
      star: star.last,
      batchSize: star.last.length,
      learningRate: 0.01,
      needRFix: true);
  Position ansTotal = gd.gradientDescent();
  print(
      "lat:${degrees(ansTotal.lat).toInt()}°${degrees(ansTotal.lat).abs() % 1 * 60}'");
  print(
      "long:${degrees(ansTotal.long).toInt()}°${degrees(ansTotal.long).abs() % 1 * 60}'");
  print('[${ansTotal.long},${ansTotal.lat}]');

  // MutiBodiesCeletialFix gdEach = MutiBodiesCeletialFix(
  //     initPosition: dr[11], star: star[11], learningRate: 0.01, needRFix: true);
  // List<Position> ans = gdEach.solveEachPosition();
  // for (int i = 0; i < ans.length; i++) {
  //   stdout.write('[${ans[i].long},${ans[i].lat}],');
  // }
  print('end');

  // MutiBodiesCeletialFix multiGd = MutiBodiesCeletialFix(
  //     initPosition: dr[4], star: star[4], learningRate: 0.01, needRFix: true);
  // List<Position> ans = multiGd.solveEachPosition();
  // for (int i = 0; i < ans.length; i++) {
  //   stdout.write('[${ans[i].long},${ans[i].lat}],');
  // }
  // print('');
  // GradientDescent gd = GradientDescent(
  //     initPosition: dr[4],
  //     star: star[4],
  //     batchSize: 3,
  //     learningRate: 0.01,
  //     needRFix: true);
  // Position ans_total = gd.gradientDescent();
  // print('[${degrees(ans_total.long)} , ${degrees(ans_total.lat)}]');

  // GradientDescent gd = GradientDescent(
  //     initPosition: sevenDr.last,
  //     star: sevenStar[1],
  //     batchSize: sevenStar[1].length,
  //     learningRate: 0.01,
  //     needRFix: true);
  // Position ansTotal = gd.gradientDescent();
  // print(
  //     "lat:${degrees(ansTotal.lat).toInt()}°${degrees(ansTotal.lat).abs() % 1 * 60}'");
  // print(
  //     "long:${degrees(ansTotal.long).toInt()}°${degrees(ansTotal.long).abs() % 1 * 60}'");
  // print('[${ansTotal.long},${ansTotal.lat}]');

  // MutiBodiesCeletialFix gdEach = MutiBodiesCeletialFix(
  //     initPosition: sevenDr.first,
  //     star: sevenStar[1],
  //     learningRate: 0.01,
  //     needRFix: true);
  // List<Position> ans = gdEach.solveEachPosition();
  // for (int i = 0; i < ans.length; i++) {
  //   stdout.write('[${ans[i].long},${ans[i].lat}],');
  // }
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

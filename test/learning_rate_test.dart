import 'dart:io';

import 'package:celestial_position_solver/celestial_position_solver.dart';
import 'package:navigation/navigation.dart';

import 'data_set.dart';

Future<void> main() async {
  for (int i = 0; i < star.length; i++) {
    final lrFile = File('learning_rate/que${i}.txt').openWrite();
    for (int step = 1; step < 100; step++) {
      final learningRate = step * 0.001;
      GradientDescent gd = GradientDescent(
        initPosition: dr[i],
        learningRate: learningRate,
        star: star[i],
        batchSize: star[i].length,
        threshold: 1e-10,
        needRFix: true,
      );
      Position ans = gd.gradientDescent();
      lrFile.writeln(
          '$learningRate ${gd.currentIteration} ${ans.lat} ${ans.long}');
    }
    await lrFile.flush(); // 確保把 buffer 刷出去
    await lrFile.close(); // 等待真正關閉檔案
  }
}

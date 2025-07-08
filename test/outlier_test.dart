import 'package:celestial_position_solver/celestial_position_solver.dart';
import 'package:celestial_position_solver/src/dbscan.dart';
import 'package:navigation/navigation.dart';

import 'data_set.dart';

void main() {
  MutiBodiesCeletialFix mAVP =
      MutiBodiesCeletialFix(initPosition: dr[6], star: star[6]);
  List<Position> ans = mAVP.solveEachPosition();
  DBSCAN db = DBSCAN(eps: 1, minPts: 3);
  List<int> labels = db.fit(ans);
  print(labels);
}

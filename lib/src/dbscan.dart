import 'dart:math';

import 'package:navigation/navigation.dart';
import 'package:vector_math/vector_math_64.dart';

class DBSCAN {
  final double eps;
  final int minPts;

  DBSCAN({required this.eps, required this.minPts});

  /// 對 data 執行 DBSCAN 分群，並回傳 labels
  /// labels[i] == -1 表示雜訊；>=0 表示該點所屬的群集編號
  List<int> fit(List<Position> data) {
    final int n = data.length;
    final labels = List<int>.filled(n, -2); // -2 表示尚未拜訪
    final visited = List<bool>.filled(n, false);
    int clusterId = 0;

    for (int i = 0; i < n; i++) {
      if (visited[i]) continue;
      visited[i] = true;

      final neighbors = _regionQuery(data, i);
      if (neighbors.length < minPts) {
        // 臨時標為 noise
        labels[i] = -1;
      } else {
        // 擴張一個新群集
        _expandCluster(data, labels, visited, i, neighbors, clusterId);
        clusterId++;
      }
    }

    return labels;
  }

  /// 從核心點 pointId 開始擴張群集
  void _expandCluster(
    List<Position> data,
    List<int> labels,
    List<bool> visited,
    int pointId,
    List<int> neighbors,
    int clusterId,
  ) {
    labels[pointId] = clusterId;
    final seeds = <int>[...neighbors]; // 用一個動態 list 當 queue
    int index = 0;

    while (index < seeds.length) {
      final current = seeds[index];

      // 如果原先被標為 noise，則把它轉成 border point
      if (labels[current] == -1) {
        labels[current] = clusterId;
      }

      if (!visited[current]) {
        visited[current] = true;
        final currentNeighbors = _regionQuery(data, current);

        // 只有核心點才能繼續擴張：把還沒在 seeds 裡的鄰居加入
        if (currentNeighbors.length >= minPts) {
          for (final pt in currentNeighbors) {
            if (!seeds.contains(pt)) {
              seeds.add(pt);
            }
          }
        }
      }

      // 若尚未被分群（剛標為 -2），直接標上 clusterId
      if (labels[current] == -2) {
        labels[current] = clusterId;
      }

      index++;
    }
  }

  /// 回傳第 pointId 個點的所有 ε-鄰域點 index 列表
  List<int> _regionQuery(List<Position> data, int pointId) {
    final neighbors = <int>[];
    for (int j = 0; j < data.length; j++) {
      if (_distance(data[pointId], data[j]) <= eps) {
        neighbors.add(j);
      }
    }
    return neighbors;
  }

  /// 計算兩個向量之間的大圈距離（knots）
  double _distance(Position a, Position b) {
    return degrees(a.greatCircleDistanceTo(b)) * 180;
  }
}

void main() {
  // final data = <List<Position>>[
  //   [2.6221909301397917, 0.48452910339685756],
  //   [2.622097208931921, 0.48424781584457915],
  //   [2.6224926291406474, 0.48543542535010825],
  //   [2.621427634638335, 0.4822417305562414],
  //   [2.638791575496376, 0.5338128991314016],
  //   [2.634941332804035, 0.5239949197036808],
  //   [2.622215529188287, 0.48434936929772593],
  //   [2.621911985108664, 0.4865565065363255],
  //   [2.6224355757916213, 0.4827346638641285],
  //   [2.6244021898047585, 0.46771082394719793],
  //   [2.611681239601824, 0.5503787651549572],
  //   [2.6227957439542764, 0.48484721676236814],
  //   [2.6175224681564915, 0.48031359794086614],
  //   [2.628311491251544, 0.48956771686515344],
  //   [2.649342111351106, 0.5073595462733445],
  //   [2.6235896986600764, 0.48329671880491215],
  //   [2.6261481031604785, 0.4782008958832958],
  //   [2.5559965330762853, 0.5963727212379282],
  //   [2.627437057410236, 0.48515220649375485],
  //   [2.6569494354845857, 0.4984832313489475],
  //   [2.636252635034898, 0.522489424815205]
  // ];

  // final db = DBSCAN(eps: 0.01, minPts: 3);
  // final labels = db.fit(data);

  // for (int i = 0; i < labels.length; i++) {
  //   print('Point $i ➜ label ${labels[i]}');
  // }
}

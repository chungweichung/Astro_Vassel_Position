import 'dart:collection';
import 'dart:math';

import 'package:navigation/navigation.dart';
import 'package:vector_math/vector_math_64.dart';

// class DBSCAN {
//   final double eps;
//   final int minPts;

//   DBSCAN({required this.eps, required this.minPts});

//   /// 對 data 執行 DBSCAN 分群，並回傳 labels
//   /// labels[i] == -1 表示雜訊；>=0 表示該點所屬的群集編號
//   List<int> fit(List<Position> data) {
//     final int n = data.length;
//     final labels = List<int>.filled(n, -2); // -2 表示尚未拜訪
//     final visited = List<bool>.filled(n, false);
//     int clusterId = 0;

//     for (int i = 0; i < n; i++) {
//       if (visited[i]) continue;
//       visited[i] = true;

//       final neighbors = _regionQuery(data, i);
//       if (neighbors.length < minPts) {
//         // 臨時標為 noise
//         labels[i] = -1;
//       } else {
//         // 擴張一個新群集
//         _expandCluster(data, labels, visited, i, neighbors, clusterId);
//         clusterId++;
//       }
//     }

//     return labels;
//   }

//   /// 從核心點 pointId 開始擴張群集
//   void _expandCluster(
//     List<Position> data,
//     List<int> labels,
//     List<bool> visited,
//     int pointId,
//     List<int> neighbors,
//     int clusterId,
//   ) {
//     labels[pointId] = clusterId;
//     final seeds = <int>[...neighbors]; // 用一個動態 list 當 queue
//     int index = 0;

//     while (index < seeds.length) {
//       final current = seeds[index];

//       // 如果原先被標為 noise，則把它轉成 border point
//       if (labels[current] == -1) {
//         labels[current] = clusterId;
//       }

//       if (!visited[current]) {
//         visited[current] = true;
//         final currentNeighbors = _regionQuery(data, current);

//         // 只有核心點才能繼續擴張：把還沒在 seeds 裡的鄰居加入
//         if (currentNeighbors.length >= minPts) {
//           for (final pt in currentNeighbors) {
//             if (!seeds.contains(pt)) {
//               seeds.add(pt);
//             }
//           }
//         }
//       }

//       // 若尚未被分群（剛標為 -2），直接標上 clusterId
//       if (labels[current] == -2) {
//         labels[current] = clusterId;
//       }

//       index++;
//     }
//   }

//   /// 回傳第 pointId 個點的所有 ε-鄰域點 index 列表
//   List<int> _regionQuery(List<Position> data, int pointId) {
//     final neighbors = <int>[];
//     for (int j = 0; j < data.length; j++) {
//       if (_distance(data[pointId], data[j]) <= eps) {
//         neighbors.add(j);
//       }
//     }
//     return neighbors;
//   }

//   /// 計算兩個向量之間的大圈距離（knots）
//   double _distance(Position a, Position b) {
//     return degrees(a.greatCircleDistanceTo(b)) * 180;
//   }
// }
class DBSCAN {
  final double eps;
  final int minPts;
  late final List<Position> _data;

  DBSCAN({required this.eps, required this.minPts});

  /// 返回 labels：-2=未訪問，-1=雜訊，>=0=群集編號
  List<int> fit(List<Position> data) {
    _data = data;
    final n = data.length;
    final labels = List<int>.filled(n, -2);
    var clusterId = 0;

    for (var i = 0; i < n; i++) {
      if (labels[i] != -2) continue; // already visited
      final neighbors = _getNeighbors(i);
      if (neighbors.length < minPts) {
        labels[i] = -1; // noise
      } else {
        _expandCluster(i, neighbors, clusterId, labels);
        clusterId++;
      }
    }

    return labels;
  }

  void _expandCluster(
    int pointId,
    List<int> seeds,
    int clusterId,
    List<int> labels,
  ) {
    labels[pointId] = clusterId;
    final queue = Queue<int>.from(seeds);
    final seen = <int>{...seeds};

    while (queue.isNotEmpty) {
      final curr = queue.removeFirst();

      if (labels[curr] == -1) {
        // border point (was noise)
        labels[curr] = clusterId;
      }

      final neigh = _getNeighbors(curr);
      if (neigh.length >= minPts) {
        for (var nb in neigh) {
          if (seen.add(nb)) {
            queue.add(nb);
          }
        }
      }

      if (labels[curr] < 0) {
        // still unassigned
        labels[curr] = clusterId;
      }
    }
  }

  List<int> _getNeighbors(int idx) => [
        for (var j = 0; j < _data.length; j++)
          if (_distance(_data[idx], _data[j]) <= eps) j
      ];

  double _distance(Position a, Position b) =>
      degrees(a.greatCircleDistanceTo(b)) * 180;
}

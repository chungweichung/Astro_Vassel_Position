import 'dart:math';
import 'package:celestial_position_solver/src/position_object/position_information.dart';
import 'package:vector_math/vector_math.dart';
import 'package:navigation/navigation.dart';

class GradientDescent {
  ShipInformation initPosition;
  List<StarInformation> star;
  double learningRate;
  double? runningFixTiem;
  bool needRFix;
  int batchSize;
  int currentIteration = 0;
  List<Position> historyPosition = [];
  List<List<double>> historyGradient = [];
  List gra = [0, 0];
  double threshold;
  GradientDescent({
    required this.initPosition,
    required this.star,
    required this.batchSize,
    this.learningRate = 0.01,
    this.threshold = 1e-8,
    this.needRFix = false,
    this.runningFixTiem,
  });

  double hc(Position position, StarInformation star) {
    return sin(position.lat) * sin(star.dec) +
        cos(position.lat) * cos(star.dec) * cos(star.gha + position.long);
  }

  double lossFunction(Position position, List<StarInformation> star) {
    double sum = 0;
    for (final star in star) {
      //double diff = star.ho - asin(hc(position, star));
      double diff = star.ho - asin(hc(position, star));
      sum += diff * diff;
      //print(sum);
    }
    //have sqrt or not it doesn't matter
    return sqrt(1e-4 + (sum / star.length)); //-(pow(0.5, 4*x)+1);
    //return sum / star.length;
    //return sum;
  }

  List forwoardGradient(Position ap, List<StarInformation> star) {
    double h = 1e-10;
    double tempLat = (lossFunction(Position(ap.lat + h, ap.long), star) -
                lossFunction(ap, star)) /
            h,
        tempLong = (lossFunction(Position(ap.lat, ap.long + h), star) -
                lossFunction(ap, star)) /
            h;
    return [tempLat, tempLong];
  }

  // List<double> gradient(Position ap, List<StarInformation> star) {
  //   double h = 1e-10;
  //   double tempLat = (lossFunction(Position(ap.lat + h, ap.long), star) -
  //           lossFunction(Position(ap.lat - h, ap.long), star)) /
  //       (2 * h);
  //   double tempLong = (lossFunction(Position(ap.lat, ap.long + h), star) -
  //           lossFunction(Position(ap.lat, ap.long - h), star)) /
  //       (2 * h);
  //   return [tempLat, tempLong];
  // }
//sine residual gradient
  // List<double> gradient(Position ap, List<StarInformation> star) {
  //   final double phi = ap.lat;
  //   final double lam = ap.long;

  //   double dPhi = 0.0;
  //   double dLam = 0.0;

  //   for (final s in star) {
  //     // 預先計算 sin/cos
  //     final double sinPhi = sin(phi);
  //     final double cosPhi = cos(phi);
  //     final double sinDec = sin(s.dec);
  //     final double cosDec = cos(s.dec);
  //     final double ghaLam = s.gha + lam;
  //     final double cosGhaLam = cos(ghaLam);
  //     final double sinGhaLam = sin(ghaLam);

  //     // 計算 hc 與殘差 r
  //     final double hc = sinPhi * sinDec + cosPhi * cosDec * cosGhaLam;
  //     final double r = sin(s.ho) - hc;

  //     // d(hc)/dφ 與 d(hc)/dλ
  //     final double dhc_dPhi = cosPhi * sinDec - sinPhi * cosDec * cosGhaLam;
  //     final double dhc_dLam = -cosPhi * cosDec * sinGhaLam;

  //     // 利用鏈式法則累加梯度
  //     // L = Σ r_i^2  ⇒  ∂L/∂x = 2 Σ r_i (∂r_i/∂x) = -2 Σ r_i (∂hc/∂x)
  //     dPhi += -2 * r * dhc_dPhi;
  //     dLam += -2 * r * dhc_dLam;
  //   }

  //   return [dPhi, dLam];
  // }
  List<double> gradient(Position position, List<StarInformation> star) {
    // analytic gradient of:
    //   loss = sqrt(1e-4 + (1/n) * Σ (star.ho - asin(hc))^2 )
    // where hc = sin(lat)*sin(dec) + cos(lat)*cos(dec)*cos(gha + long)

    final int n = star.length;
    double sumSq = 0.0;
    // we’ll accumulate dLoss/dlat and dLoss/dlong in these
    double sumLat = 0.0;
    double sumLong = 0.0;

    // first pass: compute diffs and hc values
    List<double> diffs = List.filled(n, 0.0);
    List<double> hcVals = List.filled(n, 0.0);

    for (int i = 0; i < n; i++) {
      final s = star[i];
      // hc
      final double inner = s.gha + position.long;
      final double hc = sin(position.lat) * sin(s.dec) +
          cos(position.lat) * cos(s.dec) * cos(inner);
      hcVals[i] = hc;

      // observed minus computed altitude
      final double hoCalc = asin(hc);
      final double diff = s.ho - hoCalc;
      diffs[i] = diff;

      sumSq += diff * diff;
    }

    // compute loss magnitude
    final double L = sqrt(1e-4 + sumSq / n);

    // second pass: accumulate analytic derivatives
    for (int i = 0; i < n; i++) {
      final s = star[i];
      final diff = diffs[i];
      final hc = hcVals[i];

      // d/dhc (ho - asin(hc)) = - 1/sqrt(1 - hc^2)
      final double inv = 1.0 / sqrt(1 - hc * hc);
      final double common = -diff * inv; // chain for diff * d(asin)/dhc

      // ∂hc/∂lat  = cos(lat)*sin(dec)
      //           - sin(lat)*cos(dec)*cos(gha + long)
      final double dhc_dlat = cos(position.lat) * sin(s.dec) -
          sin(position.lat) * cos(s.dec) * cos(s.gha + position.long);

      // ∂hc/∂long = - cos(lat)*cos(dec)*sin(gha + long)
      final double dhc_dlong =
          -cos(position.lat) * cos(s.dec) * sin(s.gha + position.long);

      sumLat += common * dhc_dlat;
      sumLong += common * dhc_dlong;
    }

    // finalize: ∂loss/∂lat  = (1 / (n * L)) * sumLat
    //           ∂loss/∂long = (1 / (n * L)) * sumLong
    final double tempLat = sumLat / (n * L);
    final double tempLong = sumLong / (n * L);

    return [tempLat, tempLong];
  }

  List<StarInformation> runningFix(
      {required ShipInformation initPosition,
      required List<StarInformation> star,
      required time}) {
    double tempDec, diffLong, distance, midLat, tempGHA;
    /*for (int i = 0; i < star.length; i++) {
      diffDistance = initPosition.speed * (time - star[i].time) / 60;
      diffLat = diffDistance * cos(initPosition.course) / 60;
      midLat = initPosition.lat + 0.5 * radians(diffLat);
      diffLong
    }*/
    for (int i = 0; i < star.length; i++) {
      distance = radians(initPosition.speed * (time - star[i].time) / 60);
      /*tempDec = asin(double.parse((sin(star[i].dec) * cos(distance) +
              cos(star[i].dec) * sin(distance) * cos(initPosition.course))
          .toStringAsFixed(12)));
      diffLong = acos(double.parse(
          ((cos(distance) - sin(star[i].dec) * sin(tempDec)) /
                  (cos(star[i].dec) * cos(tempDec)))
              .toStringAsFixed(10)));
      tempGHA = initPosition.course > 0
          ? (star[i].gha - diffLong) < 0
              ? 2 * pi + star[i].gha - diffLong
              : star[i].gha - diffLong
          : (star[i].gha + diffLong) > 2 * pi
              ? star[i].gha + diffLong - 2 * pi
              : star[i].gha + diffLong;
      star[i] = StarInformation(
          dec: tempDec, gha: tempGHA, ho: star[i].ho, time: time);*/
      double dlat = distance * cos(initPosition.course);
      double decM = star[i].dec + dlat / 2;
      diffLong = distance * sin(initPosition.course) / cos(decM);
      tempDec = star[i].dec + dlat;
      tempGHA = initPosition.course > 0
          ? (star[i].gha - diffLong) < 0
              ? 2 * pi + star[i].gha - diffLong
              : star[i].gha - diffLong
          : (star[i].gha + diffLong) > 2 * pi
              ? star[i].gha + diffLong - 2 * pi
              : star[i].gha + diffLong;
      star[i] = StarInformation(
          dec: tempDec, gha: tempGHA, ho: star[i].ho, time: time);
    }
    return star;
  }

  List<List<StarInformation>> creatBatch(
      List<StarInformation> star, int batchSize) {
    star.shuffle();
    List<List<StarInformation>> batch = [];
    int starIndex = 0;
    int remainder = star.length % batchSize;
    for (int i = 0; i < star.length ~/ batchSize; i++) {
      batch.add(star.sublist(starIndex, starIndex + batchSize));
      starIndex += batchSize;
    }
    if (remainder > 0) {
      batch.add(star.sublist(starIndex));
    }
    return batch;
  }

  Position gradientDescent() {
    ShipInformation ap = initPosition.clone();
    int maxIteration = 1000000;
    gra = [0, 0];
    List<List<StarInformation>> batch;
    if (needRFix == true) {
      star = runningFix(
          initPosition: ap,
          star: star,
          time: runningFixTiem ?? initPosition.time);
    }
    currentIteration = 0;

    while (currentIteration < maxIteration) {
      batch = creatBatch(star, batchSize);
      for (int j = 0; j < batch.length; j++) {
        gra = gradient(ap, batch[j]);
        ap.lat -= learningRate * gra[0];
        ap.long -= learningRate * gra[1];
        // if (ap.lat > 90) {
        //   ap.lat -= pi;
        // }
        // if (ap.lat < -90) {
        //   ap.lat += pi;
        // }
        // if (ap.long > pi) {
        //   ap.long -= 2 * pi;
        // }
        // if (ap.long < -pi) {
        //   ap.long += 2 * pi;
        // }
        historyPosition.add(ap.clone());
        historyGradient.add([gra[0], gra[1]]);
      }
      gra = gradient(ap, star);
      if (sqrt(pow(gra[0], 2) + pow(gra[1], 2)) < threshold) {
        print('gra==0,$currentIteration');
        break;
      }
      currentIteration++;
    }

    return Position(ap.lat, ap.long);
  }

  Position momentum() {
    ShipInformation ap = initPosition.clone();
    int maxIteration = 1000000;
    gra = [0, 0];
    List<double> v = [0, 0];
    List<List<StarInformation>> batch;
    double gamma = 0.9;
    if (needRFix == true) {
      star = runningFix(
          initPosition: ap,
          star: star,
          time: runningFixTiem ?? initPosition.time);
    }
    currentIteration = 0;
    while (currentIteration < maxIteration) {
      batch = creatBatch(star, batchSize);
      for (int j = 0; j < batch.length; j++) {
        gra = gradient(ap, batch[j]);
        v = [
          gamma * v[0] + learningRate * gra[0],
          gamma * v[1] + learningRate * gra[1]
        ];
        ap.lat -= v[0];
        ap.long -= v[1];
        //print(lossFunction(ap, star));
        // if (ap.lat > 90) {
        //   ap.lat -= pi;
        // }
        // if (ap.lat < -90) {
        //   ap.lat += pi;
        // }
        // if (ap.long > pi) {
        //   ap.long -= 2 * pi;
        // }
        // if (ap.long < -pi) {
        //   ap.long += 2 * pi;
        // }
        historyPosition.add(ap.clone());
        historyGradient.add([gra[0], gra[1]]);
      }
      gra = gradient(ap, star);
      if (sqrt(pow(gra[0], 2) + pow(gra[1], 2)) < threshold) {
        print('gra==0,$currentIteration');
        break;
      }
      currentIteration++;
    }
    return Position(ap.lat, ap.long);
  }

  Position adam() {
    ShipInformation ap = initPosition.clone();
    int maxIteration = 1000000;
    gra = [0, 0];
    List<double> m = [0, 0];
    List<double> v = [0, 0];
    List<List<StarInformation>> batch;
    double beta1 = 0.9;
    double beta2 = 0.999;
    double epsilon = 1e-8;
    if (needRFix == true) {
      star = runningFix(
          initPosition: ap,
          star: star,
          time: runningFixTiem ?? initPosition.time);
    }
    currentIteration = 0;
    while (currentIteration < maxIteration) {
      batch = creatBatch(star, batchSize);
      for (int j = 0; j < batch.length; j++) {
        gra = gradient(ap, batch[j]);
        m = [
          beta1 * m[0] + (1 - beta1) * gra[0],
          beta1 * m[1] + (1 - beta1) * gra[1]
        ];
        v = [
          beta2 * v[0] + (1 - beta2) * pow(gra[0], 2),
          beta2 * v[1] + (1 - beta2) * pow(gra[1], 2)
        ];
        ap.lat -= learningRate * m[0] / (sqrt(v[0]) + epsilon);
        ap.long -= learningRate * m[1] / (sqrt(v[1]) + epsilon);
        //print(lossFunction(ap, star));
        // if (ap.lat > 90) {
        //   ap.lat -= pi;
        // }
        // if (ap.lat < -90) {
        //   ap.lat += pi;
        // }
        // if (ap.long > pi) {
        //   ap.long -= 2 * pi;
        // }
        // if (ap.long < -pi) {
        //   ap.long += 2 * pi;
        // }
        historyPosition.add(ap.clone());
        historyGradient.add([gra[0], gra[1]]);
      }
      gra = gradient(ap, star);
      if (sqrt(pow(gra[0], 2) + pow(gra[1], 2)) < threshold) {
        print('gra==0,$currentIteration');
        break;
      }
      currentIteration++;
    }
    return Position(ap.lat, ap.long);
  }
}

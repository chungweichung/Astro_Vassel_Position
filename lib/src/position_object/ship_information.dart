import 'package:navigation/navigation.dart';

class ShipInformation extends Position {
  double speed, course, time;

  ShipInformation({
    required double lat,
    required double long,
    required this.speed,
    required this.course,
    required this.time,
  }) : super(lat, long); // ← 這裡用位置參數呼叫父類
  @override
  ShipInformation clone() {
    return ShipInformation(
        lat: this.lat,
        long: this.long,
        speed: this.speed,
        course: this.course,
        time: this.time);
  }
}

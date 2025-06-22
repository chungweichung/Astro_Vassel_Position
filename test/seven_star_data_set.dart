import 'package:celestial_position_solver/celestial_position_solver.dart';

import 'package:vector_math/vector_math.dart';

List<ShipInformation> sevenDr = [
  ShipInformation(
      lat: radians(27.75),
      long: radians(150.3),
      speed: 30,
      course: radians(290),
      time: 6.22361111)
];

List<List<StarInformation>> sevenStar = [
  [
    StarInformation(
        dec: radians(27.987416666),
        gha: radians(273.35575),
        ho: radians(34.416666666666666666666),
        time: 6.075),
    StarInformation(
        dec: radians(5.1863),
        gha: radians(275.48575),
        ho: radians(23.816666666666666666666),
        time: 6.11444444444444),
    StarInformation(
        dec: radians(46.044883333),
        gha: radians(311.12125),
        ho: radians(12.33333333333333333333333),
        time: 6.12361111111111),
    StarInformation(
        dec: radians(11.88786666666666),
        gha: radians(238.7365),
        ho: radians(58.5333333333333333333333),
        time: 6.1475),
    StarInformation(
        dec: radians(-11.235),
        gha: radians(189.9885),
        ho: radians(46.6666666666666666666666),
        time: 6.17694444444444),
    StarInformation(
        dec: radians(19.0983),
        gha: radians(177.65225),
        ho: radians(59.6666666666666666666666),
        time: 6.1933333333),
    StarInformation(
        dec: radians(38.83566666666666),
        gha: radians(112.9145),
        ho: radians(14.0),
        time: 6.22361111111),
  ],
  [
    StarInformation(
        dec: radians(27.987416666),
        gha: radians(273.35575),
        ho: radians(34.416666666666666666666),
        time: 6.075),
    StarInformation(
        dec: radians(5.1863),
        gha: radians(275.48575),
        ho: radians(23.816666666666666666666),
        time: 6.11444444444444),
    StarInformation(
        dec: radians(46.044883333),
        gha: radians(311.12125),
        ho: radians(12.33333333333333333333333),
        time: 6.12361111111111),
    StarInformation(
        dec: radians(11.88786666666666),
        gha: radians(238.7365),
        ho: radians(58.5333333333333333333333),
        time: 6.1475),
    StarInformation(
        dec: radians(-11.235),
        gha: radians(189.9885),
        ho: radians(46.6666666666666666666666),
        time: 6.17694444444444),
  ],
  [
    StarInformation(
        dec: radians(27.987416666),
        gha: radians(273.35575),
        ho: radians(34.416666666666666666666),
        time: 6.075),
    StarInformation(
        dec: radians(5.1863),
        gha: radians(275.48575),
        ho: radians(23.816666666666666666666),
        time: 6.11444444444444),
    StarInformation(
        dec: radians(46.044883333),
        gha: radians(311.12125),
        ho: radians(12.33333333333333333333333),
        time: 6.12361111111111),
    StarInformation(
        dec: radians(11.88786666666666),
        gha: radians(238.7365),
        ho: radians(58.5333333333333333333333),
        time: 6.1475),
  ],
];

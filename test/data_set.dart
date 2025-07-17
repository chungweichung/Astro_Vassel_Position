import 'package:celestial_position_solver/celestial_position_solver.dart';

import 'package:vector_math/vector_math.dart';

List<ShipInformation> dr = [
  // ShipInformation(
  //     lat: radians(-20),
  //     long: radians(-120),
  //     speed: 0,
  //     course: radians(0),
  //     time: 15.31722222222),
  // ShipInformation(
  //     lat: radians(35),
  //     long: radians(-65),
  //     speed: 0,
  //     course: radians(0),
  //     time: 12.21666666666666666667),
  // ShipInformation(
  //     lat: radians(25),
  //     long: radians(-157.1666666667),
  //     speed: 0,
  //     course: radians(0),
  //     time: 20.190555556), //Bowdich(2002). 0
  // ShipInformation(
  //     lat: radians(38.5),
  //     long: radians(-73.7166666667),
  //     speed: 6,
  //     course: radians(49),
  //     time: 13.02416666667), //Gibson. 1
  // ShipInformation(
  //     lat: radians(20.29),
  //     long: radians(-50.1233333333),
  //     speed: 18,
  //     course: radians(127),
  //     time: 12.4), //Bowidich(1984). 2
  // ShipInformation(
  //     lat: radians(45.16667),
  //     long: radians(-30.25),
  //     course: radians(180),
  //     speed: 20,
  //     time: 6.266666666666667), //pub 229. 3
  ShipInformation(
      lat: radians(-20.916666666),
      long: radians(86.75),
      speed: 18,
      course: radians(300),
      time: 12.416666667), //AMN. 4
  // ShipInformation(
  //     lat: radians(-35.0),
  //     long: radians(5.0),
  //     speed: 18,
  //     course: radians(220),
  //     time: 18.2), //Tsou 2015 5
  ShipInformation(
      lat: radians(27.75),
      long: radians(150.3),
      speed: 30,
      course: radians(290),
      time: 6.22361111), //PSO 6
  // ShipInformation(
  //     lat: radians(40), long: radians(-55), speed: 0, course: 0, time: 0),
  ShipInformation(
      lat: radians(41 + 34.8 / 60),
      long: radians(-17 - 0.5 / 60),
      speed: 6.8,
      course: radians(288),
      time: 20 + 3 / 60 + 58 / 3600), //Dutt(2010). 7
  ShipInformation(
      lat: radians(77 + 43 / 60),
      long: radians(-10 - 12 / 60),
      speed: 0,
      course: 0,
      time: 5.80472222222), //pub229 v6 8
  // ShipInformation(
  //     lat: radians(30), long: radians(-60), speed: 0, course: 0, time: 23.25),
  //Lusic. 9

  // ShipInformation(
  //     lat: radians(42 + 40 / 60),
  //     long: radians(-135 - 25 / 60),
  //     speed: 20,
  //     course: radians(150),
  //     time: 18 + 1 / 60), //泰亨 10
  ShipInformation(
      lat: radians(27),
      long: radians(175),
      speed: 0,
      course: 0,
      time: 12) // myself 11
];
List<List<StarInformation>> star = [
  // [
  //   StarInformation(
  //       dec: radians(0.49833333333333333),
  //       gha: radians(47.7533333333333333),
  //       ho: radians(14.25166666666666666),
  //       time: 15.3005555555555556),
  //   StarInformation(
  //       dec: radians(0.4983333333333333),
  //       gha: radians(48.0033333333333333),
  //       ho: radians(14.475),
  //       time: 15.31722222222),
  //   // StarInformation(
  //   //     dec: radians(0.496666666666),
  //   //     gha: radians(46.25333333333333333),
  //   //     ho: radians(12.90333333333333333),
  //   //     time: 15.333888888888889)
  // ],
  // [
  //   StarInformation(
  //       dec: radians(16 + 3.6 / 60),
  //       gha: radians(359 + 38.9 / 60),
  //       ho: radians(15 + 51.9 / 60),
  //       time: 12.2083333333333),
  //   StarInformation(
  //       dec: radians(16 + 3.6 / 60),
  //       gha: radians(359 + 46.4 / 60),
  //       ho: radians(15 + 57.5 / 60),
  //       time: 12.216666666666666666666666666667)
  // ],
  // [
  //   StarInformation(
  //       dec: radians(74.1766666667),
  //       gha: radians(103.716666667),
  //       ho: radians(47.22666666667),
  //       time: 20.12861111),
  //   StarInformation(
  //       dec: radians(-11.14),
  //       gha: radians(126.095),
  //       ho: radians(32.478333333),
  //       time: 20.190555556)
  // ], //Bowdich(2002). 0
  // [
  //   StarInformation(
  //       dec: radians(22.361666667),
  //       gha: radians(46.973333333),
  //       ho: radians(62.125),
  //       time: 10.1),
  //   StarInformation(
  //       dec: radians(22.37666666667),
  //       gha: radians(90.83166666666),
  //       ho: radians(68.3283333333),
  //       time: 13.02416667)
  // ], //Gibson. 1
  // [
  //   StarInformation(
  //       dec: radians(21.885),
  //       gha: radians(49.426666666),
  //       ho: radians(88.15333333),
  //       time: 12.2541666667),
  //   StarInformation(
  //       dec: radians(21.885),
  //       gha: radians(51.6683333333),
  //       ho: radians(87.713333333),
  //       time: 12.40361111)
  // ], //Bowidich(1984). 2
  // [
  //   StarInformation(
  //       dec: radians(45.181666666667),
  //       gha: radians(327.191666666667),
  //       ho: radians(46.59333333333),
  //       time: 6.151111111111111),
  //   StarInformation(
  //       dec: radians(-26.375),
  //       gha: radians(31.12666666667),
  //       ho: radians(18.7816666666667),
  //       time: 6.201388888889),
  //   StarInformation(
  //       dec: radians(38.7533333333),
  //       gha: radians(360.0566666666),
  //       ho: radians(66.811666666),
  //       time: 6.267222222)
  // ], //pub 229. 3
  [
    StarInformation(
        dec: radians(-20.098333333),
        gha: radians(272.2516666666),
        ho: radians(88.7016666666),
        time: 12.33388889),
    StarInformation(
        dec: radians(-20.0966666666),
        gha: radians(273.251666666666),
        ho: radians(89.0983333333),
        time: 12.40055556),
    StarInformation(
        dec: radians(-20.096666666666),
        gha: radians(274.25),
        ho: radians(88.698333333),
        time: 12.46722222)
  ], //AMN. 4
  // [
  //   StarInformation(
  //       dec: radians(8.856666666),
  //       gha: radians(325.11),
  //       ho: radians(37.883333333),
  //       time: 18.00),
  //   StarInformation(
  //       dec: radians(-29.6516666666666),
  //       gha: radians(279.40333333),
  //       ho: radians(27.9),
  //       time: 18.06666667),
  //   StarInformation(
  //       dec: radians(-57.26333333),
  //       gha: radians(240.3616666666),
  //       ho: radians(17.775),
  //       time: 18.133333),
  //   StarInformation(
  //       dec: radians(12.56833333),
  //       gha: radians(2.08),
  //       ho: radians(41.5916666666),
  //       time: 18.2)
  // ], //Tsou 2015 5
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
  ], //PSO 6
  // [
  //   StarInformation(
  //       dec: radians(-23 - 43.9 / 60),
  //       gha: radians(358 + 52.9 / 60),
  //       ho: radians(1 + 1.7 / 60),
  //       time: 0),
  //   StarInformation(
  //       dec: radians(-8 - 45.3 / 60),
  //       gha: radians(135 + 21.6 / 60),
  //       ho: radians(4 + 9 / 60),
  //       time: 0),
  //   StarInformation(
  //       dec: radians(-36 - 28.5 / 60),
  //       gha: radians(65 + 32.3 / 60),
  //       ho: radians(7 + 43.0 / 60),
  //       time: 0)
  // ],

  [
    StarInformation(
        dec: radians(49 + 25.7 / 60),
        gha: radians(3 + 14.2 / 60),
        ho: radians(77 + 34.9 / 60),
        time: 20.0488888888888888889),
    StarInformation(
        dec: radians(45 + 58.4 / 60),
        gha: radians(131 + 24.8 / 60),
        ho: radians(15 + 19.3 / 60),
        time: 20.066111111111)
  ], //Dutton 7
  [
    StarInformation(
        dec: radians(12 + 7.4 / 60),
        gha: radians(286 + 26.4 / 60),
        ho: radians(13 + 10.1 / 60),
        time: 5.80472222222),
    StarInformation(
        dec: radians(38 + 45.4 / 60),
        gha: radians(159 + 8.7 / 60),
        ho: radians(28 + 0.3 / 60),
        time: 5.80472222222),
    StarInformation(
        dec: radians(23 + 19 / 60),
        gha: radians(46 + 45.5 / 60),
        ho: radians(32 + 56.1 / 60),
        time: 5.80472222222)
  ], //pub229 v6 8

  // [
  //   // Deneb
  //   StarInformation(
  //     dec: radians(45 + 20.5 / 60), // 45°20.5′ N
  //     gha: radians(19 + 2.9 / 60), // 019°02.9′
  //     ho: radians(54 + 37.5 / 60), // 54°37.5′
  //     time: 23.25, // 23:15 → 23 + 15/60
  //   ),
  //   // Altair
  //   StarInformation(
  //     dec: radians(8 + 54.9 / 60), // 08°54.9′ N
  //     gha: radians(31 + 39.4 / 60), // 031°39.4′
  //     ho: radians(56 + 8.9 / 60), // 56°08.9′
  //     time: 23.25,
  //   ),
  //   // Nunki
  //   StarInformation(
  //     dec: radians(-(26 + 16.4 / 60)), // 26°16.4′ S
  //     gha: radians(45 + 29.1 / 60), // 045°29.1′
  //     ho: radians(32 + 2.1 / 60), // 32°02.1′
  //     time: 23.25,
  //   ),
  //   // Antares
  //   StarInformation(
  //     dec: radians(-(26 + 27.8 / 60)), // 26°27.8′ S
  //     gha: radians(81 + 57.2 / 60), // 081°57.2′
  //     ho: radians(29 + 45.1 / 60), // 29°45.1′
  //     time: 23.25,
  //   ),
  //   // Arcturus
  //   StarInformation(
  //     dec: radians(19 + 6.4 / 60), // 19°06.4′ N
  //     gha: radians(115 + 27.4 / 60), // 115°27.4′
  //     ho: radians(38 + 52.7 / 60), // 38°52.7′
  //     time: 23.25,
  //   ),
  //   // Alkaid
  //   StarInformation(
  //     dec: radians(49 + 14.5 / 60), // 49°14.5′ N
  //     gha: radians(122 + 31.0 / 60), // 122°31.0′
  //     ho: radians(39 + 46.0 / 60), // 39°46.0′
  //     time: 23.25,
  //   ),
  //   // Kochab
  //   StarInformation(
  //     dec: radians(74 + 5.9 / 60), // 74°05.9′ N
  //     gha: radians(106 + 53.6 / 60), // 106°53.6′
  //     ho: radians(40 + 1.0 / 60), // 40°01.0′
  //     time: 23.25,
  //   ),
  // ], //Lusic. 9
  // [
  //   // Dubhe
  //   StarInformation(
  //     dec: radians(61 + 38.4 / 60), // 61°38.4′ N
  //     gha: radians(49 + 17.4 / 60), // 049°17.4′
  //     ho: radians(38 + 20.1 / 60), // 38°20.1′
  //     time: 17 + 40.0 / 60 + 22.0 / 3600, // ZT 17-40-22 → 17.6727777778 h
  //   ),
  //   // Regulus
  //   StarInformation(
  //     dec: radians(11 + 52.1 / 60), // 11°52.1′ N
  //     gha: radians(64 + 8.2 / 60), // 064°08.2′
  //     ho: radians(21 + 34.8 / 60), // 21°34.8′
  //     time: 17 + 44.0 / 60 + 14.0 / 3600, // ZT 17-44-14 → 17.7372222222 h
  //   ),
  //   // Procyon
  //   StarInformation(
  //     dec: radians(5 + 10.3 / 60), // 05°10.3′ N
  //     gha: radians(102 + 25.3 / 60), // 102°25.3′
  //     ho: radians(42 + 14.7 / 60), // 42°14.7′
  //     time: 17 + 48.0 / 60 + 17.0 / 3600, // ZT 17-48-17 → 17.8047222222 h
  //   ),
  //   // Sirius
  //   StarInformation(
  //     dec: radians(-(16 + 44.7 / 60)), // 16°44.7′ S
  //     gha: radians(116 + 47.9 / 60), // 116°47.9′
  //     ho: radians(27 + 56.0 / 60), // 27°56.0′
  //     time: 17 + 51.0 / 60 + 28.0 / 3600, // ZT 17-51-28 → 17.8577777778 h
  //   ),
  //   // Rigel
  //   StarInformation(
  //     dec: radians(-(8 + 10.9 / 60)), // 08°10.9′ S
  //     gha: radians(140 + 10.0 / 60), // 140°10.0′
  //     ho: radians(38 + 50.2 / 60), // 38°50.2′
  //     time: 17 + 54.0 / 60 + 24.0 / 3600, // ZT 17-54-24 → 17.9066666667 h
  //   ),
  //   // Hamal
  //   StarInformation(
  //     dec: radians(23 + 33.4 / 60), // 23°33.4′ N
  //     gha: radians(187 + 53.8 / 60), // 187°53.8′
  //     ho: radians(42 + 59.4 / 60), // 42°59.4′
  //     time: 17 + 58.0 / 60 + 6.0 / 3600, // ZT 17-58-06 → 17.9683333333 h
  //   ),
  //   // Schedar
  //   StarInformation(
  //     dec: radians(56 + 39.0 / 60), // 56°39.0′ N
  //     gha: radians(210 + 25.3 / 60), // 210°25.3′
  //     ho: radians(42 + 17.0 / 60), // 42°17.0′
  //     time: 18 + 1.0 / 60 + 32.0 / 3600, // ZT 18-01-32 → 18.0255555556 h
  //   ),
  // ], //泰亨 10
  [
    // Alphecca
    StarInformation(
      dec: radians(26 + 37.9 / 60), // 26°37.9′ N
      gha: radians(245 + 33.7 / 60), // 245°33.7′
      ho: radians(34 + 12.0 / 60), // 34°12.0′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
    // Arcturus
    StarInformation(
      dec: radians(19 + 3.1 / 60), // 19°03.1′ N
      gha: radians(265 + 18.0 / 60), // 265°18.0′
      ho: radians(13 + 31.9 / 60), // 14°31.9′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
    // Vega
    StarInformation(
      dec: radians(-(16 + 8.9 / 60)), // 16°08.9′ S
      gha: radians(256 + 26.0 / 60), // 256°26.0′
      ho: radians(4 + 55.5 / 60), // 04°55.5′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
    // Shaula
    StarInformation(
      dec: radians(-(37 + 7.4 / 60)), // 37°07.4′ S
      gha: radians(215 + 40.0 / 60), // 215°40.0′
      ho: radians(17 + 38.3 / 60), // 17°38.3′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
    // Shaula
    StarInformation(
      dec: radians(-(29 + 29.0 / 60)), // 29°29.0′ S
      gha: radians(134 + 44.3 / 60), // 134°44.3′
      ho: radians(17 + 51.2 / 60), // 17°51.2′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
    // Diphda
    StarInformation(
      dec: radians(-(17 + 50.6 / 60)), // 17°50.6′ S
      gha: radians(108 + 17.3 / 60), // 108°17.3′
      ho: radians(6 + 17.0 / 60), // 06°17.0′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
    // Kochab
    StarInformation(
      dec: radians(74 + 3.3 / 60), // 74°03.3′ N
      gha: radians(256 + 50.0 / 60), // 256°50.0′
      ho: radians(30 + 14.4 / 60), // 30°14.4′
      time: 12 + 0.0 / 60 + 0.0 / 3600, // ZT 12-00-00 → 12.0 h
    ),
  ] //myelf 11
];

void main() {
  print(star.length);
  print(dr.length);
}

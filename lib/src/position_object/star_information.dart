class StarInformation {
  double dec, gha, ho, time;
  StarInformation(
      {required this.dec,
      required this.gha,
      required this.ho,
      required this.time});

  StarInformation clone() {
    return StarInformation(
        dec: this.dec, gha: this.gha, ho: this.ho, time: this.time);
  }

  Map<String, dynamic> toJson() =>
      {'dec': dec, 'gha': gha, 'ho': ho, 'time': time};

  factory StarInformation.fromJson(Map<String, dynamic> json) =>
      StarInformation(
          dec: json['dec'],
          gha: json['gha'],
          ho: json['ho'],
          time: json['time']);
}

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
}

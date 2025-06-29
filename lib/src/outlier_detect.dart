int findUpperBound(int idx, List<int> rowstart) {
  int low = 0;
  int high = rowstart.length - 1;
  while (low < high) {
    int mid = ((low + high) ~/ 2) + 1;
    if (rowstart[mid] <= idx) {
      low = mid;
    } else {
      high = mid - 1;
    }
  }
  return low;
}

List<int> buildRowStart(int n) {
  //n denotes the number of stat -1
  List<int> rowStart = [0];
  for (int i = 1; i < n; i++) {
    rowStart.add(rowStart[i - 1] + (n - i));
  }
  return rowStart;
}

List<int> getStarIndex(int idx, int n) {
  List<int> rowstart = buildRowStart(n);
  int i = findUpperBound(idx, rowstart);
  int offset = idx - rowstart[i];
  int j = i + 1 + offset;

  return [i + 1, j + 1];
}

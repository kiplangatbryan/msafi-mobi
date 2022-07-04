double sizeCompute({
  required double small,
  required double large,
  required double width,
}) {
  final maxWidth = width;
  if (maxWidth < 400) {
    return small;
  }
  return large;
}

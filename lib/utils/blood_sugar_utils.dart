class BloodSugarUtils {
  static bool isInTargetRange(double reading, double min, double max) {
    return reading >= min && reading <= max;
  }

  static double calculateProgress(double reading, double min, double max) {
    if (max == min) return 0.0;
    double progress = (reading - min) / (max - min);
    return progress.clamp(0.0, 1.0);
  }

  static double? safeReduce(List<double> values, double Function(double, double) operation) {
    return values.isEmpty ? null : values.reduce(operation);
  }

  static double? calculateAverage(List<double> readings) {
    if (readings.isEmpty) return null;
    return readings.reduce((a, b) => a + b) / readings.length;
  }
}

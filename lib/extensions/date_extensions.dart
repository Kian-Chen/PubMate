// lib/extensions/date_extensions.dart

extension DateTimeExtensions on DateTime {
  String toShortDateString() {
    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  String toReadableString() {
    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}

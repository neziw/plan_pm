extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized).join(' ');
}
// Ta funkcja dodaje capitalize - zmienia pierwszą literkę na wielką

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(days: (day - this.weekday) % DateTime.daysPerWeek),
    );
  }
}
// Ta funkcja umozliwia dostanie dnia następnego tygodnia
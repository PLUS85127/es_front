class StudyDateHelper {
  static bool isTodayInRecord(DateTime start, DateTime end) {
    final now = DateTime.now();

    final t = DateTime(now.year, now.month, now.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    return (t.isAtSameMomentAs(s) || t.isAfter(s)) &&
        (t.isAtSameMomentAs(e) || t.isBefore(e));
  }

  static String getCurrentQuarterlyId() {
    final now = DateTime.now();
    final int quarter = ((now.month - 1) / 3).floor() + 1;
    return "${now.year}-0$quarter";
  }

  static String getDayIdByDate(DateTime date) {
    Map<int, String> map = {
      6: "01",
      7: "02",
      1: "03",
      2: "04",
      3: "05",
      4: "06",
      5: "07",
    };
    return map[date.weekday] ?? "01";
  }
}

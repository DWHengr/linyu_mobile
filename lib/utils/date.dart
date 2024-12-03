class DateUtil {
  static String formatTime(dynamic input) {
    if (input == null || (input is String && input.isEmpty)) {
      return '';
    }
    DateTime? date;
    if (input is int) {
      date = DateTime.fromMillisecondsSinceEpoch(input);
    } else if (input is String) {
      try {
        date = DateTime.parse(input);
      } catch (e) {
        return '';
      }
    } else {
      return '';
    }
    final now = DateTime.now();
    final diff = now.difference(date);
    const oneDay = Duration(days: 1);
    const oneWeek = Duration(days: 7);
    final isYesterday = now.day - date.day == 1 &&
        now.month == date.month &&
        now.year == date.year;

    if (diff < oneDay && !isYesterday) {
      final hour = date.hour;
      final minute = date.minute;
      final period = hour < 12 ? '上午' : '下午';
      final formattedMinute = minute < 10 ? '0$minute' : minute.toString();
      return '$period ${hour % 12 == 0 ? 12 : hour % 12}:$formattedMinute';
    } else if (isYesterday) {
      final hour = date.hour;
      final minute = date.minute;
      final formattedMinute = minute < 10 ? '0$minute' : minute.toString();
      return '昨天 $hour:$formattedMinute';
    } else if (diff < oneWeek) {
      const daysOfWeek = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
      final dayOfWeek = daysOfWeek[date.weekday % 7];
      final hour = date.hour;
      final minute = date.minute;
      final formattedMinute = minute < 10 ? '0$minute' : minute.toString();
      return '$dayOfWeek $hour:$formattedMinute';
    } else {
      final year = date.year;
      final month = date.month < 10 ? '0${date.month}' : date.month.toString();
      final day = date.day < 10 ? '0${date.day}' : date.day.toString();
      final hour = date.hour;
      final minute =
          date.minute < 10 ? '0${date.minute}' : date.minute.toString();
      return '$year-$month-$day $hour:$minute';
    }
  }

  static String getYearDayMonth(dynamic date) {
    if (date == null || date == '') {
      return '';
    }
    DateTime initDate = DateTime.now();
    if (date is int) {
      initDate = DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is String) {
      initDate = DateTime.parse(date);
    }
    int year = initDate.year;
    int day = initDate.day;
    int month = initDate.month;
    return '$year-$month-$day';
  }

  static String calculateAge(dynamic birthDate) {
    if (birthDate == null || birthDate == '') {
      return '';
    }
    DateTime today = DateTime.now();
    DateTime birth = today;
    if (birthDate is int) {
      birth = DateTime.fromMillisecondsSinceEpoch(birthDate);
    } else if (birthDate is String) {
      birth = DateTime.parse(birthDate);
    }
    int age = today.year - birth.year;
    int monthDifference = today.month - birth.month;
    if (monthDifference < 0 ||
        (monthDifference == 0 && today.day < birth.day)) {
      age--;
    }
    return '$age岁';
  }

  static String formatTimingTime(dynamic time) {
    if (time == null || time == '') {
      return '';
    }
    int totalSeconds;
    if (time is int) {
      totalSeconds = time;
    } else if (time is String) {
      totalSeconds = int.tryParse(time) ?? 0;
    } else {
      return '';
    }
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}

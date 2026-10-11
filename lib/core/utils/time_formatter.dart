String forceEnglishTime(String time) {
  if (time.isEmpty) return time;
  const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  var result = time;
  for (int i = 0; i < 10; i++) {
    result = result.replaceAll(arabicDigits[i], englishDigits[i]);
  }
  result = result.replaceAll('ص', 'AM').replaceAll('م', 'PM');
  return result;
}

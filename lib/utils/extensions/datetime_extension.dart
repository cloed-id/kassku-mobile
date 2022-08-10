import 'package:easy_localization/easy_localization.dart';

extension DateFormatExtension on DateTime {
  String get format => DateFormat('dd MMMM yyyy', 'id').format(this);
}

import 'package:intl/intl.dart';

/// Currency format for Rupiah ( IDR )
NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'id',
  decimalDigits: 0,
  name: 'Rp. ',
  symbol: 'Rp. ',
);

/// Currency format for Rupiah ( IDR )
NumberFormat currencyFormatterNoLeading =
    NumberFormat.currency(locale: 'id', decimalDigits: 0, name: '', symbol: '');

String roleToDisplay(String role) {
  switch (role) {
    case 'admin':
      return 'Admin';
    case 'head':
      return 'Kepala';
    case 'finance':
      return 'Bendahara';
    case 'observer':
      return 'Pengamat';
    default:
      return 'Lainnya';
  }
}

String listPermissionsToDisplay(List<String> permissions) {
  if (permissions.isEmpty) {
    return '';
  }

  final list = <String>[];

  for (final element in permissions) {
    if (element == 'create_income') {
      list.add('Pemasukan');
    } else if (element == 'create_expense') {
      list.add('Pengeluaran');
    }
  }

  return list.join(', ');
}

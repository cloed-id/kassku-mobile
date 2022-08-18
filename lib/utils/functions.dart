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

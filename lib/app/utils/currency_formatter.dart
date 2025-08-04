import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String toRupiah(num number) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(number);
  }
}

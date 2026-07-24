import 'package:intl/intl.dart';

final _rupiahFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

final _tanggalFormat = DateFormat('dd/MM/yyyy');
final _tanggalPendek = DateFormat('dd/MM');
final _tanggalLengkap = DateFormat('dd MMMM yyyy', 'id_ID');

String formatRupiah(double nominal) => _rupiahFormat.format(nominal);

String formatTanggal(DateTime tanggal) => _tanggalFormat.format(tanggal);

String formatTanggalPendek(DateTime tanggal) => _tanggalPendek.format(tanggal);

String formatTanggalLengkap(DateTime tanggal) =>
    _tanggalLengkap.format(tanggal);

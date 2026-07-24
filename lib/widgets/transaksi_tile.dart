import 'package:flutter/material.dart';
import '../data/database.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../utils/kategori_helper.dart';

class TransaksiTile extends StatelessWidget {
  final TransaksiData transaksi;
  final String namaKategori;
  final VoidCallback onTap;

  const TransaksiTile({
    super.key,
    required this.transaksi,
    required this.namaKategori,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nominal = transaksi.pengeluaran;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFEBE6D8),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: warnaKategori(transaksi.kategoriId),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatTanggalPendek(transaksi.tanggal),
              style: AppTypography.monoData.copyWith(
                color: AppColors.slateGrey,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaKategori,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkNavy,
                      fontSize: 14,
                    ),
                  ),
                  if (transaksi.uraian.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      transaksi.uraian,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.slateGrey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '-${formatRupiah(nominal)}',
              style: AppTypography.monoData.copyWith(
                color: AppColors.signalCoral,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

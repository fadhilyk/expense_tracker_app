import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../data/database.dart';
import '../utils/formatters.dart';

class ExcelExportService {
  static Future<File> generateXlsx({
    required double saldoAwalInput,
    required double saldoMulai,
    required HistorySaldoAkhirData? lastHistory,
    required List<TransaksiData> transaksiList,
    required Map<int, String> kategoriMap,
    required double totalPemasukan,
    required double totalPengeluaran,
    required double saldoAkhir,
  }) async {
    final excel = Excel.createExcel();
    final sheetName = 'Laporan Pengeluaran';
    
    // Rename default sheet or create new one
    excel.rename(excel.getDefaultSheet()!, sheetName);
    final sheet = excel[sheetName];

    // Colors
    final navyColor = ExcelColor.fromHexString('FF1B3A4B');
    final whiteColor = ExcelColor.fromHexString('FFFFFFFF');
    final greenBgColor = ExcelColor.fromHexString('FFD1EAE0');
    final yellowBgColor = ExcelColor.fromHexString('FFFCEFCB');

    // Text style
    final headerStyle = CellStyle(
      backgroundColorHex: navyColor,
      fontColorHex: whiteColor,
      fontFamily: getFontFamily(FontFamily.Calibri),
      horizontalAlign: HorizontalAlign.Center,
      bold: true,
    );

    final startRowStyle = CellStyle(
      backgroundColorHex: greenBgColor,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    final totalRowStyle = CellStyle(
      backgroundColorHex: yellowBgColor,
      fontFamily: getFontFamily(FontFamily.Calibri),
      bold: true,
    );

    final defaultStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    // Headers
    final headers = [
      'No',
      'Tanggal',
      'Keterangan',
      'Uraian',
      'Pemasukan',
      'Pengeluaran',
      'Saldo'
    ];

    for (var col = 0; col < headers.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = TextCellValue(headers[col]);
      cell.cellStyle = headerStyle;
    }

    final dateFormat = DateFormat('dd/MM/yyyy');
    final List<List<CellValue>> rows = [];
    final List<CellStyle> rowStyles = [];

    print('DEBUG_EXPORT: 3. ExcelService.generateXlsx - lastHistory is null? ${lastHistory == null}');
    // 2. Baris "SALDO AKHIR PER [tanggal periode sebelumnya]"
    if (lastHistory != null) {
      print('DEBUG_EXPORT: 3b. ExcelService.generateXlsx - lastHistory values: tanggal: ${lastHistory.tanggalPeriode}, saldo: ${lastHistory.saldoAkhir}');
      final historyDateStr = formatTanggalLengkap(lastHistory.tanggalPeriode).toUpperCase();
      rows.add([
        IntCellValue(1),
        TextCellValue('-'),
        TextCellValue('SALDO AKHIR PER $historyDateStr'),
        TextCellValue('Referensi Saldo Akhir Lalu'),
        DoubleCellValue(0.0),
        DoubleCellValue(0.0),
        DoubleCellValue(lastHistory.saldoAkhir),
      ]);
      rowStyles.add(defaultStyle);
    }

    // 3. Baris "PEMASUKAN DARI FINANCE"
    final financeRowNo = lastHistory != null ? 2 : 1;
    rows.add([
      IntCellValue(financeRowNo),
      TextCellValue('-'),
      TextCellValue('PEMASUKAN DARI FINANCE'),
      TextCellValue('Saldo Awal Periode'),
      DoubleCellValue(saldoAwalInput),
      DoubleCellValue(0.0),
      DoubleCellValue(saldoMulai),
    ]);
    rowStyles.add(startRowStyle);

    // 4. Baris-baris transaksi
    for (var i = 0; i < transaksiList.length; i++) {
      final t = transaksiList[i];
      final no = (lastHistory != null ? 3 : 2) + i;
      final katNama = kategoriMap[t.kategoriId] ?? '-';
      rows.add([
        IntCellValue(no),
        TextCellValue(dateFormat.format(t.tanggal)),
        TextCellValue(katNama),
        TextCellValue(t.uraian),
        DoubleCellValue(t.pemasukan),
        DoubleCellValue(t.pengeluaran),
        DoubleCellValue(t.saldoSetelah),
      ]);
      rowStyles.add(defaultStyle);
    }

    // Write all rows
    for (var r = 0; r < rows.length; r++) {
      final rowData = rows[r];
      final style = rowStyles[r];
      final rowIndex = r + 1; // row 0 is header
      for (var col = 0; col < rowData.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex));
        cell.value = rowData[col];
        cell.cellStyle = style;
      }
    }

    // 5. Totals Row
    final totalRowIndex = rows.length + 1;
    final lastDate = transaksiList.isNotEmpty ? transaksiList.last.tanggal : DateTime.now();
    final totalRowDateStr = formatTanggalLengkap(lastDate).toUpperCase();
    final totalRowData = [
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('SALDO AKHIR PER $totalRowDateStr'),
      TextCellValue(''),
      DoubleCellValue(saldoAwalInput + totalPemasukan),
      DoubleCellValue(totalPengeluaran),
      DoubleCellValue(saldoAkhir),
    ];

    for (var col = 0; col < totalRowData.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: totalRowIndex));
      cell.value = totalRowData[col];
      cell.cellStyle = totalRowStyle;
    }

    // Auto-fit columns
    sheet.setColumnWidth(0, 8.0);  // No
    sheet.setColumnWidth(1, 15.0); // Tanggal
    sheet.setColumnWidth(2, 25.0); // Keterangan
    sheet.setColumnWidth(3, 30.0); // Uraian
    sheet.setColumnWidth(4, 18.0); // Pemasukan
    sheet.setColumnWidth(5, 18.0); // Pengeluaran
    sheet.setColumnWidth(6, 20.0); // Saldo

    // Write to a temporary file
    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Gagal mengencode file Excel');
    }

    final tempDir = await getTemporaryDirectory();
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final fileName = 'Laporan_Pengeluaran_$dateStr.xlsx';
    final file = File(p.join(tempDir.path, fileName));
    
    await file.writeAsBytes(bytes);
    return file;
  }
}

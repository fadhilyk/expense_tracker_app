import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../data/database.dart';

class ExcelExportService {
  static Future<File> generateXlsx({
    required double saldoMulai,
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

    // Row 2: Saldo Awal (Pemasukan dari Finance)
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    final saldoAwalRow = [
      IntCellValue(1),
      TextCellValue('-'),
      TextCellValue('PEMASUKAN DARI FINANCE'),
      TextCellValue('Saldo Awal Periode'),
      DoubleCellValue(saldoMulai),
      DoubleCellValue(0.0),
      DoubleCellValue(saldoMulai),
    ];

    for (var col = 0; col < saldoAwalRow.length; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1));
      cell.value = saldoAwalRow[col];
      cell.cellStyle = startRowStyle;
    }

    // Transactions rows
    for (var i = 0; i < transaksiList.length; i++) {
      final t = transaksiList[i];
      final no = i + 2;
      final katNama = kategoriMap[t.kategoriId] ?? '-';
      
      final rowData = [
        IntCellValue(no),
        TextCellValue(dateFormat.format(t.tanggal)),
        TextCellValue(katNama),
        TextCellValue(t.uraian),
        DoubleCellValue(t.pemasukan),
        DoubleCellValue(t.pengeluaran),
        DoubleCellValue(t.saldoSetelah),
      ];

      for (var col = 0; col < rowData.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: i + 2));
        cell.value = rowData[col];
        cell.cellStyle = defaultStyle;
      }
    }

    // Totals Row
    final totalRowIndex = transaksiList.length + 2;
    final totalRowData = [
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('TOTAL'),
      TextCellValue(''),
      DoubleCellValue(totalPemasukan + saldoMulai),
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

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

    final rupiahFormat = const CustomNumericNumFormat(
      formatCode: '"Rp" #,##0;-"Rp" #,##0',
    );

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

    final startRowRupiahStyle = CellStyle(
      backgroundColorHex: greenBgColor,
      fontFamily: getFontFamily(FontFamily.Calibri),
      numberFormat: rupiahFormat,
    );

    final totalRowStyle = CellStyle(
      backgroundColorHex: yellowBgColor,
      fontFamily: getFontFamily(FontFamily.Calibri),
      bold: true,
    );

    final totalRowRupiahStyle = CellStyle(
      backgroundColorHex: yellowBgColor,
      fontFamily: getFontFamily(FontFamily.Calibri),
      bold: true,
      numberFormat: rupiahFormat,
    );

    final defaultStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    final defaultRupiahStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      numberFormat: rupiahFormat,
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
    var currentRowIndex = 1;

    // 2. Baris "SALDO AKHIR PER [tanggal periode sebelumnya]"
    if (lastHistory != null) {
      final historyDateStr = formatTanggalLengkap(lastHistory.tanggalPeriode).toUpperCase();
      
      for (var col = 0; col < 7; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: currentRowIndex));
        cell.cellStyle = startRowStyle;
      }
      
      final labelCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex));
      labelCell.value = TextCellValue('SALDO AKHIR PER $historyDateStr');
      
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex),
        CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRowIndex),
        customValue: TextCellValue('SALDO AKHIR PER $historyDateStr'),
      );
      
      final saldoCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: currentRowIndex));
      saldoCell.value = DoubleCellValue(lastHistory.saldoAkhir);
      saldoCell.cellStyle = startRowRupiahStyle;
      
      currentRowIndex++;
    }

    // 3. Baris "PEMASUKAN DARI FINANCE"
    for (var col = 0; col < 7; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: currentRowIndex));
      cell.cellStyle = startRowStyle;
    }
    
    final financeLabelCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex));
    financeLabelCell.value = TextCellValue('PEMASUKAN DARI FINANCE');
    
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex),
      CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRowIndex),
      customValue: TextCellValue('PEMASUKAN DARI FINANCE'),
    );
    
    final financePemCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRowIndex));
    financePemCell.value = DoubleCellValue(saldoAwalInput);
    financePemCell.cellStyle = startRowRupiahStyle;
    
    final financeSaldoCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: currentRowIndex));
    financeSaldoCell.value = DoubleCellValue(saldoMulai);
    financeSaldoCell.cellStyle = startRowRupiahStyle;
    
    currentRowIndex++;

    // 4. Baris-baris transaksi (No starts from 1)
    for (var i = 0; i < transaksiList.length; i++) {
      final t = transaksiList[i];
      final no = i + 1;
      final katNama = kategoriMap[t.kategoriId] ?? '-';
      
      final cellNo = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRowIndex));
      cellNo.value = IntCellValue(no);
      cellNo.cellStyle = defaultStyle;

      final cellTgl = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex));
      cellTgl.value = TextCellValue(dateFormat.format(t.tanggal));
      cellTgl.cellStyle = defaultStyle;

      final cellKat = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: currentRowIndex));
      cellKat.value = TextCellValue(katNama);
      cellKat.cellStyle = defaultStyle;

      final cellUraian = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRowIndex));
      cellUraian.value = TextCellValue(t.uraian);
      cellUraian.cellStyle = defaultStyle;

      final cellPem = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRowIndex));
      if (t.pemasukan > 0) {
        cellPem.value = DoubleCellValue(t.pemasukan);
      }
      cellPem.cellStyle = defaultRupiahStyle;

      final cellPeng = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: currentRowIndex));
      if (t.pengeluaran > 0) {
        cellPeng.value = DoubleCellValue(t.pengeluaran);
      }
      cellPeng.cellStyle = defaultRupiahStyle;

      final cellSaldo = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: currentRowIndex));
      cellSaldo.value = DoubleCellValue(t.saldoSetelah);
      cellSaldo.cellStyle = defaultRupiahStyle;

      currentRowIndex++;
    }

    // 5. Totals Row
    final lastDate = transaksiList.isNotEmpty ? transaksiList.last.tanggal : DateTime.now();
    final totalRowDateStr = formatTanggalLengkap(lastDate).toUpperCase();
    
    for (var col = 0; col < 7; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: currentRowIndex));
      cell.cellStyle = totalRowStyle;
    }

    final totalLabelCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex));
    totalLabelCell.value = TextCellValue('SALDO AKHIR PER $totalRowDateStr');
    
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: currentRowIndex),
      CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: currentRowIndex),
      customValue: TextCellValue('SALDO AKHIR PER $totalRowDateStr'),
    );

    final totalPemCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: currentRowIndex));
    totalPemCell.value = DoubleCellValue(saldoAwalInput + totalPemasukan);
    totalPemCell.cellStyle = totalRowRupiahStyle;

    final totalPengCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: currentRowIndex));
    totalPengCell.value = DoubleCellValue(totalPengeluaran);
    totalPengCell.cellStyle = totalRowRupiahStyle;

    final totalSaldoCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: currentRowIndex));
    totalSaldoCell.value = DoubleCellValue(saldoAkhir);
    totalSaldoCell.cellStyle = totalRowRupiahStyle;

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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../providers/transaksi_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/rupiah_input_formatter.dart';

class TambahTransaksiSheet extends ConsumerStatefulWidget {
  final TransaksiData? editTransaksi;

  const TambahTransaksiSheet({super.key, this.editTransaksi});

  @override
  ConsumerState<TambahTransaksiSheet> createState() => _TambahTransaksiSheetState();
}

class _TambahTransaksiSheetState extends ConsumerState<TambahTransaksiSheet> {
  final _nominalController = TextEditingController();
  final _uraianController = TextEditingController();
  
  bool _isPengeluaran = true;
  int? _selectedKategoriId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.editTransaksi != null) {
      final t = widget.editTransaksi!;
      _isPengeluaran = t.pengeluaran > 0;
      final nominal = _isPengeluaran ? t.pengeluaran : t.pemasukan;
      _nominalController.text = 'Rp${_formatWithDots(nominal.toInt())}';
      _uraianController.text = t.uraian;
      _selectedKategoriId = t.kategoriId;
      _selectedDate = t.tanggal;
    }
  }

  String _formatWithDots(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _uraianController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.inkNavy,
              onPrimary: Colors.white,
              onSurface: AppColors.inkNavy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simpan() {
    final nominal = RupiahInputFormatter.parse(_nominalController.text);
    if (nominal <= 0 || _selectedKategoriId == null) return;

    final repo = ref.read(transaksiRepositoryProvider);
    final isEdit = widget.editTransaksi != null;

    final double pem = _isPengeluaran ? 0 : nominal;
    final double peng = _isPengeluaran ? nominal : 0;

    if (isEdit) {
      repo.editTransaksi(
        id: widget.editTransaksi!.id,
        tanggal: _selectedDate,
        kategoriId: _selectedKategoriId!,
        uraian: _uraianController.text,
        pemasukan: pem,
        pengeluaran: peng,
      );
    } else {
      repo.tambahTransaksi(
        tanggal: _selectedDate,
        kategoriId: _selectedKategoriId!,
        uraian: _uraianController.text,
        pemasukan: pem,
        pengeluaran: peng,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final kategoriAsync = ref.watch(kategoriListProvider);
    final formValid = _selectedKategoriId != null &&
        RupiahInputFormatter.parse(_nominalController.text) > 0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.ledgerCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.editTransaksi != null ? 'Ubah Transaksi' : 'Tambah Transaksi',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.inkNavy,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _ToggleButton(
                      label: 'Pemasukan',
                      active: !_isPengeluaran,
                      color: AppColors.emeraldPulse,
                      onTap: () => setState(() => _isPengeluaran = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ToggleButton(
                      label: 'Pengeluaran',
                      active: _isPengeluaran,
                      color: AppColors.signalCoral,
                      onTap: () => setState(() => _isPengeluaran = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Kategori',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.slateGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              kategoriAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (kategoriList) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kategoriList.map((kat) {
                    final isSel = _selectedKategoriId == kat.id;
                    return ChoiceChip(
                      label: Text(
                        kat.nama,
                        style: AppTypography.bodySmall.copyWith(
                          color: isSel ? Colors.white : AppColors.inkNavy,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: _isPengeluaran
                          ? AppColors.signalCoral
                          : AppColors.emeraldPulse,
                      backgroundColor: Colors.white,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: isSel ? Colors.transparent : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedKategoriId = selected ? kat.id : null;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RupiahInputFormatter(),
                ],
                style: AppTypography.monoData.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkNavy,
                ),
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.slateGrey,
                  ),
                  hintText: 'Rp0',
                  hintStyle: AppTypography.monoData.copyWith(
                    fontSize: 24,
                    color: AppColors.slateGrey.withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _uraianController,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.inkNavy,
                ),
                decoration: InputDecoration(
                  labelText: 'Uraian / Deskripsi',
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.slateGrey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.slateGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.slateGrey,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: AppTypography.monoData.copyWith(
                                color: AppColors.inkNavy,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: formValid ? _simpan : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPengeluaran
                        ? AppColors.signalCoral
                        : AppColors.emeraldPulse,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.editTransaksi != null ? 'Simpan Perubahan' : 'Simpan Transaksi',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: active ? Colors.white : AppColors.slateGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

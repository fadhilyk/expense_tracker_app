import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/saldo_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/rupiah_input_formatter.dart';

class SaldoAwalScreen extends ConsumerStatefulWidget {
  const SaldoAwalScreen({super.key});

  @override
  ConsumerState<SaldoAwalScreen> createState() => _SaldoAwalScreenState();
}

class _SaldoAwalScreenState extends ConsumerState<SaldoAwalScreen> {
  final _controller = TextEditingController();
  double _inputNominal = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {
      _inputNominal = RupiahInputFormatter.parse(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onInputChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _mulaiPeriode() async {
    await ref.read(saldoRepositoryProvider).mulaiPeriodeBaru(_inputNominal);
  }

  @override
  Widget build(BuildContext context) {
    final saldoAkhirAsync = ref.watch(saldoAkhirTerakhirProvider);

    return Scaffold(
      backgroundColor: AppColors.ledgerCream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: saldoAkhirAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (saldoAkhirTerakhir) =>
                  _buildContent(saldoAkhirTerakhir),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double saldoAkhirTerakhir) {
    final saldoMulai = _inputNominal + saldoAkhirTerakhir;
    final adaHistory = saldoAkhirTerakhir != 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Periode Baru',
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.inkNavy,
          ),
        ),
        const SizedBox(height: 32),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.inkNavy.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (adaHistory) ...[
                Text(
                  'Saldo Akhir Periode Lalu',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.slateGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(saldoAkhirTerakhir),
                  style: AppTypography.monoData.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: saldoAkhirTerakhir >= 0
                        ? AppColors.emeraldPulse
                        : AppColors.signalCoral,
                  ),
                ),
                const SizedBox(height: 24),
                Divider(color: AppColors.slateGrey.withValues(alpha: 0.2)),
                const SizedBox(height: 24),
              ],

              Text(
                'Saldo Awal Baru',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.inkNavy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RupiahInputFormatter(),
                ],
                style: AppTypography.monoData.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkNavy,
                ),
                decoration: InputDecoration(
                  hintText: 'Rp0',
                  hintStyle: AppTypography.monoData.copyWith(
                    fontSize: 28,
                    color: AppColors.slateGrey.withValues(alpha: 0.4),
                  ),
                  filled: true,
                  fillColor: AppColors.ledgerCream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.slateGrey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Saldo mulai periode ini',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.slateGrey,
                        ),
                      ),
                    ),
                    Text(
                      formatRupiah(saldoMulai),
                      style: AppTypography.monoData.copyWith(
                        fontWeight: FontWeight.w500,
                        color: saldoMulai >= 0
                            ? AppColors.emeraldPulse
                            : AppColors.signalCoral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _mulaiPeriode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldPulse,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'Mulai Periode Ini',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

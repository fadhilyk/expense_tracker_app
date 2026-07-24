import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class SaldoCard extends StatelessWidget {
  final double saldo;
  final double totalPemasukan;
  final double totalPengeluaran;

  const SaldoCard({
    super.key,
    required this.saldo,
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });

  @override
  Widget build(BuildContext context) {
    final aman = saldo >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.saldoCardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkNavy.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Berjalan',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              _AnimatedSaldo(saldo: saldo),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoKecil(
                    label: 'Pemasukan',
                    nominal: totalPemasukan,
                    icon: '↑',
                    warna: AppColors.emeraldPulse,
                  ),
                  const SizedBox(width: 24),
                  _InfoKecil(
                    label: 'Pengeluaran',
                    nominal: totalPengeluaran,
                    icon: '↓',
                    warna: AppColors.signalCoral,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _StempelWidget(aman: aman),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSaldo extends StatefulWidget {
  final double saldo;
  const _AnimatedSaldo({required this.saldo});

  @override
  State<_AnimatedSaldo> createState() => _AnimatedSaldoState();
}

class _AnimatedSaldoState extends State<_AnimatedSaldo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldSaldo = 0;

  @override
  void initState() {
    super.initState();
    _oldSaldo = widget.saldo;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: _oldSaldo, end: widget.saldo)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(_AnimatedSaldo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.saldo != widget.saldo) {
      _oldSaldo = oldWidget.saldo;
      _animation = Tween<double>(begin: _oldSaldo, end: widget.saldo)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Text(
          formatRupiah(_animation.value),
          style: AppTypography.displayLarge.copyWith(
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class _StempelWidget extends StatefulWidget {
  final bool aman;
  const _StempelWidget({required this.aman});

  @override
  State<_StempelWidget> createState() => _StempelWidgetState();
}

class _StempelWidgetState extends State<_StempelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(_StempelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.aman != widget.aman) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna =
        widget.aman ? AppColors.emeraldPulse : AppColors.signalCoral;
    final teks = widget.aman ? 'AMAN' : 'DEFISIT';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Transform.rotate(
        angle: -8 * pi / 180,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: warna, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: warna, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              teks,
              style: AppTypography.bodySmall.copyWith(
                color: warna,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoKecil extends StatelessWidget {
  final String label;
  final double nominal;
  final String icon;
  final Color warna;

  const _InfoKecil({
    required this.label,
    required this.nominal,
    required this.icon,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(color: warna, fontSize: 14)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            Text(
              formatRupiah(nominal),
              style: AppTypography.monoData.copyWith(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

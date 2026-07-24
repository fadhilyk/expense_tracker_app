import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'providers/saldo_provider.dart';
import 'screens/home_screen.dart';
import 'screens/saldo_awal_screen.dart';
import 'theme/app_theme.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pencatat Pengeluaran',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const _RouterScreen(),
    );
  }
}

class _RouterScreen extends ConsumerWidget {
  const _RouterScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesiAsync = ref.watch(sesiAktifStreamProvider);

    return sesiAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.ledgerCream,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.ledgerCream,
        body: Center(child: Text('Error: $e')),
      ),
      data: (sesi) {
        if (sesi.sudahDiisi) {
          return const HomeScreen();
        }
        return const SaldoAwalScreen();
      },
    );
  }
}

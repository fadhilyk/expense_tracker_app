import 'package:drift/drift.dart';
import '../data/database.dart';

class TransaksiRepository {
  final AppDatabase _db;

  TransaksiRepository(this._db);

  Stream<List<TransaksiData>> watchSemuaTransaksi() {
    return (_db.select(_db.transaksi)
          ..orderBy([(t) => OrderingTerm.desc(t.dibuatPada)]))
        .watch();
  }

  Future<List<TransaksiData>> ambilSemuaTransaksiUrut() async {
    return (_db.select(_db.transaksi)
          ..orderBy([(t) => OrderingTerm.asc(t.dibuatPada)]))
        .get();
  }

  Future<double> _ambilSaldoMulai() async {
    final sesi = await (_db.select(_db.sesiAktif)
          ..where((t) => t.id.equals(1)))
        .getSingle();
    return sesi.saldoMulai;
  }

  Future<void> tambahTransaksi({
    required DateTime tanggal,
    required int kategoriId,
    required String uraian,
    required double pengeluaran,
  }) async {
    final semua = await ambilSemuaTransaksiUrut();
    final saldoPrev = semua.isEmpty
        ? await _ambilSaldoMulai()
        : semua.last.saldoSetelah;
    final saldoSetelah = saldoPrev - pengeluaran;

    await _db.into(_db.transaksi).insert(
      TransaksiCompanion.insert(
        tanggal: tanggal,
        kategoriId: kategoriId,
        uraian: uraian,
        pemasukan: const Value(0),
        pengeluaran: Value(pengeluaran),
        saldoSetelah: saldoSetelah,
        dibuatPada: DateTime.now(),
      ),
    );
  }

  Future<void> editTransaksi({
    required int id,
    required DateTime tanggal,
    required int kategoriId,
    required String uraian,
    required double pengeluaran,
  }) async {
    await (_db.update(_db.transaksi)..where((t) => t.id.equals(id))).write(
      TransaksiCompanion(
        tanggal: Value(tanggal),
        kategoriId: Value(kategoriId),
        uraian: Value(uraian),
        pemasukan: const Value(0),
        pengeluaran: Value(pengeluaran),
      ),
    );
    await _recalculateSemua();
  }

  Future<void> hapusTransaksi(int id) async {
    await (_db.delete(_db.transaksi)..where((t) => t.id.equals(id))).go();
    await _recalculateSemua();
  }

  Future<void> _recalculateSemua() async {
    final saldoMulai = await _ambilSaldoMulai();
    final semua = await ambilSemuaTransaksiUrut();

    double saldoPrev = saldoMulai;
    for (final trx in semua) {
      final saldoBaru = saldoPrev - trx.pengeluaran;
      if (saldoBaru != trx.saldoSetelah) {
        await (_db.update(_db.transaksi)..where((t) => t.id.equals(trx.id)))
            .write(TransaksiCompanion(saldoSetelah: Value(saldoBaru)));
      }
      saldoPrev = saldoBaru;
    }
  }

  Future<List<KategoriData>> ambilSemuaKategori() {
    return _db.select(_db.kategori).get();
  }

  Stream<List<KategoriData>> watchSemuaKategori() {
    return _db.select(_db.kategori).watch();
  }
}

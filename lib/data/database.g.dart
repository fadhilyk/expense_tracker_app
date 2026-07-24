// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $KategoriTable extends Kategori
    with TableInfo<$KategoriTable, KategoriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KategoriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nama];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kategori';
  @override
  VerificationContext validateIntegrity(
    Insertable<KategoriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KategoriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KategoriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
    );
  }

  @override
  $KategoriTable createAlias(String alias) {
    return $KategoriTable(attachedDatabase, alias);
  }
}

class KategoriData extends DataClass implements Insertable<KategoriData> {
  final int id;
  final String nama;
  const KategoriData({required this.id, required this.nama});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    return map;
  }

  KategoriCompanion toCompanion(bool nullToAbsent) {
    return KategoriCompanion(id: Value(id), nama: Value(nama));
  }

  factory KategoriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KategoriData(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
    };
  }

  KategoriData copyWith({int? id, String? nama}) =>
      KategoriData(id: id ?? this.id, nama: nama ?? this.nama);
  KategoriData copyWithCompanion(KategoriCompanion data) {
    return KategoriData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KategoriData(')
          ..write('id: $id, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KategoriData && other.id == this.id && other.nama == this.nama);
}

class KategoriCompanion extends UpdateCompanion<KategoriData> {
  final Value<int> id;
  final Value<String> nama;
  const KategoriCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
  });
  KategoriCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
  }) : nama = Value(nama);
  static Insertable<KategoriData> custom({
    Expression<int>? id,
    Expression<String>? nama,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
    });
  }

  KategoriCompanion copyWith({Value<int>? id, Value<String>? nama}) {
    return KategoriCompanion(id: id ?? this.id, nama: nama ?? this.nama);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KategoriCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }
}

class $TransaksiTable extends Transaksi
    with TableInfo<$TransaksiTable, TransaksiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaksiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriIdMeta = const VerificationMeta(
    'kategoriId',
  );
  @override
  late final GeneratedColumn<int> kategoriId = GeneratedColumn<int>(
    'kategori_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kategori (id)',
    ),
  );
  static const VerificationMeta _uraianMeta = const VerificationMeta('uraian');
  @override
  late final GeneratedColumn<String> uraian = GeneratedColumn<String>(
    'uraian',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pemasukanMeta = const VerificationMeta(
    'pemasukan',
  );
  @override
  late final GeneratedColumn<double> pemasukan = GeneratedColumn<double>(
    'pemasukan',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pengeluaranMeta = const VerificationMeta(
    'pengeluaran',
  );
  @override
  late final GeneratedColumn<double> pengeluaran = GeneratedColumn<double>(
    'pengeluaran',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _saldoSetelahMeta = const VerificationMeta(
    'saldoSetelah',
  );
  @override
  late final GeneratedColumn<double> saldoSetelah = GeneratedColumn<double>(
    'saldo_setelah',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tanggal,
    kategoriId,
    uraian,
    pemasukan,
    pengeluaran,
    saldoSetelah,
    dibuatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaksi';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransaksiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('kategori_id')) {
      context.handle(
        _kategoriIdMeta,
        kategoriId.isAcceptableOrUnknown(data['kategori_id']!, _kategoriIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kategoriIdMeta);
    }
    if (data.containsKey('uraian')) {
      context.handle(
        _uraianMeta,
        uraian.isAcceptableOrUnknown(data['uraian']!, _uraianMeta),
      );
    } else if (isInserting) {
      context.missing(_uraianMeta);
    }
    if (data.containsKey('pemasukan')) {
      context.handle(
        _pemasukanMeta,
        pemasukan.isAcceptableOrUnknown(data['pemasukan']!, _pemasukanMeta),
      );
    }
    if (data.containsKey('pengeluaran')) {
      context.handle(
        _pengeluaranMeta,
        pengeluaran.isAcceptableOrUnknown(
          data['pengeluaran']!,
          _pengeluaranMeta,
        ),
      );
    }
    if (data.containsKey('saldo_setelah')) {
      context.handle(
        _saldoSetelahMeta,
        saldoSetelah.isAcceptableOrUnknown(
          data['saldo_setelah']!,
          _saldoSetelahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoSetelahMeta);
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    } else if (isInserting) {
      context.missing(_dibuatPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransaksiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransaksiData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      kategoriId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kategori_id'],
      )!,
      uraian: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uraian'],
      )!,
      pemasukan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pemasukan'],
      )!,
      pengeluaran: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pengeluaran'],
      )!,
      saldoSetelah: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_setelah'],
      )!,
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
    );
  }

  @override
  $TransaksiTable createAlias(String alias) {
    return $TransaksiTable(attachedDatabase, alias);
  }
}

class TransaksiData extends DataClass implements Insertable<TransaksiData> {
  final int id;
  final DateTime tanggal;
  final int kategoriId;
  final String uraian;
  final double pemasukan;
  final double pengeluaran;
  final double saldoSetelah;
  final DateTime dibuatPada;
  const TransaksiData({
    required this.id,
    required this.tanggal,
    required this.kategoriId,
    required this.uraian,
    required this.pemasukan,
    required this.pengeluaran,
    required this.saldoSetelah,
    required this.dibuatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tanggal'] = Variable<DateTime>(tanggal);
    map['kategori_id'] = Variable<int>(kategoriId);
    map['uraian'] = Variable<String>(uraian);
    map['pemasukan'] = Variable<double>(pemasukan);
    map['pengeluaran'] = Variable<double>(pengeluaran);
    map['saldo_setelah'] = Variable<double>(saldoSetelah);
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    return map;
  }

  TransaksiCompanion toCompanion(bool nullToAbsent) {
    return TransaksiCompanion(
      id: Value(id),
      tanggal: Value(tanggal),
      kategoriId: Value(kategoriId),
      uraian: Value(uraian),
      pemasukan: Value(pemasukan),
      pengeluaran: Value(pengeluaran),
      saldoSetelah: Value(saldoSetelah),
      dibuatPada: Value(dibuatPada),
    );
  }

  factory TransaksiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransaksiData(
      id: serializer.fromJson<int>(json['id']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      kategoriId: serializer.fromJson<int>(json['kategoriId']),
      uraian: serializer.fromJson<String>(json['uraian']),
      pemasukan: serializer.fromJson<double>(json['pemasukan']),
      pengeluaran: serializer.fromJson<double>(json['pengeluaran']),
      saldoSetelah: serializer.fromJson<double>(json['saldoSetelah']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'kategoriId': serializer.toJson<int>(kategoriId),
      'uraian': serializer.toJson<String>(uraian),
      'pemasukan': serializer.toJson<double>(pemasukan),
      'pengeluaran': serializer.toJson<double>(pengeluaran),
      'saldoSetelah': serializer.toJson<double>(saldoSetelah),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
    };
  }

  TransaksiData copyWith({
    int? id,
    DateTime? tanggal,
    int? kategoriId,
    String? uraian,
    double? pemasukan,
    double? pengeluaran,
    double? saldoSetelah,
    DateTime? dibuatPada,
  }) => TransaksiData(
    id: id ?? this.id,
    tanggal: tanggal ?? this.tanggal,
    kategoriId: kategoriId ?? this.kategoriId,
    uraian: uraian ?? this.uraian,
    pemasukan: pemasukan ?? this.pemasukan,
    pengeluaran: pengeluaran ?? this.pengeluaran,
    saldoSetelah: saldoSetelah ?? this.saldoSetelah,
    dibuatPada: dibuatPada ?? this.dibuatPada,
  );
  TransaksiData copyWithCompanion(TransaksiCompanion data) {
    return TransaksiData(
      id: data.id.present ? data.id.value : this.id,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      kategoriId: data.kategoriId.present
          ? data.kategoriId.value
          : this.kategoriId,
      uraian: data.uraian.present ? data.uraian.value : this.uraian,
      pemasukan: data.pemasukan.present ? data.pemasukan.value : this.pemasukan,
      pengeluaran: data.pengeluaran.present
          ? data.pengeluaran.value
          : this.pengeluaran,
      saldoSetelah: data.saldoSetelah.present
          ? data.saldoSetelah.value
          : this.saldoSetelah,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiData(')
          ..write('id: $id, ')
          ..write('tanggal: $tanggal, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('uraian: $uraian, ')
          ..write('pemasukan: $pemasukan, ')
          ..write('pengeluaran: $pengeluaran, ')
          ..write('saldoSetelah: $saldoSetelah, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tanggal,
    kategoriId,
    uraian,
    pemasukan,
    pengeluaran,
    saldoSetelah,
    dibuatPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransaksiData &&
          other.id == this.id &&
          other.tanggal == this.tanggal &&
          other.kategoriId == this.kategoriId &&
          other.uraian == this.uraian &&
          other.pemasukan == this.pemasukan &&
          other.pengeluaran == this.pengeluaran &&
          other.saldoSetelah == this.saldoSetelah &&
          other.dibuatPada == this.dibuatPada);
}

class TransaksiCompanion extends UpdateCompanion<TransaksiData> {
  final Value<int> id;
  final Value<DateTime> tanggal;
  final Value<int> kategoriId;
  final Value<String> uraian;
  final Value<double> pemasukan;
  final Value<double> pengeluaran;
  final Value<double> saldoSetelah;
  final Value<DateTime> dibuatPada;
  const TransaksiCompanion({
    this.id = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.uraian = const Value.absent(),
    this.pemasukan = const Value.absent(),
    this.pengeluaran = const Value.absent(),
    this.saldoSetelah = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  });
  TransaksiCompanion.insert({
    this.id = const Value.absent(),
    required DateTime tanggal,
    required int kategoriId,
    required String uraian,
    this.pemasukan = const Value.absent(),
    this.pengeluaran = const Value.absent(),
    required double saldoSetelah,
    required DateTime dibuatPada,
  }) : tanggal = Value(tanggal),
       kategoriId = Value(kategoriId),
       uraian = Value(uraian),
       saldoSetelah = Value(saldoSetelah),
       dibuatPada = Value(dibuatPada);
  static Insertable<TransaksiData> custom({
    Expression<int>? id,
    Expression<DateTime>? tanggal,
    Expression<int>? kategoriId,
    Expression<String>? uraian,
    Expression<double>? pemasukan,
    Expression<double>? pengeluaran,
    Expression<double>? saldoSetelah,
    Expression<DateTime>? dibuatPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tanggal != null) 'tanggal': tanggal,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (uraian != null) 'uraian': uraian,
      if (pemasukan != null) 'pemasukan': pemasukan,
      if (pengeluaran != null) 'pengeluaran': pengeluaran,
      if (saldoSetelah != null) 'saldo_setelah': saldoSetelah,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
    });
  }

  TransaksiCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? tanggal,
    Value<int>? kategoriId,
    Value<String>? uraian,
    Value<double>? pemasukan,
    Value<double>? pengeluaran,
    Value<double>? saldoSetelah,
    Value<DateTime>? dibuatPada,
  }) {
    return TransaksiCompanion(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      kategoriId: kategoriId ?? this.kategoriId,
      uraian: uraian ?? this.uraian,
      pemasukan: pemasukan ?? this.pemasukan,
      pengeluaran: pengeluaran ?? this.pengeluaran,
      saldoSetelah: saldoSetelah ?? this.saldoSetelah,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (kategoriId.present) {
      map['kategori_id'] = Variable<int>(kategoriId.value);
    }
    if (uraian.present) {
      map['uraian'] = Variable<String>(uraian.value);
    }
    if (pemasukan.present) {
      map['pemasukan'] = Variable<double>(pemasukan.value);
    }
    if (pengeluaran.present) {
      map['pengeluaran'] = Variable<double>(pengeluaran.value);
    }
    if (saldoSetelah.present) {
      map['saldo_setelah'] = Variable<double>(saldoSetelah.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiCompanion(')
          ..write('id: $id, ')
          ..write('tanggal: $tanggal, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('uraian: $uraian, ')
          ..write('pemasukan: $pemasukan, ')
          ..write('pengeluaran: $pengeluaran, ')
          ..write('saldoSetelah: $saldoSetelah, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }
}

class $HistorySaldoAkhirTable extends HistorySaldoAkhir
    with TableInfo<$HistorySaldoAkhirTable, HistorySaldoAkhirData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorySaldoAkhirTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tanggalPeriodeMeta = const VerificationMeta(
    'tanggalPeriode',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalPeriode =
      GeneratedColumn<DateTime>(
        'tanggal_periode',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _saldoAkhirMeta = const VerificationMeta(
    'saldoAkhir',
  );
  @override
  late final GeneratedColumn<double> saldoAkhir = GeneratedColumn<double>(
    'saldo_akhir',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dicatatPadaMeta = const VerificationMeta(
    'dicatatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dicatatPada = GeneratedColumn<DateTime>(
    'dicatat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tanggalPeriode,
    saldoAkhir,
    dicatatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_saldo_akhir';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistorySaldoAkhirData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tanggal_periode')) {
      context.handle(
        _tanggalPeriodeMeta,
        tanggalPeriode.isAcceptableOrUnknown(
          data['tanggal_periode']!,
          _tanggalPeriodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tanggalPeriodeMeta);
    }
    if (data.containsKey('saldo_akhir')) {
      context.handle(
        _saldoAkhirMeta,
        saldoAkhir.isAcceptableOrUnknown(data['saldo_akhir']!, _saldoAkhirMeta),
      );
    } else if (isInserting) {
      context.missing(_saldoAkhirMeta);
    }
    if (data.containsKey('dicatat_pada')) {
      context.handle(
        _dicatatPadaMeta,
        dicatatPada.isAcceptableOrUnknown(
          data['dicatat_pada']!,
          _dicatatPadaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dicatatPadaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistorySaldoAkhirData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorySaldoAkhirData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tanggalPeriode: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_periode'],
      )!,
      saldoAkhir: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_akhir'],
      )!,
      dicatatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dicatat_pada'],
      )!,
    );
  }

  @override
  $HistorySaldoAkhirTable createAlias(String alias) {
    return $HistorySaldoAkhirTable(attachedDatabase, alias);
  }
}

class HistorySaldoAkhirData extends DataClass
    implements Insertable<HistorySaldoAkhirData> {
  final int id;
  final DateTime tanggalPeriode;
  final double saldoAkhir;
  final DateTime dicatatPada;
  const HistorySaldoAkhirData({
    required this.id,
    required this.tanggalPeriode,
    required this.saldoAkhir,
    required this.dicatatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tanggal_periode'] = Variable<DateTime>(tanggalPeriode);
    map['saldo_akhir'] = Variable<double>(saldoAkhir);
    map['dicatat_pada'] = Variable<DateTime>(dicatatPada);
    return map;
  }

  HistorySaldoAkhirCompanion toCompanion(bool nullToAbsent) {
    return HistorySaldoAkhirCompanion(
      id: Value(id),
      tanggalPeriode: Value(tanggalPeriode),
      saldoAkhir: Value(saldoAkhir),
      dicatatPada: Value(dicatatPada),
    );
  }

  factory HistorySaldoAkhirData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorySaldoAkhirData(
      id: serializer.fromJson<int>(json['id']),
      tanggalPeriode: serializer.fromJson<DateTime>(json['tanggalPeriode']),
      saldoAkhir: serializer.fromJson<double>(json['saldoAkhir']),
      dicatatPada: serializer.fromJson<DateTime>(json['dicatatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tanggalPeriode': serializer.toJson<DateTime>(tanggalPeriode),
      'saldoAkhir': serializer.toJson<double>(saldoAkhir),
      'dicatatPada': serializer.toJson<DateTime>(dicatatPada),
    };
  }

  HistorySaldoAkhirData copyWith({
    int? id,
    DateTime? tanggalPeriode,
    double? saldoAkhir,
    DateTime? dicatatPada,
  }) => HistorySaldoAkhirData(
    id: id ?? this.id,
    tanggalPeriode: tanggalPeriode ?? this.tanggalPeriode,
    saldoAkhir: saldoAkhir ?? this.saldoAkhir,
    dicatatPada: dicatatPada ?? this.dicatatPada,
  );
  HistorySaldoAkhirData copyWithCompanion(HistorySaldoAkhirCompanion data) {
    return HistorySaldoAkhirData(
      id: data.id.present ? data.id.value : this.id,
      tanggalPeriode: data.tanggalPeriode.present
          ? data.tanggalPeriode.value
          : this.tanggalPeriode,
      saldoAkhir: data.saldoAkhir.present
          ? data.saldoAkhir.value
          : this.saldoAkhir,
      dicatatPada: data.dicatatPada.present
          ? data.dicatatPada.value
          : this.dicatatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorySaldoAkhirData(')
          ..write('id: $id, ')
          ..write('tanggalPeriode: $tanggalPeriode, ')
          ..write('saldoAkhir: $saldoAkhir, ')
          ..write('dicatatPada: $dicatatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tanggalPeriode, saldoAkhir, dicatatPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorySaldoAkhirData &&
          other.id == this.id &&
          other.tanggalPeriode == this.tanggalPeriode &&
          other.saldoAkhir == this.saldoAkhir &&
          other.dicatatPada == this.dicatatPada);
}

class HistorySaldoAkhirCompanion
    extends UpdateCompanion<HistorySaldoAkhirData> {
  final Value<int> id;
  final Value<DateTime> tanggalPeriode;
  final Value<double> saldoAkhir;
  final Value<DateTime> dicatatPada;
  const HistorySaldoAkhirCompanion({
    this.id = const Value.absent(),
    this.tanggalPeriode = const Value.absent(),
    this.saldoAkhir = const Value.absent(),
    this.dicatatPada = const Value.absent(),
  });
  HistorySaldoAkhirCompanion.insert({
    this.id = const Value.absent(),
    required DateTime tanggalPeriode,
    required double saldoAkhir,
    required DateTime dicatatPada,
  }) : tanggalPeriode = Value(tanggalPeriode),
       saldoAkhir = Value(saldoAkhir),
       dicatatPada = Value(dicatatPada);
  static Insertable<HistorySaldoAkhirData> custom({
    Expression<int>? id,
    Expression<DateTime>? tanggalPeriode,
    Expression<double>? saldoAkhir,
    Expression<DateTime>? dicatatPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tanggalPeriode != null) 'tanggal_periode': tanggalPeriode,
      if (saldoAkhir != null) 'saldo_akhir': saldoAkhir,
      if (dicatatPada != null) 'dicatat_pada': dicatatPada,
    });
  }

  HistorySaldoAkhirCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? tanggalPeriode,
    Value<double>? saldoAkhir,
    Value<DateTime>? dicatatPada,
  }) {
    return HistorySaldoAkhirCompanion(
      id: id ?? this.id,
      tanggalPeriode: tanggalPeriode ?? this.tanggalPeriode,
      saldoAkhir: saldoAkhir ?? this.saldoAkhir,
      dicatatPada: dicatatPada ?? this.dicatatPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tanggalPeriode.present) {
      map['tanggal_periode'] = Variable<DateTime>(tanggalPeriode.value);
    }
    if (saldoAkhir.present) {
      map['saldo_akhir'] = Variable<double>(saldoAkhir.value);
    }
    if (dicatatPada.present) {
      map['dicatat_pada'] = Variable<DateTime>(dicatatPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorySaldoAkhirCompanion(')
          ..write('id: $id, ')
          ..write('tanggalPeriode: $tanggalPeriode, ')
          ..write('saldoAkhir: $saldoAkhir, ')
          ..write('dicatatPada: $dicatatPada')
          ..write(')'))
        .toString();
  }
}

class $SesiAktifTable extends SesiAktif
    with TableInfo<$SesiAktifTable, SesiAktifData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SesiAktifTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saldoAwalInputMeta = const VerificationMeta(
    'saldoAwalInput',
  );
  @override
  late final GeneratedColumn<double> saldoAwalInput = GeneratedColumn<double>(
    'saldo_awal_input',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoMulaiMeta = const VerificationMeta(
    'saldoMulai',
  );
  @override
  late final GeneratedColumn<double> saldoMulai = GeneratedColumn<double>(
    'saldo_mulai',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sudahDiisiMeta = const VerificationMeta(
    'sudahDiisi',
  );
  @override
  late final GeneratedColumn<bool> sudahDiisi = GeneratedColumn<bool>(
    'sudah_diisi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sudah_diisi" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saldoAwalInput,
    saldoMulai,
    sudahDiisi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sesi_aktif';
  @override
  VerificationContext validateIntegrity(
    Insertable<SesiAktifData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('saldo_awal_input')) {
      context.handle(
        _saldoAwalInputMeta,
        saldoAwalInput.isAcceptableOrUnknown(
          data['saldo_awal_input']!,
          _saldoAwalInputMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoAwalInputMeta);
    }
    if (data.containsKey('saldo_mulai')) {
      context.handle(
        _saldoMulaiMeta,
        saldoMulai.isAcceptableOrUnknown(data['saldo_mulai']!, _saldoMulaiMeta),
      );
    } else if (isInserting) {
      context.missing(_saldoMulaiMeta);
    }
    if (data.containsKey('sudah_diisi')) {
      context.handle(
        _sudahDiisiMeta,
        sudahDiisi.isAcceptableOrUnknown(data['sudah_diisi']!, _sudahDiisiMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SesiAktifData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SesiAktifData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saldoAwalInput: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_awal_input'],
      )!,
      saldoMulai: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_mulai'],
      )!,
      sudahDiisi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sudah_diisi'],
      )!,
    );
  }

  @override
  $SesiAktifTable createAlias(String alias) {
    return $SesiAktifTable(attachedDatabase, alias);
  }
}

class SesiAktifData extends DataClass implements Insertable<SesiAktifData> {
  final int id;
  final double saldoAwalInput;
  final double saldoMulai;
  final bool sudahDiisi;
  const SesiAktifData({
    required this.id,
    required this.saldoAwalInput,
    required this.saldoMulai,
    required this.sudahDiisi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['saldo_awal_input'] = Variable<double>(saldoAwalInput);
    map['saldo_mulai'] = Variable<double>(saldoMulai);
    map['sudah_diisi'] = Variable<bool>(sudahDiisi);
    return map;
  }

  SesiAktifCompanion toCompanion(bool nullToAbsent) {
    return SesiAktifCompanion(
      id: Value(id),
      saldoAwalInput: Value(saldoAwalInput),
      saldoMulai: Value(saldoMulai),
      sudahDiisi: Value(sudahDiisi),
    );
  }

  factory SesiAktifData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SesiAktifData(
      id: serializer.fromJson<int>(json['id']),
      saldoAwalInput: serializer.fromJson<double>(json['saldoAwalInput']),
      saldoMulai: serializer.fromJson<double>(json['saldoMulai']),
      sudahDiisi: serializer.fromJson<bool>(json['sudahDiisi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saldoAwalInput': serializer.toJson<double>(saldoAwalInput),
      'saldoMulai': serializer.toJson<double>(saldoMulai),
      'sudahDiisi': serializer.toJson<bool>(sudahDiisi),
    };
  }

  SesiAktifData copyWith({
    int? id,
    double? saldoAwalInput,
    double? saldoMulai,
    bool? sudahDiisi,
  }) => SesiAktifData(
    id: id ?? this.id,
    saldoAwalInput: saldoAwalInput ?? this.saldoAwalInput,
    saldoMulai: saldoMulai ?? this.saldoMulai,
    sudahDiisi: sudahDiisi ?? this.sudahDiisi,
  );
  SesiAktifData copyWithCompanion(SesiAktifCompanion data) {
    return SesiAktifData(
      id: data.id.present ? data.id.value : this.id,
      saldoAwalInput: data.saldoAwalInput.present
          ? data.saldoAwalInput.value
          : this.saldoAwalInput,
      saldoMulai: data.saldoMulai.present
          ? data.saldoMulai.value
          : this.saldoMulai,
      sudahDiisi: data.sudahDiisi.present
          ? data.sudahDiisi.value
          : this.sudahDiisi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SesiAktifData(')
          ..write('id: $id, ')
          ..write('saldoAwalInput: $saldoAwalInput, ')
          ..write('saldoMulai: $saldoMulai, ')
          ..write('sudahDiisi: $sudahDiisi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saldoAwalInput, saldoMulai, sudahDiisi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SesiAktifData &&
          other.id == this.id &&
          other.saldoAwalInput == this.saldoAwalInput &&
          other.saldoMulai == this.saldoMulai &&
          other.sudahDiisi == this.sudahDiisi);
}

class SesiAktifCompanion extends UpdateCompanion<SesiAktifData> {
  final Value<int> id;
  final Value<double> saldoAwalInput;
  final Value<double> saldoMulai;
  final Value<bool> sudahDiisi;
  const SesiAktifCompanion({
    this.id = const Value.absent(),
    this.saldoAwalInput = const Value.absent(),
    this.saldoMulai = const Value.absent(),
    this.sudahDiisi = const Value.absent(),
  });
  SesiAktifCompanion.insert({
    this.id = const Value.absent(),
    required double saldoAwalInput,
    required double saldoMulai,
    this.sudahDiisi = const Value.absent(),
  }) : saldoAwalInput = Value(saldoAwalInput),
       saldoMulai = Value(saldoMulai);
  static Insertable<SesiAktifData> custom({
    Expression<int>? id,
    Expression<double>? saldoAwalInput,
    Expression<double>? saldoMulai,
    Expression<bool>? sudahDiisi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saldoAwalInput != null) 'saldo_awal_input': saldoAwalInput,
      if (saldoMulai != null) 'saldo_mulai': saldoMulai,
      if (sudahDiisi != null) 'sudah_diisi': sudahDiisi,
    });
  }

  SesiAktifCompanion copyWith({
    Value<int>? id,
    Value<double>? saldoAwalInput,
    Value<double>? saldoMulai,
    Value<bool>? sudahDiisi,
  }) {
    return SesiAktifCompanion(
      id: id ?? this.id,
      saldoAwalInput: saldoAwalInput ?? this.saldoAwalInput,
      saldoMulai: saldoMulai ?? this.saldoMulai,
      sudahDiisi: sudahDiisi ?? this.sudahDiisi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saldoAwalInput.present) {
      map['saldo_awal_input'] = Variable<double>(saldoAwalInput.value);
    }
    if (saldoMulai.present) {
      map['saldo_mulai'] = Variable<double>(saldoMulai.value);
    }
    if (sudahDiisi.present) {
      map['sudah_diisi'] = Variable<bool>(sudahDiisi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SesiAktifCompanion(')
          ..write('id: $id, ')
          ..write('saldoAwalInput: $saldoAwalInput, ')
          ..write('saldoMulai: $saldoMulai, ')
          ..write('sudahDiisi: $sudahDiisi')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KategoriTable kategori = $KategoriTable(this);
  late final $TransaksiTable transaksi = $TransaksiTable(this);
  late final $HistorySaldoAkhirTable historySaldoAkhir =
      $HistorySaldoAkhirTable(this);
  late final $SesiAktifTable sesiAktif = $SesiAktifTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kategori,
    transaksi,
    historySaldoAkhir,
    sesiAktif,
  ];
}

typedef $$KategoriTableCreateCompanionBuilder =
    KategoriCompanion Function({Value<int> id, required String nama});
typedef $$KategoriTableUpdateCompanionBuilder =
    KategoriCompanion Function({Value<int> id, Value<String> nama});

final class $$KategoriTableReferences
    extends BaseReferences<_$AppDatabase, $KategoriTable, KategoriData> {
  $$KategoriTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransaksiTable, List<TransaksiData>>
  _transaksiRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transaksi,
    aliasName: 'kategori__id__transaksi__kategori_id',
  );

  $$TransaksiTableProcessedTableManager get transaksiRefs {
    final manager = $$TransaksiTableTableManager(
      $_db,
      $_db.transaksi,
    ).filter((f) => f.kategoriId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transaksiRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KategoriTableFilterComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transaksiRefs(
    Expression<bool> Function($$TransaksiTableFilterComposer f) f,
  ) {
    final $$TransaksiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transaksi,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableFilterComposer(
            $db: $db,
            $table: $db.transaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KategoriTableOrderingComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KategoriTableAnnotationComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  Expression<T> transaksiRefs<T extends Object>(
    Expression<T> Function($$TransaksiTableAnnotationComposer a) f,
  ) {
    final $$TransaksiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transaksi,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableAnnotationComposer(
            $db: $db,
            $table: $db.transaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KategoriTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KategoriTable,
          KategoriData,
          $$KategoriTableFilterComposer,
          $$KategoriTableOrderingComposer,
          $$KategoriTableAnnotationComposer,
          $$KategoriTableCreateCompanionBuilder,
          $$KategoriTableUpdateCompanionBuilder,
          (KategoriData, $$KategoriTableReferences),
          KategoriData,
          PrefetchHooks Function({bool transaksiRefs})
        > {
  $$KategoriTableTableManager(_$AppDatabase db, $KategoriTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KategoriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KategoriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KategoriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
              }) => KategoriCompanion(id: id, nama: nama),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String nama}) =>
                  KategoriCompanion.insert(id: id, nama: nama),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KategoriTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transaksiRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transaksiRefs) db.transaksi],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transaksiRefs)
                    await $_getPrefetchedData<
                      KategoriData,
                      $KategoriTable,
                      TransaksiData
                    >(
                      currentTable: table,
                      referencedTable: $$KategoriTableReferences
                          ._transaksiRefsTable(db),
                      managerFromTypedResult: (p0) => $$KategoriTableReferences(
                        db,
                        table,
                        p0,
                      ).transaksiRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.kategoriId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KategoriTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KategoriTable,
      KategoriData,
      $$KategoriTableFilterComposer,
      $$KategoriTableOrderingComposer,
      $$KategoriTableAnnotationComposer,
      $$KategoriTableCreateCompanionBuilder,
      $$KategoriTableUpdateCompanionBuilder,
      (KategoriData, $$KategoriTableReferences),
      KategoriData,
      PrefetchHooks Function({bool transaksiRefs})
    >;
typedef $$TransaksiTableCreateCompanionBuilder =
    TransaksiCompanion Function({
      Value<int> id,
      required DateTime tanggal,
      required int kategoriId,
      required String uraian,
      Value<double> pemasukan,
      Value<double> pengeluaran,
      required double saldoSetelah,
      required DateTime dibuatPada,
    });
typedef $$TransaksiTableUpdateCompanionBuilder =
    TransaksiCompanion Function({
      Value<int> id,
      Value<DateTime> tanggal,
      Value<int> kategoriId,
      Value<String> uraian,
      Value<double> pemasukan,
      Value<double> pengeluaran,
      Value<double> saldoSetelah,
      Value<DateTime> dibuatPada,
    });

final class $$TransaksiTableReferences
    extends BaseReferences<_$AppDatabase, $TransaksiTable, TransaksiData> {
  $$TransaksiTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KategoriTable _kategoriIdTable(_$AppDatabase db) =>
      db.kategori.createAlias('transaksi__kategori_id__kategori__id');

  $$KategoriTableProcessedTableManager get kategoriId {
    final $_column = $_itemColumn<int>('kategori_id')!;

    final manager = $$KategoriTableTableManager(
      $_db,
      $_db.kategori,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kategoriIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransaksiTableFilterComposer
    extends Composer<_$AppDatabase, $TransaksiTable> {
  $$TransaksiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uraian => $composableBuilder(
    column: $table.uraian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pemasukan => $composableBuilder(
    column: $table.pemasukan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pengeluaran => $composableBuilder(
    column: $table.pengeluaran,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoSetelah => $composableBuilder(
    column: $table.saldoSetelah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  $$KategoriTableFilterComposer get kategoriId {
    final $$KategoriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableFilterComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaksiTableOrderingComposer
    extends Composer<_$AppDatabase, $TransaksiTable> {
  $$TransaksiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uraian => $composableBuilder(
    column: $table.uraian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pemasukan => $composableBuilder(
    column: $table.pemasukan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pengeluaran => $composableBuilder(
    column: $table.pengeluaran,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoSetelah => $composableBuilder(
    column: $table.saldoSetelah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  $$KategoriTableOrderingComposer get kategoriId {
    final $$KategoriTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableOrderingComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaksiTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransaksiTable> {
  $$TransaksiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get uraian =>
      $composableBuilder(column: $table.uraian, builder: (column) => column);

  GeneratedColumn<double> get pemasukan =>
      $composableBuilder(column: $table.pemasukan, builder: (column) => column);

  GeneratedColumn<double> get pengeluaran => $composableBuilder(
    column: $table.pengeluaran,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saldoSetelah => $composableBuilder(
    column: $table.saldoSetelah,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  $$KategoriTableAnnotationComposer get kategoriId {
    final $$KategoriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableAnnotationComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaksiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransaksiTable,
          TransaksiData,
          $$TransaksiTableFilterComposer,
          $$TransaksiTableOrderingComposer,
          $$TransaksiTableAnnotationComposer,
          $$TransaksiTableCreateCompanionBuilder,
          $$TransaksiTableUpdateCompanionBuilder,
          (TransaksiData, $$TransaksiTableReferences),
          TransaksiData,
          PrefetchHooks Function({bool kategoriId})
        > {
  $$TransaksiTableTableManager(_$AppDatabase db, $TransaksiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaksiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaksiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaksiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<int> kategoriId = const Value.absent(),
                Value<String> uraian = const Value.absent(),
                Value<double> pemasukan = const Value.absent(),
                Value<double> pengeluaran = const Value.absent(),
                Value<double> saldoSetelah = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => TransaksiCompanion(
                id: id,
                tanggal: tanggal,
                kategoriId: kategoriId,
                uraian: uraian,
                pemasukan: pemasukan,
                pengeluaran: pengeluaran,
                saldoSetelah: saldoSetelah,
                dibuatPada: dibuatPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime tanggal,
                required int kategoriId,
                required String uraian,
                Value<double> pemasukan = const Value.absent(),
                Value<double> pengeluaran = const Value.absent(),
                required double saldoSetelah,
                required DateTime dibuatPada,
              }) => TransaksiCompanion.insert(
                id: id,
                tanggal: tanggal,
                kategoriId: kategoriId,
                uraian: uraian,
                pemasukan: pemasukan,
                pengeluaran: pengeluaran,
                saldoSetelah: saldoSetelah,
                dibuatPada: dibuatPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransaksiTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kategoriId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kategoriId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kategoriId,
                                referencedTable: $$TransaksiTableReferences
                                    ._kategoriIdTable(db),
                                referencedColumn: $$TransaksiTableReferences
                                    ._kategoriIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransaksiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransaksiTable,
      TransaksiData,
      $$TransaksiTableFilterComposer,
      $$TransaksiTableOrderingComposer,
      $$TransaksiTableAnnotationComposer,
      $$TransaksiTableCreateCompanionBuilder,
      $$TransaksiTableUpdateCompanionBuilder,
      (TransaksiData, $$TransaksiTableReferences),
      TransaksiData,
      PrefetchHooks Function({bool kategoriId})
    >;
typedef $$HistorySaldoAkhirTableCreateCompanionBuilder =
    HistorySaldoAkhirCompanion Function({
      Value<int> id,
      required DateTime tanggalPeriode,
      required double saldoAkhir,
      required DateTime dicatatPada,
    });
typedef $$HistorySaldoAkhirTableUpdateCompanionBuilder =
    HistorySaldoAkhirCompanion Function({
      Value<int> id,
      Value<DateTime> tanggalPeriode,
      Value<double> saldoAkhir,
      Value<DateTime> dicatatPada,
    });

class $$HistorySaldoAkhirTableFilterComposer
    extends Composer<_$AppDatabase, $HistorySaldoAkhirTable> {
  $$HistorySaldoAkhirTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalPeriode => $composableBuilder(
    column: $table.tanggalPeriode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoAkhir => $composableBuilder(
    column: $table.saldoAkhir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dicatatPada => $composableBuilder(
    column: $table.dicatatPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistorySaldoAkhirTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorySaldoAkhirTable> {
  $$HistorySaldoAkhirTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalPeriode => $composableBuilder(
    column: $table.tanggalPeriode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoAkhir => $composableBuilder(
    column: $table.saldoAkhir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dicatatPada => $composableBuilder(
    column: $table.dicatatPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistorySaldoAkhirTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorySaldoAkhirTable> {
  $$HistorySaldoAkhirTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalPeriode => $composableBuilder(
    column: $table.tanggalPeriode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saldoAkhir => $composableBuilder(
    column: $table.saldoAkhir,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dicatatPada => $composableBuilder(
    column: $table.dicatatPada,
    builder: (column) => column,
  );
}

class $$HistorySaldoAkhirTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistorySaldoAkhirTable,
          HistorySaldoAkhirData,
          $$HistorySaldoAkhirTableFilterComposer,
          $$HistorySaldoAkhirTableOrderingComposer,
          $$HistorySaldoAkhirTableAnnotationComposer,
          $$HistorySaldoAkhirTableCreateCompanionBuilder,
          $$HistorySaldoAkhirTableUpdateCompanionBuilder,
          (
            HistorySaldoAkhirData,
            BaseReferences<
              _$AppDatabase,
              $HistorySaldoAkhirTable,
              HistorySaldoAkhirData
            >,
          ),
          HistorySaldoAkhirData,
          PrefetchHooks Function()
        > {
  $$HistorySaldoAkhirTableTableManager(
    _$AppDatabase db,
    $HistorySaldoAkhirTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistorySaldoAkhirTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistorySaldoAkhirTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistorySaldoAkhirTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> tanggalPeriode = const Value.absent(),
                Value<double> saldoAkhir = const Value.absent(),
                Value<DateTime> dicatatPada = const Value.absent(),
              }) => HistorySaldoAkhirCompanion(
                id: id,
                tanggalPeriode: tanggalPeriode,
                saldoAkhir: saldoAkhir,
                dicatatPada: dicatatPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime tanggalPeriode,
                required double saldoAkhir,
                required DateTime dicatatPada,
              }) => HistorySaldoAkhirCompanion.insert(
                id: id,
                tanggalPeriode: tanggalPeriode,
                saldoAkhir: saldoAkhir,
                dicatatPada: dicatatPada,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistorySaldoAkhirTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistorySaldoAkhirTable,
      HistorySaldoAkhirData,
      $$HistorySaldoAkhirTableFilterComposer,
      $$HistorySaldoAkhirTableOrderingComposer,
      $$HistorySaldoAkhirTableAnnotationComposer,
      $$HistorySaldoAkhirTableCreateCompanionBuilder,
      $$HistorySaldoAkhirTableUpdateCompanionBuilder,
      (
        HistorySaldoAkhirData,
        BaseReferences<
          _$AppDatabase,
          $HistorySaldoAkhirTable,
          HistorySaldoAkhirData
        >,
      ),
      HistorySaldoAkhirData,
      PrefetchHooks Function()
    >;
typedef $$SesiAktifTableCreateCompanionBuilder =
    SesiAktifCompanion Function({
      Value<int> id,
      required double saldoAwalInput,
      required double saldoMulai,
      Value<bool> sudahDiisi,
    });
typedef $$SesiAktifTableUpdateCompanionBuilder =
    SesiAktifCompanion Function({
      Value<int> id,
      Value<double> saldoAwalInput,
      Value<double> saldoMulai,
      Value<bool> sudahDiisi,
    });

class $$SesiAktifTableFilterComposer
    extends Composer<_$AppDatabase, $SesiAktifTable> {
  $$SesiAktifTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoAwalInput => $composableBuilder(
    column: $table.saldoAwalInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoMulai => $composableBuilder(
    column: $table.saldoMulai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sudahDiisi => $composableBuilder(
    column: $table.sudahDiisi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SesiAktifTableOrderingComposer
    extends Composer<_$AppDatabase, $SesiAktifTable> {
  $$SesiAktifTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoAwalInput => $composableBuilder(
    column: $table.saldoAwalInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoMulai => $composableBuilder(
    column: $table.saldoMulai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sudahDiisi => $composableBuilder(
    column: $table.sudahDiisi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SesiAktifTableAnnotationComposer
    extends Composer<_$AppDatabase, $SesiAktifTable> {
  $$SesiAktifTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get saldoAwalInput => $composableBuilder(
    column: $table.saldoAwalInput,
    builder: (column) => column,
  );

  GeneratedColumn<double> get saldoMulai => $composableBuilder(
    column: $table.saldoMulai,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sudahDiisi => $composableBuilder(
    column: $table.sudahDiisi,
    builder: (column) => column,
  );
}

class $$SesiAktifTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SesiAktifTable,
          SesiAktifData,
          $$SesiAktifTableFilterComposer,
          $$SesiAktifTableOrderingComposer,
          $$SesiAktifTableAnnotationComposer,
          $$SesiAktifTableCreateCompanionBuilder,
          $$SesiAktifTableUpdateCompanionBuilder,
          (
            SesiAktifData,
            BaseReferences<_$AppDatabase, $SesiAktifTable, SesiAktifData>,
          ),
          SesiAktifData,
          PrefetchHooks Function()
        > {
  $$SesiAktifTableTableManager(_$AppDatabase db, $SesiAktifTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SesiAktifTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SesiAktifTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SesiAktifTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> saldoAwalInput = const Value.absent(),
                Value<double> saldoMulai = const Value.absent(),
                Value<bool> sudahDiisi = const Value.absent(),
              }) => SesiAktifCompanion(
                id: id,
                saldoAwalInput: saldoAwalInput,
                saldoMulai: saldoMulai,
                sudahDiisi: sudahDiisi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double saldoAwalInput,
                required double saldoMulai,
                Value<bool> sudahDiisi = const Value.absent(),
              }) => SesiAktifCompanion.insert(
                id: id,
                saldoAwalInput: saldoAwalInput,
                saldoMulai: saldoMulai,
                sudahDiisi: sudahDiisi,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SesiAktifTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SesiAktifTable,
      SesiAktifData,
      $$SesiAktifTableFilterComposer,
      $$SesiAktifTableOrderingComposer,
      $$SesiAktifTableAnnotationComposer,
      $$SesiAktifTableCreateCompanionBuilder,
      $$SesiAktifTableUpdateCompanionBuilder,
      (
        SesiAktifData,
        BaseReferences<_$AppDatabase, $SesiAktifTable, SesiAktifData>,
      ),
      SesiAktifData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KategoriTableTableManager get kategori =>
      $$KategoriTableTableManager(_db, _db.kategori);
  $$TransaksiTableTableManager get transaksi =>
      $$TransaksiTableTableManager(_db, _db.transaksi);
  $$HistorySaldoAkhirTableTableManager get historySaldoAkhir =>
      $$HistorySaldoAkhirTableTableManager(_db, _db.historySaldoAkhir);
  $$SesiAktifTableTableManager get sesiAktif =>
      $$SesiAktifTableTableManager(_db, _db.sesiAktif);
}

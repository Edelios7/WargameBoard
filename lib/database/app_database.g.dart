// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GameSystemsTable extends GameSystems
    with TableInfo<$GameSystemsTable, GameSystem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameSystemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortNameMeta = const VerificationMeta(
    'shortName',
  );
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
    'short_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    shortName,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_systems';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameSystem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_name')) {
      context.handle(
        _shortNameMeta,
        shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameSystem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameSystem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      shortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_name'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GameSystemsTable createAlias(String alias) {
    return $GameSystemsTable(attachedDatabase, alias);
  }
}

class GameSystem extends DataClass implements Insertable<GameSystem> {
  final String id;
  final String name;
  final String? shortName;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GameSystem({
    required this.id,
    required this.name,
    this.shortName,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || shortName != null) {
      map['short_name'] = Variable<String>(shortName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GameSystemsCompanion toCompanion(bool nullToAbsent) {
    return GameSystemsCompanion(
      id: Value(id),
      name: Value(name),
      shortName: shortName == null && nullToAbsent
          ? const Value.absent()
          : Value(shortName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GameSystem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameSystem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shortName: serializer.fromJson<String?>(json['shortName']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'shortName': serializer.toJson<String?>(shortName),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GameSystem copyWith({
    String? id,
    String? name,
    Value<String?> shortName = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GameSystem(
    id: id ?? this.id,
    name: name ?? this.name,
    shortName: shortName.present ? shortName.value : this.shortName,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GameSystem copyWithCompanion(GameSystemsCompanion data) {
    return GameSystem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameSystem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    shortName,
    description,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameSystem &&
          other.id == this.id &&
          other.name == this.name &&
          other.shortName == this.shortName &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GameSystemsCompanion extends UpdateCompanion<GameSystem> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> shortName;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GameSystemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shortName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameSystemsCompanion.insert({
    required String id,
    required String name,
    this.shortName = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<GameSystem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? shortName,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shortName != null) 'short_name': shortName,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameSystemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? shortName,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GameSystemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortName.present) {
      map['short_name'] = Variable<String>(shortName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameSystemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EditionsTable extends Editions with TableInfo<$EditionsTable, Edition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameSystemIdMeta = const VerificationMeta(
    'gameSystemId',
  );
  @override
  late final GeneratedColumn<String> gameSystemId = GeneratedColumn<String>(
    'game_system_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameSystemId,
    name,
    version,
    isCurrent,
    releaseDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'editions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Edition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_system_id')) {
      context.handle(
        _gameSystemIdMeta,
        gameSystemId.isAcceptableOrUnknown(
          data['game_system_id']!,
          _gameSystemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gameSystemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Edition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Edition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameSystemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_system_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EditionsTable createAlias(String alias) {
    return $EditionsTable(attachedDatabase, alias);
  }
}

class Edition extends DataClass implements Insertable<Edition> {
  final String id;
  final String gameSystemId;
  final String name;
  final int version;
  final bool isCurrent;
  final DateTime? releaseDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Edition({
    required this.id,
    required this.gameSystemId,
    required this.name,
    required this.version,
    required this.isCurrent,
    this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_system_id'] = Variable<String>(gameSystemId);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<int>(version);
    map['is_current'] = Variable<bool>(isCurrent);
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EditionsCompanion toCompanion(bool nullToAbsent) {
    return EditionsCompanion(
      id: Value(id),
      gameSystemId: Value(gameSystemId),
      name: Value(name),
      version: Value(version),
      isCurrent: Value(isCurrent),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Edition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Edition(
      id: serializer.fromJson<String>(json['id']),
      gameSystemId: serializer.fromJson<String>(json['gameSystemId']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<int>(json['version']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameSystemId': serializer.toJson<String>(gameSystemId),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<int>(version),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Edition copyWith({
    String? id,
    String? gameSystemId,
    String? name,
    int? version,
    bool? isCurrent,
    Value<DateTime?> releaseDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Edition(
    id: id ?? this.id,
    gameSystemId: gameSystemId ?? this.gameSystemId,
    name: name ?? this.name,
    version: version ?? this.version,
    isCurrent: isCurrent ?? this.isCurrent,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Edition copyWithCompanion(EditionsCompanion data) {
    return Edition(
      id: data.id.present ? data.id.value : this.id,
      gameSystemId: data.gameSystemId.present
          ? data.gameSystemId.value
          : this.gameSystemId,
      name: data.name.present ? data.name.value : this.name,
      version: data.version.present ? data.version.value : this.version,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Edition(')
          ..write('id: $id, ')
          ..write('gameSystemId: $gameSystemId, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameSystemId,
    name,
    version,
    isCurrent,
    releaseDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Edition &&
          other.id == this.id &&
          other.gameSystemId == this.gameSystemId &&
          other.name == this.name &&
          other.version == this.version &&
          other.isCurrent == this.isCurrent &&
          other.releaseDate == this.releaseDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EditionsCompanion extends UpdateCompanion<Edition> {
  final Value<String> id;
  final Value<String> gameSystemId;
  final Value<String> name;
  final Value<int> version;
  final Value<bool> isCurrent;
  final Value<DateTime?> releaseDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EditionsCompanion({
    this.id = const Value.absent(),
    this.gameSystemId = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EditionsCompanion.insert({
    required String id,
    required String gameSystemId,
    required String name,
    required int version,
    this.isCurrent = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameSystemId = Value(gameSystemId),
       name = Value(name),
       version = Value(version);
  static Insertable<Edition> custom({
    Expression<String>? id,
    Expression<String>? gameSystemId,
    Expression<String>? name,
    Expression<int>? version,
    Expression<bool>? isCurrent,
    Expression<DateTime>? releaseDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameSystemId != null) 'game_system_id': gameSystemId,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (isCurrent != null) 'is_current': isCurrent,
      if (releaseDate != null) 'release_date': releaseDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameSystemId,
    Value<String>? name,
    Value<int>? version,
    Value<bool>? isCurrent,
    Value<DateTime?>? releaseDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EditionsCompanion(
      id: id ?? this.id,
      gameSystemId: gameSystemId ?? this.gameSystemId,
      name: name ?? this.name,
      version: version ?? this.version,
      isCurrent: isCurrent ?? this.isCurrent,
      releaseDate: releaseDate ?? this.releaseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameSystemId.present) {
      map['game_system_id'] = Variable<String>(gameSystemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditionsCompanion(')
          ..write('id: $id, ')
          ..write('gameSystemId: $gameSystemId, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameModesTable extends GameModes
    with TableInfo<$GameModesTable, GameMode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    editionId,
    name,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_modes';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameMode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameMode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameMode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GameModesTable createAlias(String alias) {
    return $GameModesTable(attachedDatabase, alias);
  }
}

class GameMode extends DataClass implements Insertable<GameMode> {
  final String id;
  final String editionId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GameMode({
    required this.id,
    required this.editionId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['edition_id'] = Variable<String>(editionId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GameModesCompanion toCompanion(bool nullToAbsent) {
    return GameModesCompanion(
      id: Value(id),
      editionId: Value(editionId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GameMode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameMode(
      id: serializer.fromJson<String>(json['id']),
      editionId: serializer.fromJson<String>(json['editionId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'editionId': serializer.toJson<String>(editionId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GameMode copyWith({
    String? id,
    String? editionId,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GameMode(
    id: id ?? this.id,
    editionId: editionId ?? this.editionId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GameMode copyWithCompanion(GameModesCompanion data) {
    return GameMode(
      id: data.id.present ? data.id.value : this.id,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameMode(')
          ..write('id: $id, ')
          ..write('editionId: $editionId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, editionId, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameMode &&
          other.id == this.id &&
          other.editionId == this.editionId &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GameModesCompanion extends UpdateCompanion<GameMode> {
  final Value<String> id;
  final Value<String> editionId;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GameModesCompanion({
    this.id = const Value.absent(),
    this.editionId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameModesCompanion.insert({
    required String id,
    required String editionId,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       editionId = Value(editionId),
       name = Value(name);
  static Insertable<GameMode> custom({
    Expression<String>? id,
    Expression<String>? editionId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (editionId != null) 'edition_id': editionId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameModesCompanion copyWith({
    Value<String>? id,
    Value<String>? editionId,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GameModesCompanion(
      id: id ?? this.id,
      editionId: editionId ?? this.editionId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameModesCompanion(')
          ..write('id: $id, ')
          ..write('editionId: $editionId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FactionsTable extends Factions with TableInfo<$FactionsTable, Faction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameSystemIdMeta = const VerificationMeta(
    'gameSystemId',
  );
  @override
  late final GeneratedColumn<String> gameSystemId = GeneratedColumn<String>(
    'game_system_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortNameMeta = const VerificationMeta(
    'shortName',
  );
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
    'short_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPlayableMeta = const VerificationMeta(
    'isPlayable',
  );
  @override
  late final GeneratedColumn<bool> isPlayable = GeneratedColumn<bool>(
    'is_playable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_playable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameSystemId,
    name,
    shortName,
    description,
    iconPath,
    displayOrder,
    isPlayable,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Faction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_system_id')) {
      context.handle(
        _gameSystemIdMeta,
        gameSystemId.isAcceptableOrUnknown(
          data['game_system_id']!,
          _gameSystemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gameSystemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_name')) {
      context.handle(
        _shortNameMeta,
        shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('is_playable')) {
      context.handle(
        _isPlayableMeta,
        isPlayable.isAcceptableOrUnknown(data['is_playable']!, _isPlayableMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Faction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Faction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameSystemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_system_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      shortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_name'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isPlayable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_playable'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FactionsTable createAlias(String alias) {
    return $FactionsTable(attachedDatabase, alias);
  }
}

class Faction extends DataClass implements Insertable<Faction> {
  final String id;
  final String gameSystemId;
  final String name;
  final String? shortName;
  final String? description;
  final String? iconPath;
  final int displayOrder;
  final bool isPlayable;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Faction({
    required this.id,
    required this.gameSystemId,
    required this.name,
    this.shortName,
    this.description,
    this.iconPath,
    required this.displayOrder,
    required this.isPlayable,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_system_id'] = Variable<String>(gameSystemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || shortName != null) {
      map['short_name'] = Variable<String>(shortName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['is_playable'] = Variable<bool>(isPlayable);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FactionsCompanion toCompanion(bool nullToAbsent) {
    return FactionsCompanion(
      id: Value(id),
      gameSystemId: Value(gameSystemId),
      name: Value(name),
      shortName: shortName == null && nullToAbsent
          ? const Value.absent()
          : Value(shortName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      displayOrder: Value(displayOrder),
      isPlayable: Value(isPlayable),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Faction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Faction(
      id: serializer.fromJson<String>(json['id']),
      gameSystemId: serializer.fromJson<String>(json['gameSystemId']),
      name: serializer.fromJson<String>(json['name']),
      shortName: serializer.fromJson<String?>(json['shortName']),
      description: serializer.fromJson<String?>(json['description']),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isPlayable: serializer.fromJson<bool>(json['isPlayable']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameSystemId': serializer.toJson<String>(gameSystemId),
      'name': serializer.toJson<String>(name),
      'shortName': serializer.toJson<String?>(shortName),
      'description': serializer.toJson<String?>(description),
      'iconPath': serializer.toJson<String?>(iconPath),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isPlayable': serializer.toJson<bool>(isPlayable),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Faction copyWith({
    String? id,
    String? gameSystemId,
    String? name,
    Value<String?> shortName = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> iconPath = const Value.absent(),
    int? displayOrder,
    bool? isPlayable,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Faction(
    id: id ?? this.id,
    gameSystemId: gameSystemId ?? this.gameSystemId,
    name: name ?? this.name,
    shortName: shortName.present ? shortName.value : this.shortName,
    description: description.present ? description.value : this.description,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    displayOrder: displayOrder ?? this.displayOrder,
    isPlayable: isPlayable ?? this.isPlayable,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Faction copyWithCompanion(FactionsCompanion data) {
    return Faction(
      id: data.id.present ? data.id.value : this.id,
      gameSystemId: data.gameSystemId.present
          ? data.gameSystemId.value
          : this.gameSystemId,
      name: data.name.present ? data.name.value : this.name,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isPlayable: data.isPlayable.present
          ? data.isPlayable.value
          : this.isPlayable,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Faction(')
          ..write('id: $id, ')
          ..write('gameSystemId: $gameSystemId, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('description: $description, ')
          ..write('iconPath: $iconPath, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isPlayable: $isPlayable, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameSystemId,
    name,
    shortName,
    description,
    iconPath,
    displayOrder,
    isPlayable,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Faction &&
          other.id == this.id &&
          other.gameSystemId == this.gameSystemId &&
          other.name == this.name &&
          other.shortName == this.shortName &&
          other.description == this.description &&
          other.iconPath == this.iconPath &&
          other.displayOrder == this.displayOrder &&
          other.isPlayable == this.isPlayable &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FactionsCompanion extends UpdateCompanion<Faction> {
  final Value<String> id;
  final Value<String> gameSystemId;
  final Value<String> name;
  final Value<String?> shortName;
  final Value<String?> description;
  final Value<String?> iconPath;
  final Value<int> displayOrder;
  final Value<bool> isPlayable;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FactionsCompanion({
    this.id = const Value.absent(),
    this.gameSystemId = const Value.absent(),
    this.name = const Value.absent(),
    this.shortName = const Value.absent(),
    this.description = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isPlayable = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FactionsCompanion.insert({
    required String id,
    required String gameSystemId,
    required String name,
    this.shortName = const Value.absent(),
    this.description = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isPlayable = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameSystemId = Value(gameSystemId),
       name = Value(name);
  static Insertable<Faction> custom({
    Expression<String>? id,
    Expression<String>? gameSystemId,
    Expression<String>? name,
    Expression<String>? shortName,
    Expression<String>? description,
    Expression<String>? iconPath,
    Expression<int>? displayOrder,
    Expression<bool>? isPlayable,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameSystemId != null) 'game_system_id': gameSystemId,
      if (name != null) 'name': name,
      if (shortName != null) 'short_name': shortName,
      if (description != null) 'description': description,
      if (iconPath != null) 'icon_path': iconPath,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isPlayable != null) 'is_playable': isPlayable,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameSystemId,
    Value<String>? name,
    Value<String?>? shortName,
    Value<String?>? description,
    Value<String?>? iconPath,
    Value<int>? displayOrder,
    Value<bool>? isPlayable,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FactionsCompanion(
      id: id ?? this.id,
      gameSystemId: gameSystemId ?? this.gameSystemId,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      displayOrder: displayOrder ?? this.displayOrder,
      isPlayable: isPlayable ?? this.isPlayable,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameSystemId.present) {
      map['game_system_id'] = Variable<String>(gameSystemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortName.present) {
      map['short_name'] = Variable<String>(shortName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isPlayable.present) {
      map['is_playable'] = Variable<bool>(isPlayable.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FactionsCompanion(')
          ..write('id: $id, ')
          ..write('gameSystemId: $gameSystemId, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('description: $description, ')
          ..write('iconPath: $iconPath, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isPlayable: $isPlayable, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubFactionsTable extends SubFactions
    with TableInfo<$SubFactionsTable, SubFaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubFactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factionIdMeta = const VerificationMeta(
    'factionId',
  );
  @override
  late final GeneratedColumn<String> factionId = GeneratedColumn<String>(
    'faction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPlayableMeta = const VerificationMeta(
    'isPlayable',
  );
  @override
  late final GeneratedColumn<bool> isPlayable = GeneratedColumn<bool>(
    'is_playable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_playable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    factionId,
    name,
    description,
    iconPath,
    isDefault,
    isPlayable,
    displayOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_factions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubFaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('faction_id')) {
      context.handle(
        _factionIdMeta,
        factionId.isAcceptableOrUnknown(data['faction_id']!, _factionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_factionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_playable')) {
      context.handle(
        _isPlayableMeta,
        isPlayable.isAcceptableOrUnknown(data['is_playable']!, _isPlayableMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubFaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubFaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      factionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faction_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isPlayable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_playable'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubFactionsTable createAlias(String alias) {
    return $SubFactionsTable(attachedDatabase, alias);
  }
}

class SubFaction extends DataClass implements Insertable<SubFaction> {
  final String id;
  final String factionId;
  final String name;
  final String? description;
  final String? iconPath;
  final bool isDefault;
  final bool isPlayable;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubFaction({
    required this.id,
    required this.factionId,
    required this.name,
    this.description,
    this.iconPath,
    required this.isDefault,
    required this.isPlayable,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['faction_id'] = Variable<String>(factionId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['is_playable'] = Variable<bool>(isPlayable);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubFactionsCompanion toCompanion(bool nullToAbsent) {
    return SubFactionsCompanion(
      id: Value(id),
      factionId: Value(factionId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      isDefault: Value(isDefault),
      isPlayable: Value(isPlayable),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubFaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubFaction(
      id: serializer.fromJson<String>(json['id']),
      factionId: serializer.fromJson<String>(json['factionId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isPlayable: serializer.fromJson<bool>(json['isPlayable']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'factionId': serializer.toJson<String>(factionId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'iconPath': serializer.toJson<String?>(iconPath),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isPlayable': serializer.toJson<bool>(isPlayable),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubFaction copyWith({
    String? id,
    String? factionId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> iconPath = const Value.absent(),
    bool? isDefault,
    bool? isPlayable,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SubFaction(
    id: id ?? this.id,
    factionId: factionId ?? this.factionId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    isDefault: isDefault ?? this.isDefault,
    isPlayable: isPlayable ?? this.isPlayable,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubFaction copyWithCompanion(SubFactionsCompanion data) {
    return SubFaction(
      id: data.id.present ? data.id.value : this.id,
      factionId: data.factionId.present ? data.factionId.value : this.factionId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isPlayable: data.isPlayable.present
          ? data.isPlayable.value
          : this.isPlayable,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubFaction(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconPath: $iconPath, ')
          ..write('isDefault: $isDefault, ')
          ..write('isPlayable: $isPlayable, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    factionId,
    name,
    description,
    iconPath,
    isDefault,
    isPlayable,
    displayOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubFaction &&
          other.id == this.id &&
          other.factionId == this.factionId &&
          other.name == this.name &&
          other.description == this.description &&
          other.iconPath == this.iconPath &&
          other.isDefault == this.isDefault &&
          other.isPlayable == this.isPlayable &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubFactionsCompanion extends UpdateCompanion<SubFaction> {
  final Value<String> id;
  final Value<String> factionId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> iconPath;
  final Value<bool> isDefault;
  final Value<bool> isPlayable;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubFactionsCompanion({
    this.id = const Value.absent(),
    this.factionId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isPlayable = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubFactionsCompanion.insert({
    required String id,
    required String factionId,
    required String name,
    this.description = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isPlayable = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       factionId = Value(factionId),
       name = Value(name);
  static Insertable<SubFaction> custom({
    Expression<String>? id,
    Expression<String>? factionId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? iconPath,
    Expression<bool>? isDefault,
    Expression<bool>? isPlayable,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (factionId != null) 'faction_id': factionId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconPath != null) 'icon_path': iconPath,
      if (isDefault != null) 'is_default': isDefault,
      if (isPlayable != null) 'is_playable': isPlayable,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubFactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? factionId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? iconPath,
    Value<bool>? isDefault,
    Value<bool>? isPlayable,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubFactionsCompanion(
      id: id ?? this.id,
      factionId: factionId ?? this.factionId,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isDefault: isDefault ?? this.isDefault,
      isPlayable: isPlayable ?? this.isPlayable,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (factionId.present) {
      map['faction_id'] = Variable<String>(factionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isPlayable.present) {
      map['is_playable'] = Variable<bool>(isPlayable.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubFactionsCompanion(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconPath: $iconPath, ')
          ..write('isDefault: $isDefault, ')
          ..write('isPlayable: $isPlayable, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeywordsTable extends Keywords with TableInfo<$KeywordsTable, Keyword> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeywordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCoreMeta = const VerificationMeta('isCore');
  @override
  late final GeneratedColumn<bool> isCore = GeneratedColumn<bool>(
    'is_core',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_core" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    isCore,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keywords';
  @override
  VerificationContext validateIntegrity(
    Insertable<Keyword> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_core')) {
      context.handle(
        _isCoreMeta,
        isCore.isAcceptableOrUnknown(data['is_core']!, _isCoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Keyword map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Keyword(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isCore: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_core'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KeywordsTable createAlias(String alias) {
    return $KeywordsTable(attachedDatabase, alias);
  }
}

class Keyword extends DataClass implements Insertable<Keyword> {
  final String id;
  final String name;
  final String? description;
  final bool isCore;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Keyword({
    required this.id,
    required this.name,
    this.description,
    required this.isCore,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_core'] = Variable<bool>(isCore);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KeywordsCompanion toCompanion(bool nullToAbsent) {
    return KeywordsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCore: Value(isCore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Keyword.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Keyword(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isCore: serializer.fromJson<bool>(json['isCore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isCore': serializer.toJson<bool>(isCore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Keyword copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isCore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Keyword(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isCore: isCore ?? this.isCore,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Keyword copyWithCompanion(KeywordsCompanion data) {
    return Keyword(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCore: data.isCore.present ? data.isCore.value : this.isCore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Keyword(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isCore: $isCore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, isCore, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Keyword &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isCore == this.isCore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KeywordsCompanion extends UpdateCompanion<Keyword> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isCore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KeywordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isCore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeywordsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.isCore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Keyword> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? isCore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isCore != null) 'is_core': isCore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeywordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isCore,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KeywordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCore: isCore ?? this.isCore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCore.present) {
      map['is_core'] = Variable<bool>(isCore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeywordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isCore: $isCore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AbilitiesTable extends Abilities
    with TableInfo<$AbilitiesTable, Ability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCoreMeta = const VerificationMeta('isCore');
  @override
  late final GeneratedColumn<bool> isCore = GeneratedColumn<bool>(
    'is_core',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_core" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    type,
    isCore,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'abilities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ability> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('is_core')) {
      context.handle(
        _isCoreMeta,
        isCore.isAcceptableOrUnknown(data['is_core']!, _isCoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ability(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      isCore: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_core'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AbilitiesTable createAlias(String alias) {
    return $AbilitiesTable(attachedDatabase, alias);
  }
}

class Ability extends DataClass implements Insertable<Ability> {
  final String id;
  final String name;
  final String description;
  final String? type;
  final bool isCore;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Ability({
    required this.id,
    required this.name,
    required this.description,
    this.type,
    required this.isCore,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['is_core'] = Variable<bool>(isCore);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AbilitiesCompanion toCompanion(bool nullToAbsent) {
    return AbilitiesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      isCore: Value(isCore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Ability.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ability(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String?>(json['type']),
      isCore: serializer.fromJson<bool>(json['isCore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String?>(type),
      'isCore': serializer.toJson<bool>(isCore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Ability copyWith({
    String? id,
    String? name,
    String? description,
    Value<String?> type = const Value.absent(),
    bool? isCore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Ability(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    type: type.present ? type.value : this.type,
    isCore: isCore ?? this.isCore,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Ability copyWithCompanion(AbilitiesCompanion data) {
    return Ability(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      isCore: data.isCore.present ? data.isCore.value : this.isCore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ability(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('isCore: $isCore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, type, isCore, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ability &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.type == this.type &&
          other.isCore == this.isCore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AbilitiesCompanion extends UpdateCompanion<Ability> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> type;
  final Value<bool> isCore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AbilitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.isCore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AbilitiesCompanion.insert({
    required String id,
    required String name,
    required String description,
    this.type = const Value.absent(),
    this.isCore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description);
  static Insertable<Ability> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? type,
    Expression<bool>? isCore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (isCore != null) 'is_core': isCore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AbilitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? type,
    Value<bool>? isCore,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AbilitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      isCore: isCore ?? this.isCore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isCore.present) {
      map['is_core'] = Variable<bool>(isCore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbilitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('isCore: $isCore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetsTable extends Datasheets
    with TableInfo<$DatasheetsTable, Datasheet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factionIdMeta = const VerificationMeta(
    'factionId',
  );
  @override
  late final GeneratedColumn<String> factionId = GeneratedColumn<String>(
    'faction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subFactionIdMeta = const VerificationMeta(
    'subFactionId',
  );
  @override
  late final GeneratedColumn<String> subFactionId = GeneratedColumn<String>(
    'sub_faction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _battlefieldRoleMeta = const VerificationMeta(
    'battlefieldRole',
  );
  @override
  late final GeneratedColumn<String> battlefieldRole = GeneratedColumn<String>(
    'battlefield_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNamedCharacterMeta = const VerificationMeta(
    'isNamedCharacter',
  );
  @override
  late final GeneratedColumn<bool> isNamedCharacter = GeneratedColumn<bool>(
    'is_named_character',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_named_character" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isEpicHeroMeta = const VerificationMeta(
    'isEpicHero',
  );
  @override
  late final GeneratedColumn<bool> isEpicHero = GeneratedColumn<bool>(
    'is_epic_hero',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_epic_hero" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLegendMeta = const VerificationMeta(
    'isLegend',
  );
  @override
  late final GeneratedColumn<bool> isLegend = GeneratedColumn<bool>(
    'is_legend',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_legend" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    factionId,
    subFactionId,
    name,
    battlefieldRole,
    unitType,
    isNamedCharacter,
    isEpicHero,
    isLegend,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Datasheet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('faction_id')) {
      context.handle(
        _factionIdMeta,
        factionId.isAcceptableOrUnknown(data['faction_id']!, _factionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_factionIdMeta);
    }
    if (data.containsKey('sub_faction_id')) {
      context.handle(
        _subFactionIdMeta,
        subFactionId.isAcceptableOrUnknown(
          data['sub_faction_id']!,
          _subFactionIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('battlefield_role')) {
      context.handle(
        _battlefieldRoleMeta,
        battlefieldRole.isAcceptableOrUnknown(
          data['battlefield_role']!,
          _battlefieldRoleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_battlefieldRoleMeta);
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_unitTypeMeta);
    }
    if (data.containsKey('is_named_character')) {
      context.handle(
        _isNamedCharacterMeta,
        isNamedCharacter.isAcceptableOrUnknown(
          data['is_named_character']!,
          _isNamedCharacterMeta,
        ),
      );
    }
    if (data.containsKey('is_epic_hero')) {
      context.handle(
        _isEpicHeroMeta,
        isEpicHero.isAcceptableOrUnknown(
          data['is_epic_hero']!,
          _isEpicHeroMeta,
        ),
      );
    }
    if (data.containsKey('is_legend')) {
      context.handle(
        _isLegendMeta,
        isLegend.isAcceptableOrUnknown(data['is_legend']!, _isLegendMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Datasheet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Datasheet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      factionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faction_id'],
      )!,
      subFactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_faction_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      battlefieldRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}battlefield_role'],
      )!,
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      )!,
      isNamedCharacter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_named_character'],
      )!,
      isEpicHero: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_epic_hero'],
      )!,
      isLegend: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_legend'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DatasheetsTable createAlias(String alias) {
    return $DatasheetsTable(attachedDatabase, alias);
  }
}

class Datasheet extends DataClass implements Insertable<Datasheet> {
  final String id;
  final String factionId;
  final String? subFactionId;
  final String name;
  final String battlefieldRole;
  final String unitType;
  final bool isNamedCharacter;
  final bool isEpicHero;
  final bool isLegend;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Datasheet({
    required this.id,
    required this.factionId,
    this.subFactionId,
    required this.name,
    required this.battlefieldRole,
    required this.unitType,
    required this.isNamedCharacter,
    required this.isEpicHero,
    required this.isLegend,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['faction_id'] = Variable<String>(factionId);
    if (!nullToAbsent || subFactionId != null) {
      map['sub_faction_id'] = Variable<String>(subFactionId);
    }
    map['name'] = Variable<String>(name);
    map['battlefield_role'] = Variable<String>(battlefieldRole);
    map['unit_type'] = Variable<String>(unitType);
    map['is_named_character'] = Variable<bool>(isNamedCharacter);
    map['is_epic_hero'] = Variable<bool>(isEpicHero);
    map['is_legend'] = Variable<bool>(isLegend);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DatasheetsCompanion toCompanion(bool nullToAbsent) {
    return DatasheetsCompanion(
      id: Value(id),
      factionId: Value(factionId),
      subFactionId: subFactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(subFactionId),
      name: Value(name),
      battlefieldRole: Value(battlefieldRole),
      unitType: Value(unitType),
      isNamedCharacter: Value(isNamedCharacter),
      isEpicHero: Value(isEpicHero),
      isLegend: Value(isLegend),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Datasheet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Datasheet(
      id: serializer.fromJson<String>(json['id']),
      factionId: serializer.fromJson<String>(json['factionId']),
      subFactionId: serializer.fromJson<String?>(json['subFactionId']),
      name: serializer.fromJson<String>(json['name']),
      battlefieldRole: serializer.fromJson<String>(json['battlefieldRole']),
      unitType: serializer.fromJson<String>(json['unitType']),
      isNamedCharacter: serializer.fromJson<bool>(json['isNamedCharacter']),
      isEpicHero: serializer.fromJson<bool>(json['isEpicHero']),
      isLegend: serializer.fromJson<bool>(json['isLegend']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'factionId': serializer.toJson<String>(factionId),
      'subFactionId': serializer.toJson<String?>(subFactionId),
      'name': serializer.toJson<String>(name),
      'battlefieldRole': serializer.toJson<String>(battlefieldRole),
      'unitType': serializer.toJson<String>(unitType),
      'isNamedCharacter': serializer.toJson<bool>(isNamedCharacter),
      'isEpicHero': serializer.toJson<bool>(isEpicHero),
      'isLegend': serializer.toJson<bool>(isLegend),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Datasheet copyWith({
    String? id,
    String? factionId,
    Value<String?> subFactionId = const Value.absent(),
    String? name,
    String? battlefieldRole,
    String? unitType,
    bool? isNamedCharacter,
    bool? isEpicHero,
    bool? isLegend,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Datasheet(
    id: id ?? this.id,
    factionId: factionId ?? this.factionId,
    subFactionId: subFactionId.present ? subFactionId.value : this.subFactionId,
    name: name ?? this.name,
    battlefieldRole: battlefieldRole ?? this.battlefieldRole,
    unitType: unitType ?? this.unitType,
    isNamedCharacter: isNamedCharacter ?? this.isNamedCharacter,
    isEpicHero: isEpicHero ?? this.isEpicHero,
    isLegend: isLegend ?? this.isLegend,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Datasheet copyWithCompanion(DatasheetsCompanion data) {
    return Datasheet(
      id: data.id.present ? data.id.value : this.id,
      factionId: data.factionId.present ? data.factionId.value : this.factionId,
      subFactionId: data.subFactionId.present
          ? data.subFactionId.value
          : this.subFactionId,
      name: data.name.present ? data.name.value : this.name,
      battlefieldRole: data.battlefieldRole.present
          ? data.battlefieldRole.value
          : this.battlefieldRole,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      isNamedCharacter: data.isNamedCharacter.present
          ? data.isNamedCharacter.value
          : this.isNamedCharacter,
      isEpicHero: data.isEpicHero.present
          ? data.isEpicHero.value
          : this.isEpicHero,
      isLegend: data.isLegend.present ? data.isLegend.value : this.isLegend,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Datasheet(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('subFactionId: $subFactionId, ')
          ..write('name: $name, ')
          ..write('battlefieldRole: $battlefieldRole, ')
          ..write('unitType: $unitType, ')
          ..write('isNamedCharacter: $isNamedCharacter, ')
          ..write('isEpicHero: $isEpicHero, ')
          ..write('isLegend: $isLegend, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    factionId,
    subFactionId,
    name,
    battlefieldRole,
    unitType,
    isNamedCharacter,
    isEpicHero,
    isLegend,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Datasheet &&
          other.id == this.id &&
          other.factionId == this.factionId &&
          other.subFactionId == this.subFactionId &&
          other.name == this.name &&
          other.battlefieldRole == this.battlefieldRole &&
          other.unitType == this.unitType &&
          other.isNamedCharacter == this.isNamedCharacter &&
          other.isEpicHero == this.isEpicHero &&
          other.isLegend == this.isLegend &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DatasheetsCompanion extends UpdateCompanion<Datasheet> {
  final Value<String> id;
  final Value<String> factionId;
  final Value<String?> subFactionId;
  final Value<String> name;
  final Value<String> battlefieldRole;
  final Value<String> unitType;
  final Value<bool> isNamedCharacter;
  final Value<bool> isEpicHero;
  final Value<bool> isLegend;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DatasheetsCompanion({
    this.id = const Value.absent(),
    this.factionId = const Value.absent(),
    this.subFactionId = const Value.absent(),
    this.name = const Value.absent(),
    this.battlefieldRole = const Value.absent(),
    this.unitType = const Value.absent(),
    this.isNamedCharacter = const Value.absent(),
    this.isEpicHero = const Value.absent(),
    this.isLegend = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetsCompanion.insert({
    required String id,
    required String factionId,
    this.subFactionId = const Value.absent(),
    required String name,
    required String battlefieldRole,
    required String unitType,
    this.isNamedCharacter = const Value.absent(),
    this.isEpicHero = const Value.absent(),
    this.isLegend = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       factionId = Value(factionId),
       name = Value(name),
       battlefieldRole = Value(battlefieldRole),
       unitType = Value(unitType);
  static Insertable<Datasheet> custom({
    Expression<String>? id,
    Expression<String>? factionId,
    Expression<String>? subFactionId,
    Expression<String>? name,
    Expression<String>? battlefieldRole,
    Expression<String>? unitType,
    Expression<bool>? isNamedCharacter,
    Expression<bool>? isEpicHero,
    Expression<bool>? isLegend,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (factionId != null) 'faction_id': factionId,
      if (subFactionId != null) 'sub_faction_id': subFactionId,
      if (name != null) 'name': name,
      if (battlefieldRole != null) 'battlefield_role': battlefieldRole,
      if (unitType != null) 'unit_type': unitType,
      if (isNamedCharacter != null) 'is_named_character': isNamedCharacter,
      if (isEpicHero != null) 'is_epic_hero': isEpicHero,
      if (isLegend != null) 'is_legend': isLegend,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetsCompanion copyWith({
    Value<String>? id,
    Value<String>? factionId,
    Value<String?>? subFactionId,
    Value<String>? name,
    Value<String>? battlefieldRole,
    Value<String>? unitType,
    Value<bool>? isNamedCharacter,
    Value<bool>? isEpicHero,
    Value<bool>? isLegend,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DatasheetsCompanion(
      id: id ?? this.id,
      factionId: factionId ?? this.factionId,
      subFactionId: subFactionId ?? this.subFactionId,
      name: name ?? this.name,
      battlefieldRole: battlefieldRole ?? this.battlefieldRole,
      unitType: unitType ?? this.unitType,
      isNamedCharacter: isNamedCharacter ?? this.isNamedCharacter,
      isEpicHero: isEpicHero ?? this.isEpicHero,
      isLegend: isLegend ?? this.isLegend,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (factionId.present) {
      map['faction_id'] = Variable<String>(factionId.value);
    }
    if (subFactionId.present) {
      map['sub_faction_id'] = Variable<String>(subFactionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (battlefieldRole.present) {
      map['battlefield_role'] = Variable<String>(battlefieldRole.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (isNamedCharacter.present) {
      map['is_named_character'] = Variable<bool>(isNamedCharacter.value);
    }
    if (isEpicHero.present) {
      map['is_epic_hero'] = Variable<bool>(isEpicHero.value);
    }
    if (isLegend.present) {
      map['is_legend'] = Variable<bool>(isLegend.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetsCompanion(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('subFactionId: $subFactionId, ')
          ..write('name: $name, ')
          ..write('battlefieldRole: $battlefieldRole, ')
          ..write('unitType: $unitType, ')
          ..write('isNamedCharacter: $isNamedCharacter, ')
          ..write('isEpicHero: $isEpicHero, ')
          ..write('isLegend: $isLegend, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetModelsTable extends DatasheetModels
    with TableInfo<$DatasheetModelsTable, DatasheetModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetModelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLeaderMeta = const VerificationMeta(
    'isLeader',
  );
  @override
  late final GeneratedColumn<bool> isLeader = GeneratedColumn<bool>(
    'is_leader',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_leader" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isChampionMeta = const VerificationMeta(
    'isChampion',
  );
  @override
  late final GeneratedColumn<bool> isChampion = GeneratedColumn<bool>(
    'is_champion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_champion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    name,
    displayOrder,
    isLeader,
    isChampion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_models';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('is_leader')) {
      context.handle(
        _isLeaderMeta,
        isLeader.isAcceptableOrUnknown(data['is_leader']!, _isLeaderMeta),
      );
    }
    if (data.containsKey('is_champion')) {
      context.handle(
        _isChampionMeta,
        isChampion.isAcceptableOrUnknown(data['is_champion']!, _isChampionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isLeader: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_leader'],
      )!,
      isChampion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_champion'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DatasheetModelsTable createAlias(String alias) {
    return $DatasheetModelsTable(attachedDatabase, alias);
  }
}

class DatasheetModel extends DataClass implements Insertable<DatasheetModel> {
  final String id;
  final String datasheetId;
  final String name;
  final int displayOrder;
  final bool isLeader;
  final bool isChampion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DatasheetModel({
    required this.id,
    required this.datasheetId,
    required this.name,
    required this.displayOrder,
    required this.isLeader,
    required this.isChampion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['name'] = Variable<String>(name);
    map['display_order'] = Variable<int>(displayOrder);
    map['is_leader'] = Variable<bool>(isLeader);
    map['is_champion'] = Variable<bool>(isChampion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DatasheetModelsCompanion toCompanion(bool nullToAbsent) {
    return DatasheetModelsCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      name: Value(name),
      displayOrder: Value(displayOrder),
      isLeader: Value(isLeader),
      isChampion: Value(isChampion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DatasheetModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetModel(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      name: serializer.fromJson<String>(json['name']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isLeader: serializer.fromJson<bool>(json['isLeader']),
      isChampion: serializer.fromJson<bool>(json['isChampion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'name': serializer.toJson<String>(name),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isLeader': serializer.toJson<bool>(isLeader),
      'isChampion': serializer.toJson<bool>(isChampion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DatasheetModel copyWith({
    String? id,
    String? datasheetId,
    String? name,
    int? displayOrder,
    bool? isLeader,
    bool? isChampion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DatasheetModel(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    name: name ?? this.name,
    displayOrder: displayOrder ?? this.displayOrder,
    isLeader: isLeader ?? this.isLeader,
    isChampion: isChampion ?? this.isChampion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DatasheetModel copyWithCompanion(DatasheetModelsCompanion data) {
    return DatasheetModel(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      name: data.name.present ? data.name.value : this.name,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isLeader: data.isLeader.present ? data.isLeader.value : this.isLeader,
      isChampion: data.isChampion.present
          ? data.isChampion.value
          : this.isChampion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetModel(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('name: $name, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isLeader: $isLeader, ')
          ..write('isChampion: $isChampion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetId,
    name,
    displayOrder,
    isLeader,
    isChampion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetModel &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.name == this.name &&
          other.displayOrder == this.displayOrder &&
          other.isLeader == this.isLeader &&
          other.isChampion == this.isChampion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DatasheetModelsCompanion extends UpdateCompanion<DatasheetModel> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> name;
  final Value<int> displayOrder;
  final Value<bool> isLeader;
  final Value<bool> isChampion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DatasheetModelsCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.name = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isLeader = const Value.absent(),
    this.isChampion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetModelsCompanion.insert({
    required String id,
    required String datasheetId,
    required String name,
    this.displayOrder = const Value.absent(),
    this.isLeader = const Value.absent(),
    this.isChampion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       name = Value(name);
  static Insertable<DatasheetModel> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? name,
    Expression<int>? displayOrder,
    Expression<bool>? isLeader,
    Expression<bool>? isChampion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (name != null) 'name': name,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isLeader != null) 'is_leader': isLeader,
      if (isChampion != null) 'is_champion': isChampion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetModelsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? name,
    Value<int>? displayOrder,
    Value<bool>? isLeader,
    Value<bool>? isChampion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DatasheetModelsCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      isLeader: isLeader ?? this.isLeader,
      isChampion: isChampion ?? this.isChampion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isLeader.present) {
      map['is_leader'] = Variable<bool>(isLeader.value);
    }
    if (isChampion.present) {
      map['is_champion'] = Variable<bool>(isChampion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetModelsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('name: $name, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isLeader: $isLeader, ')
          ..write('isChampion: $isChampion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelProfilesTable extends ModelProfiles
    with TableInfo<$ModelProfilesTable, ModelProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetModelIdMeta = const VerificationMeta(
    'datasheetModelId',
  );
  @override
  late final GeneratedColumn<String> datasheetModelId = GeneratedColumn<String>(
    'datasheet_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movementMeta = const VerificationMeta(
    'movement',
  );
  @override
  late final GeneratedColumn<int> movement = GeneratedColumn<int>(
    'movement',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toughnessMeta = const VerificationMeta(
    'toughness',
  );
  @override
  late final GeneratedColumn<int> toughness = GeneratedColumn<int>(
    'toughness',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saveMeta = const VerificationMeta('save');
  @override
  late final GeneratedColumn<int> save = GeneratedColumn<int>(
    'save',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _woundsMeta = const VerificationMeta('wounds');
  @override
  late final GeneratedColumn<int> wounds = GeneratedColumn<int>(
    'wounds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leadershipMeta = const VerificationMeta(
    'leadership',
  );
  @override
  late final GeneratedColumn<int> leadership = GeneratedColumn<int>(
    'leadership',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectiveControlMeta = const VerificationMeta(
    'objectiveControl',
  );
  @override
  late final GeneratedColumn<int> objectiveControl = GeneratedColumn<int>(
    'objective_control',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetModelId,
    name,
    movement,
    toughness,
    save,
    wounds,
    leadership,
    objectiveControl,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_model_id')) {
      context.handle(
        _datasheetModelIdMeta,
        datasheetModelId.isAcceptableOrUnknown(
          data['datasheet_model_id']!,
          _datasheetModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetModelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('movement')) {
      context.handle(
        _movementMeta,
        movement.isAcceptableOrUnknown(data['movement']!, _movementMeta),
      );
    } else if (isInserting) {
      context.missing(_movementMeta);
    }
    if (data.containsKey('toughness')) {
      context.handle(
        _toughnessMeta,
        toughness.isAcceptableOrUnknown(data['toughness']!, _toughnessMeta),
      );
    } else if (isInserting) {
      context.missing(_toughnessMeta);
    }
    if (data.containsKey('save')) {
      context.handle(
        _saveMeta,
        save.isAcceptableOrUnknown(data['save']!, _saveMeta),
      );
    } else if (isInserting) {
      context.missing(_saveMeta);
    }
    if (data.containsKey('wounds')) {
      context.handle(
        _woundsMeta,
        wounds.isAcceptableOrUnknown(data['wounds']!, _woundsMeta),
      );
    } else if (isInserting) {
      context.missing(_woundsMeta);
    }
    if (data.containsKey('leadership')) {
      context.handle(
        _leadershipMeta,
        leadership.isAcceptableOrUnknown(data['leadership']!, _leadershipMeta),
      );
    } else if (isInserting) {
      context.missing(_leadershipMeta);
    }
    if (data.containsKey('objective_control')) {
      context.handle(
        _objectiveControlMeta,
        objectiveControl.isAcceptableOrUnknown(
          data['objective_control']!,
          _objectiveControlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objectiveControlMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_model_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      movement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movement'],
      )!,
      toughness: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}toughness'],
      )!,
      save: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}save'],
      )!,
      wounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wounds'],
      )!,
      leadership: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leadership'],
      )!,
      objectiveControl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}objective_control'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ModelProfilesTable createAlias(String alias) {
    return $ModelProfilesTable(attachedDatabase, alias);
  }
}

class ModelProfile extends DataClass implements Insertable<ModelProfile> {
  final String id;
  final String datasheetModelId;
  final String name;
  final int movement;
  final int toughness;
  final int save;
  final int wounds;
  final int leadership;
  final int objectiveControl;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ModelProfile({
    required this.id,
    required this.datasheetModelId,
    required this.name,
    required this.movement,
    required this.toughness,
    required this.save,
    required this.wounds,
    required this.leadership,
    required this.objectiveControl,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_model_id'] = Variable<String>(datasheetModelId);
    map['name'] = Variable<String>(name);
    map['movement'] = Variable<int>(movement);
    map['toughness'] = Variable<int>(toughness);
    map['save'] = Variable<int>(save);
    map['wounds'] = Variable<int>(wounds);
    map['leadership'] = Variable<int>(leadership);
    map['objective_control'] = Variable<int>(objectiveControl);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ModelProfilesCompanion toCompanion(bool nullToAbsent) {
    return ModelProfilesCompanion(
      id: Value(id),
      datasheetModelId: Value(datasheetModelId),
      name: Value(name),
      movement: Value(movement),
      toughness: Value(toughness),
      save: Value(save),
      wounds: Value(wounds),
      leadership: Value(leadership),
      objectiveControl: Value(objectiveControl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ModelProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelProfile(
      id: serializer.fromJson<String>(json['id']),
      datasheetModelId: serializer.fromJson<String>(json['datasheetModelId']),
      name: serializer.fromJson<String>(json['name']),
      movement: serializer.fromJson<int>(json['movement']),
      toughness: serializer.fromJson<int>(json['toughness']),
      save: serializer.fromJson<int>(json['save']),
      wounds: serializer.fromJson<int>(json['wounds']),
      leadership: serializer.fromJson<int>(json['leadership']),
      objectiveControl: serializer.fromJson<int>(json['objectiveControl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetModelId': serializer.toJson<String>(datasheetModelId),
      'name': serializer.toJson<String>(name),
      'movement': serializer.toJson<int>(movement),
      'toughness': serializer.toJson<int>(toughness),
      'save': serializer.toJson<int>(save),
      'wounds': serializer.toJson<int>(wounds),
      'leadership': serializer.toJson<int>(leadership),
      'objectiveControl': serializer.toJson<int>(objectiveControl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ModelProfile copyWith({
    String? id,
    String? datasheetModelId,
    String? name,
    int? movement,
    int? toughness,
    int? save,
    int? wounds,
    int? leadership,
    int? objectiveControl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ModelProfile(
    id: id ?? this.id,
    datasheetModelId: datasheetModelId ?? this.datasheetModelId,
    name: name ?? this.name,
    movement: movement ?? this.movement,
    toughness: toughness ?? this.toughness,
    save: save ?? this.save,
    wounds: wounds ?? this.wounds,
    leadership: leadership ?? this.leadership,
    objectiveControl: objectiveControl ?? this.objectiveControl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ModelProfile copyWithCompanion(ModelProfilesCompanion data) {
    return ModelProfile(
      id: data.id.present ? data.id.value : this.id,
      datasheetModelId: data.datasheetModelId.present
          ? data.datasheetModelId.value
          : this.datasheetModelId,
      name: data.name.present ? data.name.value : this.name,
      movement: data.movement.present ? data.movement.value : this.movement,
      toughness: data.toughness.present ? data.toughness.value : this.toughness,
      save: data.save.present ? data.save.value : this.save,
      wounds: data.wounds.present ? data.wounds.value : this.wounds,
      leadership: data.leadership.present
          ? data.leadership.value
          : this.leadership,
      objectiveControl: data.objectiveControl.present
          ? data.objectiveControl.value
          : this.objectiveControl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelProfile(')
          ..write('id: $id, ')
          ..write('datasheetModelId: $datasheetModelId, ')
          ..write('name: $name, ')
          ..write('movement: $movement, ')
          ..write('toughness: $toughness, ')
          ..write('save: $save, ')
          ..write('wounds: $wounds, ')
          ..write('leadership: $leadership, ')
          ..write('objectiveControl: $objectiveControl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetModelId,
    name,
    movement,
    toughness,
    save,
    wounds,
    leadership,
    objectiveControl,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelProfile &&
          other.id == this.id &&
          other.datasheetModelId == this.datasheetModelId &&
          other.name == this.name &&
          other.movement == this.movement &&
          other.toughness == this.toughness &&
          other.save == this.save &&
          other.wounds == this.wounds &&
          other.leadership == this.leadership &&
          other.objectiveControl == this.objectiveControl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ModelProfilesCompanion extends UpdateCompanion<ModelProfile> {
  final Value<String> id;
  final Value<String> datasheetModelId;
  final Value<String> name;
  final Value<int> movement;
  final Value<int> toughness;
  final Value<int> save;
  final Value<int> wounds;
  final Value<int> leadership;
  final Value<int> objectiveControl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ModelProfilesCompanion({
    this.id = const Value.absent(),
    this.datasheetModelId = const Value.absent(),
    this.name = const Value.absent(),
    this.movement = const Value.absent(),
    this.toughness = const Value.absent(),
    this.save = const Value.absent(),
    this.wounds = const Value.absent(),
    this.leadership = const Value.absent(),
    this.objectiveControl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelProfilesCompanion.insert({
    required String id,
    required String datasheetModelId,
    required String name,
    required int movement,
    required int toughness,
    required int save,
    required int wounds,
    required int leadership,
    required int objectiveControl,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetModelId = Value(datasheetModelId),
       name = Value(name),
       movement = Value(movement),
       toughness = Value(toughness),
       save = Value(save),
       wounds = Value(wounds),
       leadership = Value(leadership),
       objectiveControl = Value(objectiveControl);
  static Insertable<ModelProfile> custom({
    Expression<String>? id,
    Expression<String>? datasheetModelId,
    Expression<String>? name,
    Expression<int>? movement,
    Expression<int>? toughness,
    Expression<int>? save,
    Expression<int>? wounds,
    Expression<int>? leadership,
    Expression<int>? objectiveControl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetModelId != null) 'datasheet_model_id': datasheetModelId,
      if (name != null) 'name': name,
      if (movement != null) 'movement': movement,
      if (toughness != null) 'toughness': toughness,
      if (save != null) 'save': save,
      if (wounds != null) 'wounds': wounds,
      if (leadership != null) 'leadership': leadership,
      if (objectiveControl != null) 'objective_control': objectiveControl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetModelId,
    Value<String>? name,
    Value<int>? movement,
    Value<int>? toughness,
    Value<int>? save,
    Value<int>? wounds,
    Value<int>? leadership,
    Value<int>? objectiveControl,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ModelProfilesCompanion(
      id: id ?? this.id,
      datasheetModelId: datasheetModelId ?? this.datasheetModelId,
      name: name ?? this.name,
      movement: movement ?? this.movement,
      toughness: toughness ?? this.toughness,
      save: save ?? this.save,
      wounds: wounds ?? this.wounds,
      leadership: leadership ?? this.leadership,
      objectiveControl: objectiveControl ?? this.objectiveControl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetModelId.present) {
      map['datasheet_model_id'] = Variable<String>(datasheetModelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (movement.present) {
      map['movement'] = Variable<int>(movement.value);
    }
    if (toughness.present) {
      map['toughness'] = Variable<int>(toughness.value);
    }
    if (save.present) {
      map['save'] = Variable<int>(save.value);
    }
    if (wounds.present) {
      map['wounds'] = Variable<int>(wounds.value);
    }
    if (leadership.present) {
      map['leadership'] = Variable<int>(leadership.value);
    }
    if (objectiveControl.present) {
      map['objective_control'] = Variable<int>(objectiveControl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelProfilesCompanion(')
          ..write('id: $id, ')
          ..write('datasheetModelId: $datasheetModelId, ')
          ..write('name: $name, ')
          ..write('movement: $movement, ')
          ..write('toughness: $toughness, ')
          ..write('save: $save, ')
          ..write('wounds: $wounds, ')
          ..write('leadership: $leadership, ')
          ..write('objectiveControl: $objectiveControl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitSizesTable extends UnitSizes
    with TableInfo<$UnitSizesTable, UnitSize> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitSizesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumModelsMeta = const VerificationMeta(
    'minimumModels',
  );
  @override
  late final GeneratedColumn<int> minimumModels = GeneratedColumn<int>(
    'minimum_models',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maximumModelsMeta = const VerificationMeta(
    'maximumModels',
  );
  @override
  late final GeneratedColumn<int> maximumModels = GeneratedColumn<int>(
    'maximum_models',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultModelsMeta = const VerificationMeta(
    'defaultModels',
  );
  @override
  late final GeneratedColumn<int> defaultModels = GeneratedColumn<int>(
    'default_models',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    minimumModels,
    maximumModels,
    defaultModels,
    displayOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_sizes';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitSize> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('minimum_models')) {
      context.handle(
        _minimumModelsMeta,
        minimumModels.isAcceptableOrUnknown(
          data['minimum_models']!,
          _minimumModelsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumModelsMeta);
    }
    if (data.containsKey('maximum_models')) {
      context.handle(
        _maximumModelsMeta,
        maximumModels.isAcceptableOrUnknown(
          data['maximum_models']!,
          _maximumModelsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maximumModelsMeta);
    }
    if (data.containsKey('default_models')) {
      context.handle(
        _defaultModelsMeta,
        defaultModels.isAcceptableOrUnknown(
          data['default_models']!,
          _defaultModelsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultModelsMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitSize map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitSize(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      minimumModels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_models'],
      )!,
      maximumModels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum_models'],
      )!,
      defaultModels: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_models'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UnitSizesTable createAlias(String alias) {
    return $UnitSizesTable(attachedDatabase, alias);
  }
}

class UnitSize extends DataClass implements Insertable<UnitSize> {
  final String id;
  final String datasheetId;
  final int minimumModels;
  final int maximumModels;
  final int defaultModels;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UnitSize({
    required this.id,
    required this.datasheetId,
    required this.minimumModels,
    required this.maximumModels,
    required this.defaultModels,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['minimum_models'] = Variable<int>(minimumModels);
    map['maximum_models'] = Variable<int>(maximumModels);
    map['default_models'] = Variable<int>(defaultModels);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnitSizesCompanion toCompanion(bool nullToAbsent) {
    return UnitSizesCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      minimumModels: Value(minimumModels),
      maximumModels: Value(maximumModels),
      defaultModels: Value(defaultModels),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnitSize.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitSize(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      minimumModels: serializer.fromJson<int>(json['minimumModels']),
      maximumModels: serializer.fromJson<int>(json['maximumModels']),
      defaultModels: serializer.fromJson<int>(json['defaultModels']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'minimumModels': serializer.toJson<int>(minimumModels),
      'maximumModels': serializer.toJson<int>(maximumModels),
      'defaultModels': serializer.toJson<int>(defaultModels),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnitSize copyWith({
    String? id,
    String? datasheetId,
    int? minimumModels,
    int? maximumModels,
    int? defaultModels,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UnitSize(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    minimumModels: minimumModels ?? this.minimumModels,
    maximumModels: maximumModels ?? this.maximumModels,
    defaultModels: defaultModels ?? this.defaultModels,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UnitSize copyWithCompanion(UnitSizesCompanion data) {
    return UnitSize(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      minimumModels: data.minimumModels.present
          ? data.minimumModels.value
          : this.minimumModels,
      maximumModels: data.maximumModels.present
          ? data.maximumModels.value
          : this.maximumModels,
      defaultModels: data.defaultModels.present
          ? data.defaultModels.value
          : this.defaultModels,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitSize(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('minimumModels: $minimumModels, ')
          ..write('maximumModels: $maximumModels, ')
          ..write('defaultModels: $defaultModels, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetId,
    minimumModels,
    maximumModels,
    defaultModels,
    displayOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitSize &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.minimumModels == this.minimumModels &&
          other.maximumModels == this.maximumModels &&
          other.defaultModels == this.defaultModels &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnitSizesCompanion extends UpdateCompanion<UnitSize> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<int> minimumModels;
  final Value<int> maximumModels;
  final Value<int> defaultModels;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UnitSizesCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.minimumModels = const Value.absent(),
    this.maximumModels = const Value.absent(),
    this.defaultModels = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitSizesCompanion.insert({
    required String id,
    required String datasheetId,
    required int minimumModels,
    required int maximumModels,
    required int defaultModels,
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       minimumModels = Value(minimumModels),
       maximumModels = Value(maximumModels),
       defaultModels = Value(defaultModels);
  static Insertable<UnitSize> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<int>? minimumModels,
    Expression<int>? maximumModels,
    Expression<int>? defaultModels,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (minimumModels != null) 'minimum_models': minimumModels,
      if (maximumModels != null) 'maximum_models': maximumModels,
      if (defaultModels != null) 'default_models': defaultModels,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitSizesCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<int>? minimumModels,
    Value<int>? maximumModels,
    Value<int>? defaultModels,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UnitSizesCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      minimumModels: minimumModels ?? this.minimumModels,
      maximumModels: maximumModels ?? this.maximumModels,
      defaultModels: defaultModels ?? this.defaultModels,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (minimumModels.present) {
      map['minimum_models'] = Variable<int>(minimumModels.value);
    }
    if (maximumModels.present) {
      map['maximum_models'] = Variable<int>(maximumModels.value);
    }
    if (defaultModels.present) {
      map['default_models'] = Variable<int>(defaultModels.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitSizesCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('minimumModels: $minimumModels, ')
          ..write('maximumModels: $maximumModels, ')
          ..write('defaultModels: $defaultModels, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitCompositionsTable extends UnitCompositions
    with TableInfo<$UnitCompositionsTable, UnitComposition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitCompositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumMeta = const VerificationMeta(
    'minimum',
  );
  @override
  late final GeneratedColumn<int> minimum = GeneratedColumn<int>(
    'minimum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maximumMeta = const VerificationMeta(
    'maximum',
  );
  @override
  late final GeneratedColumn<int> maximum = GeneratedColumn<int>(
    'maximum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLeaderMeta = const VerificationMeta(
    'isLeader',
  );
  @override
  late final GeneratedColumn<bool> isLeader = GeneratedColumn<bool>(
    'is_leader',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_leader" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    modelId,
    minimum,
    maximum,
    isLeader,
    displayOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_compositions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitComposition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('minimum')) {
      context.handle(
        _minimumMeta,
        minimum.isAcceptableOrUnknown(data['minimum']!, _minimumMeta),
      );
    } else if (isInserting) {
      context.missing(_minimumMeta);
    }
    if (data.containsKey('maximum')) {
      context.handle(
        _maximumMeta,
        maximum.isAcceptableOrUnknown(data['maximum']!, _maximumMeta),
      );
    } else if (isInserting) {
      context.missing(_maximumMeta);
    }
    if (data.containsKey('is_leader')) {
      context.handle(
        _isLeaderMeta,
        isLeader.isAcceptableOrUnknown(data['is_leader']!, _isLeaderMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitComposition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitComposition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      minimum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum'],
      )!,
      maximum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum'],
      )!,
      isLeader: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_leader'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UnitCompositionsTable createAlias(String alias) {
    return $UnitCompositionsTable(attachedDatabase, alias);
  }
}

class UnitComposition extends DataClass implements Insertable<UnitComposition> {
  final String id;
  final String datasheetId;
  final String modelId;
  final int minimum;
  final int maximum;
  final bool isLeader;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UnitComposition({
    required this.id,
    required this.datasheetId,
    required this.modelId,
    required this.minimum,
    required this.maximum,
    required this.isLeader,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['model_id'] = Variable<String>(modelId);
    map['minimum'] = Variable<int>(minimum);
    map['maximum'] = Variable<int>(maximum);
    map['is_leader'] = Variable<bool>(isLeader);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnitCompositionsCompanion toCompanion(bool nullToAbsent) {
    return UnitCompositionsCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      modelId: Value(modelId),
      minimum: Value(minimum),
      maximum: Value(maximum),
      isLeader: Value(isLeader),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnitComposition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitComposition(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      minimum: serializer.fromJson<int>(json['minimum']),
      maximum: serializer.fromJson<int>(json['maximum']),
      isLeader: serializer.fromJson<bool>(json['isLeader']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'modelId': serializer.toJson<String>(modelId),
      'minimum': serializer.toJson<int>(minimum),
      'maximum': serializer.toJson<int>(maximum),
      'isLeader': serializer.toJson<bool>(isLeader),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnitComposition copyWith({
    String? id,
    String? datasheetId,
    String? modelId,
    int? minimum,
    int? maximum,
    bool? isLeader,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UnitComposition(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    modelId: modelId ?? this.modelId,
    minimum: minimum ?? this.minimum,
    maximum: maximum ?? this.maximum,
    isLeader: isLeader ?? this.isLeader,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UnitComposition copyWithCompanion(UnitCompositionsCompanion data) {
    return UnitComposition(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      minimum: data.minimum.present ? data.minimum.value : this.minimum,
      maximum: data.maximum.present ? data.maximum.value : this.maximum,
      isLeader: data.isLeader.present ? data.isLeader.value : this.isLeader,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitComposition(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('modelId: $modelId, ')
          ..write('minimum: $minimum, ')
          ..write('maximum: $maximum, ')
          ..write('isLeader: $isLeader, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetId,
    modelId,
    minimum,
    maximum,
    isLeader,
    displayOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitComposition &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.modelId == this.modelId &&
          other.minimum == this.minimum &&
          other.maximum == this.maximum &&
          other.isLeader == this.isLeader &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnitCompositionsCompanion extends UpdateCompanion<UnitComposition> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> modelId;
  final Value<int> minimum;
  final Value<int> maximum;
  final Value<bool> isLeader;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UnitCompositionsCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.minimum = const Value.absent(),
    this.maximum = const Value.absent(),
    this.isLeader = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitCompositionsCompanion.insert({
    required String id,
    required String datasheetId,
    required String modelId,
    required int minimum,
    required int maximum,
    this.isLeader = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       modelId = Value(modelId),
       minimum = Value(minimum),
       maximum = Value(maximum);
  static Insertable<UnitComposition> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? modelId,
    Expression<int>? minimum,
    Expression<int>? maximum,
    Expression<bool>? isLeader,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (modelId != null) 'model_id': modelId,
      if (minimum != null) 'minimum': minimum,
      if (maximum != null) 'maximum': maximum,
      if (isLeader != null) 'is_leader': isLeader,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitCompositionsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? modelId,
    Value<int>? minimum,
    Value<int>? maximum,
    Value<bool>? isLeader,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UnitCompositionsCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      modelId: modelId ?? this.modelId,
      minimum: minimum ?? this.minimum,
      maximum: maximum ?? this.maximum,
      isLeader: isLeader ?? this.isLeader,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (minimum.present) {
      map['minimum'] = Variable<int>(minimum.value);
    }
    if (maximum.present) {
      map['maximum'] = Variable<int>(maximum.value);
    }
    if (isLeader.present) {
      map['is_leader'] = Variable<bool>(isLeader.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitCompositionsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('modelId: $modelId, ')
          ..write('minimum: $minimum, ')
          ..write('maximum: $maximum, ')
          ..write('isLeader: $isLeader, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetCostsTable extends DatasheetCosts
    with TableInfo<$DatasheetCostsTable, DatasheetCost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetCostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelCountMeta = const VerificationMeta(
    'modelCount',
  );
  @override
  late final GeneratedColumn<int> modelCount = GeneratedColumn<int>(
    'model_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _powerLevelMeta = const VerificationMeta(
    'powerLevel',
  );
  @override
  late final GeneratedColumn<int> powerLevel = GeneratedColumn<int>(
    'power_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    editionId,
    points,
    modelCount,
    powerLevel,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_costs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetCost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('model_count')) {
      context.handle(
        _modelCountMeta,
        modelCount.isAcceptableOrUnknown(data['model_count']!, _modelCountMeta),
      );
    }
    if (data.containsKey('power_level')) {
      context.handle(
        _powerLevelMeta,
        powerLevel.isAcceptableOrUnknown(data['power_level']!, _powerLevelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetCost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetCost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      modelCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}model_count'],
      ),
      powerLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}power_level'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DatasheetCostsTable createAlias(String alias) {
    return $DatasheetCostsTable(attachedDatabase, alias);
  }
}

class DatasheetCost extends DataClass implements Insertable<DatasheetCost> {
  final String id;
  final String datasheetId;
  final String editionId;
  final int points;

  /// Nombre de figurines auquel ce coût s'applique. `null` signifie que
  /// la fiche n'a qu'un seul palier de coût (unité à taille fixe, ou
  /// donnée historique important qui n'a pas encore de palier détaillé) :
  /// dans ce cas ce coût s'applique quel que soit l'effectif choisi.
  ///
  /// Une même fiche peut avoir plusieurs lignes ici (une par palier
  /// officiel, ex. 5 modèles / 10 modèles), chacune avec un coût propre —
  /// contrairement aux datasheets qui montent en coût de façon linéaire,
  /// beaucoup d'unités Warhammer 40k ont un coût par palier qui n'est pas
  /// un simple multiple du coût de base.
  final int? modelCount;
  final int? powerLevel;
  final DateTime createdAt;
  const DatasheetCost({
    required this.id,
    required this.datasheetId,
    required this.editionId,
    required this.points,
    this.modelCount,
    this.powerLevel,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['edition_id'] = Variable<String>(editionId);
    map['points'] = Variable<int>(points);
    if (!nullToAbsent || modelCount != null) {
      map['model_count'] = Variable<int>(modelCount);
    }
    if (!nullToAbsent || powerLevel != null) {
      map['power_level'] = Variable<int>(powerLevel);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DatasheetCostsCompanion toCompanion(bool nullToAbsent) {
    return DatasheetCostsCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      editionId: Value(editionId),
      points: Value(points),
      modelCount: modelCount == null && nullToAbsent
          ? const Value.absent()
          : Value(modelCount),
      powerLevel: powerLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(powerLevel),
      createdAt: Value(createdAt),
    );
  }

  factory DatasheetCost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetCost(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      editionId: serializer.fromJson<String>(json['editionId']),
      points: serializer.fromJson<int>(json['points']),
      modelCount: serializer.fromJson<int?>(json['modelCount']),
      powerLevel: serializer.fromJson<int?>(json['powerLevel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'editionId': serializer.toJson<String>(editionId),
      'points': serializer.toJson<int>(points),
      'modelCount': serializer.toJson<int?>(modelCount),
      'powerLevel': serializer.toJson<int?>(powerLevel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DatasheetCost copyWith({
    String? id,
    String? datasheetId,
    String? editionId,
    int? points,
    Value<int?> modelCount = const Value.absent(),
    Value<int?> powerLevel = const Value.absent(),
    DateTime? createdAt,
  }) => DatasheetCost(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    editionId: editionId ?? this.editionId,
    points: points ?? this.points,
    modelCount: modelCount.present ? modelCount.value : this.modelCount,
    powerLevel: powerLevel.present ? powerLevel.value : this.powerLevel,
    createdAt: createdAt ?? this.createdAt,
  );
  DatasheetCost copyWithCompanion(DatasheetCostsCompanion data) {
    return DatasheetCost(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      points: data.points.present ? data.points.value : this.points,
      modelCount: data.modelCount.present
          ? data.modelCount.value
          : this.modelCount,
      powerLevel: data.powerLevel.present
          ? data.powerLevel.value
          : this.powerLevel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetCost(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('editionId: $editionId, ')
          ..write('points: $points, ')
          ..write('modelCount: $modelCount, ')
          ..write('powerLevel: $powerLevel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetId,
    editionId,
    points,
    modelCount,
    powerLevel,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetCost &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.editionId == this.editionId &&
          other.points == this.points &&
          other.modelCount == this.modelCount &&
          other.powerLevel == this.powerLevel &&
          other.createdAt == this.createdAt);
}

class DatasheetCostsCompanion extends UpdateCompanion<DatasheetCost> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> editionId;
  final Value<int> points;
  final Value<int?> modelCount;
  final Value<int?> powerLevel;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DatasheetCostsCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.editionId = const Value.absent(),
    this.points = const Value.absent(),
    this.modelCount = const Value.absent(),
    this.powerLevel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetCostsCompanion.insert({
    required String id,
    required String datasheetId,
    required String editionId,
    required int points,
    this.modelCount = const Value.absent(),
    this.powerLevel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       editionId = Value(editionId),
       points = Value(points);
  static Insertable<DatasheetCost> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? editionId,
    Expression<int>? points,
    Expression<int>? modelCount,
    Expression<int>? powerLevel,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (editionId != null) 'edition_id': editionId,
      if (points != null) 'points': points,
      if (modelCount != null) 'model_count': modelCount,
      if (powerLevel != null) 'power_level': powerLevel,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetCostsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? editionId,
    Value<int>? points,
    Value<int?>? modelCount,
    Value<int?>? powerLevel,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DatasheetCostsCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      editionId: editionId ?? this.editionId,
      points: points ?? this.points,
      modelCount: modelCount ?? this.modelCount,
      powerLevel: powerLevel ?? this.powerLevel,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (modelCount.present) {
      map['model_count'] = Variable<int>(modelCount.value);
    }
    if (powerLevel.present) {
      map['power_level'] = Variable<int>(powerLevel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetCostsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('editionId: $editionId, ')
          ..write('points: $points, ')
          ..write('modelCount: $modelCount, ')
          ..write('powerLevel: $powerLevel, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetVersionsTable extends DatasheetVersions
    with TableInfo<$DatasheetVersionsTable, DatasheetVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    version,
    description,
    isCurrent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DatasheetVersionsTable createAlias(String alias) {
    return $DatasheetVersionsTable(attachedDatabase, alias);
  }
}

class DatasheetVersion extends DataClass
    implements Insertable<DatasheetVersion> {
  final String id;
  final String datasheetId;
  final String version;
  final String? description;
  final bool isCurrent;
  final DateTime createdAt;
  const DatasheetVersion({
    required this.id,
    required this.datasheetId,
    required this.version,
    this.description,
    required this.isCurrent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['version'] = Variable<String>(version);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_current'] = Variable<bool>(isCurrent);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DatasheetVersionsCompanion toCompanion(bool nullToAbsent) {
    return DatasheetVersionsCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      version: Value(version),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCurrent: Value(isCurrent),
      createdAt: Value(createdAt),
    );
  }

  factory DatasheetVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetVersion(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      version: serializer.fromJson<String>(json['version']),
      description: serializer.fromJson<String?>(json['description']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'version': serializer.toJson<String>(version),
      'description': serializer.toJson<String?>(description),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DatasheetVersion copyWith({
    String? id,
    String? datasheetId,
    String? version,
    Value<String?> description = const Value.absent(),
    bool? isCurrent,
    DateTime? createdAt,
  }) => DatasheetVersion(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    version: version ?? this.version,
    description: description.present ? description.value : this.description,
    isCurrent: isCurrent ?? this.isCurrent,
    createdAt: createdAt ?? this.createdAt,
  );
  DatasheetVersion copyWithCompanion(DatasheetVersionsCompanion data) {
    return DatasheetVersion(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      version: data.version.present ? data.version.value : this.version,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetVersion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('version: $version, ')
          ..write('description: $description, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, datasheetId, version, description, isCurrent, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetVersion &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.version == this.version &&
          other.description == this.description &&
          other.isCurrent == this.isCurrent &&
          other.createdAt == this.createdAt);
}

class DatasheetVersionsCompanion extends UpdateCompanion<DatasheetVersion> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> version;
  final Value<String?> description;
  final Value<bool> isCurrent;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DatasheetVersionsCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.version = const Value.absent(),
    this.description = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetVersionsCompanion.insert({
    required String id,
    required String datasheetId,
    required String version,
    this.description = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       version = Value(version);
  static Insertable<DatasheetVersion> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? version,
    Expression<String>? description,
    Expression<bool>? isCurrent,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (version != null) 'version': version,
      if (description != null) 'description': description,
      if (isCurrent != null) 'is_current': isCurrent,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? version,
    Value<String?>? description,
    Value<bool>? isCurrent,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DatasheetVersionsCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      version: version ?? this.version,
      description: description ?? this.description,
      isCurrent: isCurrent ?? this.isCurrent,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetVersionsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('version: $version, ')
          ..write('description: $description, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetSourcesTable extends DatasheetSources
    with TableInfo<$DatasheetSourcesTable, DatasheetSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<String> page = GeneratedColumn<String>(
    'page',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    sourceName,
    sourceType,
    page,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DatasheetSourcesTable createAlias(String alias) {
    return $DatasheetSourcesTable(attachedDatabase, alias);
  }
}

class DatasheetSource extends DataClass implements Insertable<DatasheetSource> {
  final String id;
  final String datasheetId;
  final String sourceName;
  final String sourceType;
  final String? page;
  final DateTime createdAt;
  const DatasheetSource({
    required this.id,
    required this.datasheetId,
    required this.sourceName,
    required this.sourceType,
    this.page,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['source_name'] = Variable<String>(sourceName);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || page != null) {
      map['page'] = Variable<String>(page);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DatasheetSourcesCompanion toCompanion(bool nullToAbsent) {
    return DatasheetSourcesCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      sourceName: Value(sourceName),
      sourceType: Value(sourceType),
      page: page == null && nullToAbsent ? const Value.absent() : Value(page),
      createdAt: Value(createdAt),
    );
  }

  factory DatasheetSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetSource(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      page: serializer.fromJson<String?>(json['page']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'sourceName': serializer.toJson<String>(sourceName),
      'sourceType': serializer.toJson<String>(sourceType),
      'page': serializer.toJson<String?>(page),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DatasheetSource copyWith({
    String? id,
    String? datasheetId,
    String? sourceName,
    String? sourceType,
    Value<String?> page = const Value.absent(),
    DateTime? createdAt,
  }) => DatasheetSource(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    sourceName: sourceName ?? this.sourceName,
    sourceType: sourceType ?? this.sourceType,
    page: page.present ? page.value : this.page,
    createdAt: createdAt ?? this.createdAt,
  );
  DatasheetSource copyWithCompanion(DatasheetSourcesCompanion data) {
    return DatasheetSource(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      page: data.page.present ? data.page.value : this.page,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetSource(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceType: $sourceType, ')
          ..write('page: $page, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, datasheetId, sourceName, sourceType, page, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetSource &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.sourceName == this.sourceName &&
          other.sourceType == this.sourceType &&
          other.page == this.page &&
          other.createdAt == this.createdAt);
}

class DatasheetSourcesCompanion extends UpdateCompanion<DatasheetSource> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> sourceName;
  final Value<String> sourceType;
  final Value<String?> page;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DatasheetSourcesCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.page = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetSourcesCompanion.insert({
    required String id,
    required String datasheetId,
    required String sourceName,
    required String sourceType,
    this.page = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       sourceName = Value(sourceName),
       sourceType = Value(sourceType);
  static Insertable<DatasheetSource> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? sourceName,
    Expression<String>? sourceType,
    Expression<String>? page,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceType != null) 'source_type': sourceType,
      if (page != null) 'page': page,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? sourceName,
    Value<String>? sourceType,
    Value<String?>? page,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DatasheetSourcesCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      sourceName: sourceName ?? this.sourceName,
      sourceType: sourceType ?? this.sourceType,
      page: page ?? this.page,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (page.present) {
      map['page'] = Variable<String>(page.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetSourcesCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceType: $sourceType, ')
          ..write('page: $page, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentGroupsTable extends EquipmentGroups
    with TableInfo<$EquipmentGroupsTable, EquipmentGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    name,
    description,
    displayOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EquipmentGroupsTable createAlias(String alias) {
    return $EquipmentGroupsTable(attachedDatabase, alias);
  }
}

class EquipmentGroup extends DataClass implements Insertable<EquipmentGroup> {
  final String id;
  final String datasheetId;
  final String name;
  final String? description;
  final int displayOrder;
  final DateTime createdAt;
  const EquipmentGroup({
    required this.id,
    required this.datasheetId,
    required this.name,
    this.description,
    required this.displayOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EquipmentGroupsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentGroupsCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
    );
  }

  factory EquipmentGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentGroup(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EquipmentGroup copyWith({
    String? id,
    String? datasheetId,
    String? name,
    Value<String?> description = const Value.absent(),
    int? displayOrder,
    DateTime? createdAt,
  }) => EquipmentGroup(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  EquipmentGroup copyWithCompanion(EquipmentGroupsCompanion data) {
    return EquipmentGroup(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentGroup(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, datasheetId, name, description, displayOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentGroup &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.name == this.name &&
          other.description == this.description &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt);
}

class EquipmentGroupsCompanion extends UpdateCompanion<EquipmentGroup> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EquipmentGroupsCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentGroupsCompanion.insert({
    required String id,
    required String datasheetId,
    required String name,
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       name = Value(name);
  static Insertable<EquipmentGroup> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EquipmentGroupsCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      name: name ?? this.name,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentGroupsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentOptionsTable extends EquipmentOptions
    with TableInfo<$EquipmentOptionsTable, EquipmentOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<String> weaponId = GeneratedColumn<String>(
    'weapon_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    weaponId,
    name,
    quantity,
    isDefault,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentOption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weapon_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $EquipmentOptionsTable createAlias(String alias) {
    return $EquipmentOptionsTable(attachedDatabase, alias);
  }
}

class EquipmentOption extends DataClass implements Insertable<EquipmentOption> {
  final String id;
  final String groupId;
  final String? weaponId;
  final String name;
  final int quantity;
  final bool isDefault;
  final int displayOrder;
  const EquipmentOption({
    required this.id,
    required this.groupId,
    this.weaponId,
    required this.name,
    required this.quantity,
    required this.isDefault,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    if (!nullToAbsent || weaponId != null) {
      map['weapon_id'] = Variable<String>(weaponId);
    }
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    map['is_default'] = Variable<bool>(isDefault);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  EquipmentOptionsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentOptionsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      weaponId: weaponId == null && nullToAbsent
          ? const Value.absent()
          : Value(weaponId),
      name: Value(name),
      quantity: Value(quantity),
      isDefault: Value(isDefault),
      displayOrder: Value(displayOrder),
    );
  }

  factory EquipmentOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentOption(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      weaponId: serializer.fromJson<String?>(json['weaponId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'weaponId': serializer.toJson<String?>(weaponId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'isDefault': serializer.toJson<bool>(isDefault),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  EquipmentOption copyWith({
    String? id,
    String? groupId,
    Value<String?> weaponId = const Value.absent(),
    String? name,
    int? quantity,
    bool? isDefault,
    int? displayOrder,
  }) => EquipmentOption(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    weaponId: weaponId.present ? weaponId.value : this.weaponId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    isDefault: isDefault ?? this.isDefault,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  EquipmentOption copyWithCompanion(EquipmentOptionsCompanion data) {
    return EquipmentOption(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentOption(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('weaponId: $weaponId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('isDefault: $isDefault, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    weaponId,
    name,
    quantity,
    isDefault,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentOption &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.weaponId == this.weaponId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.isDefault == this.isDefault &&
          other.displayOrder == this.displayOrder);
}

class EquipmentOptionsCompanion extends UpdateCompanion<EquipmentOption> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String?> weaponId;
  final Value<String> name;
  final Value<int> quantity;
  final Value<bool> isDefault;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const EquipmentOptionsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.weaponId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentOptionsCompanion.insert({
    required String id,
    required String groupId,
    this.weaponId = const Value.absent(),
    required String name,
    this.quantity = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       name = Value(name);
  static Insertable<EquipmentOption> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? weaponId,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<bool>? isDefault,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (weaponId != null) 'weapon_id': weaponId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (isDefault != null) 'is_default': isDefault,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentOptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String?>? weaponId,
    Value<String>? name,
    Value<int>? quantity,
    Value<bool>? isDefault,
    Value<int>? displayOrder,
    Value<int>? rowid,
  }) {
    return EquipmentOptionsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      weaponId: weaponId ?? this.weaponId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isDefault: isDefault ?? this.isDefault,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (weaponId.present) {
      map['weapon_id'] = Variable<String>(weaponId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentOptionsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('weaponId: $weaponId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('isDefault: $isDefault, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentChoicesTable extends EquipmentChoices
    with TableInfo<$EquipmentChoicesTable, EquipmentChoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentChoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumChoicesMeta = const VerificationMeta(
    'minimumChoices',
  );
  @override
  late final GeneratedColumn<int> minimumChoices = GeneratedColumn<int>(
    'minimum_choices',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _maximumChoicesMeta = const VerificationMeta(
    'maximumChoices',
  );
  @override
  late final GeneratedColumn<int> maximumChoices = GeneratedColumn<int>(
    'maximum_choices',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    minimumChoices,
    maximumChoices,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_choices';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentChoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('minimum_choices')) {
      context.handle(
        _minimumChoicesMeta,
        minimumChoices.isAcceptableOrUnknown(
          data['minimum_choices']!,
          _minimumChoicesMeta,
        ),
      );
    }
    if (data.containsKey('maximum_choices')) {
      context.handle(
        _maximumChoicesMeta,
        maximumChoices.isAcceptableOrUnknown(
          data['maximum_choices']!,
          _maximumChoicesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentChoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentChoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      minimumChoices: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_choices'],
      )!,
      maximumChoices: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maximum_choices'],
      )!,
    );
  }

  @override
  $EquipmentChoicesTable createAlias(String alias) {
    return $EquipmentChoicesTable(attachedDatabase, alias);
  }
}

class EquipmentChoice extends DataClass implements Insertable<EquipmentChoice> {
  final String id;
  final String groupId;
  final int minimumChoices;
  final int maximumChoices;
  const EquipmentChoice({
    required this.id,
    required this.groupId,
    required this.minimumChoices,
    required this.maximumChoices,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['minimum_choices'] = Variable<int>(minimumChoices);
    map['maximum_choices'] = Variable<int>(maximumChoices);
    return map;
  }

  EquipmentChoicesCompanion toCompanion(bool nullToAbsent) {
    return EquipmentChoicesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      minimumChoices: Value(minimumChoices),
      maximumChoices: Value(maximumChoices),
    );
  }

  factory EquipmentChoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentChoice(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      minimumChoices: serializer.fromJson<int>(json['minimumChoices']),
      maximumChoices: serializer.fromJson<int>(json['maximumChoices']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'minimumChoices': serializer.toJson<int>(minimumChoices),
      'maximumChoices': serializer.toJson<int>(maximumChoices),
    };
  }

  EquipmentChoice copyWith({
    String? id,
    String? groupId,
    int? minimumChoices,
    int? maximumChoices,
  }) => EquipmentChoice(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    minimumChoices: minimumChoices ?? this.minimumChoices,
    maximumChoices: maximumChoices ?? this.maximumChoices,
  );
  EquipmentChoice copyWithCompanion(EquipmentChoicesCompanion data) {
    return EquipmentChoice(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      minimumChoices: data.minimumChoices.present
          ? data.minimumChoices.value
          : this.minimumChoices,
      maximumChoices: data.maximumChoices.present
          ? data.maximumChoices.value
          : this.maximumChoices,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentChoice(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('minimumChoices: $minimumChoices, ')
          ..write('maximumChoices: $maximumChoices')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, minimumChoices, maximumChoices);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentChoice &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.minimumChoices == this.minimumChoices &&
          other.maximumChoices == this.maximumChoices);
}

class EquipmentChoicesCompanion extends UpdateCompanion<EquipmentChoice> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<int> minimumChoices;
  final Value<int> maximumChoices;
  final Value<int> rowid;
  const EquipmentChoicesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.minimumChoices = const Value.absent(),
    this.maximumChoices = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentChoicesCompanion.insert({
    required String id,
    required String groupId,
    this.minimumChoices = const Value.absent(),
    this.maximumChoices = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId);
  static Insertable<EquipmentChoice> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<int>? minimumChoices,
    Expression<int>? maximumChoices,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (minimumChoices != null) 'minimum_choices': minimumChoices,
      if (maximumChoices != null) 'maximum_choices': maximumChoices,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentChoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<int>? minimumChoices,
    Value<int>? maximumChoices,
    Value<int>? rowid,
  }) {
    return EquipmentChoicesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      minimumChoices: minimumChoices ?? this.minimumChoices,
      maximumChoices: maximumChoices ?? this.maximumChoices,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (minimumChoices.present) {
      map['minimum_choices'] = Variable<int>(minimumChoices.value);
    }
    if (maximumChoices.present) {
      map['maximum_choices'] = Variable<int>(maximumChoices.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentChoicesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('minimumChoices: $minimumChoices, ')
          ..write('maximumChoices: $maximumChoices, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentRestrictionsTable extends EquipmentRestrictions
    with TableInfo<$EquipmentRestrictionsTable, EquipmentRestriction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentRestrictionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionIdMeta = const VerificationMeta(
    'optionId',
  );
  @override
  late final GeneratedColumn<String> optionId = GeneratedColumn<String>(
    'option_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restrictionTypeMeta = const VerificationMeta(
    'restrictionType',
  );
  @override
  late final GeneratedColumn<String> restrictionType = GeneratedColumn<String>(
    'restriction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    optionId,
    restrictionType,
    value,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_restrictions';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentRestriction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('option_id')) {
      context.handle(
        _optionIdMeta,
        optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_optionIdMeta);
    }
    if (data.containsKey('restriction_type')) {
      context.handle(
        _restrictionTypeMeta,
        restrictionType.isAcceptableOrUnknown(
          data['restriction_type']!,
          _restrictionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restrictionTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentRestriction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentRestriction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      optionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_id'],
      )!,
      restrictionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}restriction_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $EquipmentRestrictionsTable createAlias(String alias) {
    return $EquipmentRestrictionsTable(attachedDatabase, alias);
  }
}

class EquipmentRestriction extends DataClass
    implements Insertable<EquipmentRestriction> {
  final String id;
  final String optionId;
  final String restrictionType;
  final int? value;
  final String? description;
  const EquipmentRestriction({
    required this.id,
    required this.optionId,
    required this.restrictionType,
    this.value,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['option_id'] = Variable<String>(optionId);
    map['restriction_type'] = Variable<String>(restrictionType);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<int>(value);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  EquipmentRestrictionsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentRestrictionsCompanion(
      id: Value(id),
      optionId: Value(optionId),
      restrictionType: Value(restrictionType),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory EquipmentRestriction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentRestriction(
      id: serializer.fromJson<String>(json['id']),
      optionId: serializer.fromJson<String>(json['optionId']),
      restrictionType: serializer.fromJson<String>(json['restrictionType']),
      value: serializer.fromJson<int?>(json['value']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'optionId': serializer.toJson<String>(optionId),
      'restrictionType': serializer.toJson<String>(restrictionType),
      'value': serializer.toJson<int?>(value),
      'description': serializer.toJson<String?>(description),
    };
  }

  EquipmentRestriction copyWith({
    String? id,
    String? optionId,
    String? restrictionType,
    Value<int?> value = const Value.absent(),
    Value<String?> description = const Value.absent(),
  }) => EquipmentRestriction(
    id: id ?? this.id,
    optionId: optionId ?? this.optionId,
    restrictionType: restrictionType ?? this.restrictionType,
    value: value.present ? value.value : this.value,
    description: description.present ? description.value : this.description,
  );
  EquipmentRestriction copyWithCompanion(EquipmentRestrictionsCompanion data) {
    return EquipmentRestriction(
      id: data.id.present ? data.id.value : this.id,
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
      restrictionType: data.restrictionType.present
          ? data.restrictionType.value
          : this.restrictionType,
      value: data.value.present ? data.value.value : this.value,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentRestriction(')
          ..write('id: $id, ')
          ..write('optionId: $optionId, ')
          ..write('restrictionType: $restrictionType, ')
          ..write('value: $value, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, optionId, restrictionType, value, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentRestriction &&
          other.id == this.id &&
          other.optionId == this.optionId &&
          other.restrictionType == this.restrictionType &&
          other.value == this.value &&
          other.description == this.description);
}

class EquipmentRestrictionsCompanion
    extends UpdateCompanion<EquipmentRestriction> {
  final Value<String> id;
  final Value<String> optionId;
  final Value<String> restrictionType;
  final Value<int?> value;
  final Value<String?> description;
  final Value<int> rowid;
  const EquipmentRestrictionsCompanion({
    this.id = const Value.absent(),
    this.optionId = const Value.absent(),
    this.restrictionType = const Value.absent(),
    this.value = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentRestrictionsCompanion.insert({
    required String id,
    required String optionId,
    required String restrictionType,
    this.value = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       optionId = Value(optionId),
       restrictionType = Value(restrictionType);
  static Insertable<EquipmentRestriction> custom({
    Expression<String>? id,
    Expression<String>? optionId,
    Expression<String>? restrictionType,
    Expression<int>? value,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (optionId != null) 'option_id': optionId,
      if (restrictionType != null) 'restriction_type': restrictionType,
      if (value != null) 'value': value,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentRestrictionsCompanion copyWith({
    Value<String>? id,
    Value<String>? optionId,
    Value<String>? restrictionType,
    Value<int?>? value,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return EquipmentRestrictionsCompanion(
      id: id ?? this.id,
      optionId: optionId ?? this.optionId,
      restrictionType: restrictionType ?? this.restrictionType,
      value: value ?? this.value,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (optionId.present) {
      map['option_id'] = Variable<String>(optionId.value);
    }
    if (restrictionType.present) {
      map['restriction_type'] = Variable<String>(restrictionType.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentRestrictionsCompanion(')
          ..write('id: $id, ')
          ..write('optionId: $optionId, ')
          ..write('restrictionType: $restrictionType, ')
          ..write('value: $value, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeaponsTable extends Weapons with TableInfo<$WeaponsTable, Weapon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMeleeMeta = const VerificationMeta(
    'isMelee',
  );
  @override
  late final GeneratedColumn<bool> isMelee = GeneratedColumn<bool>(
    'is_melee',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_melee" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isRangedMeta = const VerificationMeta(
    'isRanged',
  );
  @override
  late final GeneratedColumn<bool> isRanged = GeneratedColumn<bool>(
    'is_ranged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ranged" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    isMelee,
    isRanged,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Weapon> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_melee')) {
      context.handle(
        _isMeleeMeta,
        isMelee.isAcceptableOrUnknown(data['is_melee']!, _isMeleeMeta),
      );
    }
    if (data.containsKey('is_ranged')) {
      context.handle(
        _isRangedMeta,
        isRanged.isAcceptableOrUnknown(data['is_ranged']!, _isRangedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Weapon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Weapon(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isMelee: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_melee'],
      )!,
      isRanged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ranged'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WeaponsTable createAlias(String alias) {
    return $WeaponsTable(attachedDatabase, alias);
  }
}

class Weapon extends DataClass implements Insertable<Weapon> {
  final String id;
  final String name;
  final String? description;
  final bool isMelee;
  final bool isRanged;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Weapon({
    required this.id,
    required this.name,
    this.description,
    required this.isMelee,
    required this.isRanged,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_melee'] = Variable<bool>(isMelee);
    map['is_ranged'] = Variable<bool>(isRanged);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeaponsCompanion toCompanion(bool nullToAbsent) {
    return WeaponsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isMelee: Value(isMelee),
      isRanged: Value(isRanged),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Weapon.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Weapon(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isMelee: serializer.fromJson<bool>(json['isMelee']),
      isRanged: serializer.fromJson<bool>(json['isRanged']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isMelee': serializer.toJson<bool>(isMelee),
      'isRanged': serializer.toJson<bool>(isRanged),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Weapon copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? isMelee,
    bool? isRanged,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Weapon(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    isMelee: isMelee ?? this.isMelee,
    isRanged: isRanged ?? this.isRanged,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Weapon copyWithCompanion(WeaponsCompanion data) {
    return Weapon(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      isMelee: data.isMelee.present ? data.isMelee.value : this.isMelee,
      isRanged: data.isRanged.present ? data.isRanged.value : this.isRanged,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Weapon(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isMelee: $isMelee, ')
          ..write('isRanged: $isRanged, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    isMelee,
    isRanged,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Weapon &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isMelee == this.isMelee &&
          other.isRanged == this.isRanged &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeaponsCompanion extends UpdateCompanion<Weapon> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> isMelee;
  final Value<bool> isRanged;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeaponsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isMelee = const Value.absent(),
    this.isRanged = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeaponsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.isMelee = const Value.absent(),
    this.isRanged = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Weapon> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? isMelee,
    Expression<bool>? isRanged,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isMelee != null) 'is_melee': isMelee,
      if (isRanged != null) 'is_ranged': isRanged,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeaponsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? isMelee,
    Value<bool>? isRanged,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WeaponsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isMelee: isMelee ?? this.isMelee,
      isRanged: isRanged ?? this.isRanged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isMelee.present) {
      map['is_melee'] = Variable<bool>(isMelee.value);
    }
    if (isRanged.present) {
      map['is_ranged'] = Variable<bool>(isRanged.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isMelee: $isMelee, ')
          ..write('isRanged: $isRanged, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeaponProfilesTable extends WeaponProfiles
    with TableInfo<$WeaponProfilesTable, WeaponProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<String> weaponId = GeneratedColumn<String>(
    'weapon_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rangeMeta = const VerificationMeta('range');
  @override
  late final GeneratedColumn<int> range = GeneratedColumn<int>(
    'range',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attacksMeta = const VerificationMeta(
    'attacks',
  );
  @override
  late final GeneratedColumn<String> attacks = GeneratedColumn<String>(
    'attacks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ballisticSkillMeta = const VerificationMeta(
    'ballisticSkill',
  );
  @override
  late final GeneratedColumn<int> ballisticSkill = GeneratedColumn<int>(
    'ballistic_skill',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weaponSkillMeta = const VerificationMeta(
    'weaponSkill',
  );
  @override
  late final GeneratedColumn<int> weaponSkill = GeneratedColumn<int>(
    'weapon_skill',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<int> strength = GeneratedColumn<int>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armorPenetrationMeta = const VerificationMeta(
    'armorPenetration',
  );
  @override
  late final GeneratedColumn<int> armorPenetration = GeneratedColumn<int>(
    'armor_penetration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageMeta = const VerificationMeta('damage');
  @override
  late final GeneratedColumn<String> damage = GeneratedColumn<String>(
    'damage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weaponId,
    name,
    range,
    attacks,
    ballisticSkill,
    weaponSkill,
    strength,
    armorPenetration,
    damage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapon_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weaponIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('range')) {
      context.handle(
        _rangeMeta,
        range.isAcceptableOrUnknown(data['range']!, _rangeMeta),
      );
    } else if (isInserting) {
      context.missing(_rangeMeta);
    }
    if (data.containsKey('attacks')) {
      context.handle(
        _attacksMeta,
        attacks.isAcceptableOrUnknown(data['attacks']!, _attacksMeta),
      );
    } else if (isInserting) {
      context.missing(_attacksMeta);
    }
    if (data.containsKey('ballistic_skill')) {
      context.handle(
        _ballisticSkillMeta,
        ballisticSkill.isAcceptableOrUnknown(
          data['ballistic_skill']!,
          _ballisticSkillMeta,
        ),
      );
    }
    if (data.containsKey('weapon_skill')) {
      context.handle(
        _weaponSkillMeta,
        weaponSkill.isAcceptableOrUnknown(
          data['weapon_skill']!,
          _weaponSkillMeta,
        ),
      );
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    } else if (isInserting) {
      context.missing(_strengthMeta);
    }
    if (data.containsKey('armor_penetration')) {
      context.handle(
        _armorPenetrationMeta,
        armorPenetration.isAcceptableOrUnknown(
          data['armor_penetration']!,
          _armorPenetrationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_armorPenetrationMeta);
    }
    if (data.containsKey('damage')) {
      context.handle(
        _damageMeta,
        damage.isAcceptableOrUnknown(data['damage']!, _damageMeta),
      );
    } else if (isInserting) {
      context.missing(_damageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaponProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weapon_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      range: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}range'],
      )!,
      attacks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attacks'],
      )!,
      ballisticSkill: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ballistic_skill'],
      ),
      weaponSkill: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weapon_skill'],
      ),
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength'],
      )!,
      armorPenetration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}armor_penetration'],
      )!,
      damage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WeaponProfilesTable createAlias(String alias) {
    return $WeaponProfilesTable(attachedDatabase, alias);
  }
}

class WeaponProfile extends DataClass implements Insertable<WeaponProfile> {
  final String id;
  final String weaponId;
  final String name;
  final int range;
  final String attacks;
  final int? ballisticSkill;
  final int? weaponSkill;
  final int strength;
  final int armorPenetration;
  final String damage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WeaponProfile({
    required this.id,
    required this.weaponId,
    required this.name,
    required this.range,
    required this.attacks,
    this.ballisticSkill,
    this.weaponSkill,
    required this.strength,
    required this.armorPenetration,
    required this.damage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weapon_id'] = Variable<String>(weaponId);
    map['name'] = Variable<String>(name);
    map['range'] = Variable<int>(range);
    map['attacks'] = Variable<String>(attacks);
    if (!nullToAbsent || ballisticSkill != null) {
      map['ballistic_skill'] = Variable<int>(ballisticSkill);
    }
    if (!nullToAbsent || weaponSkill != null) {
      map['weapon_skill'] = Variable<int>(weaponSkill);
    }
    map['strength'] = Variable<int>(strength);
    map['armor_penetration'] = Variable<int>(armorPenetration);
    map['damage'] = Variable<String>(damage);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeaponProfilesCompanion toCompanion(bool nullToAbsent) {
    return WeaponProfilesCompanion(
      id: Value(id),
      weaponId: Value(weaponId),
      name: Value(name),
      range: Value(range),
      attacks: Value(attacks),
      ballisticSkill: ballisticSkill == null && nullToAbsent
          ? const Value.absent()
          : Value(ballisticSkill),
      weaponSkill: weaponSkill == null && nullToAbsent
          ? const Value.absent()
          : Value(weaponSkill),
      strength: Value(strength),
      armorPenetration: Value(armorPenetration),
      damage: Value(damage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeaponProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponProfile(
      id: serializer.fromJson<String>(json['id']),
      weaponId: serializer.fromJson<String>(json['weaponId']),
      name: serializer.fromJson<String>(json['name']),
      range: serializer.fromJson<int>(json['range']),
      attacks: serializer.fromJson<String>(json['attacks']),
      ballisticSkill: serializer.fromJson<int?>(json['ballisticSkill']),
      weaponSkill: serializer.fromJson<int?>(json['weaponSkill']),
      strength: serializer.fromJson<int>(json['strength']),
      armorPenetration: serializer.fromJson<int>(json['armorPenetration']),
      damage: serializer.fromJson<String>(json['damage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weaponId': serializer.toJson<String>(weaponId),
      'name': serializer.toJson<String>(name),
      'range': serializer.toJson<int>(range),
      'attacks': serializer.toJson<String>(attacks),
      'ballisticSkill': serializer.toJson<int?>(ballisticSkill),
      'weaponSkill': serializer.toJson<int?>(weaponSkill),
      'strength': serializer.toJson<int>(strength),
      'armorPenetration': serializer.toJson<int>(armorPenetration),
      'damage': serializer.toJson<String>(damage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeaponProfile copyWith({
    String? id,
    String? weaponId,
    String? name,
    int? range,
    String? attacks,
    Value<int?> ballisticSkill = const Value.absent(),
    Value<int?> weaponSkill = const Value.absent(),
    int? strength,
    int? armorPenetration,
    String? damage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WeaponProfile(
    id: id ?? this.id,
    weaponId: weaponId ?? this.weaponId,
    name: name ?? this.name,
    range: range ?? this.range,
    attacks: attacks ?? this.attacks,
    ballisticSkill: ballisticSkill.present
        ? ballisticSkill.value
        : this.ballisticSkill,
    weaponSkill: weaponSkill.present ? weaponSkill.value : this.weaponSkill,
    strength: strength ?? this.strength,
    armorPenetration: armorPenetration ?? this.armorPenetration,
    damage: damage ?? this.damage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WeaponProfile copyWithCompanion(WeaponProfilesCompanion data) {
    return WeaponProfile(
      id: data.id.present ? data.id.value : this.id,
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      name: data.name.present ? data.name.value : this.name,
      range: data.range.present ? data.range.value : this.range,
      attacks: data.attacks.present ? data.attacks.value : this.attacks,
      ballisticSkill: data.ballisticSkill.present
          ? data.ballisticSkill.value
          : this.ballisticSkill,
      weaponSkill: data.weaponSkill.present
          ? data.weaponSkill.value
          : this.weaponSkill,
      strength: data.strength.present ? data.strength.value : this.strength,
      armorPenetration: data.armorPenetration.present
          ? data.armorPenetration.value
          : this.armorPenetration,
      damage: data.damage.present ? data.damage.value : this.damage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponProfile(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('name: $name, ')
          ..write('range: $range, ')
          ..write('attacks: $attacks, ')
          ..write('ballisticSkill: $ballisticSkill, ')
          ..write('weaponSkill: $weaponSkill, ')
          ..write('strength: $strength, ')
          ..write('armorPenetration: $armorPenetration, ')
          ..write('damage: $damage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weaponId,
    name,
    range,
    attacks,
    ballisticSkill,
    weaponSkill,
    strength,
    armorPenetration,
    damage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponProfile &&
          other.id == this.id &&
          other.weaponId == this.weaponId &&
          other.name == this.name &&
          other.range == this.range &&
          other.attacks == this.attacks &&
          other.ballisticSkill == this.ballisticSkill &&
          other.weaponSkill == this.weaponSkill &&
          other.strength == this.strength &&
          other.armorPenetration == this.armorPenetration &&
          other.damage == this.damage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeaponProfilesCompanion extends UpdateCompanion<WeaponProfile> {
  final Value<String> id;
  final Value<String> weaponId;
  final Value<String> name;
  final Value<int> range;
  final Value<String> attacks;
  final Value<int?> ballisticSkill;
  final Value<int?> weaponSkill;
  final Value<int> strength;
  final Value<int> armorPenetration;
  final Value<String> damage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeaponProfilesCompanion({
    this.id = const Value.absent(),
    this.weaponId = const Value.absent(),
    this.name = const Value.absent(),
    this.range = const Value.absent(),
    this.attacks = const Value.absent(),
    this.ballisticSkill = const Value.absent(),
    this.weaponSkill = const Value.absent(),
    this.strength = const Value.absent(),
    this.armorPenetration = const Value.absent(),
    this.damage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeaponProfilesCompanion.insert({
    required String id,
    required String weaponId,
    required String name,
    required int range,
    required String attacks,
    this.ballisticSkill = const Value.absent(),
    this.weaponSkill = const Value.absent(),
    required int strength,
    required int armorPenetration,
    required String damage,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       weaponId = Value(weaponId),
       name = Value(name),
       range = Value(range),
       attacks = Value(attacks),
       strength = Value(strength),
       armorPenetration = Value(armorPenetration),
       damage = Value(damage);
  static Insertable<WeaponProfile> custom({
    Expression<String>? id,
    Expression<String>? weaponId,
    Expression<String>? name,
    Expression<int>? range,
    Expression<String>? attacks,
    Expression<int>? ballisticSkill,
    Expression<int>? weaponSkill,
    Expression<int>? strength,
    Expression<int>? armorPenetration,
    Expression<String>? damage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weaponId != null) 'weapon_id': weaponId,
      if (name != null) 'name': name,
      if (range != null) 'range': range,
      if (attacks != null) 'attacks': attacks,
      if (ballisticSkill != null) 'ballistic_skill': ballisticSkill,
      if (weaponSkill != null) 'weapon_skill': weaponSkill,
      if (strength != null) 'strength': strength,
      if (armorPenetration != null) 'armor_penetration': armorPenetration,
      if (damage != null) 'damage': damage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeaponProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? weaponId,
    Value<String>? name,
    Value<int>? range,
    Value<String>? attacks,
    Value<int?>? ballisticSkill,
    Value<int?>? weaponSkill,
    Value<int>? strength,
    Value<int>? armorPenetration,
    Value<String>? damage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WeaponProfilesCompanion(
      id: id ?? this.id,
      weaponId: weaponId ?? this.weaponId,
      name: name ?? this.name,
      range: range ?? this.range,
      attacks: attacks ?? this.attacks,
      ballisticSkill: ballisticSkill ?? this.ballisticSkill,
      weaponSkill: weaponSkill ?? this.weaponSkill,
      strength: strength ?? this.strength,
      armorPenetration: armorPenetration ?? this.armorPenetration,
      damage: damage ?? this.damage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weaponId.present) {
      map['weapon_id'] = Variable<String>(weaponId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (range.present) {
      map['range'] = Variable<int>(range.value);
    }
    if (attacks.present) {
      map['attacks'] = Variable<String>(attacks.value);
    }
    if (ballisticSkill.present) {
      map['ballistic_skill'] = Variable<int>(ballisticSkill.value);
    }
    if (weaponSkill.present) {
      map['weapon_skill'] = Variable<int>(weaponSkill.value);
    }
    if (strength.present) {
      map['strength'] = Variable<int>(strength.value);
    }
    if (armorPenetration.present) {
      map['armor_penetration'] = Variable<int>(armorPenetration.value);
    }
    if (damage.present) {
      map['damage'] = Variable<String>(damage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponProfilesCompanion(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('name: $name, ')
          ..write('range: $range, ')
          ..write('attacks: $attacks, ')
          ..write('ballisticSkill: $ballisticSkill, ')
          ..write('weaponSkill: $weaponSkill, ')
          ..write('strength: $strength, ')
          ..write('armorPenetration: $armorPenetration, ')
          ..write('damage: $damage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetWeaponsTable extends DatasheetWeapons
    with TableInfo<$DatasheetWeaponsTable, DatasheetWeapon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetWeaponsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetModelIdMeta = const VerificationMeta(
    'datasheetModelId',
  );
  @override
  late final GeneratedColumn<String> datasheetModelId = GeneratedColumn<String>(
    'datasheet_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<String> weaponId = GeneratedColumn<String>(
    'weapon_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetModelId,
    weaponId,
    quantity,
    isDefault,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_weapons';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetWeapon> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_model_id')) {
      context.handle(
        _datasheetModelIdMeta,
        datasheetModelId.isAcceptableOrUnknown(
          data['datasheet_model_id']!,
          _datasheetModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetModelIdMeta);
    }
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weaponIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetWeapon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetWeapon(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_model_id'],
      )!,
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weapon_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DatasheetWeaponsTable createAlias(String alias) {
    return $DatasheetWeaponsTable(attachedDatabase, alias);
  }
}

class DatasheetWeapon extends DataClass implements Insertable<DatasheetWeapon> {
  final String id;
  final String datasheetModelId;
  final String weaponId;
  final int quantity;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DatasheetWeapon({
    required this.id,
    required this.datasheetModelId,
    required this.weaponId,
    required this.quantity,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_model_id'] = Variable<String>(datasheetModelId);
    map['weapon_id'] = Variable<String>(weaponId);
    map['quantity'] = Variable<int>(quantity);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DatasheetWeaponsCompanion toCompanion(bool nullToAbsent) {
    return DatasheetWeaponsCompanion(
      id: Value(id),
      datasheetModelId: Value(datasheetModelId),
      weaponId: Value(weaponId),
      quantity: Value(quantity),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DatasheetWeapon.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetWeapon(
      id: serializer.fromJson<String>(json['id']),
      datasheetModelId: serializer.fromJson<String>(json['datasheetModelId']),
      weaponId: serializer.fromJson<String>(json['weaponId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetModelId': serializer.toJson<String>(datasheetModelId),
      'weaponId': serializer.toJson<String>(weaponId),
      'quantity': serializer.toJson<int>(quantity),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DatasheetWeapon copyWith({
    String? id,
    String? datasheetModelId,
    String? weaponId,
    int? quantity,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DatasheetWeapon(
    id: id ?? this.id,
    datasheetModelId: datasheetModelId ?? this.datasheetModelId,
    weaponId: weaponId ?? this.weaponId,
    quantity: quantity ?? this.quantity,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DatasheetWeapon copyWithCompanion(DatasheetWeaponsCompanion data) {
    return DatasheetWeapon(
      id: data.id.present ? data.id.value : this.id,
      datasheetModelId: data.datasheetModelId.present
          ? data.datasheetModelId.value
          : this.datasheetModelId,
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetWeapon(')
          ..write('id: $id, ')
          ..write('datasheetModelId: $datasheetModelId, ')
          ..write('weaponId: $weaponId, ')
          ..write('quantity: $quantity, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetModelId,
    weaponId,
    quantity,
    isDefault,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetWeapon &&
          other.id == this.id &&
          other.datasheetModelId == this.datasheetModelId &&
          other.weaponId == this.weaponId &&
          other.quantity == this.quantity &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DatasheetWeaponsCompanion extends UpdateCompanion<DatasheetWeapon> {
  final Value<String> id;
  final Value<String> datasheetModelId;
  final Value<String> weaponId;
  final Value<int> quantity;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DatasheetWeaponsCompanion({
    this.id = const Value.absent(),
    this.datasheetModelId = const Value.absent(),
    this.weaponId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetWeaponsCompanion.insert({
    required String id,
    required String datasheetModelId,
    required String weaponId,
    this.quantity = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetModelId = Value(datasheetModelId),
       weaponId = Value(weaponId);
  static Insertable<DatasheetWeapon> custom({
    Expression<String>? id,
    Expression<String>? datasheetModelId,
    Expression<String>? weaponId,
    Expression<int>? quantity,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetModelId != null) 'datasheet_model_id': datasheetModelId,
      if (weaponId != null) 'weapon_id': weaponId,
      if (quantity != null) 'quantity': quantity,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetWeaponsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetModelId,
    Value<String>? weaponId,
    Value<int>? quantity,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DatasheetWeaponsCompanion(
      id: id ?? this.id,
      datasheetModelId: datasheetModelId ?? this.datasheetModelId,
      weaponId: weaponId ?? this.weaponId,
      quantity: quantity ?? this.quantity,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetModelId.present) {
      map['datasheet_model_id'] = Variable<String>(datasheetModelId.value);
    }
    if (weaponId.present) {
      map['weapon_id'] = Variable<String>(weaponId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetWeaponsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetModelId: $datasheetModelId, ')
          ..write('weaponId: $weaponId, ')
          ..write('quantity: $quantity, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeaponKeywordLinksTable extends WeaponKeywordLinks
    with TableInfo<$WeaponKeywordLinksTable, WeaponKeywordLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponKeywordLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<String> weaponId = GeneratedColumn<String>(
    'weapon_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keywordIdMeta = const VerificationMeta(
    'keywordId',
  );
  @override
  late final GeneratedColumn<String> keywordId = GeneratedColumn<String>(
    'keyword_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, weaponId, keywordId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapon_keyword_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponKeywordLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weaponIdMeta);
    }
    if (data.containsKey('keyword_id')) {
      context.handle(
        _keywordIdMeta,
        keywordId.isAcceptableOrUnknown(data['keyword_id']!, _keywordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaponKeywordLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponKeywordLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weapon_id'],
      )!,
      keywordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyword_id'],
      )!,
    );
  }

  @override
  $WeaponKeywordLinksTable createAlias(String alias) {
    return $WeaponKeywordLinksTable(attachedDatabase, alias);
  }
}

class WeaponKeywordLink extends DataClass
    implements Insertable<WeaponKeywordLink> {
  final String id;
  final String weaponId;
  final String keywordId;
  const WeaponKeywordLink({
    required this.id,
    required this.weaponId,
    required this.keywordId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weapon_id'] = Variable<String>(weaponId);
    map['keyword_id'] = Variable<String>(keywordId);
    return map;
  }

  WeaponKeywordLinksCompanion toCompanion(bool nullToAbsent) {
    return WeaponKeywordLinksCompanion(
      id: Value(id),
      weaponId: Value(weaponId),
      keywordId: Value(keywordId),
    );
  }

  factory WeaponKeywordLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponKeywordLink(
      id: serializer.fromJson<String>(json['id']),
      weaponId: serializer.fromJson<String>(json['weaponId']),
      keywordId: serializer.fromJson<String>(json['keywordId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weaponId': serializer.toJson<String>(weaponId),
      'keywordId': serializer.toJson<String>(keywordId),
    };
  }

  WeaponKeywordLink copyWith({
    String? id,
    String? weaponId,
    String? keywordId,
  }) => WeaponKeywordLink(
    id: id ?? this.id,
    weaponId: weaponId ?? this.weaponId,
    keywordId: keywordId ?? this.keywordId,
  );
  WeaponKeywordLink copyWithCompanion(WeaponKeywordLinksCompanion data) {
    return WeaponKeywordLink(
      id: data.id.present ? data.id.value : this.id,
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      keywordId: data.keywordId.present ? data.keywordId.value : this.keywordId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponKeywordLink(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('keywordId: $keywordId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weaponId, keywordId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponKeywordLink &&
          other.id == this.id &&
          other.weaponId == this.weaponId &&
          other.keywordId == this.keywordId);
}

class WeaponKeywordLinksCompanion extends UpdateCompanion<WeaponKeywordLink> {
  final Value<String> id;
  final Value<String> weaponId;
  final Value<String> keywordId;
  final Value<int> rowid;
  const WeaponKeywordLinksCompanion({
    this.id = const Value.absent(),
    this.weaponId = const Value.absent(),
    this.keywordId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeaponKeywordLinksCompanion.insert({
    required String id,
    required String weaponId,
    required String keywordId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       weaponId = Value(weaponId),
       keywordId = Value(keywordId);
  static Insertable<WeaponKeywordLink> custom({
    Expression<String>? id,
    Expression<String>? weaponId,
    Expression<String>? keywordId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weaponId != null) 'weapon_id': weaponId,
      if (keywordId != null) 'keyword_id': keywordId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeaponKeywordLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? weaponId,
    Value<String>? keywordId,
    Value<int>? rowid,
  }) {
    return WeaponKeywordLinksCompanion(
      id: id ?? this.id,
      weaponId: weaponId ?? this.weaponId,
      keywordId: keywordId ?? this.keywordId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weaponId.present) {
      map['weapon_id'] = Variable<String>(weaponId.value);
    }
    if (keywordId.present) {
      map['keyword_id'] = Variable<String>(keywordId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponKeywordLinksCompanion(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('keywordId: $keywordId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeaponAbilityLinksTable extends WeaponAbilityLinks
    with TableInfo<$WeaponAbilityLinksTable, WeaponAbilityLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponAbilityLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaponIdMeta = const VerificationMeta(
    'weaponId',
  );
  @override
  late final GeneratedColumn<String> weaponId = GeneratedColumn<String>(
    'weapon_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilityIdMeta = const VerificationMeta(
    'abilityId',
  );
  @override
  late final GeneratedColumn<String> abilityId = GeneratedColumn<String>(
    'ability_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, weaponId, abilityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapon_ability_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponAbilityLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('weapon_id')) {
      context.handle(
        _weaponIdMeta,
        weaponId.isAcceptableOrUnknown(data['weapon_id']!, _weaponIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weaponIdMeta);
    }
    if (data.containsKey('ability_id')) {
      context.handle(
        _abilityIdMeta,
        abilityId.isAcceptableOrUnknown(data['ability_id']!, _abilityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_abilityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaponAbilityLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponAbilityLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weaponId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weapon_id'],
      )!,
      abilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_id'],
      )!,
    );
  }

  @override
  $WeaponAbilityLinksTable createAlias(String alias) {
    return $WeaponAbilityLinksTable(attachedDatabase, alias);
  }
}

class WeaponAbilityLink extends DataClass
    implements Insertable<WeaponAbilityLink> {
  final String id;
  final String weaponId;
  final String abilityId;
  const WeaponAbilityLink({
    required this.id,
    required this.weaponId,
    required this.abilityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['weapon_id'] = Variable<String>(weaponId);
    map['ability_id'] = Variable<String>(abilityId);
    return map;
  }

  WeaponAbilityLinksCompanion toCompanion(bool nullToAbsent) {
    return WeaponAbilityLinksCompanion(
      id: Value(id),
      weaponId: Value(weaponId),
      abilityId: Value(abilityId),
    );
  }

  factory WeaponAbilityLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponAbilityLink(
      id: serializer.fromJson<String>(json['id']),
      weaponId: serializer.fromJson<String>(json['weaponId']),
      abilityId: serializer.fromJson<String>(json['abilityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weaponId': serializer.toJson<String>(weaponId),
      'abilityId': serializer.toJson<String>(abilityId),
    };
  }

  WeaponAbilityLink copyWith({
    String? id,
    String? weaponId,
    String? abilityId,
  }) => WeaponAbilityLink(
    id: id ?? this.id,
    weaponId: weaponId ?? this.weaponId,
    abilityId: abilityId ?? this.abilityId,
  );
  WeaponAbilityLink copyWithCompanion(WeaponAbilityLinksCompanion data) {
    return WeaponAbilityLink(
      id: data.id.present ? data.id.value : this.id,
      weaponId: data.weaponId.present ? data.weaponId.value : this.weaponId,
      abilityId: data.abilityId.present ? data.abilityId.value : this.abilityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponAbilityLink(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('abilityId: $abilityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weaponId, abilityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponAbilityLink &&
          other.id == this.id &&
          other.weaponId == this.weaponId &&
          other.abilityId == this.abilityId);
}

class WeaponAbilityLinksCompanion extends UpdateCompanion<WeaponAbilityLink> {
  final Value<String> id;
  final Value<String> weaponId;
  final Value<String> abilityId;
  final Value<int> rowid;
  const WeaponAbilityLinksCompanion({
    this.id = const Value.absent(),
    this.weaponId = const Value.absent(),
    this.abilityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeaponAbilityLinksCompanion.insert({
    required String id,
    required String weaponId,
    required String abilityId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       weaponId = Value(weaponId),
       abilityId = Value(abilityId);
  static Insertable<WeaponAbilityLink> custom({
    Expression<String>? id,
    Expression<String>? weaponId,
    Expression<String>? abilityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weaponId != null) 'weapon_id': weaponId,
      if (abilityId != null) 'ability_id': abilityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeaponAbilityLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? weaponId,
    Value<String>? abilityId,
    Value<int>? rowid,
  }) {
    return WeaponAbilityLinksCompanion(
      id: id ?? this.id,
      weaponId: weaponId ?? this.weaponId,
      abilityId: abilityId ?? this.abilityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weaponId.present) {
      map['weapon_id'] = Variable<String>(weaponId.value);
    }
    if (abilityId.present) {
      map['ability_id'] = Variable<String>(abilityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponAbilityLinksCompanion(')
          ..write('id: $id, ')
          ..write('weaponId: $weaponId, ')
          ..write('abilityId: $abilityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetKeywordLinksTable extends DatasheetKeywordLinks
    with TableInfo<$DatasheetKeywordLinksTable, DatasheetKeywordLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetKeywordLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keywordIdMeta = const VerificationMeta(
    'keywordId',
  );
  @override
  late final GeneratedColumn<String> keywordId = GeneratedColumn<String>(
    'keyword_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, datasheetId, keywordId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_keyword_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetKeywordLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('keyword_id')) {
      context.handle(
        _keywordIdMeta,
        keywordId.isAcceptableOrUnknown(data['keyword_id']!, _keywordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetKeywordLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetKeywordLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      keywordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyword_id'],
      )!,
    );
  }

  @override
  $DatasheetKeywordLinksTable createAlias(String alias) {
    return $DatasheetKeywordLinksTable(attachedDatabase, alias);
  }
}

class DatasheetKeywordLink extends DataClass
    implements Insertable<DatasheetKeywordLink> {
  final String id;
  final String datasheetId;
  final String keywordId;
  const DatasheetKeywordLink({
    required this.id,
    required this.datasheetId,
    required this.keywordId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['keyword_id'] = Variable<String>(keywordId);
    return map;
  }

  DatasheetKeywordLinksCompanion toCompanion(bool nullToAbsent) {
    return DatasheetKeywordLinksCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      keywordId: Value(keywordId),
    );
  }

  factory DatasheetKeywordLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetKeywordLink(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      keywordId: serializer.fromJson<String>(json['keywordId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'keywordId': serializer.toJson<String>(keywordId),
    };
  }

  DatasheetKeywordLink copyWith({
    String? id,
    String? datasheetId,
    String? keywordId,
  }) => DatasheetKeywordLink(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    keywordId: keywordId ?? this.keywordId,
  );
  DatasheetKeywordLink copyWithCompanion(DatasheetKeywordLinksCompanion data) {
    return DatasheetKeywordLink(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      keywordId: data.keywordId.present ? data.keywordId.value : this.keywordId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetKeywordLink(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('keywordId: $keywordId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, datasheetId, keywordId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetKeywordLink &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.keywordId == this.keywordId);
}

class DatasheetKeywordLinksCompanion
    extends UpdateCompanion<DatasheetKeywordLink> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> keywordId;
  final Value<int> rowid;
  const DatasheetKeywordLinksCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.keywordId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetKeywordLinksCompanion.insert({
    required String id,
    required String datasheetId,
    required String keywordId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       keywordId = Value(keywordId);
  static Insertable<DatasheetKeywordLink> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? keywordId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (keywordId != null) 'keyword_id': keywordId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetKeywordLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? keywordId,
    Value<int>? rowid,
  }) {
    return DatasheetKeywordLinksCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      keywordId: keywordId ?? this.keywordId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (keywordId.present) {
      map['keyword_id'] = Variable<String>(keywordId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetKeywordLinksCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('keywordId: $keywordId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DatasheetAbilityLinksTable extends DatasheetAbilityLinks
    with TableInfo<$DatasheetAbilityLinksTable, DatasheetAbilityLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatasheetAbilityLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilityIdMeta = const VerificationMeta(
    'abilityId',
  );
  @override
  late final GeneratedColumn<String> abilityId = GeneratedColumn<String>(
    'ability_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, datasheetId, abilityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'datasheet_ability_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatasheetAbilityLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('ability_id')) {
      context.handle(
        _abilityIdMeta,
        abilityId.isAcceptableOrUnknown(data['ability_id']!, _abilityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_abilityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DatasheetAbilityLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatasheetAbilityLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      abilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ability_id'],
      )!,
    );
  }

  @override
  $DatasheetAbilityLinksTable createAlias(String alias) {
    return $DatasheetAbilityLinksTable(attachedDatabase, alias);
  }
}

class DatasheetAbilityLink extends DataClass
    implements Insertable<DatasheetAbilityLink> {
  final String id;
  final String datasheetId;
  final String abilityId;
  const DatasheetAbilityLink({
    required this.id,
    required this.datasheetId,
    required this.abilityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['ability_id'] = Variable<String>(abilityId);
    return map;
  }

  DatasheetAbilityLinksCompanion toCompanion(bool nullToAbsent) {
    return DatasheetAbilityLinksCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      abilityId: Value(abilityId),
    );
  }

  factory DatasheetAbilityLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatasheetAbilityLink(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      abilityId: serializer.fromJson<String>(json['abilityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'abilityId': serializer.toJson<String>(abilityId),
    };
  }

  DatasheetAbilityLink copyWith({
    String? id,
    String? datasheetId,
    String? abilityId,
  }) => DatasheetAbilityLink(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    abilityId: abilityId ?? this.abilityId,
  );
  DatasheetAbilityLink copyWithCompanion(DatasheetAbilityLinksCompanion data) {
    return DatasheetAbilityLink(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      abilityId: data.abilityId.present ? data.abilityId.value : this.abilityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetAbilityLink(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('abilityId: $abilityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, datasheetId, abilityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatasheetAbilityLink &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.abilityId == this.abilityId);
}

class DatasheetAbilityLinksCompanion
    extends UpdateCompanion<DatasheetAbilityLink> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<String> abilityId;
  final Value<int> rowid;
  const DatasheetAbilityLinksCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.abilityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatasheetAbilityLinksCompanion.insert({
    required String id,
    required String datasheetId,
    required String abilityId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       abilityId = Value(abilityId);
  static Insertable<DatasheetAbilityLink> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<String>? abilityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (abilityId != null) 'ability_id': abilityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatasheetAbilityLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<String>? abilityId,
    Value<int>? rowid,
  }) {
    return DatasheetAbilityLinksCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      abilityId: abilityId ?? this.abilityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (abilityId.present) {
      map['ability_id'] = Variable<String>(abilityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatasheetAbilityLinksCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('abilityId: $abilityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DetachmentsTable extends Detachments
    with TableInfo<$DetachmentsTable, Detachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factionIdMeta = const VerificationMeta(
    'factionId',
  );
  @override
  late final GeneratedColumn<String> factionId = GeneratedColumn<String>(
    'faction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    factionId,
    name,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Detachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('faction_id')) {
      context.handle(
        _factionIdMeta,
        factionId.isAcceptableOrUnknown(data['faction_id']!, _factionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_factionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Detachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Detachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      factionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faction_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DetachmentsTable createAlias(String alias) {
    return $DetachmentsTable(attachedDatabase, alias);
  }
}

class Detachment extends DataClass implements Insertable<Detachment> {
  final String id;
  final String factionId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Detachment({
    required this.id,
    required this.factionId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['faction_id'] = Variable<String>(factionId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DetachmentsCompanion toCompanion(bool nullToAbsent) {
    return DetachmentsCompanion(
      id: Value(id),
      factionId: Value(factionId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Detachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Detachment(
      id: serializer.fromJson<String>(json['id']),
      factionId: serializer.fromJson<String>(json['factionId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'factionId': serializer.toJson<String>(factionId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Detachment copyWith({
    String? id,
    String? factionId,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Detachment(
    id: id ?? this.id,
    factionId: factionId ?? this.factionId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Detachment copyWithCompanion(DetachmentsCompanion data) {
    return Detachment(
      id: data.id.present ? data.id.value : this.id,
      factionId: data.factionId.present ? data.factionId.value : this.factionId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Detachment(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, factionId, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Detachment &&
          other.id == this.id &&
          other.factionId == this.factionId &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DetachmentsCompanion extends UpdateCompanion<Detachment> {
  final Value<String> id;
  final Value<String> factionId;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DetachmentsCompanion({
    this.id = const Value.absent(),
    this.factionId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DetachmentsCompanion.insert({
    required String id,
    required String factionId,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       factionId = Value(factionId),
       name = Value(name);
  static Insertable<Detachment> custom({
    Expression<String>? id,
    Expression<String>? factionId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (factionId != null) 'faction_id': factionId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DetachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? factionId,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DetachmentsCompanion(
      id: id ?? this.id,
      factionId: factionId ?? this.factionId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (factionId.present) {
      map['faction_id'] = Variable<String>(factionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetachmentsCompanion(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnhancementsTable extends Enhancements
    with TableInfo<$EnhancementsTable, Enhancement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnhancementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detachmentIdMeta = const VerificationMeta(
    'detachmentId',
  );
  @override
  late final GeneratedColumn<String> detachmentId = GeneratedColumn<String>(
    'detachment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    detachmentId,
    name,
    points,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enhancements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Enhancement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('detachment_id')) {
      context.handle(
        _detachmentIdMeta,
        detachmentId.isAcceptableOrUnknown(
          data['detachment_id']!,
          _detachmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detachmentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Enhancement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Enhancement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      detachmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detachment_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnhancementsTable createAlias(String alias) {
    return $EnhancementsTable(attachedDatabase, alias);
  }
}

class Enhancement extends DataClass implements Insertable<Enhancement> {
  final String id;
  final String detachmentId;
  final String name;
  final int points;
  final String? description;
  final DateTime createdAt;
  const Enhancement({
    required this.id,
    required this.detachmentId,
    required this.name,
    required this.points,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['detachment_id'] = Variable<String>(detachmentId);
    map['name'] = Variable<String>(name);
    map['points'] = Variable<int>(points);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnhancementsCompanion toCompanion(bool nullToAbsent) {
    return EnhancementsCompanion(
      id: Value(id),
      detachmentId: Value(detachmentId),
      name: Value(name),
      points: Value(points),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Enhancement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Enhancement(
      id: serializer.fromJson<String>(json['id']),
      detachmentId: serializer.fromJson<String>(json['detachmentId']),
      name: serializer.fromJson<String>(json['name']),
      points: serializer.fromJson<int>(json['points']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'detachmentId': serializer.toJson<String>(detachmentId),
      'name': serializer.toJson<String>(name),
      'points': serializer.toJson<int>(points),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Enhancement copyWith({
    String? id,
    String? detachmentId,
    String? name,
    int? points,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
  }) => Enhancement(
    id: id ?? this.id,
    detachmentId: detachmentId ?? this.detachmentId,
    name: name ?? this.name,
    points: points ?? this.points,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  Enhancement copyWithCompanion(EnhancementsCompanion data) {
    return Enhancement(
      id: data.id.present ? data.id.value : this.id,
      detachmentId: data.detachmentId.present
          ? data.detachmentId.value
          : this.detachmentId,
      name: data.name.present ? data.name.value : this.name,
      points: data.points.present ? data.points.value : this.points,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Enhancement(')
          ..write('id: $id, ')
          ..write('detachmentId: $detachmentId, ')
          ..write('name: $name, ')
          ..write('points: $points, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, detachmentId, name, points, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Enhancement &&
          other.id == this.id &&
          other.detachmentId == this.detachmentId &&
          other.name == this.name &&
          other.points == this.points &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class EnhancementsCompanion extends UpdateCompanion<Enhancement> {
  final Value<String> id;
  final Value<String> detachmentId;
  final Value<String> name;
  final Value<int> points;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EnhancementsCompanion({
    this.id = const Value.absent(),
    this.detachmentId = const Value.absent(),
    this.name = const Value.absent(),
    this.points = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnhancementsCompanion.insert({
    required String id,
    required String detachmentId,
    required String name,
    required int points,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       detachmentId = Value(detachmentId),
       name = Value(name),
       points = Value(points);
  static Insertable<Enhancement> custom({
    Expression<String>? id,
    Expression<String>? detachmentId,
    Expression<String>? name,
    Expression<int>? points,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detachmentId != null) 'detachment_id': detachmentId,
      if (name != null) 'name': name,
      if (points != null) 'points': points,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnhancementsCompanion copyWith({
    Value<String>? id,
    Value<String>? detachmentId,
    Value<String>? name,
    Value<int>? points,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EnhancementsCompanion(
      id: id ?? this.id,
      detachmentId: detachmentId ?? this.detachmentId,
      name: name ?? this.name,
      points: points ?? this.points,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (detachmentId.present) {
      map['detachment_id'] = Variable<String>(detachmentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnhancementsCompanion(')
          ..write('id: $id, ')
          ..write('detachmentId: $detachmentId, ')
          ..write('name: $name, ')
          ..write('points: $points, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StratagemsTable extends Stratagems
    with TableInfo<$StratagemsTable, Stratagem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StratagemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detachmentIdMeta = const VerificationMeta(
    'detachmentId',
  );
  @override
  late final GeneratedColumn<String> detachmentId = GeneratedColumn<String>(
    'detachment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commandPointsMeta = const VerificationMeta(
    'commandPoints',
  );
  @override
  late final GeneratedColumn<int> commandPoints = GeneratedColumn<int>(
    'command_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    detachmentId,
    name,
    commandPoints,
    phase,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stratagems';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stratagem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('detachment_id')) {
      context.handle(
        _detachmentIdMeta,
        detachmentId.isAcceptableOrUnknown(
          data['detachment_id']!,
          _detachmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detachmentIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('command_points')) {
      context.handle(
        _commandPointsMeta,
        commandPoints.isAcceptableOrUnknown(
          data['command_points']!,
          _commandPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commandPointsMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stratagem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stratagem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      detachmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detachment_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      commandPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}command_points'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StratagemsTable createAlias(String alias) {
    return $StratagemsTable(attachedDatabase, alias);
  }
}

class Stratagem extends DataClass implements Insertable<Stratagem> {
  final String id;
  final String detachmentId;
  final String name;
  final int commandPoints;
  final String? phase;
  final String? description;
  final DateTime createdAt;
  const Stratagem({
    required this.id,
    required this.detachmentId,
    required this.name,
    required this.commandPoints,
    this.phase,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['detachment_id'] = Variable<String>(detachmentId);
    map['name'] = Variable<String>(name);
    map['command_points'] = Variable<int>(commandPoints);
    if (!nullToAbsent || phase != null) {
      map['phase'] = Variable<String>(phase);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StratagemsCompanion toCompanion(bool nullToAbsent) {
    return StratagemsCompanion(
      id: Value(id),
      detachmentId: Value(detachmentId),
      name: Value(name),
      commandPoints: Value(commandPoints),
      phase: phase == null && nullToAbsent
          ? const Value.absent()
          : Value(phase),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Stratagem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stratagem(
      id: serializer.fromJson<String>(json['id']),
      detachmentId: serializer.fromJson<String>(json['detachmentId']),
      name: serializer.fromJson<String>(json['name']),
      commandPoints: serializer.fromJson<int>(json['commandPoints']),
      phase: serializer.fromJson<String?>(json['phase']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'detachmentId': serializer.toJson<String>(detachmentId),
      'name': serializer.toJson<String>(name),
      'commandPoints': serializer.toJson<int>(commandPoints),
      'phase': serializer.toJson<String?>(phase),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Stratagem copyWith({
    String? id,
    String? detachmentId,
    String? name,
    int? commandPoints,
    Value<String?> phase = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
  }) => Stratagem(
    id: id ?? this.id,
    detachmentId: detachmentId ?? this.detachmentId,
    name: name ?? this.name,
    commandPoints: commandPoints ?? this.commandPoints,
    phase: phase.present ? phase.value : this.phase,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  Stratagem copyWithCompanion(StratagemsCompanion data) {
    return Stratagem(
      id: data.id.present ? data.id.value : this.id,
      detachmentId: data.detachmentId.present
          ? data.detachmentId.value
          : this.detachmentId,
      name: data.name.present ? data.name.value : this.name,
      commandPoints: data.commandPoints.present
          ? data.commandPoints.value
          : this.commandPoints,
      phase: data.phase.present ? data.phase.value : this.phase,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stratagem(')
          ..write('id: $id, ')
          ..write('detachmentId: $detachmentId, ')
          ..write('name: $name, ')
          ..write('commandPoints: $commandPoints, ')
          ..write('phase: $phase, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    detachmentId,
    name,
    commandPoints,
    phase,
    description,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stratagem &&
          other.id == this.id &&
          other.detachmentId == this.detachmentId &&
          other.name == this.name &&
          other.commandPoints == this.commandPoints &&
          other.phase == this.phase &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class StratagemsCompanion extends UpdateCompanion<Stratagem> {
  final Value<String> id;
  final Value<String> detachmentId;
  final Value<String> name;
  final Value<int> commandPoints;
  final Value<String?> phase;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StratagemsCompanion({
    this.id = const Value.absent(),
    this.detachmentId = const Value.absent(),
    this.name = const Value.absent(),
    this.commandPoints = const Value.absent(),
    this.phase = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StratagemsCompanion.insert({
    required String id,
    required String detachmentId,
    required String name,
    required int commandPoints,
    this.phase = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       detachmentId = Value(detachmentId),
       name = Value(name),
       commandPoints = Value(commandPoints);
  static Insertable<Stratagem> custom({
    Expression<String>? id,
    Expression<String>? detachmentId,
    Expression<String>? name,
    Expression<int>? commandPoints,
    Expression<String>? phase,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detachmentId != null) 'detachment_id': detachmentId,
      if (name != null) 'name': name,
      if (commandPoints != null) 'command_points': commandPoints,
      if (phase != null) 'phase': phase,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StratagemsCompanion copyWith({
    Value<String>? id,
    Value<String>? detachmentId,
    Value<String>? name,
    Value<int>? commandPoints,
    Value<String?>? phase,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StratagemsCompanion(
      id: id ?? this.id,
      detachmentId: detachmentId ?? this.detachmentId,
      name: name ?? this.name,
      commandPoints: commandPoints ?? this.commandPoints,
      phase: phase ?? this.phase,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (detachmentId.present) {
      map['detachment_id'] = Variable<String>(detachmentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (commandPoints.present) {
      map['command_points'] = Variable<int>(commandPoints.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StratagemsCompanion(')
          ..write('id: $id, ')
          ..write('detachmentId: $detachmentId, ')
          ..write('name: $name, ')
          ..write('commandPoints: $commandPoints, ')
          ..write('phase: $phase, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArmiesTable extends Armies with TableInfo<$ArmiesTable, Army> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArmiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factionIdMeta = const VerificationMeta(
    'factionId',
  );
  @override
  late final GeneratedColumn<String> factionId = GeneratedColumn<String>(
    'faction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detachmentIdMeta = const VerificationMeta(
    'detachmentId',
  );
  @override
  late final GeneratedColumn<String> detachmentId = GeneratedColumn<String>(
    'detachment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsLimitMeta = const VerificationMeta(
    'pointsLimit',
  );
  @override
  late final GeneratedColumn<int> pointsLimit = GeneratedColumn<int>(
    'points_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    factionId,
    detachmentId,
    name,
    notes,
    pointsLimit,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'armies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Army> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('faction_id')) {
      context.handle(
        _factionIdMeta,
        factionId.isAcceptableOrUnknown(data['faction_id']!, _factionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_factionIdMeta);
    }
    if (data.containsKey('detachment_id')) {
      context.handle(
        _detachmentIdMeta,
        detachmentId.isAcceptableOrUnknown(
          data['detachment_id']!,
          _detachmentIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('points_limit')) {
      context.handle(
        _pointsLimitMeta,
        pointsLimit.isAcceptableOrUnknown(
          data['points_limit']!,
          _pointsLimitMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Army map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Army(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      factionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faction_id'],
      )!,
      detachmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detachment_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      pointsLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_limit'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ArmiesTable createAlias(String alias) {
    return $ArmiesTable(attachedDatabase, alias);
  }
}

class Army extends DataClass implements Insertable<Army> {
  final String id;
  final String factionId;
  final String? detachmentId;
  final String name;
  final String? notes;
  final int? pointsLimit;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Army({
    required this.id,
    required this.factionId,
    this.detachmentId,
    required this.name,
    this.notes,
    this.pointsLimit,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['faction_id'] = Variable<String>(factionId);
    if (!nullToAbsent || detachmentId != null) {
      map['detachment_id'] = Variable<String>(detachmentId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || pointsLimit != null) {
      map['points_limit'] = Variable<int>(pointsLimit);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ArmiesCompanion toCompanion(bool nullToAbsent) {
    return ArmiesCompanion(
      id: Value(id),
      factionId: Value(factionId),
      detachmentId: detachmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(detachmentId),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      pointsLimit: pointsLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(pointsLimit),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Army.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Army(
      id: serializer.fromJson<String>(json['id']),
      factionId: serializer.fromJson<String>(json['factionId']),
      detachmentId: serializer.fromJson<String?>(json['detachmentId']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      pointsLimit: serializer.fromJson<int?>(json['pointsLimit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'factionId': serializer.toJson<String>(factionId),
      'detachmentId': serializer.toJson<String?>(detachmentId),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'pointsLimit': serializer.toJson<int?>(pointsLimit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Army copyWith({
    String? id,
    String? factionId,
    Value<String?> detachmentId = const Value.absent(),
    String? name,
    Value<String?> notes = const Value.absent(),
    Value<int?> pointsLimit = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Army(
    id: id ?? this.id,
    factionId: factionId ?? this.factionId,
    detachmentId: detachmentId.present ? detachmentId.value : this.detachmentId,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    pointsLimit: pointsLimit.present ? pointsLimit.value : this.pointsLimit,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Army copyWithCompanion(ArmiesCompanion data) {
    return Army(
      id: data.id.present ? data.id.value : this.id,
      factionId: data.factionId.present ? data.factionId.value : this.factionId,
      detachmentId: data.detachmentId.present
          ? data.detachmentId.value
          : this.detachmentId,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      pointsLimit: data.pointsLimit.present
          ? data.pointsLimit.value
          : this.pointsLimit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Army(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('detachmentId: $detachmentId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('pointsLimit: $pointsLimit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    factionId,
    detachmentId,
    name,
    notes,
    pointsLimit,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Army &&
          other.id == this.id &&
          other.factionId == this.factionId &&
          other.detachmentId == this.detachmentId &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.pointsLimit == this.pointsLimit &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ArmiesCompanion extends UpdateCompanion<Army> {
  final Value<String> id;
  final Value<String> factionId;
  final Value<String?> detachmentId;
  final Value<String> name;
  final Value<String?> notes;
  final Value<int?> pointsLimit;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ArmiesCompanion({
    this.id = const Value.absent(),
    this.factionId = const Value.absent(),
    this.detachmentId = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.pointsLimit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArmiesCompanion.insert({
    required String id,
    required String factionId,
    this.detachmentId = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.pointsLimit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       factionId = Value(factionId),
       name = Value(name);
  static Insertable<Army> custom({
    Expression<String>? id,
    Expression<String>? factionId,
    Expression<String>? detachmentId,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<int>? pointsLimit,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (factionId != null) 'faction_id': factionId,
      if (detachmentId != null) 'detachment_id': detachmentId,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (pointsLimit != null) 'points_limit': pointsLimit,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArmiesCompanion copyWith({
    Value<String>? id,
    Value<String>? factionId,
    Value<String?>? detachmentId,
    Value<String>? name,
    Value<String?>? notes,
    Value<int?>? pointsLimit,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ArmiesCompanion(
      id: id ?? this.id,
      factionId: factionId ?? this.factionId,
      detachmentId: detachmentId ?? this.detachmentId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      pointsLimit: pointsLimit ?? this.pointsLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (factionId.present) {
      map['faction_id'] = Variable<String>(factionId.value);
    }
    if (detachmentId.present) {
      map['detachment_id'] = Variable<String>(detachmentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (pointsLimit.present) {
      map['points_limit'] = Variable<int>(pointsLimit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArmiesCompanion(')
          ..write('id: $id, ')
          ..write('factionId: $factionId, ')
          ..write('detachmentId: $detachmentId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('pointsLimit: $pointsLimit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArmyUnitsTable extends ArmyUnits
    with TableInfo<$ArmyUnitsTable, ArmyUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArmyUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armyIdMeta = const VerificationMeta('armyId');
  @override
  late final GeneratedColumn<String> armyId = GeneratedColumn<String>(
    'army_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enhancementIdMeta = const VerificationMeta(
    'enhancementId',
  );
  @override
  late final GeneratedColumn<String> enhancementId = GeneratedColumn<String>(
    'enhancement_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelCountMeta = const VerificationMeta(
    'modelCount',
  );
  @override
  late final GeneratedColumn<int> modelCount = GeneratedColumn<int>(
    'model_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    armyId,
    datasheetId,
    enhancementId,
    modelCount,
    displayOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'army_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArmyUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('army_id')) {
      context.handle(
        _armyIdMeta,
        armyId.isAcceptableOrUnknown(data['army_id']!, _armyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_armyIdMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('enhancement_id')) {
      context.handle(
        _enhancementIdMeta,
        enhancementId.isAcceptableOrUnknown(
          data['enhancement_id']!,
          _enhancementIdMeta,
        ),
      );
    }
    if (data.containsKey('model_count')) {
      context.handle(
        _modelCountMeta,
        modelCount.isAcceptableOrUnknown(data['model_count']!, _modelCountMeta),
      );
    } else if (isInserting) {
      context.missing(_modelCountMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArmyUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArmyUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      armyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}army_id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      enhancementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enhancement_id'],
      ),
      modelCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}model_count'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ArmyUnitsTable createAlias(String alias) {
    return $ArmyUnitsTable(attachedDatabase, alias);
  }
}

class ArmyUnit extends DataClass implements Insertable<ArmyUnit> {
  final String id;
  final String armyId;
  final String datasheetId;
  final String? enhancementId;
  final int modelCount;
  final int displayOrder;
  final DateTime createdAt;
  const ArmyUnit({
    required this.id,
    required this.armyId,
    required this.datasheetId,
    this.enhancementId,
    required this.modelCount,
    required this.displayOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['army_id'] = Variable<String>(armyId);
    map['datasheet_id'] = Variable<String>(datasheetId);
    if (!nullToAbsent || enhancementId != null) {
      map['enhancement_id'] = Variable<String>(enhancementId);
    }
    map['model_count'] = Variable<int>(modelCount);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ArmyUnitsCompanion toCompanion(bool nullToAbsent) {
    return ArmyUnitsCompanion(
      id: Value(id),
      armyId: Value(armyId),
      datasheetId: Value(datasheetId),
      enhancementId: enhancementId == null && nullToAbsent
          ? const Value.absent()
          : Value(enhancementId),
      modelCount: Value(modelCount),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
    );
  }

  factory ArmyUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArmyUnit(
      id: serializer.fromJson<String>(json['id']),
      armyId: serializer.fromJson<String>(json['armyId']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      enhancementId: serializer.fromJson<String?>(json['enhancementId']),
      modelCount: serializer.fromJson<int>(json['modelCount']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'armyId': serializer.toJson<String>(armyId),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'enhancementId': serializer.toJson<String?>(enhancementId),
      'modelCount': serializer.toJson<int>(modelCount),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ArmyUnit copyWith({
    String? id,
    String? armyId,
    String? datasheetId,
    Value<String?> enhancementId = const Value.absent(),
    int? modelCount,
    int? displayOrder,
    DateTime? createdAt,
  }) => ArmyUnit(
    id: id ?? this.id,
    armyId: armyId ?? this.armyId,
    datasheetId: datasheetId ?? this.datasheetId,
    enhancementId: enhancementId.present
        ? enhancementId.value
        : this.enhancementId,
    modelCount: modelCount ?? this.modelCount,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  ArmyUnit copyWithCompanion(ArmyUnitsCompanion data) {
    return ArmyUnit(
      id: data.id.present ? data.id.value : this.id,
      armyId: data.armyId.present ? data.armyId.value : this.armyId,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      enhancementId: data.enhancementId.present
          ? data.enhancementId.value
          : this.enhancementId,
      modelCount: data.modelCount.present
          ? data.modelCount.value
          : this.modelCount,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArmyUnit(')
          ..write('id: $id, ')
          ..write('armyId: $armyId, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('enhancementId: $enhancementId, ')
          ..write('modelCount: $modelCount, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    armyId,
    datasheetId,
    enhancementId,
    modelCount,
    displayOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArmyUnit &&
          other.id == this.id &&
          other.armyId == this.armyId &&
          other.datasheetId == this.datasheetId &&
          other.enhancementId == this.enhancementId &&
          other.modelCount == this.modelCount &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt);
}

class ArmyUnitsCompanion extends UpdateCompanion<ArmyUnit> {
  final Value<String> id;
  final Value<String> armyId;
  final Value<String> datasheetId;
  final Value<String?> enhancementId;
  final Value<int> modelCount;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ArmyUnitsCompanion({
    this.id = const Value.absent(),
    this.armyId = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.enhancementId = const Value.absent(),
    this.modelCount = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArmyUnitsCompanion.insert({
    required String id,
    required String armyId,
    required String datasheetId,
    this.enhancementId = const Value.absent(),
    required int modelCount,
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       armyId = Value(armyId),
       datasheetId = Value(datasheetId),
       modelCount = Value(modelCount);
  static Insertable<ArmyUnit> custom({
    Expression<String>? id,
    Expression<String>? armyId,
    Expression<String>? datasheetId,
    Expression<String>? enhancementId,
    Expression<int>? modelCount,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (armyId != null) 'army_id': armyId,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (enhancementId != null) 'enhancement_id': enhancementId,
      if (modelCount != null) 'model_count': modelCount,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArmyUnitsCompanion copyWith({
    Value<String>? id,
    Value<String>? armyId,
    Value<String>? datasheetId,
    Value<String?>? enhancementId,
    Value<int>? modelCount,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ArmyUnitsCompanion(
      id: id ?? this.id,
      armyId: armyId ?? this.armyId,
      datasheetId: datasheetId ?? this.datasheetId,
      enhancementId: enhancementId ?? this.enhancementId,
      modelCount: modelCount ?? this.modelCount,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (armyId.present) {
      map['army_id'] = Variable<String>(armyId.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (enhancementId.present) {
      map['enhancement_id'] = Variable<String>(enhancementId.value);
    }
    if (modelCount.present) {
      map['model_count'] = Variable<int>(modelCount.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArmyUnitsCompanion(')
          ..write('id: $id, ')
          ..write('armyId: $armyId, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('enhancementId: $enhancementId, ')
          ..write('modelCount: $modelCount, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArmyUnitEquipmentSelectionsTable extends ArmyUnitEquipmentSelections
    with
        TableInfo<
          $ArmyUnitEquipmentSelectionsTable,
          ArmyUnitEquipmentSelection
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArmyUnitEquipmentSelectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armyUnitIdMeta = const VerificationMeta(
    'armyUnitId',
  );
  @override
  late final GeneratedColumn<String> armyUnitId = GeneratedColumn<String>(
    'army_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionIdMeta = const VerificationMeta(
    'optionId',
  );
  @override
  late final GeneratedColumn<String> optionId = GeneratedColumn<String>(
    'option_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    armyUnitId,
    groupId,
    optionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'army_unit_equipment_selections';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArmyUnitEquipmentSelection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('army_unit_id')) {
      context.handle(
        _armyUnitIdMeta,
        armyUnitId.isAcceptableOrUnknown(
          data['army_unit_id']!,
          _armyUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_armyUnitIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('option_id')) {
      context.handle(
        _optionIdMeta,
        optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_optionIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArmyUnitEquipmentSelection map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArmyUnitEquipmentSelection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      armyUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}army_unit_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      optionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ArmyUnitEquipmentSelectionsTable createAlias(String alias) {
    return $ArmyUnitEquipmentSelectionsTable(attachedDatabase, alias);
  }
}

class ArmyUnitEquipmentSelection extends DataClass
    implements Insertable<ArmyUnitEquipmentSelection> {
  final String id;
  final String armyUnitId;
  final String groupId;
  final String optionId;
  final DateTime createdAt;
  const ArmyUnitEquipmentSelection({
    required this.id,
    required this.armyUnitId,
    required this.groupId,
    required this.optionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['army_unit_id'] = Variable<String>(armyUnitId);
    map['group_id'] = Variable<String>(groupId);
    map['option_id'] = Variable<String>(optionId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ArmyUnitEquipmentSelectionsCompanion toCompanion(bool nullToAbsent) {
    return ArmyUnitEquipmentSelectionsCompanion(
      id: Value(id),
      armyUnitId: Value(armyUnitId),
      groupId: Value(groupId),
      optionId: Value(optionId),
      createdAt: Value(createdAt),
    );
  }

  factory ArmyUnitEquipmentSelection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArmyUnitEquipmentSelection(
      id: serializer.fromJson<String>(json['id']),
      armyUnitId: serializer.fromJson<String>(json['armyUnitId']),
      groupId: serializer.fromJson<String>(json['groupId']),
      optionId: serializer.fromJson<String>(json['optionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'armyUnitId': serializer.toJson<String>(armyUnitId),
      'groupId': serializer.toJson<String>(groupId),
      'optionId': serializer.toJson<String>(optionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ArmyUnitEquipmentSelection copyWith({
    String? id,
    String? armyUnitId,
    String? groupId,
    String? optionId,
    DateTime? createdAt,
  }) => ArmyUnitEquipmentSelection(
    id: id ?? this.id,
    armyUnitId: armyUnitId ?? this.armyUnitId,
    groupId: groupId ?? this.groupId,
    optionId: optionId ?? this.optionId,
    createdAt: createdAt ?? this.createdAt,
  );
  ArmyUnitEquipmentSelection copyWithCompanion(
    ArmyUnitEquipmentSelectionsCompanion data,
  ) {
    return ArmyUnitEquipmentSelection(
      id: data.id.present ? data.id.value : this.id,
      armyUnitId: data.armyUnitId.present
          ? data.armyUnitId.value
          : this.armyUnitId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArmyUnitEquipmentSelection(')
          ..write('id: $id, ')
          ..write('armyUnitId: $armyUnitId, ')
          ..write('groupId: $groupId, ')
          ..write('optionId: $optionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, armyUnitId, groupId, optionId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArmyUnitEquipmentSelection &&
          other.id == this.id &&
          other.armyUnitId == this.armyUnitId &&
          other.groupId == this.groupId &&
          other.optionId == this.optionId &&
          other.createdAt == this.createdAt);
}

class ArmyUnitEquipmentSelectionsCompanion
    extends UpdateCompanion<ArmyUnitEquipmentSelection> {
  final Value<String> id;
  final Value<String> armyUnitId;
  final Value<String> groupId;
  final Value<String> optionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ArmyUnitEquipmentSelectionsCompanion({
    this.id = const Value.absent(),
    this.armyUnitId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.optionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArmyUnitEquipmentSelectionsCompanion.insert({
    required String id,
    required String armyUnitId,
    required String groupId,
    required String optionId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       armyUnitId = Value(armyUnitId),
       groupId = Value(groupId),
       optionId = Value(optionId);
  static Insertable<ArmyUnitEquipmentSelection> custom({
    Expression<String>? id,
    Expression<String>? armyUnitId,
    Expression<String>? groupId,
    Expression<String>? optionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (armyUnitId != null) 'army_unit_id': armyUnitId,
      if (groupId != null) 'group_id': groupId,
      if (optionId != null) 'option_id': optionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArmyUnitEquipmentSelectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? armyUnitId,
    Value<String>? groupId,
    Value<String>? optionId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ArmyUnitEquipmentSelectionsCompanion(
      id: id ?? this.id,
      armyUnitId: armyUnitId ?? this.armyUnitId,
      groupId: groupId ?? this.groupId,
      optionId: optionId ?? this.optionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (armyUnitId.present) {
      map['army_unit_id'] = Variable<String>(armyUnitId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (optionId.present) {
      map['option_id'] = Variable<String>(optionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArmyUnitEquipmentSelectionsCompanion(')
          ..write('id: $id, ')
          ..write('armyUnitId: $armyUnitId, ')
          ..write('groupId: $groupId, ')
          ..write('optionId: $optionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OwnedMiniaturesTable extends OwnedMiniatures
    with TableInfo<$OwnedMiniaturesTable, OwnedMiniature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedMiniaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assembledMeta = const VerificationMeta(
    'assembled',
  );
  @override
  late final GeneratedColumn<int> assembled = GeneratedColumn<int>(
    'assembled',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _primedMeta = const VerificationMeta('primed');
  @override
  late final GeneratedColumn<int> primed = GeneratedColumn<int>(
    'primed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paintedMeta = const VerificationMeta(
    'painted',
  );
  @override
  late final GeneratedColumn<int> painted = GeneratedColumn<int>(
    'painted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    quantity,
    assembled,
    primed,
    painted,
    notes,
    purchaseDate,
    purchasePrice,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_miniatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedMiniature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('assembled')) {
      context.handle(
        _assembledMeta,
        assembled.isAcceptableOrUnknown(data['assembled']!, _assembledMeta),
      );
    }
    if (data.containsKey('primed')) {
      context.handle(
        _primedMeta,
        primed.isAcceptableOrUnknown(data['primed']!, _primedMeta),
      );
    }
    if (data.containsKey('painted')) {
      context.handle(
        _paintedMeta,
        painted.isAcceptableOrUnknown(data['painted']!, _paintedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OwnedMiniature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedMiniature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      assembled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assembled'],
      )!,
      primed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primed'],
      )!,
      painted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}painted'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OwnedMiniaturesTable createAlias(String alias) {
    return $OwnedMiniaturesTable(attachedDatabase, alias);
  }
}

class OwnedMiniature extends DataClass implements Insertable<OwnedMiniature> {
  final String id;
  final String datasheetId;
  final int quantity;
  final int assembled;
  final int primed;
  final int painted;
  final String? notes;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OwnedMiniature({
    required this.id,
    required this.datasheetId,
    required this.quantity,
    required this.assembled,
    required this.primed,
    required this.painted,
    this.notes,
    this.purchaseDate,
    this.purchasePrice,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['quantity'] = Variable<int>(quantity);
    map['assembled'] = Variable<int>(assembled);
    map['primed'] = Variable<int>(primed);
    map['painted'] = Variable<int>(painted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OwnedMiniaturesCompanion toCompanion(bool nullToAbsent) {
    return OwnedMiniaturesCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      quantity: Value(quantity),
      assembled: Value(assembled),
      primed: Value(primed),
      painted: Value(painted),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OwnedMiniature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedMiniature(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      assembled: serializer.fromJson<int>(json['assembled']),
      primed: serializer.fromJson<int>(json['primed']),
      painted: serializer.fromJson<int>(json['painted']),
      notes: serializer.fromJson<String?>(json['notes']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'quantity': serializer.toJson<int>(quantity),
      'assembled': serializer.toJson<int>(assembled),
      'primed': serializer.toJson<int>(primed),
      'painted': serializer.toJson<int>(painted),
      'notes': serializer.toJson<String?>(notes),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OwnedMiniature copyWith({
    String? id,
    String? datasheetId,
    int? quantity,
    int? assembled,
    int? primed,
    int? painted,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> purchaseDate = const Value.absent(),
    Value<double?> purchasePrice = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OwnedMiniature(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    quantity: quantity ?? this.quantity,
    assembled: assembled ?? this.assembled,
    primed: primed ?? this.primed,
    painted: painted ?? this.painted,
    notes: notes.present ? notes.value : this.notes,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OwnedMiniature copyWithCompanion(OwnedMiniaturesCompanion data) {
    return OwnedMiniature(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      assembled: data.assembled.present ? data.assembled.value : this.assembled,
      primed: data.primed.present ? data.primed.value : this.primed,
      painted: data.painted.present ? data.painted.value : this.painted,
      notes: data.notes.present ? data.notes.value : this.notes,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedMiniature(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('quantity: $quantity, ')
          ..write('assembled: $assembled, ')
          ..write('primed: $primed, ')
          ..write('painted: $painted, ')
          ..write('notes: $notes, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    datasheetId,
    quantity,
    assembled,
    primed,
    painted,
    notes,
    purchaseDate,
    purchasePrice,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedMiniature &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.quantity == this.quantity &&
          other.assembled == this.assembled &&
          other.primed == this.primed &&
          other.painted == this.painted &&
          other.notes == this.notes &&
          other.purchaseDate == this.purchaseDate &&
          other.purchasePrice == this.purchasePrice &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OwnedMiniaturesCompanion extends UpdateCompanion<OwnedMiniature> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<int> quantity;
  final Value<int> assembled;
  final Value<int> primed;
  final Value<int> painted;
  final Value<String?> notes;
  final Value<DateTime?> purchaseDate;
  final Value<double?> purchasePrice;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OwnedMiniaturesCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.assembled = const Value.absent(),
    this.primed = const Value.absent(),
    this.painted = const Value.absent(),
    this.notes = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnedMiniaturesCompanion.insert({
    required String id,
    required String datasheetId,
    required int quantity,
    this.assembled = const Value.absent(),
    this.primed = const Value.absent(),
    this.painted = const Value.absent(),
    this.notes = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId),
       quantity = Value(quantity);
  static Insertable<OwnedMiniature> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<int>? quantity,
    Expression<int>? assembled,
    Expression<int>? primed,
    Expression<int>? painted,
    Expression<String>? notes,
    Expression<DateTime>? purchaseDate,
    Expression<double>? purchasePrice,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (quantity != null) 'quantity': quantity,
      if (assembled != null) 'assembled': assembled,
      if (primed != null) 'primed': primed,
      if (painted != null) 'painted': painted,
      if (notes != null) 'notes': notes,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnedMiniaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<int>? quantity,
    Value<int>? assembled,
    Value<int>? primed,
    Value<int>? painted,
    Value<String?>? notes,
    Value<DateTime?>? purchaseDate,
    Value<double?>? purchasePrice,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OwnedMiniaturesCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      quantity: quantity ?? this.quantity,
      assembled: assembled ?? this.assembled,
      primed: primed ?? this.primed,
      painted: painted ?? this.painted,
      notes: notes ?? this.notes,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (assembled.present) {
      map['assembled'] = Variable<int>(assembled.value);
    }
    if (primed.present) {
      map['primed'] = Variable<int>(primed.value);
    }
    if (painted.present) {
      map['painted'] = Variable<int>(painted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedMiniaturesCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('quantity: $quantity, ')
          ..write('assembled: $assembled, ')
          ..write('primed: $primed, ')
          ..write('painted: $painted, ')
          ..write('notes: $notes, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WishlistItemsTable extends WishlistItems
    with TableInfo<$WishlistItemsTable, WishlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datasheetIdMeta = const VerificationMeta(
    'datasheetId',
  );
  @override
  late final GeneratedColumn<String> datasheetId = GeneratedColumn<String>(
    'datasheet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    datasheetId,
    quantity,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishlistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('datasheet_id')) {
      context.handle(
        _datasheetIdMeta,
        datasheetId.isAcceptableOrUnknown(
          data['datasheet_id']!,
          _datasheetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datasheetIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      datasheetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WishlistItemsTable createAlias(String alias) {
    return $WishlistItemsTable(attachedDatabase, alias);
  }
}

class WishlistItem extends DataClass implements Insertable<WishlistItem> {
  final String id;
  final String datasheetId;
  final int quantity;
  final String? notes;
  final DateTime createdAt;
  const WishlistItem({
    required this.id,
    required this.datasheetId,
    required this.quantity,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['datasheet_id'] = Variable<String>(datasheetId);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WishlistItemsCompanion toCompanion(bool nullToAbsent) {
    return WishlistItemsCompanion(
      id: Value(id),
      datasheetId: Value(datasheetId),
      quantity: Value(quantity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory WishlistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistItem(
      id: serializer.fromJson<String>(json['id']),
      datasheetId: serializer.fromJson<String>(json['datasheetId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'datasheetId': serializer.toJson<String>(datasheetId),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WishlistItem copyWith({
    String? id,
    String? datasheetId,
    int? quantity,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => WishlistItem(
    id: id ?? this.id,
    datasheetId: datasheetId ?? this.datasheetId,
    quantity: quantity ?? this.quantity,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  WishlistItem copyWithCompanion(WishlistItemsCompanion data) {
    return WishlistItem(
      id: data.id.present ? data.id.value : this.id,
      datasheetId: data.datasheetId.present
          ? data.datasheetId.value
          : this.datasheetId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItem(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, datasheetId, quantity, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistItem &&
          other.id == this.id &&
          other.datasheetId == this.datasheetId &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class WishlistItemsCompanion extends UpdateCompanion<WishlistItem> {
  final Value<String> id;
  final Value<String> datasheetId;
  final Value<int> quantity;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WishlistItemsCompanion({
    this.id = const Value.absent(),
    this.datasheetId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WishlistItemsCompanion.insert({
    required String id,
    required String datasheetId,
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       datasheetId = Value(datasheetId);
  static Insertable<WishlistItem> custom({
    Expression<String>? id,
    Expression<String>? datasheetId,
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datasheetId != null) 'datasheet_id': datasheetId,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WishlistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? datasheetId,
    Value<int>? quantity,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WishlistItemsCompanion(
      id: id ?? this.id,
      datasheetId: datasheetId ?? this.datasheetId,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (datasheetId.present) {
      map['datasheet_id'] = Variable<String>(datasheetId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItemsCompanion(')
          ..write('id: $id, ')
          ..write('datasheetId: $datasheetId, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BattlesTable extends Battles with TableInfo<$BattlesTable, Battle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BattlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armyIdMeta = const VerificationMeta('armyId');
  @override
  late final GeneratedColumn<String> armyId = GeneratedColumn<String>(
    'army_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opponentNameMeta = const VerificationMeta(
    'opponentName',
  );
  @override
  late final GeneratedColumn<String> opponentName = GeneratedColumn<String>(
    'opponent_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opponentFactionIdMeta = const VerificationMeta(
    'opponentFactionId',
  );
  @override
  late final GeneratedColumn<String> opponentFactionId =
      GeneratedColumn<String>(
        'opponent_faction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missionNameMeta = const VerificationMeta(
    'missionName',
  );
  @override
  late final GeneratedColumn<String> missionName = GeneratedColumn<String>(
    'mission_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BattleResult?, String> result =
      GeneratedColumn<String>(
        'result',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<BattleResult?>($BattlesTable.$converterresultn);
  @override
  late final GeneratedColumnWithTypeConverter<BattleType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(BattleType.matched.name),
      ).withConverter<BattleType>($BattlesTable.$convertertype);
  static const VerificationMeta _myScoreMeta = const VerificationMeta(
    'myScore',
  );
  @override
  late final GeneratedColumn<int> myScore = GeneratedColumn<int>(
    'my_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opponentScoreMeta = const VerificationMeta(
    'opponentScore',
  );
  @override
  late final GeneratedColumn<int> opponentScore = GeneratedColumn<int>(
    'opponent_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    armyId,
    opponentName,
    opponentFactionId,
    location,
    missionName,
    result,
    type,
    myScore,
    opponentScore,
    notes,
    playedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'battles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Battle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('army_id')) {
      context.handle(
        _armyIdMeta,
        armyId.isAcceptableOrUnknown(data['army_id']!, _armyIdMeta),
      );
    }
    if (data.containsKey('opponent_name')) {
      context.handle(
        _opponentNameMeta,
        opponentName.isAcceptableOrUnknown(
          data['opponent_name']!,
          _opponentNameMeta,
        ),
      );
    }
    if (data.containsKey('opponent_faction_id')) {
      context.handle(
        _opponentFactionIdMeta,
        opponentFactionId.isAcceptableOrUnknown(
          data['opponent_faction_id']!,
          _opponentFactionIdMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('mission_name')) {
      context.handle(
        _missionNameMeta,
        missionName.isAcceptableOrUnknown(
          data['mission_name']!,
          _missionNameMeta,
        ),
      );
    }
    if (data.containsKey('my_score')) {
      context.handle(
        _myScoreMeta,
        myScore.isAcceptableOrUnknown(data['my_score']!, _myScoreMeta),
      );
    }
    if (data.containsKey('opponent_score')) {
      context.handle(
        _opponentScoreMeta,
        opponentScore.isAcceptableOrUnknown(
          data['opponent_score']!,
          _opponentScoreMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Battle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Battle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      armyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}army_id'],
      ),
      opponentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opponent_name'],
      ),
      opponentFactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opponent_faction_id'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      missionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mission_name'],
      ),
      result: $BattlesTable.$converterresultn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}result'],
        ),
      ),
      type: $BattlesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      myScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}my_score'],
      ),
      opponentScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opponent_score'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}played_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BattlesTable createAlias(String alias) {
    return $BattlesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BattleResult, String, String> $converterresult =
      const EnumNameConverter<BattleResult>(BattleResult.values);
  static JsonTypeConverter2<BattleResult?, String?, String?> $converterresultn =
      JsonTypeConverter2.asNullable($converterresult);
  static JsonTypeConverter2<BattleType, String, String> $convertertype =
      const EnumNameConverter<BattleType>(BattleType.values);
}

class Battle extends DataClass implements Insertable<Battle> {
  final String id;
  final String? armyId;
  final String? opponentName;
  final String? opponentFactionId;
  final String? location;
  final String? missionName;
  final BattleResult? result;
  final BattleType type;
  final int? myScore;
  final int? opponentScore;
  final String? notes;
  final DateTime playedAt;
  final DateTime createdAt;
  const Battle({
    required this.id,
    this.armyId,
    this.opponentName,
    this.opponentFactionId,
    this.location,
    this.missionName,
    this.result,
    required this.type,
    this.myScore,
    this.opponentScore,
    this.notes,
    required this.playedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || armyId != null) {
      map['army_id'] = Variable<String>(armyId);
    }
    if (!nullToAbsent || opponentName != null) {
      map['opponent_name'] = Variable<String>(opponentName);
    }
    if (!nullToAbsent || opponentFactionId != null) {
      map['opponent_faction_id'] = Variable<String>(opponentFactionId);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || missionName != null) {
      map['mission_name'] = Variable<String>(missionName);
    }
    if (!nullToAbsent || result != null) {
      map['result'] = Variable<String>(
        $BattlesTable.$converterresultn.toSql(result),
      );
    }
    {
      map['type'] = Variable<String>($BattlesTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || myScore != null) {
      map['my_score'] = Variable<int>(myScore);
    }
    if (!nullToAbsent || opponentScore != null) {
      map['opponent_score'] = Variable<int>(opponentScore);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['played_at'] = Variable<DateTime>(playedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BattlesCompanion toCompanion(bool nullToAbsent) {
    return BattlesCompanion(
      id: Value(id),
      armyId: armyId == null && nullToAbsent
          ? const Value.absent()
          : Value(armyId),
      opponentName: opponentName == null && nullToAbsent
          ? const Value.absent()
          : Value(opponentName),
      opponentFactionId: opponentFactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(opponentFactionId),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      missionName: missionName == null && nullToAbsent
          ? const Value.absent()
          : Value(missionName),
      result: result == null && nullToAbsent
          ? const Value.absent()
          : Value(result),
      type: Value(type),
      myScore: myScore == null && nullToAbsent
          ? const Value.absent()
          : Value(myScore),
      opponentScore: opponentScore == null && nullToAbsent
          ? const Value.absent()
          : Value(opponentScore),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      playedAt: Value(playedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Battle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Battle(
      id: serializer.fromJson<String>(json['id']),
      armyId: serializer.fromJson<String?>(json['armyId']),
      opponentName: serializer.fromJson<String?>(json['opponentName']),
      opponentFactionId: serializer.fromJson<String?>(
        json['opponentFactionId'],
      ),
      location: serializer.fromJson<String?>(json['location']),
      missionName: serializer.fromJson<String?>(json['missionName']),
      result: $BattlesTable.$converterresultn.fromJson(
        serializer.fromJson<String?>(json['result']),
      ),
      type: $BattlesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      myScore: serializer.fromJson<int?>(json['myScore']),
      opponentScore: serializer.fromJson<int?>(json['opponentScore']),
      notes: serializer.fromJson<String?>(json['notes']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'armyId': serializer.toJson<String?>(armyId),
      'opponentName': serializer.toJson<String?>(opponentName),
      'opponentFactionId': serializer.toJson<String?>(opponentFactionId),
      'location': serializer.toJson<String?>(location),
      'missionName': serializer.toJson<String?>(missionName),
      'result': serializer.toJson<String?>(
        $BattlesTable.$converterresultn.toJson(result),
      ),
      'type': serializer.toJson<String>(
        $BattlesTable.$convertertype.toJson(type),
      ),
      'myScore': serializer.toJson<int?>(myScore),
      'opponentScore': serializer.toJson<int?>(opponentScore),
      'notes': serializer.toJson<String?>(notes),
      'playedAt': serializer.toJson<DateTime>(playedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Battle copyWith({
    String? id,
    Value<String?> armyId = const Value.absent(),
    Value<String?> opponentName = const Value.absent(),
    Value<String?> opponentFactionId = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> missionName = const Value.absent(),
    Value<BattleResult?> result = const Value.absent(),
    BattleType? type,
    Value<int?> myScore = const Value.absent(),
    Value<int?> opponentScore = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? playedAt,
    DateTime? createdAt,
  }) => Battle(
    id: id ?? this.id,
    armyId: armyId.present ? armyId.value : this.armyId,
    opponentName: opponentName.present ? opponentName.value : this.opponentName,
    opponentFactionId: opponentFactionId.present
        ? opponentFactionId.value
        : this.opponentFactionId,
    location: location.present ? location.value : this.location,
    missionName: missionName.present ? missionName.value : this.missionName,
    result: result.present ? result.value : this.result,
    type: type ?? this.type,
    myScore: myScore.present ? myScore.value : this.myScore,
    opponentScore: opponentScore.present
        ? opponentScore.value
        : this.opponentScore,
    notes: notes.present ? notes.value : this.notes,
    playedAt: playedAt ?? this.playedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Battle copyWithCompanion(BattlesCompanion data) {
    return Battle(
      id: data.id.present ? data.id.value : this.id,
      armyId: data.armyId.present ? data.armyId.value : this.armyId,
      opponentName: data.opponentName.present
          ? data.opponentName.value
          : this.opponentName,
      opponentFactionId: data.opponentFactionId.present
          ? data.opponentFactionId.value
          : this.opponentFactionId,
      location: data.location.present ? data.location.value : this.location,
      missionName: data.missionName.present
          ? data.missionName.value
          : this.missionName,
      result: data.result.present ? data.result.value : this.result,
      type: data.type.present ? data.type.value : this.type,
      myScore: data.myScore.present ? data.myScore.value : this.myScore,
      opponentScore: data.opponentScore.present
          ? data.opponentScore.value
          : this.opponentScore,
      notes: data.notes.present ? data.notes.value : this.notes,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Battle(')
          ..write('id: $id, ')
          ..write('armyId: $armyId, ')
          ..write('opponentName: $opponentName, ')
          ..write('opponentFactionId: $opponentFactionId, ')
          ..write('location: $location, ')
          ..write('missionName: $missionName, ')
          ..write('result: $result, ')
          ..write('type: $type, ')
          ..write('myScore: $myScore, ')
          ..write('opponentScore: $opponentScore, ')
          ..write('notes: $notes, ')
          ..write('playedAt: $playedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    armyId,
    opponentName,
    opponentFactionId,
    location,
    missionName,
    result,
    type,
    myScore,
    opponentScore,
    notes,
    playedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Battle &&
          other.id == this.id &&
          other.armyId == this.armyId &&
          other.opponentName == this.opponentName &&
          other.opponentFactionId == this.opponentFactionId &&
          other.location == this.location &&
          other.missionName == this.missionName &&
          other.result == this.result &&
          other.type == this.type &&
          other.myScore == this.myScore &&
          other.opponentScore == this.opponentScore &&
          other.notes == this.notes &&
          other.playedAt == this.playedAt &&
          other.createdAt == this.createdAt);
}

class BattlesCompanion extends UpdateCompanion<Battle> {
  final Value<String> id;
  final Value<String?> armyId;
  final Value<String?> opponentName;
  final Value<String?> opponentFactionId;
  final Value<String?> location;
  final Value<String?> missionName;
  final Value<BattleResult?> result;
  final Value<BattleType> type;
  final Value<int?> myScore;
  final Value<int?> opponentScore;
  final Value<String?> notes;
  final Value<DateTime> playedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BattlesCompanion({
    this.id = const Value.absent(),
    this.armyId = const Value.absent(),
    this.opponentName = const Value.absent(),
    this.opponentFactionId = const Value.absent(),
    this.location = const Value.absent(),
    this.missionName = const Value.absent(),
    this.result = const Value.absent(),
    this.type = const Value.absent(),
    this.myScore = const Value.absent(),
    this.opponentScore = const Value.absent(),
    this.notes = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BattlesCompanion.insert({
    required String id,
    this.armyId = const Value.absent(),
    this.opponentName = const Value.absent(),
    this.opponentFactionId = const Value.absent(),
    this.location = const Value.absent(),
    this.missionName = const Value.absent(),
    this.result = const Value.absent(),
    this.type = const Value.absent(),
    this.myScore = const Value.absent(),
    this.opponentScore = const Value.absent(),
    this.notes = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Battle> custom({
    Expression<String>? id,
    Expression<String>? armyId,
    Expression<String>? opponentName,
    Expression<String>? opponentFactionId,
    Expression<String>? location,
    Expression<String>? missionName,
    Expression<String>? result,
    Expression<String>? type,
    Expression<int>? myScore,
    Expression<int>? opponentScore,
    Expression<String>? notes,
    Expression<DateTime>? playedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (armyId != null) 'army_id': armyId,
      if (opponentName != null) 'opponent_name': opponentName,
      if (opponentFactionId != null) 'opponent_faction_id': opponentFactionId,
      if (location != null) 'location': location,
      if (missionName != null) 'mission_name': missionName,
      if (result != null) 'result': result,
      if (type != null) 'type': type,
      if (myScore != null) 'my_score': myScore,
      if (opponentScore != null) 'opponent_score': opponentScore,
      if (notes != null) 'notes': notes,
      if (playedAt != null) 'played_at': playedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BattlesCompanion copyWith({
    Value<String>? id,
    Value<String?>? armyId,
    Value<String?>? opponentName,
    Value<String?>? opponentFactionId,
    Value<String?>? location,
    Value<String?>? missionName,
    Value<BattleResult?>? result,
    Value<BattleType>? type,
    Value<int?>? myScore,
    Value<int?>? opponentScore,
    Value<String?>? notes,
    Value<DateTime>? playedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BattlesCompanion(
      id: id ?? this.id,
      armyId: armyId ?? this.armyId,
      opponentName: opponentName ?? this.opponentName,
      opponentFactionId: opponentFactionId ?? this.opponentFactionId,
      location: location ?? this.location,
      missionName: missionName ?? this.missionName,
      result: result ?? this.result,
      type: type ?? this.type,
      myScore: myScore ?? this.myScore,
      opponentScore: opponentScore ?? this.opponentScore,
      notes: notes ?? this.notes,
      playedAt: playedAt ?? this.playedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (armyId.present) {
      map['army_id'] = Variable<String>(armyId.value);
    }
    if (opponentName.present) {
      map['opponent_name'] = Variable<String>(opponentName.value);
    }
    if (opponentFactionId.present) {
      map['opponent_faction_id'] = Variable<String>(opponentFactionId.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (missionName.present) {
      map['mission_name'] = Variable<String>(missionName.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(
        $BattlesTable.$converterresultn.toSql(result.value),
      );
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $BattlesTable.$convertertype.toSql(type.value),
      );
    }
    if (myScore.present) {
      map['my_score'] = Variable<int>(myScore.value);
    }
    if (opponentScore.present) {
      map['opponent_score'] = Variable<int>(opponentScore.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BattlesCompanion(')
          ..write('id: $id, ')
          ..write('armyId: $armyId, ')
          ..write('opponentName: $opponentName, ')
          ..write('opponentFactionId: $opponentFactionId, ')
          ..write('location: $location, ')
          ..write('missionName: $missionName, ')
          ..write('result: $result, ')
          ..write('type: $type, ')
          ..write('myScore: $myScore, ')
          ..write('opponentScore: $opponentScore, ')
          ..write('notes: $notes, ')
          ..write('playedAt: $playedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _progressPercentMeta = const VerificationMeta(
    'progressPercent',
  );
  @override
  late final GeneratedColumn<int> progressPercent = GeneratedColumn<int>(
    'progress_percent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    done,
    progressPercent,
    displayOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
        _progressPercentMeta,
        progressPercent.isAcceptableOrUnknown(
          data['progress_percent']!,
          _progressPercentMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      progressPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_percent'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String title;
  final bool done;
  final int? progressPercent;
  final int displayOrder;
  final DateTime createdAt;
  const Project({
    required this.id,
    required this.title,
    required this.done,
    this.progressPercent,
    required this.displayOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || progressPercent != null) {
      map['progress_percent'] = Variable<int>(progressPercent);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      title: Value(title),
      done: Value(done),
      progressPercent: progressPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(progressPercent),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      done: serializer.fromJson<bool>(json['done']),
      progressPercent: serializer.fromJson<int?>(json['progressPercent']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'done': serializer.toJson<bool>(done),
      'progressPercent': serializer.toJson<int?>(progressPercent),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Project copyWith({
    String? id,
    String? title,
    bool? done,
    Value<int?> progressPercent = const Value.absent(),
    int? displayOrder,
    DateTime? createdAt,
  }) => Project(
    id: id ?? this.id,
    title: title ?? this.title,
    done: done ?? this.done,
    progressPercent: progressPercent.present
        ? progressPercent.value
        : this.progressPercent,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      done: data.done.present ? data.done.value : this.done,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, done, progressPercent, displayOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.title == this.title &&
          other.done == this.done &&
          other.progressPercent == this.progressPercent &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> done;
  final Value<int?> progressPercent;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.done = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String title,
    this.done = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? done,
    Expression<int>? progressPercent,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (done != null) 'done': done,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<bool>? done,
    Value<int?>? progressPercent,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      progressPercent: progressPercent ?? this.progressPercent,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<int>(progressPercent.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpCategoryTotalsTable extends XpCategoryTotals
    with TableInfo<$XpCategoryTotalsTable, XpCategoryTotal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpCategoryTotalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [category, xp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_category_totals';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpCategoryTotal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {category};
  @override
  XpCategoryTotal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpCategoryTotal(
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
    );
  }

  @override
  $XpCategoryTotalsTable createAlias(String alias) {
    return $XpCategoryTotalsTable(attachedDatabase, alias);
  }
}

class XpCategoryTotal extends DataClass implements Insertable<XpCategoryTotal> {
  final String category;
  final int xp;
  const XpCategoryTotal({required this.category, required this.xp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category'] = Variable<String>(category);
    map['xp'] = Variable<int>(xp);
    return map;
  }

  XpCategoryTotalsCompanion toCompanion(bool nullToAbsent) {
    return XpCategoryTotalsCompanion(category: Value(category), xp: Value(xp));
  }

  factory XpCategoryTotal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpCategoryTotal(
      category: serializer.fromJson<String>(json['category']),
      xp: serializer.fromJson<int>(json['xp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'category': serializer.toJson<String>(category),
      'xp': serializer.toJson<int>(xp),
    };
  }

  XpCategoryTotal copyWith({String? category, int? xp}) =>
      XpCategoryTotal(category: category ?? this.category, xp: xp ?? this.xp);
  XpCategoryTotal copyWithCompanion(XpCategoryTotalsCompanion data) {
    return XpCategoryTotal(
      category: data.category.present ? data.category.value : this.category,
      xp: data.xp.present ? data.xp.value : this.xp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpCategoryTotal(')
          ..write('category: $category, ')
          ..write('xp: $xp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(category, xp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpCategoryTotal &&
          other.category == this.category &&
          other.xp == this.xp);
}

class XpCategoryTotalsCompanion extends UpdateCompanion<XpCategoryTotal> {
  final Value<String> category;
  final Value<int> xp;
  final Value<int> rowid;
  const XpCategoryTotalsCompanion({
    this.category = const Value.absent(),
    this.xp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  XpCategoryTotalsCompanion.insert({
    required String category,
    this.xp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : category = Value(category);
  static Insertable<XpCategoryTotal> custom({
    Expression<String>? category,
    Expression<int>? xp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (category != null) 'category': category,
      if (xp != null) 'xp': xp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  XpCategoryTotalsCompanion copyWith({
    Value<String>? category,
    Value<int>? xp,
    Value<int>? rowid,
  }) {
    return XpCategoryTotalsCompanion(
      category: category ?? this.category,
      xp: xp ?? this.xp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpCategoryTotalsCompanion(')
          ..write('category: $category, ')
          ..write('xp: $xp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpFactionTotalsTable extends XpFactionTotals
    with TableInfo<$XpFactionTotalsTable, XpFactionTotal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpFactionTotalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _factionIdMeta = const VerificationMeta(
    'factionId',
  );
  @override
  late final GeneratedColumn<String> factionId = GeneratedColumn<String>(
    'faction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [factionId, xp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_faction_totals';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpFactionTotal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('faction_id')) {
      context.handle(
        _factionIdMeta,
        factionId.isAcceptableOrUnknown(data['faction_id']!, _factionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_factionIdMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {factionId};
  @override
  XpFactionTotal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpFactionTotal(
      factionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faction_id'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
    );
  }

  @override
  $XpFactionTotalsTable createAlias(String alias) {
    return $XpFactionTotalsTable(attachedDatabase, alias);
  }
}

class XpFactionTotal extends DataClass implements Insertable<XpFactionTotal> {
  final String factionId;
  final int xp;
  const XpFactionTotal({required this.factionId, required this.xp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['faction_id'] = Variable<String>(factionId);
    map['xp'] = Variable<int>(xp);
    return map;
  }

  XpFactionTotalsCompanion toCompanion(bool nullToAbsent) {
    return XpFactionTotalsCompanion(factionId: Value(factionId), xp: Value(xp));
  }

  factory XpFactionTotal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpFactionTotal(
      factionId: serializer.fromJson<String>(json['factionId']),
      xp: serializer.fromJson<int>(json['xp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'factionId': serializer.toJson<String>(factionId),
      'xp': serializer.toJson<int>(xp),
    };
  }

  XpFactionTotal copyWith({String? factionId, int? xp}) =>
      XpFactionTotal(factionId: factionId ?? this.factionId, xp: xp ?? this.xp);
  XpFactionTotal copyWithCompanion(XpFactionTotalsCompanion data) {
    return XpFactionTotal(
      factionId: data.factionId.present ? data.factionId.value : this.factionId,
      xp: data.xp.present ? data.xp.value : this.xp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpFactionTotal(')
          ..write('factionId: $factionId, ')
          ..write('xp: $xp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(factionId, xp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpFactionTotal &&
          other.factionId == this.factionId &&
          other.xp == this.xp);
}

class XpFactionTotalsCompanion extends UpdateCompanion<XpFactionTotal> {
  final Value<String> factionId;
  final Value<int> xp;
  final Value<int> rowid;
  const XpFactionTotalsCompanion({
    this.factionId = const Value.absent(),
    this.xp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  XpFactionTotalsCompanion.insert({
    required String factionId,
    this.xp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : factionId = Value(factionId);
  static Insertable<XpFactionTotal> custom({
    Expression<String>? factionId,
    Expression<int>? xp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (factionId != null) 'faction_id': factionId,
      if (xp != null) 'xp': xp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  XpFactionTotalsCompanion copyWith({
    Value<String>? factionId,
    Value<int>? xp,
    Value<int>? rowid,
  }) {
    return XpFactionTotalsCompanion(
      factionId: factionId ?? this.factionId,
      xp: xp ?? this.xp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (factionId.present) {
      map['faction_id'] = Variable<String>(factionId.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpFactionTotalsCompanion(')
          ..write('factionId: $factionId, ')
          ..write('xp: $xp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GameSystemsTable gameSystems = $GameSystemsTable(this);
  late final $EditionsTable editions = $EditionsTable(this);
  late final $GameModesTable gameModes = $GameModesTable(this);
  late final $FactionsTable factions = $FactionsTable(this);
  late final $SubFactionsTable subFactions = $SubFactionsTable(this);
  late final $KeywordsTable keywords = $KeywordsTable(this);
  late final $AbilitiesTable abilities = $AbilitiesTable(this);
  late final $DatasheetsTable datasheets = $DatasheetsTable(this);
  late final $DatasheetModelsTable datasheetModels = $DatasheetModelsTable(
    this,
  );
  late final $ModelProfilesTable modelProfiles = $ModelProfilesTable(this);
  late final $UnitSizesTable unitSizes = $UnitSizesTable(this);
  late final $UnitCompositionsTable unitCompositions = $UnitCompositionsTable(
    this,
  );
  late final $DatasheetCostsTable datasheetCosts = $DatasheetCostsTable(this);
  late final $DatasheetVersionsTable datasheetVersions =
      $DatasheetVersionsTable(this);
  late final $DatasheetSourcesTable datasheetSources = $DatasheetSourcesTable(
    this,
  );
  late final $EquipmentGroupsTable equipmentGroups = $EquipmentGroupsTable(
    this,
  );
  late final $EquipmentOptionsTable equipmentOptions = $EquipmentOptionsTable(
    this,
  );
  late final $EquipmentChoicesTable equipmentChoices = $EquipmentChoicesTable(
    this,
  );
  late final $EquipmentRestrictionsTable equipmentRestrictions =
      $EquipmentRestrictionsTable(this);
  late final $WeaponsTable weapons = $WeaponsTable(this);
  late final $WeaponProfilesTable weaponProfiles = $WeaponProfilesTable(this);
  late final $DatasheetWeaponsTable datasheetWeapons = $DatasheetWeaponsTable(
    this,
  );
  late final $WeaponKeywordLinksTable weaponKeywordLinks =
      $WeaponKeywordLinksTable(this);
  late final $WeaponAbilityLinksTable weaponAbilityLinks =
      $WeaponAbilityLinksTable(this);
  late final $DatasheetKeywordLinksTable datasheetKeywordLinks =
      $DatasheetKeywordLinksTable(this);
  late final $DatasheetAbilityLinksTable datasheetAbilityLinks =
      $DatasheetAbilityLinksTable(this);
  late final $DetachmentsTable detachments = $DetachmentsTable(this);
  late final $EnhancementsTable enhancements = $EnhancementsTable(this);
  late final $StratagemsTable stratagems = $StratagemsTable(this);
  late final $ArmiesTable armies = $ArmiesTable(this);
  late final $ArmyUnitsTable armyUnits = $ArmyUnitsTable(this);
  late final $ArmyUnitEquipmentSelectionsTable armyUnitEquipmentSelections =
      $ArmyUnitEquipmentSelectionsTable(this);
  late final $OwnedMiniaturesTable ownedMiniatures = $OwnedMiniaturesTable(
    this,
  );
  late final $WishlistItemsTable wishlistItems = $WishlistItemsTable(this);
  late final $BattlesTable battles = $BattlesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $XpCategoryTotalsTable xpCategoryTotals = $XpCategoryTotalsTable(
    this,
  );
  late final $XpFactionTotalsTable xpFactionTotals = $XpFactionTotalsTable(
    this,
  );
  late final GameSystemDao gameSystemDao = GameSystemDao(this as AppDatabase);
  late final FactionDao factionDao = FactionDao(this as AppDatabase);
  late final AbilityDao abilityDao = AbilityDao(this as AppDatabase);
  late final KeywordDao keywordDao = KeywordDao(this as AppDatabase);
  late final WeaponDao weaponDao = WeaponDao(this as AppDatabase);
  late final DatasheetDao datasheetDao = DatasheetDao(this as AppDatabase);
  late final ArmyDao armyDao = ArmyDao(this as AppDatabase);
  late final CollectionDao collectionDao = CollectionDao(this as AppDatabase);
  late final BattleDao battleDao = BattleDao(this as AppDatabase);
  late final ProjectDao projectDao = ProjectDao(this as AppDatabase);
  late final XpDao xpDao = XpDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gameSystems,
    editions,
    gameModes,
    factions,
    subFactions,
    keywords,
    abilities,
    datasheets,
    datasheetModels,
    modelProfiles,
    unitSizes,
    unitCompositions,
    datasheetCosts,
    datasheetVersions,
    datasheetSources,
    equipmentGroups,
    equipmentOptions,
    equipmentChoices,
    equipmentRestrictions,
    weapons,
    weaponProfiles,
    datasheetWeapons,
    weaponKeywordLinks,
    weaponAbilityLinks,
    datasheetKeywordLinks,
    datasheetAbilityLinks,
    detachments,
    enhancements,
    stratagems,
    armies,
    armyUnits,
    armyUnitEquipmentSelections,
    ownedMiniatures,
    wishlistItems,
    battles,
    projects,
    xpCategoryTotals,
    xpFactionTotals,
  ];
}

typedef $$GameSystemsTableCreateCompanionBuilder =
    GameSystemsCompanion Function({
      required String id,
      required String name,
      Value<String?> shortName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GameSystemsTableUpdateCompanionBuilder =
    GameSystemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> shortName,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GameSystemsTableFilterComposer
    extends Composer<_$AppDatabase, $GameSystemsTable> {
  $$GameSystemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameSystemsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameSystemsTable> {
  $$GameSystemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameSystemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameSystemsTable> {
  $$GameSystemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GameSystemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameSystemsTable,
          GameSystem,
          $$GameSystemsTableFilterComposer,
          $$GameSystemsTableOrderingComposer,
          $$GameSystemsTableAnnotationComposer,
          $$GameSystemsTableCreateCompanionBuilder,
          $$GameSystemsTableUpdateCompanionBuilder,
          (
            GameSystem,
            BaseReferences<_$AppDatabase, $GameSystemsTable, GameSystem>,
          ),
          GameSystem,
          PrefetchHooks Function()
        > {
  $$GameSystemsTableTableManager(_$AppDatabase db, $GameSystemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameSystemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameSystemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameSystemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> shortName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameSystemsCompanion(
                id: id,
                name: name,
                shortName: shortName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> shortName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameSystemsCompanion.insert(
                id: id,
                name: name,
                shortName: shortName,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameSystemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameSystemsTable,
      GameSystem,
      $$GameSystemsTableFilterComposer,
      $$GameSystemsTableOrderingComposer,
      $$GameSystemsTableAnnotationComposer,
      $$GameSystemsTableCreateCompanionBuilder,
      $$GameSystemsTableUpdateCompanionBuilder,
      (
        GameSystem,
        BaseReferences<_$AppDatabase, $GameSystemsTable, GameSystem>,
      ),
      GameSystem,
      PrefetchHooks Function()
    >;
typedef $$EditionsTableCreateCompanionBuilder =
    EditionsCompanion Function({
      required String id,
      required String gameSystemId,
      required String name,
      required int version,
      Value<bool> isCurrent,
      Value<DateTime?> releaseDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$EditionsTableUpdateCompanionBuilder =
    EditionsCompanion Function({
      Value<String> id,
      Value<String> gameSystemId,
      Value<String> name,
      Value<int> version,
      Value<bool> isCurrent,
      Value<DateTime?> releaseDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$EditionsTableFilterComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameSystemId => $composableBuilder(
    column: $table.gameSystemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameSystemId => $composableBuilder(
    column: $table.gameSystemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameSystemId => $composableBuilder(
    column: $table.gameSystemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EditionsTable,
          Edition,
          $$EditionsTableFilterComposer,
          $$EditionsTableOrderingComposer,
          $$EditionsTableAnnotationComposer,
          $$EditionsTableCreateCompanionBuilder,
          $$EditionsTableUpdateCompanionBuilder,
          (Edition, BaseReferences<_$AppDatabase, $EditionsTable, Edition>),
          Edition,
          PrefetchHooks Function()
        > {
  $$EditionsTableTableManager(_$AppDatabase db, $EditionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameSystemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EditionsCompanion(
                id: id,
                gameSystemId: gameSystemId,
                name: name,
                version: version,
                isCurrent: isCurrent,
                releaseDate: releaseDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameSystemId,
                required String name,
                required int version,
                Value<bool> isCurrent = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EditionsCompanion.insert(
                id: id,
                gameSystemId: gameSystemId,
                name: name,
                version: version,
                isCurrent: isCurrent,
                releaseDate: releaseDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EditionsTable,
      Edition,
      $$EditionsTableFilterComposer,
      $$EditionsTableOrderingComposer,
      $$EditionsTableAnnotationComposer,
      $$EditionsTableCreateCompanionBuilder,
      $$EditionsTableUpdateCompanionBuilder,
      (Edition, BaseReferences<_$AppDatabase, $EditionsTable, Edition>),
      Edition,
      PrefetchHooks Function()
    >;
typedef $$GameModesTableCreateCompanionBuilder =
    GameModesCompanion Function({
      required String id,
      required String editionId,
      required String name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GameModesTableUpdateCompanionBuilder =
    GameModesCompanion Function({
      Value<String> id,
      Value<String> editionId,
      Value<String> name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GameModesTableFilterComposer
    extends Composer<_$AppDatabase, $GameModesTable> {
  $$GameModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameModesTableOrderingComposer
    extends Composer<_$AppDatabase, $GameModesTable> {
  $$GameModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameModesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameModesTable> {
  $$GameModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get editionId =>
      $composableBuilder(column: $table.editionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GameModesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameModesTable,
          GameMode,
          $$GameModesTableFilterComposer,
          $$GameModesTableOrderingComposer,
          $$GameModesTableAnnotationComposer,
          $$GameModesTableCreateCompanionBuilder,
          $$GameModesTableUpdateCompanionBuilder,
          (GameMode, BaseReferences<_$AppDatabase, $GameModesTable, GameMode>),
          GameMode,
          PrefetchHooks Function()
        > {
  $$GameModesTableTableManager(_$AppDatabase db, $GameModesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameModesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> editionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameModesCompanion(
                id: id,
                editionId: editionId,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String editionId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameModesCompanion.insert(
                id: id,
                editionId: editionId,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameModesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameModesTable,
      GameMode,
      $$GameModesTableFilterComposer,
      $$GameModesTableOrderingComposer,
      $$GameModesTableAnnotationComposer,
      $$GameModesTableCreateCompanionBuilder,
      $$GameModesTableUpdateCompanionBuilder,
      (GameMode, BaseReferences<_$AppDatabase, $GameModesTable, GameMode>),
      GameMode,
      PrefetchHooks Function()
    >;
typedef $$FactionsTableCreateCompanionBuilder =
    FactionsCompanion Function({
      required String id,
      required String gameSystemId,
      required String name,
      Value<String?> shortName,
      Value<String?> description,
      Value<String?> iconPath,
      Value<int> displayOrder,
      Value<bool> isPlayable,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$FactionsTableUpdateCompanionBuilder =
    FactionsCompanion Function({
      Value<String> id,
      Value<String> gameSystemId,
      Value<String> name,
      Value<String?> shortName,
      Value<String?> description,
      Value<String?> iconPath,
      Value<int> displayOrder,
      Value<bool> isPlayable,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FactionsTableFilterComposer
    extends Composer<_$AppDatabase, $FactionsTable> {
  $$FactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameSystemId => $composableBuilder(
    column: $table.gameSystemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FactionsTable> {
  $$FactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameSystemId => $composableBuilder(
    column: $table.gameSystemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FactionsTable> {
  $$FactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameSystemId => $composableBuilder(
    column: $table.gameSystemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FactionsTable,
          Faction,
          $$FactionsTableFilterComposer,
          $$FactionsTableOrderingComposer,
          $$FactionsTableAnnotationComposer,
          $$FactionsTableCreateCompanionBuilder,
          $$FactionsTableUpdateCompanionBuilder,
          (Faction, BaseReferences<_$AppDatabase, $FactionsTable, Faction>),
          Faction,
          PrefetchHooks Function()
        > {
  $$FactionsTableTableManager(_$AppDatabase db, $FactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameSystemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> shortName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isPlayable = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FactionsCompanion(
                id: id,
                gameSystemId: gameSystemId,
                name: name,
                shortName: shortName,
                description: description,
                iconPath: iconPath,
                displayOrder: displayOrder,
                isPlayable: isPlayable,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameSystemId,
                required String name,
                Value<String?> shortName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isPlayable = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FactionsCompanion.insert(
                id: id,
                gameSystemId: gameSystemId,
                name: name,
                shortName: shortName,
                description: description,
                iconPath: iconPath,
                displayOrder: displayOrder,
                isPlayable: isPlayable,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FactionsTable,
      Faction,
      $$FactionsTableFilterComposer,
      $$FactionsTableOrderingComposer,
      $$FactionsTableAnnotationComposer,
      $$FactionsTableCreateCompanionBuilder,
      $$FactionsTableUpdateCompanionBuilder,
      (Faction, BaseReferences<_$AppDatabase, $FactionsTable, Faction>),
      Faction,
      PrefetchHooks Function()
    >;
typedef $$SubFactionsTableCreateCompanionBuilder =
    SubFactionsCompanion Function({
      required String id,
      required String factionId,
      required String name,
      Value<String?> description,
      Value<String?> iconPath,
      Value<bool> isDefault,
      Value<bool> isPlayable,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SubFactionsTableUpdateCompanionBuilder =
    SubFactionsCompanion Function({
      Value<String> id,
      Value<String> factionId,
      Value<String> name,
      Value<String?> description,
      Value<String?> iconPath,
      Value<bool> isDefault,
      Value<bool> isPlayable,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SubFactionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubFactionsTable> {
  $$SubFactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubFactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubFactionsTable> {
  $$SubFactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubFactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubFactionsTable> {
  $$SubFactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get factionId =>
      $composableBuilder(column: $table.factionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isPlayable => $composableBuilder(
    column: $table.isPlayable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubFactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubFactionsTable,
          SubFaction,
          $$SubFactionsTableFilterComposer,
          $$SubFactionsTableOrderingComposer,
          $$SubFactionsTableAnnotationComposer,
          $$SubFactionsTableCreateCompanionBuilder,
          $$SubFactionsTableUpdateCompanionBuilder,
          (
            SubFaction,
            BaseReferences<_$AppDatabase, $SubFactionsTable, SubFaction>,
          ),
          SubFaction,
          PrefetchHooks Function()
        > {
  $$SubFactionsTableTableManager(_$AppDatabase db, $SubFactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubFactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubFactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubFactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> factionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isPlayable = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubFactionsCompanion(
                id: id,
                factionId: factionId,
                name: name,
                description: description,
                iconPath: iconPath,
                isDefault: isDefault,
                isPlayable: isPlayable,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String factionId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isPlayable = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubFactionsCompanion.insert(
                id: id,
                factionId: factionId,
                name: name,
                description: description,
                iconPath: iconPath,
                isDefault: isDefault,
                isPlayable: isPlayable,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubFactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubFactionsTable,
      SubFaction,
      $$SubFactionsTableFilterComposer,
      $$SubFactionsTableOrderingComposer,
      $$SubFactionsTableAnnotationComposer,
      $$SubFactionsTableCreateCompanionBuilder,
      $$SubFactionsTableUpdateCompanionBuilder,
      (
        SubFaction,
        BaseReferences<_$AppDatabase, $SubFactionsTable, SubFaction>,
      ),
      SubFaction,
      PrefetchHooks Function()
    >;
typedef $$KeywordsTableCreateCompanionBuilder =
    KeywordsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<bool> isCore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$KeywordsTableUpdateCompanionBuilder =
    KeywordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> isCore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$KeywordsTableFilterComposer
    extends Composer<_$AppDatabase, $KeywordsTable> {
  $$KeywordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCore => $composableBuilder(
    column: $table.isCore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeywordsTableOrderingComposer
    extends Composer<_$AppDatabase, $KeywordsTable> {
  $$KeywordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCore => $composableBuilder(
    column: $table.isCore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeywordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeywordsTable> {
  $$KeywordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCore =>
      $composableBuilder(column: $table.isCore, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KeywordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeywordsTable,
          Keyword,
          $$KeywordsTableFilterComposer,
          $$KeywordsTableOrderingComposer,
          $$KeywordsTableAnnotationComposer,
          $$KeywordsTableCreateCompanionBuilder,
          $$KeywordsTableUpdateCompanionBuilder,
          (Keyword, BaseReferences<_$AppDatabase, $KeywordsTable, Keyword>),
          Keyword,
          PrefetchHooks Function()
        > {
  $$KeywordsTableTableManager(_$AppDatabase db, $KeywordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeywordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeywordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeywordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isCore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeywordsCompanion(
                id: id,
                name: name,
                description: description,
                isCore: isCore,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> isCore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeywordsCompanion.insert(
                id: id,
                name: name,
                description: description,
                isCore: isCore,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeywordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeywordsTable,
      Keyword,
      $$KeywordsTableFilterComposer,
      $$KeywordsTableOrderingComposer,
      $$KeywordsTableAnnotationComposer,
      $$KeywordsTableCreateCompanionBuilder,
      $$KeywordsTableUpdateCompanionBuilder,
      (Keyword, BaseReferences<_$AppDatabase, $KeywordsTable, Keyword>),
      Keyword,
      PrefetchHooks Function()
    >;
typedef $$AbilitiesTableCreateCompanionBuilder =
    AbilitiesCompanion Function({
      required String id,
      required String name,
      required String description,
      Value<String?> type,
      Value<bool> isCore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AbilitiesTableUpdateCompanionBuilder =
    AbilitiesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String?> type,
      Value<bool> isCore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AbilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $AbilitiesTable> {
  $$AbilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCore => $composableBuilder(
    column: $table.isCore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AbilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $AbilitiesTable> {
  $$AbilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCore => $composableBuilder(
    column: $table.isCore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AbilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AbilitiesTable> {
  $$AbilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isCore =>
      $composableBuilder(column: $table.isCore, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AbilitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AbilitiesTable,
          Ability,
          $$AbilitiesTableFilterComposer,
          $$AbilitiesTableOrderingComposer,
          $$AbilitiesTableAnnotationComposer,
          $$AbilitiesTableCreateCompanionBuilder,
          $$AbilitiesTableUpdateCompanionBuilder,
          (Ability, BaseReferences<_$AppDatabase, $AbilitiesTable, Ability>),
          Ability,
          PrefetchHooks Function()
        > {
  $$AbilitiesTableTableManager(_$AppDatabase db, $AbilitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<bool> isCore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbilitiesCompanion(
                id: id,
                name: name,
                description: description,
                type: type,
                isCore: isCore,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                Value<String?> type = const Value.absent(),
                Value<bool> isCore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbilitiesCompanion.insert(
                id: id,
                name: name,
                description: description,
                type: type,
                isCore: isCore,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AbilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AbilitiesTable,
      Ability,
      $$AbilitiesTableFilterComposer,
      $$AbilitiesTableOrderingComposer,
      $$AbilitiesTableAnnotationComposer,
      $$AbilitiesTableCreateCompanionBuilder,
      $$AbilitiesTableUpdateCompanionBuilder,
      (Ability, BaseReferences<_$AppDatabase, $AbilitiesTable, Ability>),
      Ability,
      PrefetchHooks Function()
    >;
typedef $$DatasheetsTableCreateCompanionBuilder =
    DatasheetsCompanion Function({
      required String id,
      required String factionId,
      Value<String?> subFactionId,
      required String name,
      required String battlefieldRole,
      required String unitType,
      Value<bool> isNamedCharacter,
      Value<bool> isEpicHero,
      Value<bool> isLegend,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DatasheetsTableUpdateCompanionBuilder =
    DatasheetsCompanion Function({
      Value<String> id,
      Value<String> factionId,
      Value<String?> subFactionId,
      Value<String> name,
      Value<String> battlefieldRole,
      Value<String> unitType,
      Value<bool> isNamedCharacter,
      Value<bool> isEpicHero,
      Value<bool> isLegend,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DatasheetsTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetsTable> {
  $$DatasheetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subFactionId => $composableBuilder(
    column: $table.subFactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get battlefieldRole => $composableBuilder(
    column: $table.battlefieldRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNamedCharacter => $composableBuilder(
    column: $table.isNamedCharacter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEpicHero => $composableBuilder(
    column: $table.isEpicHero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLegend => $composableBuilder(
    column: $table.isLegend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetsTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetsTable> {
  $$DatasheetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subFactionId => $composableBuilder(
    column: $table.subFactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get battlefieldRole => $composableBuilder(
    column: $table.battlefieldRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNamedCharacter => $composableBuilder(
    column: $table.isNamedCharacter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEpicHero => $composableBuilder(
    column: $table.isEpicHero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLegend => $composableBuilder(
    column: $table.isLegend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetsTable> {
  $$DatasheetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get factionId =>
      $composableBuilder(column: $table.factionId, builder: (column) => column);

  GeneratedColumn<String> get subFactionId => $composableBuilder(
    column: $table.subFactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get battlefieldRole => $composableBuilder(
    column: $table.battlefieldRole,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<bool> get isNamedCharacter => $composableBuilder(
    column: $table.isNamedCharacter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEpicHero => $composableBuilder(
    column: $table.isEpicHero,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLegend =>
      $composableBuilder(column: $table.isLegend, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DatasheetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetsTable,
          Datasheet,
          $$DatasheetsTableFilterComposer,
          $$DatasheetsTableOrderingComposer,
          $$DatasheetsTableAnnotationComposer,
          $$DatasheetsTableCreateCompanionBuilder,
          $$DatasheetsTableUpdateCompanionBuilder,
          (
            Datasheet,
            BaseReferences<_$AppDatabase, $DatasheetsTable, Datasheet>,
          ),
          Datasheet,
          PrefetchHooks Function()
        > {
  $$DatasheetsTableTableManager(_$AppDatabase db, $DatasheetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasheetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasheetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> factionId = const Value.absent(),
                Value<String?> subFactionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> battlefieldRole = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<bool> isNamedCharacter = const Value.absent(),
                Value<bool> isEpicHero = const Value.absent(),
                Value<bool> isLegend = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetsCompanion(
                id: id,
                factionId: factionId,
                subFactionId: subFactionId,
                name: name,
                battlefieldRole: battlefieldRole,
                unitType: unitType,
                isNamedCharacter: isNamedCharacter,
                isEpicHero: isEpicHero,
                isLegend: isLegend,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String factionId,
                Value<String?> subFactionId = const Value.absent(),
                required String name,
                required String battlefieldRole,
                required String unitType,
                Value<bool> isNamedCharacter = const Value.absent(),
                Value<bool> isEpicHero = const Value.absent(),
                Value<bool> isLegend = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetsCompanion.insert(
                id: id,
                factionId: factionId,
                subFactionId: subFactionId,
                name: name,
                battlefieldRole: battlefieldRole,
                unitType: unitType,
                isNamedCharacter: isNamedCharacter,
                isEpicHero: isEpicHero,
                isLegend: isLegend,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetsTable,
      Datasheet,
      $$DatasheetsTableFilterComposer,
      $$DatasheetsTableOrderingComposer,
      $$DatasheetsTableAnnotationComposer,
      $$DatasheetsTableCreateCompanionBuilder,
      $$DatasheetsTableUpdateCompanionBuilder,
      (Datasheet, BaseReferences<_$AppDatabase, $DatasheetsTable, Datasheet>),
      Datasheet,
      PrefetchHooks Function()
    >;
typedef $$DatasheetModelsTableCreateCompanionBuilder =
    DatasheetModelsCompanion Function({
      required String id,
      required String datasheetId,
      required String name,
      Value<int> displayOrder,
      Value<bool> isLeader,
      Value<bool> isChampion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DatasheetModelsTableUpdateCompanionBuilder =
    DatasheetModelsCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> name,
      Value<int> displayOrder,
      Value<bool> isLeader,
      Value<bool> isChampion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DatasheetModelsTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetModelsTable> {
  $$DatasheetModelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLeader => $composableBuilder(
    column: $table.isLeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChampion => $composableBuilder(
    column: $table.isChampion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetModelsTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetModelsTable> {
  $$DatasheetModelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLeader => $composableBuilder(
    column: $table.isLeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChampion => $composableBuilder(
    column: $table.isChampion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetModelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetModelsTable> {
  $$DatasheetModelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLeader =>
      $composableBuilder(column: $table.isLeader, builder: (column) => column);

  GeneratedColumn<bool> get isChampion => $composableBuilder(
    column: $table.isChampion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DatasheetModelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetModelsTable,
          DatasheetModel,
          $$DatasheetModelsTableFilterComposer,
          $$DatasheetModelsTableOrderingComposer,
          $$DatasheetModelsTableAnnotationComposer,
          $$DatasheetModelsTableCreateCompanionBuilder,
          $$DatasheetModelsTableUpdateCompanionBuilder,
          (
            DatasheetModel,
            BaseReferences<
              _$AppDatabase,
              $DatasheetModelsTable,
              DatasheetModel
            >,
          ),
          DatasheetModel,
          PrefetchHooks Function()
        > {
  $$DatasheetModelsTableTableManager(
    _$AppDatabase db,
    $DatasheetModelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetModelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasheetModelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasheetModelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isLeader = const Value.absent(),
                Value<bool> isChampion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetModelsCompanion(
                id: id,
                datasheetId: datasheetId,
                name: name,
                displayOrder: displayOrder,
                isLeader: isLeader,
                isChampion: isChampion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String name,
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isLeader = const Value.absent(),
                Value<bool> isChampion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetModelsCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                name: name,
                displayOrder: displayOrder,
                isLeader: isLeader,
                isChampion: isChampion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetModelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetModelsTable,
      DatasheetModel,
      $$DatasheetModelsTableFilterComposer,
      $$DatasheetModelsTableOrderingComposer,
      $$DatasheetModelsTableAnnotationComposer,
      $$DatasheetModelsTableCreateCompanionBuilder,
      $$DatasheetModelsTableUpdateCompanionBuilder,
      (
        DatasheetModel,
        BaseReferences<_$AppDatabase, $DatasheetModelsTable, DatasheetModel>,
      ),
      DatasheetModel,
      PrefetchHooks Function()
    >;
typedef $$ModelProfilesTableCreateCompanionBuilder =
    ModelProfilesCompanion Function({
      required String id,
      required String datasheetModelId,
      required String name,
      required int movement,
      required int toughness,
      required int save,
      required int wounds,
      required int leadership,
      required int objectiveControl,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ModelProfilesTableUpdateCompanionBuilder =
    ModelProfilesCompanion Function({
      Value<String> id,
      Value<String> datasheetModelId,
      Value<String> name,
      Value<int> movement,
      Value<int> toughness,
      Value<int> save,
      Value<int> wounds,
      Value<int> leadership,
      Value<int> objectiveControl,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ModelProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ModelProfilesTable> {
  $$ModelProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetModelId => $composableBuilder(
    column: $table.datasheetModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toughness => $composableBuilder(
    column: $table.toughness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get save => $composableBuilder(
    column: $table.save,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wounds => $composableBuilder(
    column: $table.wounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadership => $composableBuilder(
    column: $table.leadership,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get objectiveControl => $composableBuilder(
    column: $table.objectiveControl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModelProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelProfilesTable> {
  $$ModelProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetModelId => $composableBuilder(
    column: $table.datasheetModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movement => $composableBuilder(
    column: $table.movement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toughness => $composableBuilder(
    column: $table.toughness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get save => $composableBuilder(
    column: $table.save,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wounds => $composableBuilder(
    column: $table.wounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadership => $composableBuilder(
    column: $table.leadership,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get objectiveControl => $composableBuilder(
    column: $table.objectiveControl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelProfilesTable> {
  $$ModelProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetModelId => $composableBuilder(
    column: $table.datasheetModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get movement =>
      $composableBuilder(column: $table.movement, builder: (column) => column);

  GeneratedColumn<int> get toughness =>
      $composableBuilder(column: $table.toughness, builder: (column) => column);

  GeneratedColumn<int> get save =>
      $composableBuilder(column: $table.save, builder: (column) => column);

  GeneratedColumn<int> get wounds =>
      $composableBuilder(column: $table.wounds, builder: (column) => column);

  GeneratedColumn<int> get leadership => $composableBuilder(
    column: $table.leadership,
    builder: (column) => column,
  );

  GeneratedColumn<int> get objectiveControl => $composableBuilder(
    column: $table.objectiveControl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ModelProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelProfilesTable,
          ModelProfile,
          $$ModelProfilesTableFilterComposer,
          $$ModelProfilesTableOrderingComposer,
          $$ModelProfilesTableAnnotationComposer,
          $$ModelProfilesTableCreateCompanionBuilder,
          $$ModelProfilesTableUpdateCompanionBuilder,
          (
            ModelProfile,
            BaseReferences<_$AppDatabase, $ModelProfilesTable, ModelProfile>,
          ),
          ModelProfile,
          PrefetchHooks Function()
        > {
  $$ModelProfilesTableTableManager(_$AppDatabase db, $ModelProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetModelId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> movement = const Value.absent(),
                Value<int> toughness = const Value.absent(),
                Value<int> save = const Value.absent(),
                Value<int> wounds = const Value.absent(),
                Value<int> leadership = const Value.absent(),
                Value<int> objectiveControl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelProfilesCompanion(
                id: id,
                datasheetModelId: datasheetModelId,
                name: name,
                movement: movement,
                toughness: toughness,
                save: save,
                wounds: wounds,
                leadership: leadership,
                objectiveControl: objectiveControl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetModelId,
                required String name,
                required int movement,
                required int toughness,
                required int save,
                required int wounds,
                required int leadership,
                required int objectiveControl,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelProfilesCompanion.insert(
                id: id,
                datasheetModelId: datasheetModelId,
                name: name,
                movement: movement,
                toughness: toughness,
                save: save,
                wounds: wounds,
                leadership: leadership,
                objectiveControl: objectiveControl,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModelProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelProfilesTable,
      ModelProfile,
      $$ModelProfilesTableFilterComposer,
      $$ModelProfilesTableOrderingComposer,
      $$ModelProfilesTableAnnotationComposer,
      $$ModelProfilesTableCreateCompanionBuilder,
      $$ModelProfilesTableUpdateCompanionBuilder,
      (
        ModelProfile,
        BaseReferences<_$AppDatabase, $ModelProfilesTable, ModelProfile>,
      ),
      ModelProfile,
      PrefetchHooks Function()
    >;
typedef $$UnitSizesTableCreateCompanionBuilder =
    UnitSizesCompanion Function({
      required String id,
      required String datasheetId,
      required int minimumModels,
      required int maximumModels,
      required int defaultModels,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UnitSizesTableUpdateCompanionBuilder =
    UnitSizesCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<int> minimumModels,
      Value<int> maximumModels,
      Value<int> defaultModels,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UnitSizesTableFilterComposer
    extends Composer<_$AppDatabase, $UnitSizesTable> {
  $$UnitSizesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumModels => $composableBuilder(
    column: $table.minimumModels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximumModels => $composableBuilder(
    column: $table.maximumModels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultModels => $composableBuilder(
    column: $table.defaultModels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnitSizesTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitSizesTable> {
  $$UnitSizesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumModels => $composableBuilder(
    column: $table.minimumModels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximumModels => $composableBuilder(
    column: $table.maximumModels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultModels => $composableBuilder(
    column: $table.defaultModels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitSizesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitSizesTable> {
  $$UnitSizesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumModels => $composableBuilder(
    column: $table.minimumModels,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maximumModels => $composableBuilder(
    column: $table.maximumModels,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultModels => $composableBuilder(
    column: $table.defaultModels,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UnitSizesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitSizesTable,
          UnitSize,
          $$UnitSizesTableFilterComposer,
          $$UnitSizesTableOrderingComposer,
          $$UnitSizesTableAnnotationComposer,
          $$UnitSizesTableCreateCompanionBuilder,
          $$UnitSizesTableUpdateCompanionBuilder,
          (UnitSize, BaseReferences<_$AppDatabase, $UnitSizesTable, UnitSize>),
          UnitSize,
          PrefetchHooks Function()
        > {
  $$UnitSizesTableTableManager(_$AppDatabase db, $UnitSizesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitSizesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitSizesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitSizesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<int> minimumModels = const Value.absent(),
                Value<int> maximumModels = const Value.absent(),
                Value<int> defaultModels = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitSizesCompanion(
                id: id,
                datasheetId: datasheetId,
                minimumModels: minimumModels,
                maximumModels: maximumModels,
                defaultModels: defaultModels,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required int minimumModels,
                required int maximumModels,
                required int defaultModels,
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitSizesCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                minimumModels: minimumModels,
                maximumModels: maximumModels,
                defaultModels: defaultModels,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitSizesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitSizesTable,
      UnitSize,
      $$UnitSizesTableFilterComposer,
      $$UnitSizesTableOrderingComposer,
      $$UnitSizesTableAnnotationComposer,
      $$UnitSizesTableCreateCompanionBuilder,
      $$UnitSizesTableUpdateCompanionBuilder,
      (UnitSize, BaseReferences<_$AppDatabase, $UnitSizesTable, UnitSize>),
      UnitSize,
      PrefetchHooks Function()
    >;
typedef $$UnitCompositionsTableCreateCompanionBuilder =
    UnitCompositionsCompanion Function({
      required String id,
      required String datasheetId,
      required String modelId,
      required int minimum,
      required int maximum,
      Value<bool> isLeader,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UnitCompositionsTableUpdateCompanionBuilder =
    UnitCompositionsCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> modelId,
      Value<int> minimum,
      Value<int> maximum,
      Value<bool> isLeader,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UnitCompositionsTableFilterComposer
    extends Composer<_$AppDatabase, $UnitCompositionsTable> {
  $$UnitCompositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimum => $composableBuilder(
    column: $table.minimum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximum => $composableBuilder(
    column: $table.maximum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLeader => $composableBuilder(
    column: $table.isLeader,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnitCompositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitCompositionsTable> {
  $$UnitCompositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelId => $composableBuilder(
    column: $table.modelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimum => $composableBuilder(
    column: $table.minimum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximum => $composableBuilder(
    column: $table.maximum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLeader => $composableBuilder(
    column: $table.isLeader,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitCompositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitCompositionsTable> {
  $$UnitCompositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<int> get minimum =>
      $composableBuilder(column: $table.minimum, builder: (column) => column);

  GeneratedColumn<int> get maximum =>
      $composableBuilder(column: $table.maximum, builder: (column) => column);

  GeneratedColumn<bool> get isLeader =>
      $composableBuilder(column: $table.isLeader, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UnitCompositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitCompositionsTable,
          UnitComposition,
          $$UnitCompositionsTableFilterComposer,
          $$UnitCompositionsTableOrderingComposer,
          $$UnitCompositionsTableAnnotationComposer,
          $$UnitCompositionsTableCreateCompanionBuilder,
          $$UnitCompositionsTableUpdateCompanionBuilder,
          (
            UnitComposition,
            BaseReferences<
              _$AppDatabase,
              $UnitCompositionsTable,
              UnitComposition
            >,
          ),
          UnitComposition,
          PrefetchHooks Function()
        > {
  $$UnitCompositionsTableTableManager(
    _$AppDatabase db,
    $UnitCompositionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitCompositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitCompositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitCompositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<int> minimum = const Value.absent(),
                Value<int> maximum = const Value.absent(),
                Value<bool> isLeader = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitCompositionsCompanion(
                id: id,
                datasheetId: datasheetId,
                modelId: modelId,
                minimum: minimum,
                maximum: maximum,
                isLeader: isLeader,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String modelId,
                required int minimum,
                required int maximum,
                Value<bool> isLeader = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitCompositionsCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                modelId: modelId,
                minimum: minimum,
                maximum: maximum,
                isLeader: isLeader,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitCompositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitCompositionsTable,
      UnitComposition,
      $$UnitCompositionsTableFilterComposer,
      $$UnitCompositionsTableOrderingComposer,
      $$UnitCompositionsTableAnnotationComposer,
      $$UnitCompositionsTableCreateCompanionBuilder,
      $$UnitCompositionsTableUpdateCompanionBuilder,
      (
        UnitComposition,
        BaseReferences<_$AppDatabase, $UnitCompositionsTable, UnitComposition>,
      ),
      UnitComposition,
      PrefetchHooks Function()
    >;
typedef $$DatasheetCostsTableCreateCompanionBuilder =
    DatasheetCostsCompanion Function({
      required String id,
      required String datasheetId,
      required String editionId,
      required int points,
      Value<int?> modelCount,
      Value<int?> powerLevel,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$DatasheetCostsTableUpdateCompanionBuilder =
    DatasheetCostsCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> editionId,
      Value<int> points,
      Value<int?> modelCount,
      Value<int?> powerLevel,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DatasheetCostsTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetCostsTable> {
  $$DatasheetCostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modelCount => $composableBuilder(
    column: $table.modelCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get powerLevel => $composableBuilder(
    column: $table.powerLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetCostsTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetCostsTable> {
  $$DatasheetCostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modelCount => $composableBuilder(
    column: $table.modelCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get powerLevel => $composableBuilder(
    column: $table.powerLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetCostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetCostsTable> {
  $$DatasheetCostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editionId =>
      $composableBuilder(column: $table.editionId, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get modelCount => $composableBuilder(
    column: $table.modelCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get powerLevel => $composableBuilder(
    column: $table.powerLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DatasheetCostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetCostsTable,
          DatasheetCost,
          $$DatasheetCostsTableFilterComposer,
          $$DatasheetCostsTableOrderingComposer,
          $$DatasheetCostsTableAnnotationComposer,
          $$DatasheetCostsTableCreateCompanionBuilder,
          $$DatasheetCostsTableUpdateCompanionBuilder,
          (
            DatasheetCost,
            BaseReferences<_$AppDatabase, $DatasheetCostsTable, DatasheetCost>,
          ),
          DatasheetCost,
          PrefetchHooks Function()
        > {
  $$DatasheetCostsTableTableManager(
    _$AppDatabase db,
    $DatasheetCostsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetCostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasheetCostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasheetCostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> editionId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int?> modelCount = const Value.absent(),
                Value<int?> powerLevel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetCostsCompanion(
                id: id,
                datasheetId: datasheetId,
                editionId: editionId,
                points: points,
                modelCount: modelCount,
                powerLevel: powerLevel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String editionId,
                required int points,
                Value<int?> modelCount = const Value.absent(),
                Value<int?> powerLevel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetCostsCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                editionId: editionId,
                points: points,
                modelCount: modelCount,
                powerLevel: powerLevel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetCostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetCostsTable,
      DatasheetCost,
      $$DatasheetCostsTableFilterComposer,
      $$DatasheetCostsTableOrderingComposer,
      $$DatasheetCostsTableAnnotationComposer,
      $$DatasheetCostsTableCreateCompanionBuilder,
      $$DatasheetCostsTableUpdateCompanionBuilder,
      (
        DatasheetCost,
        BaseReferences<_$AppDatabase, $DatasheetCostsTable, DatasheetCost>,
      ),
      DatasheetCost,
      PrefetchHooks Function()
    >;
typedef $$DatasheetVersionsTableCreateCompanionBuilder =
    DatasheetVersionsCompanion Function({
      required String id,
      required String datasheetId,
      required String version,
      Value<String?> description,
      Value<bool> isCurrent,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$DatasheetVersionsTableUpdateCompanionBuilder =
    DatasheetVersionsCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> version,
      Value<String?> description,
      Value<bool> isCurrent,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DatasheetVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetVersionsTable> {
  $$DatasheetVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetVersionsTable> {
  $$DatasheetVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetVersionsTable> {
  $$DatasheetVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DatasheetVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetVersionsTable,
          DatasheetVersion,
          $$DatasheetVersionsTableFilterComposer,
          $$DatasheetVersionsTableOrderingComposer,
          $$DatasheetVersionsTableAnnotationComposer,
          $$DatasheetVersionsTableCreateCompanionBuilder,
          $$DatasheetVersionsTableUpdateCompanionBuilder,
          (
            DatasheetVersion,
            BaseReferences<
              _$AppDatabase,
              $DatasheetVersionsTable,
              DatasheetVersion
            >,
          ),
          DatasheetVersion,
          PrefetchHooks Function()
        > {
  $$DatasheetVersionsTableTableManager(
    _$AppDatabase db,
    $DatasheetVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasheetVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasheetVersionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetVersionsCompanion(
                id: id,
                datasheetId: datasheetId,
                version: version,
                description: description,
                isCurrent: isCurrent,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String version,
                Value<String?> description = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetVersionsCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                version: version,
                description: description,
                isCurrent: isCurrent,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetVersionsTable,
      DatasheetVersion,
      $$DatasheetVersionsTableFilterComposer,
      $$DatasheetVersionsTableOrderingComposer,
      $$DatasheetVersionsTableAnnotationComposer,
      $$DatasheetVersionsTableCreateCompanionBuilder,
      $$DatasheetVersionsTableUpdateCompanionBuilder,
      (
        DatasheetVersion,
        BaseReferences<
          _$AppDatabase,
          $DatasheetVersionsTable,
          DatasheetVersion
        >,
      ),
      DatasheetVersion,
      PrefetchHooks Function()
    >;
typedef $$DatasheetSourcesTableCreateCompanionBuilder =
    DatasheetSourcesCompanion Function({
      required String id,
      required String datasheetId,
      required String sourceName,
      required String sourceType,
      Value<String?> page,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$DatasheetSourcesTableUpdateCompanionBuilder =
    DatasheetSourcesCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> sourceName,
      Value<String> sourceType,
      Value<String?> page,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DatasheetSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetSourcesTable> {
  $$DatasheetSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetSourcesTable> {
  $$DatasheetSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetSourcesTable> {
  $$DatasheetSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DatasheetSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetSourcesTable,
          DatasheetSource,
          $$DatasheetSourcesTableFilterComposer,
          $$DatasheetSourcesTableOrderingComposer,
          $$DatasheetSourcesTableAnnotationComposer,
          $$DatasheetSourcesTableCreateCompanionBuilder,
          $$DatasheetSourcesTableUpdateCompanionBuilder,
          (
            DatasheetSource,
            BaseReferences<
              _$AppDatabase,
              $DatasheetSourcesTable,
              DatasheetSource
            >,
          ),
          DatasheetSource,
          PrefetchHooks Function()
        > {
  $$DatasheetSourcesTableTableManager(
    _$AppDatabase db,
    $DatasheetSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasheetSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasheetSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> page = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetSourcesCompanion(
                id: id,
                datasheetId: datasheetId,
                sourceName: sourceName,
                sourceType: sourceType,
                page: page,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String sourceName,
                required String sourceType,
                Value<String?> page = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetSourcesCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                sourceName: sourceName,
                sourceType: sourceType,
                page: page,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetSourcesTable,
      DatasheetSource,
      $$DatasheetSourcesTableFilterComposer,
      $$DatasheetSourcesTableOrderingComposer,
      $$DatasheetSourcesTableAnnotationComposer,
      $$DatasheetSourcesTableCreateCompanionBuilder,
      $$DatasheetSourcesTableUpdateCompanionBuilder,
      (
        DatasheetSource,
        BaseReferences<_$AppDatabase, $DatasheetSourcesTable, DatasheetSource>,
      ),
      DatasheetSource,
      PrefetchHooks Function()
    >;
typedef $$EquipmentGroupsTableCreateCompanionBuilder =
    EquipmentGroupsCompanion Function({
      required String id,
      required String datasheetId,
      required String name,
      Value<String?> description,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$EquipmentGroupsTableUpdateCompanionBuilder =
    EquipmentGroupsCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> name,
      Value<String?> description,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EquipmentGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentGroupsTable> {
  $$EquipmentGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentGroupsTable> {
  $$EquipmentGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentGroupsTable> {
  $$EquipmentGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EquipmentGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentGroupsTable,
          EquipmentGroup,
          $$EquipmentGroupsTableFilterComposer,
          $$EquipmentGroupsTableOrderingComposer,
          $$EquipmentGroupsTableAnnotationComposer,
          $$EquipmentGroupsTableCreateCompanionBuilder,
          $$EquipmentGroupsTableUpdateCompanionBuilder,
          (
            EquipmentGroup,
            BaseReferences<
              _$AppDatabase,
              $EquipmentGroupsTable,
              EquipmentGroup
            >,
          ),
          EquipmentGroup,
          PrefetchHooks Function()
        > {
  $$EquipmentGroupsTableTableManager(
    _$AppDatabase db,
    $EquipmentGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentGroupsCompanion(
                id: id,
                datasheetId: datasheetId,
                name: name,
                description: description,
                displayOrder: displayOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentGroupsCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                name: name,
                description: description,
                displayOrder: displayOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentGroupsTable,
      EquipmentGroup,
      $$EquipmentGroupsTableFilterComposer,
      $$EquipmentGroupsTableOrderingComposer,
      $$EquipmentGroupsTableAnnotationComposer,
      $$EquipmentGroupsTableCreateCompanionBuilder,
      $$EquipmentGroupsTableUpdateCompanionBuilder,
      (
        EquipmentGroup,
        BaseReferences<_$AppDatabase, $EquipmentGroupsTable, EquipmentGroup>,
      ),
      EquipmentGroup,
      PrefetchHooks Function()
    >;
typedef $$EquipmentOptionsTableCreateCompanionBuilder =
    EquipmentOptionsCompanion Function({
      required String id,
      required String groupId,
      Value<String?> weaponId,
      required String name,
      Value<int> quantity,
      Value<bool> isDefault,
      Value<int> displayOrder,
      Value<int> rowid,
    });
typedef $$EquipmentOptionsTableUpdateCompanionBuilder =
    EquipmentOptionsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String?> weaponId,
      Value<String> name,
      Value<int> quantity,
      Value<bool> isDefault,
      Value<int> displayOrder,
      Value<int> rowid,
    });

class $$EquipmentOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentOptionsTable> {
  $$EquipmentOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentOptionsTable> {
  $$EquipmentOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentOptionsTable> {
  $$EquipmentOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get weaponId =>
      $composableBuilder(column: $table.weaponId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );
}

class $$EquipmentOptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentOptionsTable,
          EquipmentOption,
          $$EquipmentOptionsTableFilterComposer,
          $$EquipmentOptionsTableOrderingComposer,
          $$EquipmentOptionsTableAnnotationComposer,
          $$EquipmentOptionsTableCreateCompanionBuilder,
          $$EquipmentOptionsTableUpdateCompanionBuilder,
          (
            EquipmentOption,
            BaseReferences<
              _$AppDatabase,
              $EquipmentOptionsTable,
              EquipmentOption
            >,
          ),
          EquipmentOption,
          PrefetchHooks Function()
        > {
  $$EquipmentOptionsTableTableManager(
    _$AppDatabase db,
    $EquipmentOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String?> weaponId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentOptionsCompanion(
                id: id,
                groupId: groupId,
                weaponId: weaponId,
                name: name,
                quantity: quantity,
                isDefault: isDefault,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                Value<String?> weaponId = const Value.absent(),
                required String name,
                Value<int> quantity = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentOptionsCompanion.insert(
                id: id,
                groupId: groupId,
                weaponId: weaponId,
                name: name,
                quantity: quantity,
                isDefault: isDefault,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentOptionsTable,
      EquipmentOption,
      $$EquipmentOptionsTableFilterComposer,
      $$EquipmentOptionsTableOrderingComposer,
      $$EquipmentOptionsTableAnnotationComposer,
      $$EquipmentOptionsTableCreateCompanionBuilder,
      $$EquipmentOptionsTableUpdateCompanionBuilder,
      (
        EquipmentOption,
        BaseReferences<_$AppDatabase, $EquipmentOptionsTable, EquipmentOption>,
      ),
      EquipmentOption,
      PrefetchHooks Function()
    >;
typedef $$EquipmentChoicesTableCreateCompanionBuilder =
    EquipmentChoicesCompanion Function({
      required String id,
      required String groupId,
      Value<int> minimumChoices,
      Value<int> maximumChoices,
      Value<int> rowid,
    });
typedef $$EquipmentChoicesTableUpdateCompanionBuilder =
    EquipmentChoicesCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<int> minimumChoices,
      Value<int> maximumChoices,
      Value<int> rowid,
    });

class $$EquipmentChoicesTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentChoicesTable> {
  $$EquipmentChoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumChoices => $composableBuilder(
    column: $table.minimumChoices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maximumChoices => $composableBuilder(
    column: $table.maximumChoices,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentChoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentChoicesTable> {
  $$EquipmentChoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumChoices => $composableBuilder(
    column: $table.minimumChoices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maximumChoices => $composableBuilder(
    column: $table.maximumChoices,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentChoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentChoicesTable> {
  $$EquipmentChoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get minimumChoices => $composableBuilder(
    column: $table.minimumChoices,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maximumChoices => $composableBuilder(
    column: $table.maximumChoices,
    builder: (column) => column,
  );
}

class $$EquipmentChoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentChoicesTable,
          EquipmentChoice,
          $$EquipmentChoicesTableFilterComposer,
          $$EquipmentChoicesTableOrderingComposer,
          $$EquipmentChoicesTableAnnotationComposer,
          $$EquipmentChoicesTableCreateCompanionBuilder,
          $$EquipmentChoicesTableUpdateCompanionBuilder,
          (
            EquipmentChoice,
            BaseReferences<
              _$AppDatabase,
              $EquipmentChoicesTable,
              EquipmentChoice
            >,
          ),
          EquipmentChoice,
          PrefetchHooks Function()
        > {
  $$EquipmentChoicesTableTableManager(
    _$AppDatabase db,
    $EquipmentChoicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentChoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentChoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentChoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<int> minimumChoices = const Value.absent(),
                Value<int> maximumChoices = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentChoicesCompanion(
                id: id,
                groupId: groupId,
                minimumChoices: minimumChoices,
                maximumChoices: maximumChoices,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                Value<int> minimumChoices = const Value.absent(),
                Value<int> maximumChoices = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentChoicesCompanion.insert(
                id: id,
                groupId: groupId,
                minimumChoices: minimumChoices,
                maximumChoices: maximumChoices,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentChoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentChoicesTable,
      EquipmentChoice,
      $$EquipmentChoicesTableFilterComposer,
      $$EquipmentChoicesTableOrderingComposer,
      $$EquipmentChoicesTableAnnotationComposer,
      $$EquipmentChoicesTableCreateCompanionBuilder,
      $$EquipmentChoicesTableUpdateCompanionBuilder,
      (
        EquipmentChoice,
        BaseReferences<_$AppDatabase, $EquipmentChoicesTable, EquipmentChoice>,
      ),
      EquipmentChoice,
      PrefetchHooks Function()
    >;
typedef $$EquipmentRestrictionsTableCreateCompanionBuilder =
    EquipmentRestrictionsCompanion Function({
      required String id,
      required String optionId,
      required String restrictionType,
      Value<int?> value,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$EquipmentRestrictionsTableUpdateCompanionBuilder =
    EquipmentRestrictionsCompanion Function({
      Value<String> id,
      Value<String> optionId,
      Value<String> restrictionType,
      Value<int?> value,
      Value<String?> description,
      Value<int> rowid,
    });

class $$EquipmentRestrictionsTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentRestrictionsTable> {
  $$EquipmentRestrictionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get restrictionType => $composableBuilder(
    column: $table.restrictionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquipmentRestrictionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentRestrictionsTable> {
  $$EquipmentRestrictionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restrictionType => $composableBuilder(
    column: $table.restrictionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentRestrictionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentRestrictionsTable> {
  $$EquipmentRestrictionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get optionId =>
      $composableBuilder(column: $table.optionId, builder: (column) => column);

  GeneratedColumn<String> get restrictionType => $composableBuilder(
    column: $table.restrictionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$EquipmentRestrictionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentRestrictionsTable,
          EquipmentRestriction,
          $$EquipmentRestrictionsTableFilterComposer,
          $$EquipmentRestrictionsTableOrderingComposer,
          $$EquipmentRestrictionsTableAnnotationComposer,
          $$EquipmentRestrictionsTableCreateCompanionBuilder,
          $$EquipmentRestrictionsTableUpdateCompanionBuilder,
          (
            EquipmentRestriction,
            BaseReferences<
              _$AppDatabase,
              $EquipmentRestrictionsTable,
              EquipmentRestriction
            >,
          ),
          EquipmentRestriction,
          PrefetchHooks Function()
        > {
  $$EquipmentRestrictionsTableTableManager(
    _$AppDatabase db,
    $EquipmentRestrictionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentRestrictionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EquipmentRestrictionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EquipmentRestrictionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> optionId = const Value.absent(),
                Value<String> restrictionType = const Value.absent(),
                Value<int?> value = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentRestrictionsCompanion(
                id: id,
                optionId: optionId,
                restrictionType: restrictionType,
                value: value,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String optionId,
                required String restrictionType,
                Value<int?> value = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentRestrictionsCompanion.insert(
                id: id,
                optionId: optionId,
                restrictionType: restrictionType,
                value: value,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquipmentRestrictionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentRestrictionsTable,
      EquipmentRestriction,
      $$EquipmentRestrictionsTableFilterComposer,
      $$EquipmentRestrictionsTableOrderingComposer,
      $$EquipmentRestrictionsTableAnnotationComposer,
      $$EquipmentRestrictionsTableCreateCompanionBuilder,
      $$EquipmentRestrictionsTableUpdateCompanionBuilder,
      (
        EquipmentRestriction,
        BaseReferences<
          _$AppDatabase,
          $EquipmentRestrictionsTable,
          EquipmentRestriction
        >,
      ),
      EquipmentRestriction,
      PrefetchHooks Function()
    >;
typedef $$WeaponsTableCreateCompanionBuilder =
    WeaponsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<bool> isMelee,
      Value<bool> isRanged,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$WeaponsTableUpdateCompanionBuilder =
    WeaponsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> isMelee,
      Value<bool> isRanged,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WeaponsTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMelee => $composableBuilder(
    column: $table.isMelee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRanged => $composableBuilder(
    column: $table.isRanged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeaponsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMelee => $composableBuilder(
    column: $table.isMelee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRanged => $composableBuilder(
    column: $table.isRanged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeaponsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMelee =>
      $composableBuilder(column: $table.isMelee, builder: (column) => column);

  GeneratedColumn<bool> get isRanged =>
      $composableBuilder(column: $table.isRanged, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WeaponsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponsTable,
          Weapon,
          $$WeaponsTableFilterComposer,
          $$WeaponsTableOrderingComposer,
          $$WeaponsTableAnnotationComposer,
          $$WeaponsTableCreateCompanionBuilder,
          $$WeaponsTableUpdateCompanionBuilder,
          (Weapon, BaseReferences<_$AppDatabase, $WeaponsTable, Weapon>),
          Weapon,
          PrefetchHooks Function()
        > {
  $$WeaponsTableTableManager(_$AppDatabase db, $WeaponsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isMelee = const Value.absent(),
                Value<bool> isRanged = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponsCompanion(
                id: id,
                name: name,
                description: description,
                isMelee: isMelee,
                isRanged: isRanged,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> isMelee = const Value.absent(),
                Value<bool> isRanged = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponsCompanion.insert(
                id: id,
                name: name,
                description: description,
                isMelee: isMelee,
                isRanged: isRanged,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeaponsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponsTable,
      Weapon,
      $$WeaponsTableFilterComposer,
      $$WeaponsTableOrderingComposer,
      $$WeaponsTableAnnotationComposer,
      $$WeaponsTableCreateCompanionBuilder,
      $$WeaponsTableUpdateCompanionBuilder,
      (Weapon, BaseReferences<_$AppDatabase, $WeaponsTable, Weapon>),
      Weapon,
      PrefetchHooks Function()
    >;
typedef $$WeaponProfilesTableCreateCompanionBuilder =
    WeaponProfilesCompanion Function({
      required String id,
      required String weaponId,
      required String name,
      required int range,
      required String attacks,
      Value<int?> ballisticSkill,
      Value<int?> weaponSkill,
      required int strength,
      required int armorPenetration,
      required String damage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$WeaponProfilesTableUpdateCompanionBuilder =
    WeaponProfilesCompanion Function({
      Value<String> id,
      Value<String> weaponId,
      Value<String> name,
      Value<int> range,
      Value<String> attacks,
      Value<int?> ballisticSkill,
      Value<int?> weaponSkill,
      Value<int> strength,
      Value<int> armorPenetration,
      Value<String> damage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WeaponProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponProfilesTable> {
  $$WeaponProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attacks => $composableBuilder(
    column: $table.attacks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ballisticSkill => $composableBuilder(
    column: $table.ballisticSkill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weaponSkill => $composableBuilder(
    column: $table.weaponSkill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get armorPenetration => $composableBuilder(
    column: $table.armorPenetration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeaponProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponProfilesTable> {
  $$WeaponProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get range => $composableBuilder(
    column: $table.range,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attacks => $composableBuilder(
    column: $table.attacks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ballisticSkill => $composableBuilder(
    column: $table.ballisticSkill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weaponSkill => $composableBuilder(
    column: $table.weaponSkill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get armorPenetration => $composableBuilder(
    column: $table.armorPenetration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeaponProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponProfilesTable> {
  $$WeaponProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weaponId =>
      $composableBuilder(column: $table.weaponId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get range =>
      $composableBuilder(column: $table.range, builder: (column) => column);

  GeneratedColumn<String> get attacks =>
      $composableBuilder(column: $table.attacks, builder: (column) => column);

  GeneratedColumn<int> get ballisticSkill => $composableBuilder(
    column: $table.ballisticSkill,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weaponSkill => $composableBuilder(
    column: $table.weaponSkill,
    builder: (column) => column,
  );

  GeneratedColumn<int> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<int> get armorPenetration => $composableBuilder(
    column: $table.armorPenetration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damage =>
      $composableBuilder(column: $table.damage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WeaponProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponProfilesTable,
          WeaponProfile,
          $$WeaponProfilesTableFilterComposer,
          $$WeaponProfilesTableOrderingComposer,
          $$WeaponProfilesTableAnnotationComposer,
          $$WeaponProfilesTableCreateCompanionBuilder,
          $$WeaponProfilesTableUpdateCompanionBuilder,
          (
            WeaponProfile,
            BaseReferences<_$AppDatabase, $WeaponProfilesTable, WeaponProfile>,
          ),
          WeaponProfile,
          PrefetchHooks Function()
        > {
  $$WeaponProfilesTableTableManager(
    _$AppDatabase db,
    $WeaponProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> weaponId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> range = const Value.absent(),
                Value<String> attacks = const Value.absent(),
                Value<int?> ballisticSkill = const Value.absent(),
                Value<int?> weaponSkill = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> armorPenetration = const Value.absent(),
                Value<String> damage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponProfilesCompanion(
                id: id,
                weaponId: weaponId,
                name: name,
                range: range,
                attacks: attacks,
                ballisticSkill: ballisticSkill,
                weaponSkill: weaponSkill,
                strength: strength,
                armorPenetration: armorPenetration,
                damage: damage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String weaponId,
                required String name,
                required int range,
                required String attacks,
                Value<int?> ballisticSkill = const Value.absent(),
                Value<int?> weaponSkill = const Value.absent(),
                required int strength,
                required int armorPenetration,
                required String damage,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponProfilesCompanion.insert(
                id: id,
                weaponId: weaponId,
                name: name,
                range: range,
                attacks: attacks,
                ballisticSkill: ballisticSkill,
                weaponSkill: weaponSkill,
                strength: strength,
                armorPenetration: armorPenetration,
                damage: damage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeaponProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponProfilesTable,
      WeaponProfile,
      $$WeaponProfilesTableFilterComposer,
      $$WeaponProfilesTableOrderingComposer,
      $$WeaponProfilesTableAnnotationComposer,
      $$WeaponProfilesTableCreateCompanionBuilder,
      $$WeaponProfilesTableUpdateCompanionBuilder,
      (
        WeaponProfile,
        BaseReferences<_$AppDatabase, $WeaponProfilesTable, WeaponProfile>,
      ),
      WeaponProfile,
      PrefetchHooks Function()
    >;
typedef $$DatasheetWeaponsTableCreateCompanionBuilder =
    DatasheetWeaponsCompanion Function({
      required String id,
      required String datasheetModelId,
      required String weaponId,
      Value<int> quantity,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DatasheetWeaponsTableUpdateCompanionBuilder =
    DatasheetWeaponsCompanion Function({
      Value<String> id,
      Value<String> datasheetModelId,
      Value<String> weaponId,
      Value<int> quantity,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DatasheetWeaponsTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetWeaponsTable> {
  $$DatasheetWeaponsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetModelId => $composableBuilder(
    column: $table.datasheetModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetWeaponsTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetWeaponsTable> {
  $$DatasheetWeaponsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetModelId => $composableBuilder(
    column: $table.datasheetModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetWeaponsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetWeaponsTable> {
  $$DatasheetWeaponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetModelId => $composableBuilder(
    column: $table.datasheetModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weaponId =>
      $composableBuilder(column: $table.weaponId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DatasheetWeaponsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetWeaponsTable,
          DatasheetWeapon,
          $$DatasheetWeaponsTableFilterComposer,
          $$DatasheetWeaponsTableOrderingComposer,
          $$DatasheetWeaponsTableAnnotationComposer,
          $$DatasheetWeaponsTableCreateCompanionBuilder,
          $$DatasheetWeaponsTableUpdateCompanionBuilder,
          (
            DatasheetWeapon,
            BaseReferences<
              _$AppDatabase,
              $DatasheetWeaponsTable,
              DatasheetWeapon
            >,
          ),
          DatasheetWeapon,
          PrefetchHooks Function()
        > {
  $$DatasheetWeaponsTableTableManager(
    _$AppDatabase db,
    $DatasheetWeaponsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetWeaponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatasheetWeaponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatasheetWeaponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetModelId = const Value.absent(),
                Value<String> weaponId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetWeaponsCompanion(
                id: id,
                datasheetModelId: datasheetModelId,
                weaponId: weaponId,
                quantity: quantity,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetModelId,
                required String weaponId,
                Value<int> quantity = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetWeaponsCompanion.insert(
                id: id,
                datasheetModelId: datasheetModelId,
                weaponId: weaponId,
                quantity: quantity,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetWeaponsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetWeaponsTable,
      DatasheetWeapon,
      $$DatasheetWeaponsTableFilterComposer,
      $$DatasheetWeaponsTableOrderingComposer,
      $$DatasheetWeaponsTableAnnotationComposer,
      $$DatasheetWeaponsTableCreateCompanionBuilder,
      $$DatasheetWeaponsTableUpdateCompanionBuilder,
      (
        DatasheetWeapon,
        BaseReferences<_$AppDatabase, $DatasheetWeaponsTable, DatasheetWeapon>,
      ),
      DatasheetWeapon,
      PrefetchHooks Function()
    >;
typedef $$WeaponKeywordLinksTableCreateCompanionBuilder =
    WeaponKeywordLinksCompanion Function({
      required String id,
      required String weaponId,
      required String keywordId,
      Value<int> rowid,
    });
typedef $$WeaponKeywordLinksTableUpdateCompanionBuilder =
    WeaponKeywordLinksCompanion Function({
      Value<String> id,
      Value<String> weaponId,
      Value<String> keywordId,
      Value<int> rowid,
    });

class $$WeaponKeywordLinksTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponKeywordLinksTable> {
  $$WeaponKeywordLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywordId => $composableBuilder(
    column: $table.keywordId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeaponKeywordLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponKeywordLinksTable> {
  $$WeaponKeywordLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywordId => $composableBuilder(
    column: $table.keywordId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeaponKeywordLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponKeywordLinksTable> {
  $$WeaponKeywordLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weaponId =>
      $composableBuilder(column: $table.weaponId, builder: (column) => column);

  GeneratedColumn<String> get keywordId =>
      $composableBuilder(column: $table.keywordId, builder: (column) => column);
}

class $$WeaponKeywordLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponKeywordLinksTable,
          WeaponKeywordLink,
          $$WeaponKeywordLinksTableFilterComposer,
          $$WeaponKeywordLinksTableOrderingComposer,
          $$WeaponKeywordLinksTableAnnotationComposer,
          $$WeaponKeywordLinksTableCreateCompanionBuilder,
          $$WeaponKeywordLinksTableUpdateCompanionBuilder,
          (
            WeaponKeywordLink,
            BaseReferences<
              _$AppDatabase,
              $WeaponKeywordLinksTable,
              WeaponKeywordLink
            >,
          ),
          WeaponKeywordLink,
          PrefetchHooks Function()
        > {
  $$WeaponKeywordLinksTableTableManager(
    _$AppDatabase db,
    $WeaponKeywordLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponKeywordLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponKeywordLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponKeywordLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> weaponId = const Value.absent(),
                Value<String> keywordId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponKeywordLinksCompanion(
                id: id,
                weaponId: weaponId,
                keywordId: keywordId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String weaponId,
                required String keywordId,
                Value<int> rowid = const Value.absent(),
              }) => WeaponKeywordLinksCompanion.insert(
                id: id,
                weaponId: weaponId,
                keywordId: keywordId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeaponKeywordLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponKeywordLinksTable,
      WeaponKeywordLink,
      $$WeaponKeywordLinksTableFilterComposer,
      $$WeaponKeywordLinksTableOrderingComposer,
      $$WeaponKeywordLinksTableAnnotationComposer,
      $$WeaponKeywordLinksTableCreateCompanionBuilder,
      $$WeaponKeywordLinksTableUpdateCompanionBuilder,
      (
        WeaponKeywordLink,
        BaseReferences<
          _$AppDatabase,
          $WeaponKeywordLinksTable,
          WeaponKeywordLink
        >,
      ),
      WeaponKeywordLink,
      PrefetchHooks Function()
    >;
typedef $$WeaponAbilityLinksTableCreateCompanionBuilder =
    WeaponAbilityLinksCompanion Function({
      required String id,
      required String weaponId,
      required String abilityId,
      Value<int> rowid,
    });
typedef $$WeaponAbilityLinksTableUpdateCompanionBuilder =
    WeaponAbilityLinksCompanion Function({
      Value<String> id,
      Value<String> weaponId,
      Value<String> abilityId,
      Value<int> rowid,
    });

class $$WeaponAbilityLinksTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponAbilityLinksTable> {
  $$WeaponAbilityLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeaponAbilityLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponAbilityLinksTable> {
  $$WeaponAbilityLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaponId => $composableBuilder(
    column: $table.weaponId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeaponAbilityLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponAbilityLinksTable> {
  $$WeaponAbilityLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weaponId =>
      $composableBuilder(column: $table.weaponId, builder: (column) => column);

  GeneratedColumn<String> get abilityId =>
      $composableBuilder(column: $table.abilityId, builder: (column) => column);
}

class $$WeaponAbilityLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponAbilityLinksTable,
          WeaponAbilityLink,
          $$WeaponAbilityLinksTableFilterComposer,
          $$WeaponAbilityLinksTableOrderingComposer,
          $$WeaponAbilityLinksTableAnnotationComposer,
          $$WeaponAbilityLinksTableCreateCompanionBuilder,
          $$WeaponAbilityLinksTableUpdateCompanionBuilder,
          (
            WeaponAbilityLink,
            BaseReferences<
              _$AppDatabase,
              $WeaponAbilityLinksTable,
              WeaponAbilityLink
            >,
          ),
          WeaponAbilityLink,
          PrefetchHooks Function()
        > {
  $$WeaponAbilityLinksTableTableManager(
    _$AppDatabase db,
    $WeaponAbilityLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponAbilityLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponAbilityLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponAbilityLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> weaponId = const Value.absent(),
                Value<String> abilityId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeaponAbilityLinksCompanion(
                id: id,
                weaponId: weaponId,
                abilityId: abilityId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String weaponId,
                required String abilityId,
                Value<int> rowid = const Value.absent(),
              }) => WeaponAbilityLinksCompanion.insert(
                id: id,
                weaponId: weaponId,
                abilityId: abilityId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeaponAbilityLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponAbilityLinksTable,
      WeaponAbilityLink,
      $$WeaponAbilityLinksTableFilterComposer,
      $$WeaponAbilityLinksTableOrderingComposer,
      $$WeaponAbilityLinksTableAnnotationComposer,
      $$WeaponAbilityLinksTableCreateCompanionBuilder,
      $$WeaponAbilityLinksTableUpdateCompanionBuilder,
      (
        WeaponAbilityLink,
        BaseReferences<
          _$AppDatabase,
          $WeaponAbilityLinksTable,
          WeaponAbilityLink
        >,
      ),
      WeaponAbilityLink,
      PrefetchHooks Function()
    >;
typedef $$DatasheetKeywordLinksTableCreateCompanionBuilder =
    DatasheetKeywordLinksCompanion Function({
      required String id,
      required String datasheetId,
      required String keywordId,
      Value<int> rowid,
    });
typedef $$DatasheetKeywordLinksTableUpdateCompanionBuilder =
    DatasheetKeywordLinksCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> keywordId,
      Value<int> rowid,
    });

class $$DatasheetKeywordLinksTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetKeywordLinksTable> {
  $$DatasheetKeywordLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywordId => $composableBuilder(
    column: $table.keywordId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetKeywordLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetKeywordLinksTable> {
  $$DatasheetKeywordLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywordId => $composableBuilder(
    column: $table.keywordId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetKeywordLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetKeywordLinksTable> {
  $$DatasheetKeywordLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keywordId =>
      $composableBuilder(column: $table.keywordId, builder: (column) => column);
}

class $$DatasheetKeywordLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetKeywordLinksTable,
          DatasheetKeywordLink,
          $$DatasheetKeywordLinksTableFilterComposer,
          $$DatasheetKeywordLinksTableOrderingComposer,
          $$DatasheetKeywordLinksTableAnnotationComposer,
          $$DatasheetKeywordLinksTableCreateCompanionBuilder,
          $$DatasheetKeywordLinksTableUpdateCompanionBuilder,
          (
            DatasheetKeywordLink,
            BaseReferences<
              _$AppDatabase,
              $DatasheetKeywordLinksTable,
              DatasheetKeywordLink
            >,
          ),
          DatasheetKeywordLink,
          PrefetchHooks Function()
        > {
  $$DatasheetKeywordLinksTableTableManager(
    _$AppDatabase db,
    $DatasheetKeywordLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetKeywordLinksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DatasheetKeywordLinksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DatasheetKeywordLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> keywordId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetKeywordLinksCompanion(
                id: id,
                datasheetId: datasheetId,
                keywordId: keywordId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String keywordId,
                Value<int> rowid = const Value.absent(),
              }) => DatasheetKeywordLinksCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                keywordId: keywordId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetKeywordLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetKeywordLinksTable,
      DatasheetKeywordLink,
      $$DatasheetKeywordLinksTableFilterComposer,
      $$DatasheetKeywordLinksTableOrderingComposer,
      $$DatasheetKeywordLinksTableAnnotationComposer,
      $$DatasheetKeywordLinksTableCreateCompanionBuilder,
      $$DatasheetKeywordLinksTableUpdateCompanionBuilder,
      (
        DatasheetKeywordLink,
        BaseReferences<
          _$AppDatabase,
          $DatasheetKeywordLinksTable,
          DatasheetKeywordLink
        >,
      ),
      DatasheetKeywordLink,
      PrefetchHooks Function()
    >;
typedef $$DatasheetAbilityLinksTableCreateCompanionBuilder =
    DatasheetAbilityLinksCompanion Function({
      required String id,
      required String datasheetId,
      required String abilityId,
      Value<int> rowid,
    });
typedef $$DatasheetAbilityLinksTableUpdateCompanionBuilder =
    DatasheetAbilityLinksCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<String> abilityId,
      Value<int> rowid,
    });

class $$DatasheetAbilityLinksTableFilterComposer
    extends Composer<_$AppDatabase, $DatasheetAbilityLinksTable> {
  $$DatasheetAbilityLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatasheetAbilityLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $DatasheetAbilityLinksTable> {
  $$DatasheetAbilityLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilityId => $composableBuilder(
    column: $table.abilityId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatasheetAbilityLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatasheetAbilityLinksTable> {
  $$DatasheetAbilityLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get abilityId =>
      $composableBuilder(column: $table.abilityId, builder: (column) => column);
}

class $$DatasheetAbilityLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatasheetAbilityLinksTable,
          DatasheetAbilityLink,
          $$DatasheetAbilityLinksTableFilterComposer,
          $$DatasheetAbilityLinksTableOrderingComposer,
          $$DatasheetAbilityLinksTableAnnotationComposer,
          $$DatasheetAbilityLinksTableCreateCompanionBuilder,
          $$DatasheetAbilityLinksTableUpdateCompanionBuilder,
          (
            DatasheetAbilityLink,
            BaseReferences<
              _$AppDatabase,
              $DatasheetAbilityLinksTable,
              DatasheetAbilityLink
            >,
          ),
          DatasheetAbilityLink,
          PrefetchHooks Function()
        > {
  $$DatasheetAbilityLinksTableTableManager(
    _$AppDatabase db,
    $DatasheetAbilityLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatasheetAbilityLinksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DatasheetAbilityLinksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DatasheetAbilityLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String> abilityId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatasheetAbilityLinksCompanion(
                id: id,
                datasheetId: datasheetId,
                abilityId: abilityId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required String abilityId,
                Value<int> rowid = const Value.absent(),
              }) => DatasheetAbilityLinksCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                abilityId: abilityId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatasheetAbilityLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatasheetAbilityLinksTable,
      DatasheetAbilityLink,
      $$DatasheetAbilityLinksTableFilterComposer,
      $$DatasheetAbilityLinksTableOrderingComposer,
      $$DatasheetAbilityLinksTableAnnotationComposer,
      $$DatasheetAbilityLinksTableCreateCompanionBuilder,
      $$DatasheetAbilityLinksTableUpdateCompanionBuilder,
      (
        DatasheetAbilityLink,
        BaseReferences<
          _$AppDatabase,
          $DatasheetAbilityLinksTable,
          DatasheetAbilityLink
        >,
      ),
      DatasheetAbilityLink,
      PrefetchHooks Function()
    >;
typedef $$DetachmentsTableCreateCompanionBuilder =
    DetachmentsCompanion Function({
      required String id,
      required String factionId,
      required String name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DetachmentsTableUpdateCompanionBuilder =
    DetachmentsCompanion Function({
      Value<String> id,
      Value<String> factionId,
      Value<String> name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DetachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DetachmentsTable> {
  $$DetachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DetachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DetachmentsTable> {
  $$DetachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DetachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetachmentsTable> {
  $$DetachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get factionId =>
      $composableBuilder(column: $table.factionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DetachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DetachmentsTable,
          Detachment,
          $$DetachmentsTableFilterComposer,
          $$DetachmentsTableOrderingComposer,
          $$DetachmentsTableAnnotationComposer,
          $$DetachmentsTableCreateCompanionBuilder,
          $$DetachmentsTableUpdateCompanionBuilder,
          (
            Detachment,
            BaseReferences<_$AppDatabase, $DetachmentsTable, Detachment>,
          ),
          Detachment,
          PrefetchHooks Function()
        > {
  $$DetachmentsTableTableManager(_$AppDatabase db, $DetachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DetachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> factionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DetachmentsCompanion(
                id: id,
                factionId: factionId,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String factionId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DetachmentsCompanion.insert(
                id: id,
                factionId: factionId,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DetachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DetachmentsTable,
      Detachment,
      $$DetachmentsTableFilterComposer,
      $$DetachmentsTableOrderingComposer,
      $$DetachmentsTableAnnotationComposer,
      $$DetachmentsTableCreateCompanionBuilder,
      $$DetachmentsTableUpdateCompanionBuilder,
      (
        Detachment,
        BaseReferences<_$AppDatabase, $DetachmentsTable, Detachment>,
      ),
      Detachment,
      PrefetchHooks Function()
    >;
typedef $$EnhancementsTableCreateCompanionBuilder =
    EnhancementsCompanion Function({
      required String id,
      required String detachmentId,
      required String name,
      required int points,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$EnhancementsTableUpdateCompanionBuilder =
    EnhancementsCompanion Function({
      Value<String> id,
      Value<String> detachmentId,
      Value<String> name,
      Value<int> points,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EnhancementsTableFilterComposer
    extends Composer<_$AppDatabase, $EnhancementsTable> {
  $$EnhancementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnhancementsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnhancementsTable> {
  $$EnhancementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnhancementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnhancementsTable> {
  $$EnhancementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EnhancementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnhancementsTable,
          Enhancement,
          $$EnhancementsTableFilterComposer,
          $$EnhancementsTableOrderingComposer,
          $$EnhancementsTableAnnotationComposer,
          $$EnhancementsTableCreateCompanionBuilder,
          $$EnhancementsTableUpdateCompanionBuilder,
          (
            Enhancement,
            BaseReferences<_$AppDatabase, $EnhancementsTable, Enhancement>,
          ),
          Enhancement,
          PrefetchHooks Function()
        > {
  $$EnhancementsTableTableManager(_$AppDatabase db, $EnhancementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnhancementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnhancementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnhancementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> detachmentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnhancementsCompanion(
                id: id,
                detachmentId: detachmentId,
                name: name,
                points: points,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String detachmentId,
                required String name,
                required int points,
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnhancementsCompanion.insert(
                id: id,
                detachmentId: detachmentId,
                name: name,
                points: points,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnhancementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnhancementsTable,
      Enhancement,
      $$EnhancementsTableFilterComposer,
      $$EnhancementsTableOrderingComposer,
      $$EnhancementsTableAnnotationComposer,
      $$EnhancementsTableCreateCompanionBuilder,
      $$EnhancementsTableUpdateCompanionBuilder,
      (
        Enhancement,
        BaseReferences<_$AppDatabase, $EnhancementsTable, Enhancement>,
      ),
      Enhancement,
      PrefetchHooks Function()
    >;
typedef $$StratagemsTableCreateCompanionBuilder =
    StratagemsCompanion Function({
      required String id,
      required String detachmentId,
      required String name,
      required int commandPoints,
      Value<String?> phase,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$StratagemsTableUpdateCompanionBuilder =
    StratagemsCompanion Function({
      Value<String> id,
      Value<String> detachmentId,
      Value<String> name,
      Value<int> commandPoints,
      Value<String?> phase,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$StratagemsTableFilterComposer
    extends Composer<_$AppDatabase, $StratagemsTable> {
  $$StratagemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get commandPoints => $composableBuilder(
    column: $table.commandPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StratagemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StratagemsTable> {
  $$StratagemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get commandPoints => $composableBuilder(
    column: $table.commandPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StratagemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StratagemsTable> {
  $$StratagemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get commandPoints => $composableBuilder(
    column: $table.commandPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StratagemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StratagemsTable,
          Stratagem,
          $$StratagemsTableFilterComposer,
          $$StratagemsTableOrderingComposer,
          $$StratagemsTableAnnotationComposer,
          $$StratagemsTableCreateCompanionBuilder,
          $$StratagemsTableUpdateCompanionBuilder,
          (
            Stratagem,
            BaseReferences<_$AppDatabase, $StratagemsTable, Stratagem>,
          ),
          Stratagem,
          PrefetchHooks Function()
        > {
  $$StratagemsTableTableManager(_$AppDatabase db, $StratagemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StratagemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StratagemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StratagemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> detachmentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> commandPoints = const Value.absent(),
                Value<String?> phase = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StratagemsCompanion(
                id: id,
                detachmentId: detachmentId,
                name: name,
                commandPoints: commandPoints,
                phase: phase,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String detachmentId,
                required String name,
                required int commandPoints,
                Value<String?> phase = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StratagemsCompanion.insert(
                id: id,
                detachmentId: detachmentId,
                name: name,
                commandPoints: commandPoints,
                phase: phase,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StratagemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StratagemsTable,
      Stratagem,
      $$StratagemsTableFilterComposer,
      $$StratagemsTableOrderingComposer,
      $$StratagemsTableAnnotationComposer,
      $$StratagemsTableCreateCompanionBuilder,
      $$StratagemsTableUpdateCompanionBuilder,
      (Stratagem, BaseReferences<_$AppDatabase, $StratagemsTable, Stratagem>),
      Stratagem,
      PrefetchHooks Function()
    >;
typedef $$ArmiesTableCreateCompanionBuilder =
    ArmiesCompanion Function({
      required String id,
      required String factionId,
      Value<String?> detachmentId,
      required String name,
      Value<String?> notes,
      Value<int?> pointsLimit,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ArmiesTableUpdateCompanionBuilder =
    ArmiesCompanion Function({
      Value<String> id,
      Value<String> factionId,
      Value<String?> detachmentId,
      Value<String> name,
      Value<String?> notes,
      Value<int?> pointsLimit,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ArmiesTableFilterComposer
    extends Composer<_$AppDatabase, $ArmiesTable> {
  $$ArmiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsLimit => $composableBuilder(
    column: $table.pointsLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArmiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ArmiesTable> {
  $$ArmiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsLimit => $composableBuilder(
    column: $table.pointsLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArmiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArmiesTable> {
  $$ArmiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get factionId =>
      $composableBuilder(column: $table.factionId, builder: (column) => column);

  GeneratedColumn<String> get detachmentId => $composableBuilder(
    column: $table.detachmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get pointsLimit => $composableBuilder(
    column: $table.pointsLimit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ArmiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArmiesTable,
          Army,
          $$ArmiesTableFilterComposer,
          $$ArmiesTableOrderingComposer,
          $$ArmiesTableAnnotationComposer,
          $$ArmiesTableCreateCompanionBuilder,
          $$ArmiesTableUpdateCompanionBuilder,
          (Army, BaseReferences<_$AppDatabase, $ArmiesTable, Army>),
          Army,
          PrefetchHooks Function()
        > {
  $$ArmiesTableTableManager(_$AppDatabase db, $ArmiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArmiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArmiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArmiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> factionId = const Value.absent(),
                Value<String?> detachmentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> pointsLimit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmiesCompanion(
                id: id,
                factionId: factionId,
                detachmentId: detachmentId,
                name: name,
                notes: notes,
                pointsLimit: pointsLimit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String factionId,
                Value<String?> detachmentId = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<int?> pointsLimit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmiesCompanion.insert(
                id: id,
                factionId: factionId,
                detachmentId: detachmentId,
                name: name,
                notes: notes,
                pointsLimit: pointsLimit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArmiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArmiesTable,
      Army,
      $$ArmiesTableFilterComposer,
      $$ArmiesTableOrderingComposer,
      $$ArmiesTableAnnotationComposer,
      $$ArmiesTableCreateCompanionBuilder,
      $$ArmiesTableUpdateCompanionBuilder,
      (Army, BaseReferences<_$AppDatabase, $ArmiesTable, Army>),
      Army,
      PrefetchHooks Function()
    >;
typedef $$ArmyUnitsTableCreateCompanionBuilder =
    ArmyUnitsCompanion Function({
      required String id,
      required String armyId,
      required String datasheetId,
      Value<String?> enhancementId,
      required int modelCount,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ArmyUnitsTableUpdateCompanionBuilder =
    ArmyUnitsCompanion Function({
      Value<String> id,
      Value<String> armyId,
      Value<String> datasheetId,
      Value<String?> enhancementId,
      Value<int> modelCount,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ArmyUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $ArmyUnitsTable> {
  $$ArmyUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armyId => $composableBuilder(
    column: $table.armyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enhancementId => $composableBuilder(
    column: $table.enhancementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modelCount => $composableBuilder(
    column: $table.modelCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArmyUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArmyUnitsTable> {
  $$ArmyUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armyId => $composableBuilder(
    column: $table.armyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enhancementId => $composableBuilder(
    column: $table.enhancementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modelCount => $composableBuilder(
    column: $table.modelCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArmyUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArmyUnitsTable> {
  $$ArmyUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get armyId =>
      $composableBuilder(column: $table.armyId, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get enhancementId => $composableBuilder(
    column: $table.enhancementId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get modelCount => $composableBuilder(
    column: $table.modelCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ArmyUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArmyUnitsTable,
          ArmyUnit,
          $$ArmyUnitsTableFilterComposer,
          $$ArmyUnitsTableOrderingComposer,
          $$ArmyUnitsTableAnnotationComposer,
          $$ArmyUnitsTableCreateCompanionBuilder,
          $$ArmyUnitsTableUpdateCompanionBuilder,
          (ArmyUnit, BaseReferences<_$AppDatabase, $ArmyUnitsTable, ArmyUnit>),
          ArmyUnit,
          PrefetchHooks Function()
        > {
  $$ArmyUnitsTableTableManager(_$AppDatabase db, $ArmyUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArmyUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArmyUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArmyUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> armyId = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<String?> enhancementId = const Value.absent(),
                Value<int> modelCount = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmyUnitsCompanion(
                id: id,
                armyId: armyId,
                datasheetId: datasheetId,
                enhancementId: enhancementId,
                modelCount: modelCount,
                displayOrder: displayOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String armyId,
                required String datasheetId,
                Value<String?> enhancementId = const Value.absent(),
                required int modelCount,
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmyUnitsCompanion.insert(
                id: id,
                armyId: armyId,
                datasheetId: datasheetId,
                enhancementId: enhancementId,
                modelCount: modelCount,
                displayOrder: displayOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArmyUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArmyUnitsTable,
      ArmyUnit,
      $$ArmyUnitsTableFilterComposer,
      $$ArmyUnitsTableOrderingComposer,
      $$ArmyUnitsTableAnnotationComposer,
      $$ArmyUnitsTableCreateCompanionBuilder,
      $$ArmyUnitsTableUpdateCompanionBuilder,
      (ArmyUnit, BaseReferences<_$AppDatabase, $ArmyUnitsTable, ArmyUnit>),
      ArmyUnit,
      PrefetchHooks Function()
    >;
typedef $$ArmyUnitEquipmentSelectionsTableCreateCompanionBuilder =
    ArmyUnitEquipmentSelectionsCompanion Function({
      required String id,
      required String armyUnitId,
      required String groupId,
      required String optionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ArmyUnitEquipmentSelectionsTableUpdateCompanionBuilder =
    ArmyUnitEquipmentSelectionsCompanion Function({
      Value<String> id,
      Value<String> armyUnitId,
      Value<String> groupId,
      Value<String> optionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ArmyUnitEquipmentSelectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ArmyUnitEquipmentSelectionsTable> {
  $$ArmyUnitEquipmentSelectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armyUnitId => $composableBuilder(
    column: $table.armyUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArmyUnitEquipmentSelectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArmyUnitEquipmentSelectionsTable> {
  $$ArmyUnitEquipmentSelectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armyUnitId => $composableBuilder(
    column: $table.armyUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArmyUnitEquipmentSelectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArmyUnitEquipmentSelectionsTable> {
  $$ArmyUnitEquipmentSelectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get armyUnitId => $composableBuilder(
    column: $table.armyUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get optionId =>
      $composableBuilder(column: $table.optionId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ArmyUnitEquipmentSelectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArmyUnitEquipmentSelectionsTable,
          ArmyUnitEquipmentSelection,
          $$ArmyUnitEquipmentSelectionsTableFilterComposer,
          $$ArmyUnitEquipmentSelectionsTableOrderingComposer,
          $$ArmyUnitEquipmentSelectionsTableAnnotationComposer,
          $$ArmyUnitEquipmentSelectionsTableCreateCompanionBuilder,
          $$ArmyUnitEquipmentSelectionsTableUpdateCompanionBuilder,
          (
            ArmyUnitEquipmentSelection,
            BaseReferences<
              _$AppDatabase,
              $ArmyUnitEquipmentSelectionsTable,
              ArmyUnitEquipmentSelection
            >,
          ),
          ArmyUnitEquipmentSelection,
          PrefetchHooks Function()
        > {
  $$ArmyUnitEquipmentSelectionsTableTableManager(
    _$AppDatabase db,
    $ArmyUnitEquipmentSelectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArmyUnitEquipmentSelectionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ArmyUnitEquipmentSelectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ArmyUnitEquipmentSelectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> armyUnitId = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> optionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmyUnitEquipmentSelectionsCompanion(
                id: id,
                armyUnitId: armyUnitId,
                groupId: groupId,
                optionId: optionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String armyUnitId,
                required String groupId,
                required String optionId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArmyUnitEquipmentSelectionsCompanion.insert(
                id: id,
                armyUnitId: armyUnitId,
                groupId: groupId,
                optionId: optionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArmyUnitEquipmentSelectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArmyUnitEquipmentSelectionsTable,
      ArmyUnitEquipmentSelection,
      $$ArmyUnitEquipmentSelectionsTableFilterComposer,
      $$ArmyUnitEquipmentSelectionsTableOrderingComposer,
      $$ArmyUnitEquipmentSelectionsTableAnnotationComposer,
      $$ArmyUnitEquipmentSelectionsTableCreateCompanionBuilder,
      $$ArmyUnitEquipmentSelectionsTableUpdateCompanionBuilder,
      (
        ArmyUnitEquipmentSelection,
        BaseReferences<
          _$AppDatabase,
          $ArmyUnitEquipmentSelectionsTable,
          ArmyUnitEquipmentSelection
        >,
      ),
      ArmyUnitEquipmentSelection,
      PrefetchHooks Function()
    >;
typedef $$OwnedMiniaturesTableCreateCompanionBuilder =
    OwnedMiniaturesCompanion Function({
      required String id,
      required String datasheetId,
      required int quantity,
      Value<int> assembled,
      Value<int> primed,
      Value<int> painted,
      Value<String?> notes,
      Value<DateTime?> purchaseDate,
      Value<double?> purchasePrice,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OwnedMiniaturesTableUpdateCompanionBuilder =
    OwnedMiniaturesCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<int> quantity,
      Value<int> assembled,
      Value<int> primed,
      Value<int> painted,
      Value<String?> notes,
      Value<DateTime?> purchaseDate,
      Value<double?> purchasePrice,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OwnedMiniaturesTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedMiniaturesTable> {
  $$OwnedMiniaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assembled => $composableBuilder(
    column: $table.assembled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get primed => $composableBuilder(
    column: $table.primed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get painted => $composableBuilder(
    column: $table.painted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedMiniaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedMiniaturesTable> {
  $$OwnedMiniaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assembled => $composableBuilder(
    column: $table.assembled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get primed => $composableBuilder(
    column: $table.primed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get painted => $composableBuilder(
    column: $table.painted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedMiniaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedMiniaturesTable> {
  $$OwnedMiniaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get assembled =>
      $composableBuilder(column: $table.assembled, builder: (column) => column);

  GeneratedColumn<int> get primed =>
      $composableBuilder(column: $table.primed, builder: (column) => column);

  GeneratedColumn<int> get painted =>
      $composableBuilder(column: $table.painted, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OwnedMiniaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedMiniaturesTable,
          OwnedMiniature,
          $$OwnedMiniaturesTableFilterComposer,
          $$OwnedMiniaturesTableOrderingComposer,
          $$OwnedMiniaturesTableAnnotationComposer,
          $$OwnedMiniaturesTableCreateCompanionBuilder,
          $$OwnedMiniaturesTableUpdateCompanionBuilder,
          (
            OwnedMiniature,
            BaseReferences<
              _$AppDatabase,
              $OwnedMiniaturesTable,
              OwnedMiniature
            >,
          ),
          OwnedMiniature,
          PrefetchHooks Function()
        > {
  $$OwnedMiniaturesTableTableManager(
    _$AppDatabase db,
    $OwnedMiniaturesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedMiniaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedMiniaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedMiniaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> assembled = const Value.absent(),
                Value<int> primed = const Value.absent(),
                Value<int> painted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedMiniaturesCompanion(
                id: id,
                datasheetId: datasheetId,
                quantity: quantity,
                assembled: assembled,
                primed: primed,
                painted: painted,
                notes: notes,
                purchaseDate: purchaseDate,
                purchasePrice: purchasePrice,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                required int quantity,
                Value<int> assembled = const Value.absent(),
                Value<int> primed = const Value.absent(),
                Value<int> painted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedMiniaturesCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                quantity: quantity,
                assembled: assembled,
                primed: primed,
                painted: painted,
                notes: notes,
                purchaseDate: purchaseDate,
                purchasePrice: purchasePrice,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedMiniaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedMiniaturesTable,
      OwnedMiniature,
      $$OwnedMiniaturesTableFilterComposer,
      $$OwnedMiniaturesTableOrderingComposer,
      $$OwnedMiniaturesTableAnnotationComposer,
      $$OwnedMiniaturesTableCreateCompanionBuilder,
      $$OwnedMiniaturesTableUpdateCompanionBuilder,
      (
        OwnedMiniature,
        BaseReferences<_$AppDatabase, $OwnedMiniaturesTable, OwnedMiniature>,
      ),
      OwnedMiniature,
      PrefetchHooks Function()
    >;
typedef $$WishlistItemsTableCreateCompanionBuilder =
    WishlistItemsCompanion Function({
      required String id,
      required String datasheetId,
      Value<int> quantity,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$WishlistItemsTableUpdateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<String> id,
      Value<String> datasheetId,
      Value<int> quantity,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$WishlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WishlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WishlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get datasheetId => $composableBuilder(
    column: $table.datasheetId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WishlistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WishlistItemsTable,
          WishlistItem,
          $$WishlistItemsTableFilterComposer,
          $$WishlistItemsTableOrderingComposer,
          $$WishlistItemsTableAnnotationComposer,
          $$WishlistItemsTableCreateCompanionBuilder,
          $$WishlistItemsTableUpdateCompanionBuilder,
          (
            WishlistItem,
            BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem>,
          ),
          WishlistItem,
          PrefetchHooks Function()
        > {
  $$WishlistItemsTableTableManager(_$AppDatabase db, $WishlistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> datasheetId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishlistItemsCompanion(
                id: id,
                datasheetId: datasheetId,
                quantity: quantity,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String datasheetId,
                Value<int> quantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WishlistItemsCompanion.insert(
                id: id,
                datasheetId: datasheetId,
                quantity: quantity,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WishlistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WishlistItemsTable,
      WishlistItem,
      $$WishlistItemsTableFilterComposer,
      $$WishlistItemsTableOrderingComposer,
      $$WishlistItemsTableAnnotationComposer,
      $$WishlistItemsTableCreateCompanionBuilder,
      $$WishlistItemsTableUpdateCompanionBuilder,
      (
        WishlistItem,
        BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem>,
      ),
      WishlistItem,
      PrefetchHooks Function()
    >;
typedef $$BattlesTableCreateCompanionBuilder =
    BattlesCompanion Function({
      required String id,
      Value<String?> armyId,
      Value<String?> opponentName,
      Value<String?> opponentFactionId,
      Value<String?> location,
      Value<String?> missionName,
      Value<BattleResult?> result,
      Value<BattleType> type,
      Value<int?> myScore,
      Value<int?> opponentScore,
      Value<String?> notes,
      Value<DateTime> playedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$BattlesTableUpdateCompanionBuilder =
    BattlesCompanion Function({
      Value<String> id,
      Value<String?> armyId,
      Value<String?> opponentName,
      Value<String?> opponentFactionId,
      Value<String?> location,
      Value<String?> missionName,
      Value<BattleResult?> result,
      Value<BattleType> type,
      Value<int?> myScore,
      Value<int?> opponentScore,
      Value<String?> notes,
      Value<DateTime> playedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BattlesTableFilterComposer
    extends Composer<_$AppDatabase, $BattlesTable> {
  $$BattlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armyId => $composableBuilder(
    column: $table.armyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opponentName => $composableBuilder(
    column: $table.opponentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opponentFactionId => $composableBuilder(
    column: $table.opponentFactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missionName => $composableBuilder(
    column: $table.missionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BattleResult?, BattleResult, String>
  get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<BattleType, BattleType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get myScore => $composableBuilder(
    column: $table.myScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get opponentScore => $composableBuilder(
    column: $table.opponentScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BattlesTableOrderingComposer
    extends Composer<_$AppDatabase, $BattlesTable> {
  $$BattlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armyId => $composableBuilder(
    column: $table.armyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opponentName => $composableBuilder(
    column: $table.opponentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opponentFactionId => $composableBuilder(
    column: $table.opponentFactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missionName => $composableBuilder(
    column: $table.missionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get myScore => $composableBuilder(
    column: $table.myScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get opponentScore => $composableBuilder(
    column: $table.opponentScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BattlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BattlesTable> {
  $$BattlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get armyId =>
      $composableBuilder(column: $table.armyId, builder: (column) => column);

  GeneratedColumn<String> get opponentName => $composableBuilder(
    column: $table.opponentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get opponentFactionId => $composableBuilder(
    column: $table.opponentFactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get missionName => $composableBuilder(
    column: $table.missionName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BattleResult?, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BattleType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get myScore =>
      $composableBuilder(column: $table.myScore, builder: (column) => column);

  GeneratedColumn<int> get opponentScore => $composableBuilder(
    column: $table.opponentScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BattlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BattlesTable,
          Battle,
          $$BattlesTableFilterComposer,
          $$BattlesTableOrderingComposer,
          $$BattlesTableAnnotationComposer,
          $$BattlesTableCreateCompanionBuilder,
          $$BattlesTableUpdateCompanionBuilder,
          (Battle, BaseReferences<_$AppDatabase, $BattlesTable, Battle>),
          Battle,
          PrefetchHooks Function()
        > {
  $$BattlesTableTableManager(_$AppDatabase db, $BattlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BattlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BattlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BattlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> armyId = const Value.absent(),
                Value<String?> opponentName = const Value.absent(),
                Value<String?> opponentFactionId = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> missionName = const Value.absent(),
                Value<BattleResult?> result = const Value.absent(),
                Value<BattleType> type = const Value.absent(),
                Value<int?> myScore = const Value.absent(),
                Value<int?> opponentScore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> playedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BattlesCompanion(
                id: id,
                armyId: armyId,
                opponentName: opponentName,
                opponentFactionId: opponentFactionId,
                location: location,
                missionName: missionName,
                result: result,
                type: type,
                myScore: myScore,
                opponentScore: opponentScore,
                notes: notes,
                playedAt: playedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> armyId = const Value.absent(),
                Value<String?> opponentName = const Value.absent(),
                Value<String?> opponentFactionId = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> missionName = const Value.absent(),
                Value<BattleResult?> result = const Value.absent(),
                Value<BattleType> type = const Value.absent(),
                Value<int?> myScore = const Value.absent(),
                Value<int?> opponentScore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> playedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BattlesCompanion.insert(
                id: id,
                armyId: armyId,
                opponentName: opponentName,
                opponentFactionId: opponentFactionId,
                location: location,
                missionName: missionName,
                result: result,
                type: type,
                myScore: myScore,
                opponentScore: opponentScore,
                notes: notes,
                playedAt: playedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BattlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BattlesTable,
      Battle,
      $$BattlesTableFilterComposer,
      $$BattlesTableOrderingComposer,
      $$BattlesTableAnnotationComposer,
      $$BattlesTableCreateCompanionBuilder,
      $$BattlesTableUpdateCompanionBuilder,
      (Battle, BaseReferences<_$AppDatabase, $BattlesTable, Battle>),
      Battle,
      PrefetchHooks Function()
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String title,
      Value<bool> done,
      Value<int?> progressPercent,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<bool> done,
      Value<int?> progressPercent,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
          Project,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int?> progressPercent = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                title: title,
                done: done,
                progressPercent: progressPercent,
                displayOrder: displayOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<bool> done = const Value.absent(),
                Value<int?> progressPercent = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                title: title,
                done: done,
                progressPercent: progressPercent,
                displayOrder: displayOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
      Project,
      PrefetchHooks Function()
    >;
typedef $$XpCategoryTotalsTableCreateCompanionBuilder =
    XpCategoryTotalsCompanion Function({
      required String category,
      Value<int> xp,
      Value<int> rowid,
    });
typedef $$XpCategoryTotalsTableUpdateCompanionBuilder =
    XpCategoryTotalsCompanion Function({
      Value<String> category,
      Value<int> xp,
      Value<int> rowid,
    });

class $$XpCategoryTotalsTableFilterComposer
    extends Composer<_$AppDatabase, $XpCategoryTotalsTable> {
  $$XpCategoryTotalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpCategoryTotalsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpCategoryTotalsTable> {
  $$XpCategoryTotalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpCategoryTotalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpCategoryTotalsTable> {
  $$XpCategoryTotalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);
}

class $$XpCategoryTotalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpCategoryTotalsTable,
          XpCategoryTotal,
          $$XpCategoryTotalsTableFilterComposer,
          $$XpCategoryTotalsTableOrderingComposer,
          $$XpCategoryTotalsTableAnnotationComposer,
          $$XpCategoryTotalsTableCreateCompanionBuilder,
          $$XpCategoryTotalsTableUpdateCompanionBuilder,
          (
            XpCategoryTotal,
            BaseReferences<
              _$AppDatabase,
              $XpCategoryTotalsTable,
              XpCategoryTotal
            >,
          ),
          XpCategoryTotal,
          PrefetchHooks Function()
        > {
  $$XpCategoryTotalsTableTableManager(
    _$AppDatabase db,
    $XpCategoryTotalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpCategoryTotalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpCategoryTotalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpCategoryTotalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> category = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpCategoryTotalsCompanion(
                category: category,
                xp: xp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String category,
                Value<int> xp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpCategoryTotalsCompanion.insert(
                category: category,
                xp: xp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpCategoryTotalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpCategoryTotalsTable,
      XpCategoryTotal,
      $$XpCategoryTotalsTableFilterComposer,
      $$XpCategoryTotalsTableOrderingComposer,
      $$XpCategoryTotalsTableAnnotationComposer,
      $$XpCategoryTotalsTableCreateCompanionBuilder,
      $$XpCategoryTotalsTableUpdateCompanionBuilder,
      (
        XpCategoryTotal,
        BaseReferences<_$AppDatabase, $XpCategoryTotalsTable, XpCategoryTotal>,
      ),
      XpCategoryTotal,
      PrefetchHooks Function()
    >;
typedef $$XpFactionTotalsTableCreateCompanionBuilder =
    XpFactionTotalsCompanion Function({
      required String factionId,
      Value<int> xp,
      Value<int> rowid,
    });
typedef $$XpFactionTotalsTableUpdateCompanionBuilder =
    XpFactionTotalsCompanion Function({
      Value<String> factionId,
      Value<int> xp,
      Value<int> rowid,
    });

class $$XpFactionTotalsTableFilterComposer
    extends Composer<_$AppDatabase, $XpFactionTotalsTable> {
  $$XpFactionTotalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpFactionTotalsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpFactionTotalsTable> {
  $$XpFactionTotalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get factionId => $composableBuilder(
    column: $table.factionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpFactionTotalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpFactionTotalsTable> {
  $$XpFactionTotalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get factionId =>
      $composableBuilder(column: $table.factionId, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);
}

class $$XpFactionTotalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpFactionTotalsTable,
          XpFactionTotal,
          $$XpFactionTotalsTableFilterComposer,
          $$XpFactionTotalsTableOrderingComposer,
          $$XpFactionTotalsTableAnnotationComposer,
          $$XpFactionTotalsTableCreateCompanionBuilder,
          $$XpFactionTotalsTableUpdateCompanionBuilder,
          (
            XpFactionTotal,
            BaseReferences<
              _$AppDatabase,
              $XpFactionTotalsTable,
              XpFactionTotal
            >,
          ),
          XpFactionTotal,
          PrefetchHooks Function()
        > {
  $$XpFactionTotalsTableTableManager(
    _$AppDatabase db,
    $XpFactionTotalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpFactionTotalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpFactionTotalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpFactionTotalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> factionId = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpFactionTotalsCompanion(
                factionId: factionId,
                xp: xp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String factionId,
                Value<int> xp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpFactionTotalsCompanion.insert(
                factionId: factionId,
                xp: xp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpFactionTotalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpFactionTotalsTable,
      XpFactionTotal,
      $$XpFactionTotalsTableFilterComposer,
      $$XpFactionTotalsTableOrderingComposer,
      $$XpFactionTotalsTableAnnotationComposer,
      $$XpFactionTotalsTableCreateCompanionBuilder,
      $$XpFactionTotalsTableUpdateCompanionBuilder,
      (
        XpFactionTotal,
        BaseReferences<_$AppDatabase, $XpFactionTotalsTable, XpFactionTotal>,
      ),
      XpFactionTotal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GameSystemsTableTableManager get gameSystems =>
      $$GameSystemsTableTableManager(_db, _db.gameSystems);
  $$EditionsTableTableManager get editions =>
      $$EditionsTableTableManager(_db, _db.editions);
  $$GameModesTableTableManager get gameModes =>
      $$GameModesTableTableManager(_db, _db.gameModes);
  $$FactionsTableTableManager get factions =>
      $$FactionsTableTableManager(_db, _db.factions);
  $$SubFactionsTableTableManager get subFactions =>
      $$SubFactionsTableTableManager(_db, _db.subFactions);
  $$KeywordsTableTableManager get keywords =>
      $$KeywordsTableTableManager(_db, _db.keywords);
  $$AbilitiesTableTableManager get abilities =>
      $$AbilitiesTableTableManager(_db, _db.abilities);
  $$DatasheetsTableTableManager get datasheets =>
      $$DatasheetsTableTableManager(_db, _db.datasheets);
  $$DatasheetModelsTableTableManager get datasheetModels =>
      $$DatasheetModelsTableTableManager(_db, _db.datasheetModels);
  $$ModelProfilesTableTableManager get modelProfiles =>
      $$ModelProfilesTableTableManager(_db, _db.modelProfiles);
  $$UnitSizesTableTableManager get unitSizes =>
      $$UnitSizesTableTableManager(_db, _db.unitSizes);
  $$UnitCompositionsTableTableManager get unitCompositions =>
      $$UnitCompositionsTableTableManager(_db, _db.unitCompositions);
  $$DatasheetCostsTableTableManager get datasheetCosts =>
      $$DatasheetCostsTableTableManager(_db, _db.datasheetCosts);
  $$DatasheetVersionsTableTableManager get datasheetVersions =>
      $$DatasheetVersionsTableTableManager(_db, _db.datasheetVersions);
  $$DatasheetSourcesTableTableManager get datasheetSources =>
      $$DatasheetSourcesTableTableManager(_db, _db.datasheetSources);
  $$EquipmentGroupsTableTableManager get equipmentGroups =>
      $$EquipmentGroupsTableTableManager(_db, _db.equipmentGroups);
  $$EquipmentOptionsTableTableManager get equipmentOptions =>
      $$EquipmentOptionsTableTableManager(_db, _db.equipmentOptions);
  $$EquipmentChoicesTableTableManager get equipmentChoices =>
      $$EquipmentChoicesTableTableManager(_db, _db.equipmentChoices);
  $$EquipmentRestrictionsTableTableManager get equipmentRestrictions =>
      $$EquipmentRestrictionsTableTableManager(_db, _db.equipmentRestrictions);
  $$WeaponsTableTableManager get weapons =>
      $$WeaponsTableTableManager(_db, _db.weapons);
  $$WeaponProfilesTableTableManager get weaponProfiles =>
      $$WeaponProfilesTableTableManager(_db, _db.weaponProfiles);
  $$DatasheetWeaponsTableTableManager get datasheetWeapons =>
      $$DatasheetWeaponsTableTableManager(_db, _db.datasheetWeapons);
  $$WeaponKeywordLinksTableTableManager get weaponKeywordLinks =>
      $$WeaponKeywordLinksTableTableManager(_db, _db.weaponKeywordLinks);
  $$WeaponAbilityLinksTableTableManager get weaponAbilityLinks =>
      $$WeaponAbilityLinksTableTableManager(_db, _db.weaponAbilityLinks);
  $$DatasheetKeywordLinksTableTableManager get datasheetKeywordLinks =>
      $$DatasheetKeywordLinksTableTableManager(_db, _db.datasheetKeywordLinks);
  $$DatasheetAbilityLinksTableTableManager get datasheetAbilityLinks =>
      $$DatasheetAbilityLinksTableTableManager(_db, _db.datasheetAbilityLinks);
  $$DetachmentsTableTableManager get detachments =>
      $$DetachmentsTableTableManager(_db, _db.detachments);
  $$EnhancementsTableTableManager get enhancements =>
      $$EnhancementsTableTableManager(_db, _db.enhancements);
  $$StratagemsTableTableManager get stratagems =>
      $$StratagemsTableTableManager(_db, _db.stratagems);
  $$ArmiesTableTableManager get armies =>
      $$ArmiesTableTableManager(_db, _db.armies);
  $$ArmyUnitsTableTableManager get armyUnits =>
      $$ArmyUnitsTableTableManager(_db, _db.armyUnits);
  $$ArmyUnitEquipmentSelectionsTableTableManager
  get armyUnitEquipmentSelections =>
      $$ArmyUnitEquipmentSelectionsTableTableManager(
        _db,
        _db.armyUnitEquipmentSelections,
      );
  $$OwnedMiniaturesTableTableManager get ownedMiniatures =>
      $$OwnedMiniaturesTableTableManager(_db, _db.ownedMiniatures);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db, _db.wishlistItems);
  $$BattlesTableTableManager get battles =>
      $$BattlesTableTableManager(_db, _db.battles);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$XpCategoryTotalsTableTableManager get xpCategoryTotals =>
      $$XpCategoryTotalsTableTableManager(_db, _db.xpCategoryTotals);
  $$XpFactionTotalsTableTableManager get xpFactionTotals =>
      $$XpFactionTotalsTableTableManager(_db, _db.xpFactionTotals);
}

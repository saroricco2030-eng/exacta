// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    color,
    startDate,
    endDate,
    status,
    createdAt,
    updatedAt,
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
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final String? color;
  final String? startDate;
  final String? endDate;
  final String status;
  final String createdAt;
  final String updatedAt;
  const Project({
    required this.id,
    required this.name,
    this.color,
    this.startDate,
    this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Project copyWith({
    int? id,
    String? name,
    Value<String?> color = const Value.absent(),
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    String? status,
    String? createdAt,
    String? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    color,
    startDate,
    endDate,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<String> status;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? color,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<String>? status,
    Value<String>? createdAt,
    Value<String>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presetTypeMeta = const VerificationMeta(
    'presetType',
  );
  @override
  late final GeneratedColumn<String> presetType = GeneratedColumn<String>(
    'preset_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSecureMeta = const VerificationMeta(
    'isSecure',
  );
  @override
  late final GeneratedColumn<bool> isSecure = GeneratedColumn<bool>(
    'is_secure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_secure" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isVideoMeta = const VerificationMeta(
    'isVideo',
  );
  @override
  late final GeneratedColumn<bool> isVideo = GeneratedColumn<bool>(
    'is_video',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_video" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoCodeMeta = const VerificationMeta(
    'photoCode',
  );
  @override
  late final GeneratedColumn<String> photoCode = GeneratedColumn<String>(
    'photo_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherInfoMeta = const VerificationMeta(
    'weatherInfo',
  );
  @override
  late final GeneratedColumn<String> weatherInfo = GeneratedColumn<String>(
    'weather_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoHashMeta = const VerificationMeta(
    'photoHash',
  );
  @override
  late final GeneratedColumn<String> photoHash = GeneratedColumn<String>(
    'photo_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prevHashMeta = const VerificationMeta(
    'prevHash',
  );
  @override
  late final GeneratedColumn<String> prevHash = GeneratedColumn<String>(
    'prev_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chainHashMeta = const VerificationMeta(
    'chainHash',
  );
  @override
  late final GeneratedColumn<String> chainHash = GeneratedColumn<String>(
    'chain_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ntpSyncedMeta = const VerificationMeta(
    'ntpSynced',
  );
  @override
  late final GeneratedColumn<bool> ntpSynced = GeneratedColumn<bool>(
    'ntp_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ntp_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    filePath,
    thumbnailPath,
    presetType,
    memo,
    tags,
    timestamp,
    latitude,
    longitude,
    address,
    isSecure,
    isVideo,
    photoCode,
    weatherInfo,
    photoHash,
    prevHash,
    chainHash,
    ntpSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('preset_type')) {
      context.handle(
        _presetTypeMeta,
        presetType.isAcceptableOrUnknown(data['preset_type']!, _presetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_presetTypeMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('is_secure')) {
      context.handle(
        _isSecureMeta,
        isSecure.isAcceptableOrUnknown(data['is_secure']!, _isSecureMeta),
      );
    }
    if (data.containsKey('is_video')) {
      context.handle(
        _isVideoMeta,
        isVideo.isAcceptableOrUnknown(data['is_video']!, _isVideoMeta),
      );
    }
    if (data.containsKey('photo_code')) {
      context.handle(
        _photoCodeMeta,
        photoCode.isAcceptableOrUnknown(data['photo_code']!, _photoCodeMeta),
      );
    }
    if (data.containsKey('weather_info')) {
      context.handle(
        _weatherInfoMeta,
        weatherInfo.isAcceptableOrUnknown(
          data['weather_info']!,
          _weatherInfoMeta,
        ),
      );
    }
    if (data.containsKey('photo_hash')) {
      context.handle(
        _photoHashMeta,
        photoHash.isAcceptableOrUnknown(data['photo_hash']!, _photoHashMeta),
      );
    }
    if (data.containsKey('prev_hash')) {
      context.handle(
        _prevHashMeta,
        prevHash.isAcceptableOrUnknown(data['prev_hash']!, _prevHashMeta),
      );
    }
    if (data.containsKey('chain_hash')) {
      context.handle(
        _chainHashMeta,
        chainHash.isAcceptableOrUnknown(data['chain_hash']!, _chainHashMeta),
      );
    }
    if (data.containsKey('ntp_synced')) {
      context.handle(
        _ntpSyncedMeta,
        ntpSynced.isAcceptableOrUnknown(data['ntp_synced']!, _ntpSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      presetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preset_type'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      isSecure: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_secure'],
      )!,
      isVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_video'],
      )!,
      photoCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_code'],
      ),
      weatherInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather_info'],
      ),
      photoHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_hash'],
      ),
      prevHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prev_hash'],
      ),
      chainHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chain_hash'],
      ),
      ntpSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ntp_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final int id;
  final int? projectId;
  final String filePath;
  final String? thumbnailPath;
  final String presetType;
  final String? memo;
  final String? tags;
  final String timestamp;
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool isSecure;
  final bool isVideo;
  final String? photoCode;
  final String? weatherInfo;
  final String? photoHash;
  final String? prevHash;
  final String? chainHash;
  final bool ntpSynced;
  final String createdAt;
  const Photo({
    required this.id,
    this.projectId,
    required this.filePath,
    this.thumbnailPath,
    required this.presetType,
    this.memo,
    this.tags,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.address,
    required this.isSecure,
    required this.isVideo,
    this.photoCode,
    this.weatherInfo,
    this.photoHash,
    this.prevHash,
    this.chainHash,
    required this.ntpSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['preset_type'] = Variable<String>(presetType);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['timestamp'] = Variable<String>(timestamp);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['is_secure'] = Variable<bool>(isSecure);
    map['is_video'] = Variable<bool>(isVideo);
    if (!nullToAbsent || photoCode != null) {
      map['photo_code'] = Variable<String>(photoCode);
    }
    if (!nullToAbsent || weatherInfo != null) {
      map['weather_info'] = Variable<String>(weatherInfo);
    }
    if (!nullToAbsent || photoHash != null) {
      map['photo_hash'] = Variable<String>(photoHash);
    }
    if (!nullToAbsent || prevHash != null) {
      map['prev_hash'] = Variable<String>(prevHash);
    }
    if (!nullToAbsent || chainHash != null) {
      map['chain_hash'] = Variable<String>(chainHash);
    }
    map['ntp_synced'] = Variable<bool>(ntpSynced);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      filePath: Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      presetType: Value(presetType),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      timestamp: Value(timestamp),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      isSecure: Value(isSecure),
      isVideo: Value(isVideo),
      photoCode: photoCode == null && nullToAbsent
          ? const Value.absent()
          : Value(photoCode),
      weatherInfo: weatherInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherInfo),
      photoHash: photoHash == null && nullToAbsent
          ? const Value.absent()
          : Value(photoHash),
      prevHash: prevHash == null && nullToAbsent
          ? const Value.absent()
          : Value(prevHash),
      chainHash: chainHash == null && nullToAbsent
          ? const Value.absent()
          : Value(chainHash),
      ntpSynced: Value(ntpSynced),
      createdAt: Value(createdAt),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int?>(json['projectId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      presetType: serializer.fromJson<String>(json['presetType']),
      memo: serializer.fromJson<String?>(json['memo']),
      tags: serializer.fromJson<String?>(json['tags']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      address: serializer.fromJson<String?>(json['address']),
      isSecure: serializer.fromJson<bool>(json['isSecure']),
      isVideo: serializer.fromJson<bool>(json['isVideo']),
      photoCode: serializer.fromJson<String?>(json['photoCode']),
      weatherInfo: serializer.fromJson<String?>(json['weatherInfo']),
      photoHash: serializer.fromJson<String?>(json['photoHash']),
      prevHash: serializer.fromJson<String?>(json['prevHash']),
      chainHash: serializer.fromJson<String?>(json['chainHash']),
      ntpSynced: serializer.fromJson<bool>(json['ntpSynced']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int?>(projectId),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'presetType': serializer.toJson<String>(presetType),
      'memo': serializer.toJson<String?>(memo),
      'tags': serializer.toJson<String?>(tags),
      'timestamp': serializer.toJson<String>(timestamp),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'address': serializer.toJson<String?>(address),
      'isSecure': serializer.toJson<bool>(isSecure),
      'isVideo': serializer.toJson<bool>(isVideo),
      'photoCode': serializer.toJson<String?>(photoCode),
      'weatherInfo': serializer.toJson<String?>(weatherInfo),
      'photoHash': serializer.toJson<String?>(photoHash),
      'prevHash': serializer.toJson<String?>(prevHash),
      'chainHash': serializer.toJson<String?>(chainHash),
      'ntpSynced': serializer.toJson<bool>(ntpSynced),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Photo copyWith({
    int? id,
    Value<int?> projectId = const Value.absent(),
    String? filePath,
    Value<String?> thumbnailPath = const Value.absent(),
    String? presetType,
    Value<String?> memo = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    String? timestamp,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> address = const Value.absent(),
    bool? isSecure,
    bool? isVideo,
    Value<String?> photoCode = const Value.absent(),
    Value<String?> weatherInfo = const Value.absent(),
    Value<String?> photoHash = const Value.absent(),
    Value<String?> prevHash = const Value.absent(),
    Value<String?> chainHash = const Value.absent(),
    bool? ntpSynced,
    String? createdAt,
  }) => Photo(
    id: id ?? this.id,
    projectId: projectId.present ? projectId.value : this.projectId,
    filePath: filePath ?? this.filePath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    presetType: presetType ?? this.presetType,
    memo: memo.present ? memo.value : this.memo,
    tags: tags.present ? tags.value : this.tags,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    address: address.present ? address.value : this.address,
    isSecure: isSecure ?? this.isSecure,
    isVideo: isVideo ?? this.isVideo,
    photoCode: photoCode.present ? photoCode.value : this.photoCode,
    weatherInfo: weatherInfo.present ? weatherInfo.value : this.weatherInfo,
    photoHash: photoHash.present ? photoHash.value : this.photoHash,
    prevHash: prevHash.present ? prevHash.value : this.prevHash,
    chainHash: chainHash.present ? chainHash.value : this.chainHash,
    ntpSynced: ntpSynced ?? this.ntpSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      presetType: data.presetType.present
          ? data.presetType.value
          : this.presetType,
      memo: data.memo.present ? data.memo.value : this.memo,
      tags: data.tags.present ? data.tags.value : this.tags,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      isSecure: data.isSecure.present ? data.isSecure.value : this.isSecure,
      isVideo: data.isVideo.present ? data.isVideo.value : this.isVideo,
      photoCode: data.photoCode.present ? data.photoCode.value : this.photoCode,
      weatherInfo: data.weatherInfo.present
          ? data.weatherInfo.value
          : this.weatherInfo,
      photoHash: data.photoHash.present ? data.photoHash.value : this.photoHash,
      prevHash: data.prevHash.present ? data.prevHash.value : this.prevHash,
      chainHash: data.chainHash.present ? data.chainHash.value : this.chainHash,
      ntpSynced: data.ntpSynced.present ? data.ntpSynced.value : this.ntpSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('presetType: $presetType, ')
          ..write('memo: $memo, ')
          ..write('tags: $tags, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('isSecure: $isSecure, ')
          ..write('isVideo: $isVideo, ')
          ..write('photoCode: $photoCode, ')
          ..write('weatherInfo: $weatherInfo, ')
          ..write('photoHash: $photoHash, ')
          ..write('prevHash: $prevHash, ')
          ..write('chainHash: $chainHash, ')
          ..write('ntpSynced: $ntpSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    filePath,
    thumbnailPath,
    presetType,
    memo,
    tags,
    timestamp,
    latitude,
    longitude,
    address,
    isSecure,
    isVideo,
    photoCode,
    weatherInfo,
    photoHash,
    prevHash,
    chainHash,
    ntpSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.presetType == this.presetType &&
          other.memo == this.memo &&
          other.tags == this.tags &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.isSecure == this.isSecure &&
          other.isVideo == this.isVideo &&
          other.photoCode == this.photoCode &&
          other.weatherInfo == this.weatherInfo &&
          other.photoHash == this.photoHash &&
          other.prevHash == this.prevHash &&
          other.chainHash == this.chainHash &&
          other.ntpSynced == this.ntpSynced &&
          other.createdAt == this.createdAt);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<int> id;
  final Value<int?> projectId;
  final Value<String> filePath;
  final Value<String?> thumbnailPath;
  final Value<String> presetType;
  final Value<String?> memo;
  final Value<String?> tags;
  final Value<String> timestamp;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> address;
  final Value<bool> isSecure;
  final Value<bool> isVideo;
  final Value<String?> photoCode;
  final Value<String?> weatherInfo;
  final Value<String?> photoHash;
  final Value<String?> prevHash;
  final Value<String?> chainHash;
  final Value<bool> ntpSynced;
  final Value<String> createdAt;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.presetType = const Value.absent(),
    this.memo = const Value.absent(),
    this.tags = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.isSecure = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.photoCode = const Value.absent(),
    this.weatherInfo = const Value.absent(),
    this.photoHash = const Value.absent(),
    this.prevHash = const Value.absent(),
    this.chainHash = const Value.absent(),
    this.ntpSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    required String filePath,
    this.thumbnailPath = const Value.absent(),
    required String presetType,
    this.memo = const Value.absent(),
    this.tags = const Value.absent(),
    required String timestamp,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.isSecure = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.photoCode = const Value.absent(),
    this.weatherInfo = const Value.absent(),
    this.photoHash = const Value.absent(),
    this.prevHash = const Value.absent(),
    this.chainHash = const Value.absent(),
    this.ntpSynced = const Value.absent(),
    required String createdAt,
  }) : filePath = Value(filePath),
       presetType = Value(presetType),
       timestamp = Value(timestamp),
       createdAt = Value(createdAt);
  static Insertable<Photo> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<String>? presetType,
    Expression<String>? memo,
    Expression<String>? tags,
    Expression<String>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<bool>? isSecure,
    Expression<bool>? isVideo,
    Expression<String>? photoCode,
    Expression<String>? weatherInfo,
    Expression<String>? photoHash,
    Expression<String>? prevHash,
    Expression<String>? chainHash,
    Expression<bool>? ntpSynced,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (presetType != null) 'preset_type': presetType,
      if (memo != null) 'memo': memo,
      if (tags != null) 'tags': tags,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (isSecure != null) 'is_secure': isSecure,
      if (isVideo != null) 'is_video': isVideo,
      if (photoCode != null) 'photo_code': photoCode,
      if (weatherInfo != null) 'weather_info': weatherInfo,
      if (photoHash != null) 'photo_hash': photoHash,
      if (prevHash != null) 'prev_hash': prevHash,
      if (chainHash != null) 'chain_hash': chainHash,
      if (ntpSynced != null) 'ntp_synced': ntpSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PhotosCompanion copyWith({
    Value<int>? id,
    Value<int?>? projectId,
    Value<String>? filePath,
    Value<String?>? thumbnailPath,
    Value<String>? presetType,
    Value<String?>? memo,
    Value<String?>? tags,
    Value<String>? timestamp,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? address,
    Value<bool>? isSecure,
    Value<bool>? isVideo,
    Value<String?>? photoCode,
    Value<String?>? weatherInfo,
    Value<String?>? photoHash,
    Value<String?>? prevHash,
    Value<String?>? chainHash,
    Value<bool>? ntpSynced,
    Value<String>? createdAt,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      presetType: presetType ?? this.presetType,
      memo: memo ?? this.memo,
      tags: tags ?? this.tags,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isSecure: isSecure ?? this.isSecure,
      isVideo: isVideo ?? this.isVideo,
      photoCode: photoCode ?? this.photoCode,
      weatherInfo: weatherInfo ?? this.weatherInfo,
      photoHash: photoHash ?? this.photoHash,
      prevHash: prevHash ?? this.prevHash,
      chainHash: chainHash ?? this.chainHash,
      ntpSynced: ntpSynced ?? this.ntpSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (presetType.present) {
      map['preset_type'] = Variable<String>(presetType.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isSecure.present) {
      map['is_secure'] = Variable<bool>(isSecure.value);
    }
    if (isVideo.present) {
      map['is_video'] = Variable<bool>(isVideo.value);
    }
    if (photoCode.present) {
      map['photo_code'] = Variable<String>(photoCode.value);
    }
    if (weatherInfo.present) {
      map['weather_info'] = Variable<String>(weatherInfo.value);
    }
    if (photoHash.present) {
      map['photo_hash'] = Variable<String>(photoHash.value);
    }
    if (prevHash.present) {
      map['prev_hash'] = Variable<String>(prevHash.value);
    }
    if (chainHash.present) {
      map['chain_hash'] = Variable<String>(chainHash.value);
    }
    if (ntpSynced.present) {
      map['ntp_synced'] = Variable<bool>(ntpSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('presetType: $presetType, ')
          ..write('memo: $memo, ')
          ..write('tags: $tags, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('isSecure: $isSecure, ')
          ..write('isVideo: $isVideo, ')
          ..write('photoCode: $photoCode, ')
          ..write('weatherInfo: $weatherInfo, ')
          ..write('photoHash: $photoHash, ')
          ..write('prevHash: $prevHash, ')
          ..write('chainHash: $chainHash, ')
          ..write('ntpSynced: $ntpSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StampConfigsTable extends StampConfigs
    with TableInfo<$StampConfigsTable, StampConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StampConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dateFormatMeta = const VerificationMeta(
    'dateFormat',
  );
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
    'date_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('YYYY.MM.DD'),
  );
  static const VerificationMeta _fontFamilyMeta = const VerificationMeta(
    'fontFamily',
  );
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
    'font_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mono'),
  );
  static const VerificationMeta _stampColorMeta = const VerificationMeta(
    'stampColor',
  );
  @override
  late final GeneratedColumn<String> stampColor = GeneratedColumn<String>(
    'stamp_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#FFFFFF'),
  );
  static const VerificationMeta _stampPositionMeta = const VerificationMeta(
    'stampPosition',
  );
  @override
  late final GeneratedColumn<String> stampPosition = GeneratedColumn<String>(
    'stamp_position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bottom'),
  );
  static const VerificationMeta _showInNativeGalleryMeta =
      const VerificationMeta('showInNativeGallery');
  @override
  late final GeneratedColumn<bool> showInNativeGallery = GeneratedColumn<bool>(
    'show_in_native_gallery',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_native_gallery" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _resolutionMeta = const VerificationMeta(
    'resolution',
  );
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
    'resolution',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('4k'),
  );
  static const VerificationMeta _shutterSoundMeta = const VerificationMeta(
    'shutterSound',
  );
  @override
  late final GeneratedColumn<bool> shutterSound = GeneratedColumn<bool>(
    'shutter_sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("shutter_sound" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _batterySaverMeta = const VerificationMeta(
    'batterySaver',
  );
  @override
  late final GeneratedColumn<bool> batterySaver = GeneratedColumn<bool>(
    'battery_saver',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("battery_saver" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _exifStripMeta = const VerificationMeta(
    'exifStrip',
  );
  @override
  late final GeneratedColumn<bool> exifStrip = GeneratedColumn<bool>(
    'exif_strip',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("exif_strip" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _secureShareLimitMeta = const VerificationMeta(
    'secureShareLimit',
  );
  @override
  late final GeneratedColumn<bool> secureShareLimit = GeneratedColumn<bool>(
    'secure_share_limit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("secure_share_limit" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signaturePathMeta = const VerificationMeta(
    'signaturePath',
  );
  @override
  late final GeneratedColumn<String> signaturePath = GeneratedColumn<String>(
    'signature_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _stampLayoutMeta = const VerificationMeta(
    'stampLayout',
  );
  @override
  late final GeneratedColumn<String> stampLayout = GeneratedColumn<String>(
    'stamp_layout',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('card'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateFormat,
    fontFamily,
    stampColor,
    stampPosition,
    showInNativeGallery,
    resolution,
    shutterSound,
    batterySaver,
    exifStrip,
    secureShareLimit,
    logoPath,
    signaturePath,
    themeMode,
    locale,
    stampLayout,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stamp_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<StampConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_format')) {
      context.handle(
        _dateFormatMeta,
        dateFormat.isAcceptableOrUnknown(data['date_format']!, _dateFormatMeta),
      );
    }
    if (data.containsKey('font_family')) {
      context.handle(
        _fontFamilyMeta,
        fontFamily.isAcceptableOrUnknown(data['font_family']!, _fontFamilyMeta),
      );
    }
    if (data.containsKey('stamp_color')) {
      context.handle(
        _stampColorMeta,
        stampColor.isAcceptableOrUnknown(data['stamp_color']!, _stampColorMeta),
      );
    }
    if (data.containsKey('stamp_position')) {
      context.handle(
        _stampPositionMeta,
        stampPosition.isAcceptableOrUnknown(
          data['stamp_position']!,
          _stampPositionMeta,
        ),
      );
    }
    if (data.containsKey('show_in_native_gallery')) {
      context.handle(
        _showInNativeGalleryMeta,
        showInNativeGallery.isAcceptableOrUnknown(
          data['show_in_native_gallery']!,
          _showInNativeGalleryMeta,
        ),
      );
    }
    if (data.containsKey('resolution')) {
      context.handle(
        _resolutionMeta,
        resolution.isAcceptableOrUnknown(data['resolution']!, _resolutionMeta),
      );
    }
    if (data.containsKey('shutter_sound')) {
      context.handle(
        _shutterSoundMeta,
        shutterSound.isAcceptableOrUnknown(
          data['shutter_sound']!,
          _shutterSoundMeta,
        ),
      );
    }
    if (data.containsKey('battery_saver')) {
      context.handle(
        _batterySaverMeta,
        batterySaver.isAcceptableOrUnknown(
          data['battery_saver']!,
          _batterySaverMeta,
        ),
      );
    }
    if (data.containsKey('exif_strip')) {
      context.handle(
        _exifStripMeta,
        exifStrip.isAcceptableOrUnknown(data['exif_strip']!, _exifStripMeta),
      );
    }
    if (data.containsKey('secure_share_limit')) {
      context.handle(
        _secureShareLimitMeta,
        secureShareLimit.isAcceptableOrUnknown(
          data['secure_share_limit']!,
          _secureShareLimitMeta,
        ),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('signature_path')) {
      context.handle(
        _signaturePathMeta,
        signaturePath.isAcceptableOrUnknown(
          data['signature_path']!,
          _signaturePathMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('stamp_layout')) {
      context.handle(
        _stampLayoutMeta,
        stampLayout.isAcceptableOrUnknown(
          data['stamp_layout']!,
          _stampLayoutMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StampConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StampConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dateFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_format'],
      )!,
      fontFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_family'],
      )!,
      stampColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stamp_color'],
      )!,
      stampPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stamp_position'],
      )!,
      showInNativeGallery: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_native_gallery'],
      )!,
      resolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution'],
      )!,
      shutterSound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}shutter_sound'],
      )!,
      batterySaver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}battery_saver'],
      )!,
      exifStrip: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}exif_strip'],
      )!,
      secureShareLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}secure_share_limit'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      signaturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_path'],
      ),
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      stampLayout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stamp_layout'],
      )!,
    );
  }

  @override
  $StampConfigsTable createAlias(String alias) {
    return $StampConfigsTable(attachedDatabase, alias);
  }
}

class StampConfig extends DataClass implements Insertable<StampConfig> {
  final int id;
  final String dateFormat;
  final String fontFamily;
  final String stampColor;
  final String stampPosition;
  final bool showInNativeGallery;
  final String resolution;
  final bool shutterSound;
  final bool batterySaver;
  final bool exifStrip;
  final bool secureShareLimit;
  final String? logoPath;
  final String? signaturePath;
  final String themeMode;
  final String locale;
  final String stampLayout;
  const StampConfig({
    required this.id,
    required this.dateFormat,
    required this.fontFamily,
    required this.stampColor,
    required this.stampPosition,
    required this.showInNativeGallery,
    required this.resolution,
    required this.shutterSound,
    required this.batterySaver,
    required this.exifStrip,
    required this.secureShareLimit,
    this.logoPath,
    this.signaturePath,
    required this.themeMode,
    required this.locale,
    required this.stampLayout,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_format'] = Variable<String>(dateFormat);
    map['font_family'] = Variable<String>(fontFamily);
    map['stamp_color'] = Variable<String>(stampColor);
    map['stamp_position'] = Variable<String>(stampPosition);
    map['show_in_native_gallery'] = Variable<bool>(showInNativeGallery);
    map['resolution'] = Variable<String>(resolution);
    map['shutter_sound'] = Variable<bool>(shutterSound);
    map['battery_saver'] = Variable<bool>(batterySaver);
    map['exif_strip'] = Variable<bool>(exifStrip);
    map['secure_share_limit'] = Variable<bool>(secureShareLimit);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || signaturePath != null) {
      map['signature_path'] = Variable<String>(signaturePath);
    }
    map['theme_mode'] = Variable<String>(themeMode);
    map['locale'] = Variable<String>(locale);
    map['stamp_layout'] = Variable<String>(stampLayout);
    return map;
  }

  StampConfigsCompanion toCompanion(bool nullToAbsent) {
    return StampConfigsCompanion(
      id: Value(id),
      dateFormat: Value(dateFormat),
      fontFamily: Value(fontFamily),
      stampColor: Value(stampColor),
      stampPosition: Value(stampPosition),
      showInNativeGallery: Value(showInNativeGallery),
      resolution: Value(resolution),
      shutterSound: Value(shutterSound),
      batterySaver: Value(batterySaver),
      exifStrip: Value(exifStrip),
      secureShareLimit: Value(secureShareLimit),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      signaturePath: signaturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(signaturePath),
      themeMode: Value(themeMode),
      locale: Value(locale),
      stampLayout: Value(stampLayout),
    );
  }

  factory StampConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StampConfig(
      id: serializer.fromJson<int>(json['id']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
      stampColor: serializer.fromJson<String>(json['stampColor']),
      stampPosition: serializer.fromJson<String>(json['stampPosition']),
      showInNativeGallery: serializer.fromJson<bool>(
        json['showInNativeGallery'],
      ),
      resolution: serializer.fromJson<String>(json['resolution']),
      shutterSound: serializer.fromJson<bool>(json['shutterSound']),
      batterySaver: serializer.fromJson<bool>(json['batterySaver']),
      exifStrip: serializer.fromJson<bool>(json['exifStrip']),
      secureShareLimit: serializer.fromJson<bool>(json['secureShareLimit']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      signaturePath: serializer.fromJson<String?>(json['signaturePath']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      locale: serializer.fromJson<String>(json['locale']),
      stampLayout: serializer.fromJson<String>(json['stampLayout']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateFormat': serializer.toJson<String>(dateFormat),
      'fontFamily': serializer.toJson<String>(fontFamily),
      'stampColor': serializer.toJson<String>(stampColor),
      'stampPosition': serializer.toJson<String>(stampPosition),
      'showInNativeGallery': serializer.toJson<bool>(showInNativeGallery),
      'resolution': serializer.toJson<String>(resolution),
      'shutterSound': serializer.toJson<bool>(shutterSound),
      'batterySaver': serializer.toJson<bool>(batterySaver),
      'exifStrip': serializer.toJson<bool>(exifStrip),
      'secureShareLimit': serializer.toJson<bool>(secureShareLimit),
      'logoPath': serializer.toJson<String?>(logoPath),
      'signaturePath': serializer.toJson<String?>(signaturePath),
      'themeMode': serializer.toJson<String>(themeMode),
      'locale': serializer.toJson<String>(locale),
      'stampLayout': serializer.toJson<String>(stampLayout),
    };
  }

  StampConfig copyWith({
    int? id,
    String? dateFormat,
    String? fontFamily,
    String? stampColor,
    String? stampPosition,
    bool? showInNativeGallery,
    String? resolution,
    bool? shutterSound,
    bool? batterySaver,
    bool? exifStrip,
    bool? secureShareLimit,
    Value<String?> logoPath = const Value.absent(),
    Value<String?> signaturePath = const Value.absent(),
    String? themeMode,
    String? locale,
    String? stampLayout,
  }) => StampConfig(
    id: id ?? this.id,
    dateFormat: dateFormat ?? this.dateFormat,
    fontFamily: fontFamily ?? this.fontFamily,
    stampColor: stampColor ?? this.stampColor,
    stampPosition: stampPosition ?? this.stampPosition,
    showInNativeGallery: showInNativeGallery ?? this.showInNativeGallery,
    resolution: resolution ?? this.resolution,
    shutterSound: shutterSound ?? this.shutterSound,
    batterySaver: batterySaver ?? this.batterySaver,
    exifStrip: exifStrip ?? this.exifStrip,
    secureShareLimit: secureShareLimit ?? this.secureShareLimit,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    signaturePath: signaturePath.present
        ? signaturePath.value
        : this.signaturePath,
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    stampLayout: stampLayout ?? this.stampLayout,
  );
  StampConfig copyWithCompanion(StampConfigsCompanion data) {
    return StampConfig(
      id: data.id.present ? data.id.value : this.id,
      dateFormat: data.dateFormat.present
          ? data.dateFormat.value
          : this.dateFormat,
      fontFamily: data.fontFamily.present
          ? data.fontFamily.value
          : this.fontFamily,
      stampColor: data.stampColor.present
          ? data.stampColor.value
          : this.stampColor,
      stampPosition: data.stampPosition.present
          ? data.stampPosition.value
          : this.stampPosition,
      showInNativeGallery: data.showInNativeGallery.present
          ? data.showInNativeGallery.value
          : this.showInNativeGallery,
      resolution: data.resolution.present
          ? data.resolution.value
          : this.resolution,
      shutterSound: data.shutterSound.present
          ? data.shutterSound.value
          : this.shutterSound,
      batterySaver: data.batterySaver.present
          ? data.batterySaver.value
          : this.batterySaver,
      exifStrip: data.exifStrip.present ? data.exifStrip.value : this.exifStrip,
      secureShareLimit: data.secureShareLimit.present
          ? data.secureShareLimit.value
          : this.secureShareLimit,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      signaturePath: data.signaturePath.present
          ? data.signaturePath.value
          : this.signaturePath,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      locale: data.locale.present ? data.locale.value : this.locale,
      stampLayout: data.stampLayout.present
          ? data.stampLayout.value
          : this.stampLayout,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StampConfig(')
          ..write('id: $id, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('stampColor: $stampColor, ')
          ..write('stampPosition: $stampPosition, ')
          ..write('showInNativeGallery: $showInNativeGallery, ')
          ..write('resolution: $resolution, ')
          ..write('shutterSound: $shutterSound, ')
          ..write('batterySaver: $batterySaver, ')
          ..write('exifStrip: $exifStrip, ')
          ..write('secureShareLimit: $secureShareLimit, ')
          ..write('logoPath: $logoPath, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('themeMode: $themeMode, ')
          ..write('locale: $locale, ')
          ..write('stampLayout: $stampLayout')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateFormat,
    fontFamily,
    stampColor,
    stampPosition,
    showInNativeGallery,
    resolution,
    shutterSound,
    batterySaver,
    exifStrip,
    secureShareLimit,
    logoPath,
    signaturePath,
    themeMode,
    locale,
    stampLayout,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StampConfig &&
          other.id == this.id &&
          other.dateFormat == this.dateFormat &&
          other.fontFamily == this.fontFamily &&
          other.stampColor == this.stampColor &&
          other.stampPosition == this.stampPosition &&
          other.showInNativeGallery == this.showInNativeGallery &&
          other.resolution == this.resolution &&
          other.shutterSound == this.shutterSound &&
          other.batterySaver == this.batterySaver &&
          other.exifStrip == this.exifStrip &&
          other.secureShareLimit == this.secureShareLimit &&
          other.logoPath == this.logoPath &&
          other.signaturePath == this.signaturePath &&
          other.themeMode == this.themeMode &&
          other.locale == this.locale &&
          other.stampLayout == this.stampLayout);
}

class StampConfigsCompanion extends UpdateCompanion<StampConfig> {
  final Value<int> id;
  final Value<String> dateFormat;
  final Value<String> fontFamily;
  final Value<String> stampColor;
  final Value<String> stampPosition;
  final Value<bool> showInNativeGallery;
  final Value<String> resolution;
  final Value<bool> shutterSound;
  final Value<bool> batterySaver;
  final Value<bool> exifStrip;
  final Value<bool> secureShareLimit;
  final Value<String?> logoPath;
  final Value<String?> signaturePath;
  final Value<String> themeMode;
  final Value<String> locale;
  final Value<String> stampLayout;
  const StampConfigsCompanion({
    this.id = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.stampColor = const Value.absent(),
    this.stampPosition = const Value.absent(),
    this.showInNativeGallery = const Value.absent(),
    this.resolution = const Value.absent(),
    this.shutterSound = const Value.absent(),
    this.batterySaver = const Value.absent(),
    this.exifStrip = const Value.absent(),
    this.secureShareLimit = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.locale = const Value.absent(),
    this.stampLayout = const Value.absent(),
  });
  StampConfigsCompanion.insert({
    this.id = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.stampColor = const Value.absent(),
    this.stampPosition = const Value.absent(),
    this.showInNativeGallery = const Value.absent(),
    this.resolution = const Value.absent(),
    this.shutterSound = const Value.absent(),
    this.batterySaver = const Value.absent(),
    this.exifStrip = const Value.absent(),
    this.secureShareLimit = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.locale = const Value.absent(),
    this.stampLayout = const Value.absent(),
  });
  static Insertable<StampConfig> custom({
    Expression<int>? id,
    Expression<String>? dateFormat,
    Expression<String>? fontFamily,
    Expression<String>? stampColor,
    Expression<String>? stampPosition,
    Expression<bool>? showInNativeGallery,
    Expression<String>? resolution,
    Expression<bool>? shutterSound,
    Expression<bool>? batterySaver,
    Expression<bool>? exifStrip,
    Expression<bool>? secureShareLimit,
    Expression<String>? logoPath,
    Expression<String>? signaturePath,
    Expression<String>? themeMode,
    Expression<String>? locale,
    Expression<String>? stampLayout,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateFormat != null) 'date_format': dateFormat,
      if (fontFamily != null) 'font_family': fontFamily,
      if (stampColor != null) 'stamp_color': stampColor,
      if (stampPosition != null) 'stamp_position': stampPosition,
      if (showInNativeGallery != null)
        'show_in_native_gallery': showInNativeGallery,
      if (resolution != null) 'resolution': resolution,
      if (shutterSound != null) 'shutter_sound': shutterSound,
      if (batterySaver != null) 'battery_saver': batterySaver,
      if (exifStrip != null) 'exif_strip': exifStrip,
      if (secureShareLimit != null) 'secure_share_limit': secureShareLimit,
      if (logoPath != null) 'logo_path': logoPath,
      if (signaturePath != null) 'signature_path': signaturePath,
      if (themeMode != null) 'theme_mode': themeMode,
      if (locale != null) 'locale': locale,
      if (stampLayout != null) 'stamp_layout': stampLayout,
    });
  }

  StampConfigsCompanion copyWith({
    Value<int>? id,
    Value<String>? dateFormat,
    Value<String>? fontFamily,
    Value<String>? stampColor,
    Value<String>? stampPosition,
    Value<bool>? showInNativeGallery,
    Value<String>? resolution,
    Value<bool>? shutterSound,
    Value<bool>? batterySaver,
    Value<bool>? exifStrip,
    Value<bool>? secureShareLimit,
    Value<String?>? logoPath,
    Value<String?>? signaturePath,
    Value<String>? themeMode,
    Value<String>? locale,
    Value<String>? stampLayout,
  }) {
    return StampConfigsCompanion(
      id: id ?? this.id,
      dateFormat: dateFormat ?? this.dateFormat,
      fontFamily: fontFamily ?? this.fontFamily,
      stampColor: stampColor ?? this.stampColor,
      stampPosition: stampPosition ?? this.stampPosition,
      showInNativeGallery: showInNativeGallery ?? this.showInNativeGallery,
      resolution: resolution ?? this.resolution,
      shutterSound: shutterSound ?? this.shutterSound,
      batterySaver: batterySaver ?? this.batterySaver,
      exifStrip: exifStrip ?? this.exifStrip,
      secureShareLimit: secureShareLimit ?? this.secureShareLimit,
      logoPath: logoPath ?? this.logoPath,
      signaturePath: signaturePath ?? this.signaturePath,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      stampLayout: stampLayout ?? this.stampLayout,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (stampColor.present) {
      map['stamp_color'] = Variable<String>(stampColor.value);
    }
    if (stampPosition.present) {
      map['stamp_position'] = Variable<String>(stampPosition.value);
    }
    if (showInNativeGallery.present) {
      map['show_in_native_gallery'] = Variable<bool>(showInNativeGallery.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (shutterSound.present) {
      map['shutter_sound'] = Variable<bool>(shutterSound.value);
    }
    if (batterySaver.present) {
      map['battery_saver'] = Variable<bool>(batterySaver.value);
    }
    if (exifStrip.present) {
      map['exif_strip'] = Variable<bool>(exifStrip.value);
    }
    if (secureShareLimit.present) {
      map['secure_share_limit'] = Variable<bool>(secureShareLimit.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (signaturePath.present) {
      map['signature_path'] = Variable<String>(signaturePath.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (stampLayout.present) {
      map['stamp_layout'] = Variable<String>(stampLayout.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StampConfigsCompanion(')
          ..write('id: $id, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('stampColor: $stampColor, ')
          ..write('stampPosition: $stampPosition, ')
          ..write('showInNativeGallery: $showInNativeGallery, ')
          ..write('resolution: $resolution, ')
          ..write('shutterSound: $shutterSound, ')
          ..write('batterySaver: $batterySaver, ')
          ..write('exifStrip: $exifStrip, ')
          ..write('secureShareLimit: $secureShareLimit, ')
          ..write('logoPath: $logoPath, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('themeMode: $themeMode, ')
          ..write('locale: $locale, ')
          ..write('stampLayout: $stampLayout')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $StampConfigsTable stampConfigs = $StampConfigsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    photos,
    stampConfigs,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> color,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<String> status,
      required String createdAt,
      required String updatedAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> color,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<String> status,
      Value<String> createdAt,
      Value<String> updatedAt,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: $_aliasNameGenerator(db.projects.id, db.photos.projectId),
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool photosRefs})
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
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                color: color,
                startDate: startDate,
                endDate: endDate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                required String createdAt,
                required String updatedAt,
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                color: color,
                startDate: startDate,
                endDate: endDate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({photosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (photosRefs) db.photos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (photosRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable, Photo>(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._photosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProjectsTableReferences(db, table, p0).photosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool photosRefs})
    >;
typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      Value<int?> projectId,
      required String filePath,
      Value<String?> thumbnailPath,
      required String presetType,
      Value<String?> memo,
      Value<String?> tags,
      required String timestamp,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> address,
      Value<bool> isSecure,
      Value<bool> isVideo,
      Value<String?> photoCode,
      Value<String?> weatherInfo,
      Value<String?> photoHash,
      Value<String?> prevHash,
      Value<String?> chainHash,
      Value<bool> ntpSynced,
      required String createdAt,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      Value<int?> projectId,
      Value<String> filePath,
      Value<String?> thumbnailPath,
      Value<String> presetType,
      Value<String?> memo,
      Value<String?> tags,
      Value<String> timestamp,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> address,
      Value<bool> isSecure,
      Value<bool> isVideo,
      Value<String?> photoCode,
      Value<String?> weatherInfo,
      Value<String?> photoHash,
      Value<String?> prevHash,
      Value<String?> chainHash,
      Value<bool> ntpSynced,
      Value<String> createdAt,
    });

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, Photo> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.photos.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<int>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
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

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presetType => $composableBuilder(
    column: $table.presetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSecure => $composableBuilder(
    column: $table.isSecure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoCode => $composableBuilder(
    column: $table.photoCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weatherInfo => $composableBuilder(
    column: $table.weatherInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoHash => $composableBuilder(
    column: $table.photoHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chainHash => $composableBuilder(
    column: $table.chainHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ntpSynced => $composableBuilder(
    column: $table.ntpSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
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

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presetType => $composableBuilder(
    column: $table.presetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSecure => $composableBuilder(
    column: $table.isSecure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoCode => $composableBuilder(
    column: $table.photoCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weatherInfo => $composableBuilder(
    column: $table.weatherInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoHash => $composableBuilder(
    column: $table.photoHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chainHash => $composableBuilder(
    column: $table.chainHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ntpSynced => $composableBuilder(
    column: $table.ntpSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get presetType => $composableBuilder(
    column: $table.presetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isSecure =>
      $composableBuilder(column: $table.isSecure, builder: (column) => column);

  GeneratedColumn<bool> get isVideo =>
      $composableBuilder(column: $table.isVideo, builder: (column) => column);

  GeneratedColumn<String> get photoCode =>
      $composableBuilder(column: $table.photoCode, builder: (column) => column);

  GeneratedColumn<String> get weatherInfo => $composableBuilder(
    column: $table.weatherInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoHash =>
      $composableBuilder(column: $table.photoHash, builder: (column) => column);

  GeneratedColumn<String> get prevHash =>
      $composableBuilder(column: $table.prevHash, builder: (column) => column);

  GeneratedColumn<String> get chainHash =>
      $composableBuilder(column: $table.chainHash, builder: (column) => column);

  GeneratedColumn<bool> get ntpSynced =>
      $composableBuilder(column: $table.ntpSynced, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, $$PhotosTableReferences),
          Photo,
          PrefetchHooks Function({bool projectId})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String> presetType = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> isSecure = const Value.absent(),
                Value<bool> isVideo = const Value.absent(),
                Value<String?> photoCode = const Value.absent(),
                Value<String?> weatherInfo = const Value.absent(),
                Value<String?> photoHash = const Value.absent(),
                Value<String?> prevHash = const Value.absent(),
                Value<String?> chainHash = const Value.absent(),
                Value<bool> ntpSynced = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                projectId: projectId,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                presetType: presetType,
                memo: memo,
                tags: tags,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                address: address,
                isSecure: isSecure,
                isVideo: isVideo,
                photoCode: photoCode,
                weatherInfo: weatherInfo,
                photoHash: photoHash,
                prevHash: prevHash,
                chainHash: chainHash,
                ntpSynced: ntpSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> projectId = const Value.absent(),
                required String filePath,
                Value<String?> thumbnailPath = const Value.absent(),
                required String presetType,
                Value<String?> memo = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                required String timestamp,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<bool> isSecure = const Value.absent(),
                Value<bool> isVideo = const Value.absent(),
                Value<String?> photoCode = const Value.absent(),
                Value<String?> weatherInfo = const Value.absent(),
                Value<String?> photoHash = const Value.absent(),
                Value<String?> prevHash = const Value.absent(),
                Value<String?> chainHash = const Value.absent(),
                Value<bool> ntpSynced = const Value.absent(),
                required String createdAt,
              }) => PhotosCompanion.insert(
                id: id,
                projectId: projectId,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                presetType: presetType,
                memo: memo,
                tags: tags,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                address: address,
                isSecure: isSecure,
                isVideo: isVideo,
                photoCode: photoCode,
                weatherInfo: weatherInfo,
                photoHash: photoHash,
                prevHash: prevHash,
                chainHash: chainHash,
                ntpSynced: ntpSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PhotosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$PhotosTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$PhotosTableReferences
                                    ._projectIdTable(db)
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

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, $$PhotosTableReferences),
      Photo,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$StampConfigsTableCreateCompanionBuilder =
    StampConfigsCompanion Function({
      Value<int> id,
      Value<String> dateFormat,
      Value<String> fontFamily,
      Value<String> stampColor,
      Value<String> stampPosition,
      Value<bool> showInNativeGallery,
      Value<String> resolution,
      Value<bool> shutterSound,
      Value<bool> batterySaver,
      Value<bool> exifStrip,
      Value<bool> secureShareLimit,
      Value<String?> logoPath,
      Value<String?> signaturePath,
      Value<String> themeMode,
      Value<String> locale,
      Value<String> stampLayout,
    });
typedef $$StampConfigsTableUpdateCompanionBuilder =
    StampConfigsCompanion Function({
      Value<int> id,
      Value<String> dateFormat,
      Value<String> fontFamily,
      Value<String> stampColor,
      Value<String> stampPosition,
      Value<bool> showInNativeGallery,
      Value<String> resolution,
      Value<bool> shutterSound,
      Value<bool> batterySaver,
      Value<bool> exifStrip,
      Value<bool> secureShareLimit,
      Value<String?> logoPath,
      Value<String?> signaturePath,
      Value<String> themeMode,
      Value<String> locale,
      Value<String> stampLayout,
    });

class $$StampConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $StampConfigsTable> {
  $$StampConfigsTableFilterComposer({
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

  ColumnFilters<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stampColor => $composableBuilder(
    column: $table.stampColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stampPosition => $composableBuilder(
    column: $table.stampPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInNativeGallery => $composableBuilder(
    column: $table.showInNativeGallery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get shutterSound => $composableBuilder(
    column: $table.shutterSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get batterySaver => $composableBuilder(
    column: $table.batterySaver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get exifStrip => $composableBuilder(
    column: $table.exifStrip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get secureShareLimit => $composableBuilder(
    column: $table.secureShareLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stampLayout => $composableBuilder(
    column: $table.stampLayout,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StampConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $StampConfigsTable> {
  $$StampConfigsTableOrderingComposer({
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

  ColumnOrderings<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stampColor => $composableBuilder(
    column: $table.stampColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stampPosition => $composableBuilder(
    column: $table.stampPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInNativeGallery => $composableBuilder(
    column: $table.showInNativeGallery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shutterSound => $composableBuilder(
    column: $table.shutterSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get batterySaver => $composableBuilder(
    column: $table.batterySaver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get exifStrip => $composableBuilder(
    column: $table.exifStrip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get secureShareLimit => $composableBuilder(
    column: $table.secureShareLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stampLayout => $composableBuilder(
    column: $table.stampLayout,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StampConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StampConfigsTable> {
  $$StampConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stampColor => $composableBuilder(
    column: $table.stampColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stampPosition => $composableBuilder(
    column: $table.stampPosition,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showInNativeGallery => $composableBuilder(
    column: $table.showInNativeGallery,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolution => $composableBuilder(
    column: $table.resolution,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get shutterSound => $composableBuilder(
    column: $table.shutterSound,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get batterySaver => $composableBuilder(
    column: $table.batterySaver,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get exifStrip =>
      $composableBuilder(column: $table.exifStrip, builder: (column) => column);

  GeneratedColumn<bool> get secureShareLimit => $composableBuilder(
    column: $table.secureShareLimit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get signaturePath => $composableBuilder(
    column: $table.signaturePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get stampLayout => $composableBuilder(
    column: $table.stampLayout,
    builder: (column) => column,
  );
}

class $$StampConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StampConfigsTable,
          StampConfig,
          $$StampConfigsTableFilterComposer,
          $$StampConfigsTableOrderingComposer,
          $$StampConfigsTableAnnotationComposer,
          $$StampConfigsTableCreateCompanionBuilder,
          $$StampConfigsTableUpdateCompanionBuilder,
          (
            StampConfig,
            BaseReferences<_$AppDatabase, $StampConfigsTable, StampConfig>,
          ),
          StampConfig,
          PrefetchHooks Function()
        > {
  $$StampConfigsTableTableManager(_$AppDatabase db, $StampConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StampConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StampConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StampConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<String> stampColor = const Value.absent(),
                Value<String> stampPosition = const Value.absent(),
                Value<bool> showInNativeGallery = const Value.absent(),
                Value<String> resolution = const Value.absent(),
                Value<bool> shutterSound = const Value.absent(),
                Value<bool> batterySaver = const Value.absent(),
                Value<bool> exifStrip = const Value.absent(),
                Value<bool> secureShareLimit = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> signaturePath = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> stampLayout = const Value.absent(),
              }) => StampConfigsCompanion(
                id: id,
                dateFormat: dateFormat,
                fontFamily: fontFamily,
                stampColor: stampColor,
                stampPosition: stampPosition,
                showInNativeGallery: showInNativeGallery,
                resolution: resolution,
                shutterSound: shutterSound,
                batterySaver: batterySaver,
                exifStrip: exifStrip,
                secureShareLimit: secureShareLimit,
                logoPath: logoPath,
                signaturePath: signaturePath,
                themeMode: themeMode,
                locale: locale,
                stampLayout: stampLayout,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<String> stampColor = const Value.absent(),
                Value<String> stampPosition = const Value.absent(),
                Value<bool> showInNativeGallery = const Value.absent(),
                Value<String> resolution = const Value.absent(),
                Value<bool> shutterSound = const Value.absent(),
                Value<bool> batterySaver = const Value.absent(),
                Value<bool> exifStrip = const Value.absent(),
                Value<bool> secureShareLimit = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> signaturePath = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> stampLayout = const Value.absent(),
              }) => StampConfigsCompanion.insert(
                id: id,
                dateFormat: dateFormat,
                fontFamily: fontFamily,
                stampColor: stampColor,
                stampPosition: stampPosition,
                showInNativeGallery: showInNativeGallery,
                resolution: resolution,
                shutterSound: shutterSound,
                batterySaver: batterySaver,
                exifStrip: exifStrip,
                secureShareLimit: secureShareLimit,
                logoPath: logoPath,
                signaturePath: signaturePath,
                themeMode: themeMode,
                locale: locale,
                stampLayout: stampLayout,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StampConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StampConfigsTable,
      StampConfig,
      $$StampConfigsTableFilterComposer,
      $$StampConfigsTableOrderingComposer,
      $$StampConfigsTableAnnotationComposer,
      $$StampConfigsTableCreateCompanionBuilder,
      $$StampConfigsTableUpdateCompanionBuilder,
      (
        StampConfig,
        BaseReferences<_$AppDatabase, $StampConfigsTable, StampConfig>,
      ),
      StampConfig,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$StampConfigsTableTableManager get stampConfigs =>
      $$StampConfigsTableTableManager(_db, _db.stampConfigs);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTableTable extends StudentsTable
    with TableInfo<$StudentsTableTable, StudentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fcmTokenMeta = const VerificationMeta(
    'fcmToken',
  );
  @override
  late final GeneratedColumn<String> fcmToken = GeneratedColumn<String>(
    'fcm_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _deactivatedAtMeta = const VerificationMeta(
    'deactivatedAt',
  );
  @override
  late final GeneratedColumn<String> deactivatedAt = GeneratedColumn<String>(
    'deactivated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastActiveAtMeta = const VerificationMeta(
    'lastActiveAt',
  );
  @override
  late final GeneratedColumn<String> lastActiveAt = GeneratedColumn<String>(
    'last_active_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    name,
    email,
    district,
    school,
    fcmToken,
    notificationsEnabled,
    deactivatedAt,
    deletedAt,
    lastActiveAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentsTableData> instance, {
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    } else if (isInserting) {
      context.missing(_districtMeta);
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolMeta);
    }
    if (data.containsKey('fcm_token')) {
      context.handle(
        _fcmTokenMeta,
        fcmToken.isAcceptableOrUnknown(data['fcm_token']!, _fcmTokenMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('deactivated_at')) {
      context.handle(
        _deactivatedAtMeta,
        deactivatedAt.isAcceptableOrUnknown(
          data['deactivated_at']!,
          _deactivatedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('last_active_at')) {
      context.handle(
        _lastActiveAtMeta,
        lastActiveAt.isAcceptableOrUnknown(
          data['last_active_at']!,
          _lastActiveAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastActiveAtMeta);
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
  StudentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      )!,
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      )!,
      fcmToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fcm_token'],
      ),
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      deactivatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deactivated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      ),
      lastActiveAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_active_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudentsTableTable createAlias(String alias) {
    return $StudentsTableTable(attachedDatabase, alias);
  }
}

class StudentsTableData extends DataClass
    implements Insertable<StudentsTableData> {
  final String id;
  final String name;
  final String email;
  final String district;
  final String school;
  final String? fcmToken;
  final bool notificationsEnabled;
  final String? deactivatedAt;
  final String? deletedAt;
  final String lastActiveAt;
  final String createdAt;
  const StudentsTableData({
    required this.id,
    required this.name,
    required this.email,
    required this.district,
    required this.school,
    this.fcmToken,
    required this.notificationsEnabled,
    this.deactivatedAt,
    this.deletedAt,
    required this.lastActiveAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['district'] = Variable<String>(district);
    map['school'] = Variable<String>(school);
    if (!nullToAbsent || fcmToken != null) {
      map['fcm_token'] = Variable<String>(fcmToken);
    }
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    if (!nullToAbsent || deactivatedAt != null) {
      map['deactivated_at'] = Variable<String>(deactivatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<String>(deletedAt);
    }
    map['last_active_at'] = Variable<String>(lastActiveAt);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  StudentsTableCompanion toCompanion(bool nullToAbsent) {
    return StudentsTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      district: Value(district),
      school: Value(school),
      fcmToken: fcmToken == null && nullToAbsent
          ? const Value.absent()
          : Value(fcmToken),
      notificationsEnabled: Value(notificationsEnabled),
      deactivatedAt: deactivatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deactivatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastActiveAt: Value(lastActiveAt),
      createdAt: Value(createdAt),
    );
  }

  factory StudentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      district: serializer.fromJson<String>(json['district']),
      school: serializer.fromJson<String>(json['school']),
      fcmToken: serializer.fromJson<String?>(json['fcmToken']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      deactivatedAt: serializer.fromJson<String?>(json['deactivatedAt']),
      deletedAt: serializer.fromJson<String?>(json['deletedAt']),
      lastActiveAt: serializer.fromJson<String>(json['lastActiveAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'district': serializer.toJson<String>(district),
      'school': serializer.toJson<String>(school),
      'fcmToken': serializer.toJson<String?>(fcmToken),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'deactivatedAt': serializer.toJson<String?>(deactivatedAt),
      'deletedAt': serializer.toJson<String?>(deletedAt),
      'lastActiveAt': serializer.toJson<String>(lastActiveAt),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  StudentsTableData copyWith({
    String? id,
    String? name,
    String? email,
    String? district,
    String? school,
    Value<String?> fcmToken = const Value.absent(),
    bool? notificationsEnabled,
    Value<String?> deactivatedAt = const Value.absent(),
    Value<String?> deletedAt = const Value.absent(),
    String? lastActiveAt,
    String? createdAt,
  }) => StudentsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    district: district ?? this.district,
    school: school ?? this.school,
    fcmToken: fcmToken.present ? fcmToken.value : this.fcmToken,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    deactivatedAt: deactivatedAt.present
        ? deactivatedAt.value
        : this.deactivatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    createdAt: createdAt ?? this.createdAt,
  );
  StudentsTableData copyWithCompanion(StudentsTableCompanion data) {
    return StudentsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      district: data.district.present ? data.district.value : this.district,
      school: data.school.present ? data.school.value : this.school,
      fcmToken: data.fcmToken.present ? data.fcmToken.value : this.fcmToken,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      deactivatedAt: data.deactivatedAt.present
          ? data.deactivatedAt.value
          : this.deactivatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastActiveAt: data.lastActiveAt.present
          ? data.lastActiveAt.value
          : this.lastActiveAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('district: $district, ')
          ..write('school: $school, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('deactivatedAt: $deactivatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastActiveAt: $lastActiveAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    district,
    school,
    fcmToken,
    notificationsEnabled,
    deactivatedAt,
    deletedAt,
    lastActiveAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.district == this.district &&
          other.school == this.school &&
          other.fcmToken == this.fcmToken &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.deactivatedAt == this.deactivatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastActiveAt == this.lastActiveAt &&
          other.createdAt == this.createdAt);
}

class StudentsTableCompanion extends UpdateCompanion<StudentsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> district;
  final Value<String> school;
  final Value<String?> fcmToken;
  final Value<bool> notificationsEnabled;
  final Value<String?> deactivatedAt;
  final Value<String?> deletedAt;
  final Value<String> lastActiveAt;
  final Value<String> createdAt;
  final Value<int> rowid;
  const StudentsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.district = const Value.absent(),
    this.school = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.deactivatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastActiveAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsTableCompanion.insert({
    required String id,
    required String name,
    required String email,
    required String district,
    required String school,
    this.fcmToken = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.deactivatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String lastActiveAt,
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       district = Value(district),
       school = Value(school),
       lastActiveAt = Value(lastActiveAt),
       createdAt = Value(createdAt);
  static Insertable<StudentsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? district,
    Expression<String>? school,
    Expression<String>? fcmToken,
    Expression<bool>? notificationsEnabled,
    Expression<String>? deactivatedAt,
    Expression<String>? deletedAt,
    Expression<String>? lastActiveAt,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (district != null) 'district': district,
      if (school != null) 'school': school,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (deactivatedAt != null) 'deactivated_at': deactivatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastActiveAt != null) 'last_active_at': lastActiveAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? district,
    Value<String>? school,
    Value<String?>? fcmToken,
    Value<bool>? notificationsEnabled,
    Value<String?>? deactivatedAt,
    Value<String?>? deletedAt,
    Value<String>? lastActiveAt,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return StudentsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      district: district ?? this.district,
      school: school ?? this.school,
      fcmToken: fcmToken ?? this.fcmToken,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      deactivatedAt: deactivatedAt ?? this.deactivatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (fcmToken.present) {
      map['fcm_token'] = Variable<String>(fcmToken.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (deactivatedAt.present) {
      map['deactivated_at'] = Variable<String>(deactivatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (lastActiveAt.present) {
      map['last_active_at'] = Variable<String>(lastActiveAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('district: $district, ')
          ..write('school: $school, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('deactivatedAt: $deactivatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastActiveAt: $lastActiveAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTableTable extends SubjectsTable
    with TableInfo<$SubjectsTableTable, SubjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _quizPassThresholdMeta = const VerificationMeta(
    'quizPassThreshold',
  );
  @override
  late final GeneratedColumn<double> quizPassThreshold =
      GeneratedColumn<double>(
        'quiz_pass_threshold',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.8),
      );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    quizPassThreshold,
    contentVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubjectsTableData> instance, {
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
    if (data.containsKey('quiz_pass_threshold')) {
      context.handle(
        _quizPassThresholdMeta,
        quizPassThreshold.isAcceptableOrUnknown(
          data['quiz_pass_threshold']!,
          _quizPassThresholdMeta,
        ),
      );
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quizPassThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quiz_pass_threshold'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
    );
  }

  @override
  $SubjectsTableTable createAlias(String alias) {
    return $SubjectsTableTable(attachedDatabase, alias);
  }
}

class SubjectsTableData extends DataClass
    implements Insertable<SubjectsTableData> {
  final String id;
  final String name;
  final double quizPassThreshold;
  final int contentVersion;
  const SubjectsTableData({
    required this.id,
    required this.name,
    required this.quizPassThreshold,
    required this.contentVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['quiz_pass_threshold'] = Variable<double>(quizPassThreshold);
    map['content_version'] = Variable<int>(contentVersion);
    return map;
  }

  SubjectsTableCompanion toCompanion(bool nullToAbsent) {
    return SubjectsTableCompanion(
      id: Value(id),
      name: Value(name),
      quizPassThreshold: Value(quizPassThreshold),
      contentVersion: Value(contentVersion),
    );
  }

  factory SubjectsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      quizPassThreshold: serializer.fromJson<double>(json['quizPassThreshold']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'quizPassThreshold': serializer.toJson<double>(quizPassThreshold),
      'contentVersion': serializer.toJson<int>(contentVersion),
    };
  }

  SubjectsTableData copyWith({
    String? id,
    String? name,
    double? quizPassThreshold,
    int? contentVersion,
  }) => SubjectsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    quizPassThreshold: quizPassThreshold ?? this.quizPassThreshold,
    contentVersion: contentVersion ?? this.contentVersion,
  );
  SubjectsTableData copyWithCompanion(SubjectsTableCompanion data) {
    return SubjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      quizPassThreshold: data.quizPassThreshold.present
          ? data.quizPassThreshold.value
          : this.quizPassThreshold,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quizPassThreshold: $quizPassThreshold, ')
          ..write('contentVersion: $contentVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, quizPassThreshold, contentVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.quizPassThreshold == this.quizPassThreshold &&
          other.contentVersion == this.contentVersion);
}

class SubjectsTableCompanion extends UpdateCompanion<SubjectsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> quizPassThreshold;
  final Value<int> contentVersion;
  final Value<int> rowid;
  const SubjectsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.quizPassThreshold = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsTableCompanion.insert({
    required String id,
    required String name,
    this.quizPassThreshold = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<SubjectsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? quizPassThreshold,
    Expression<int>? contentVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (quizPassThreshold != null) 'quiz_pass_threshold': quizPassThreshold,
      if (contentVersion != null) 'content_version': contentVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? quizPassThreshold,
    Value<int>? contentVersion,
    Value<int>? rowid,
  }) {
    return SubjectsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      quizPassThreshold: quizPassThreshold ?? this.quizPassThreshold,
      contentVersion: contentVersion ?? this.contentVersion,
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
    if (quizPassThreshold.present) {
      map['quiz_pass_threshold'] = Variable<double>(quizPassThreshold.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quizPassThreshold: $quizPassThreshold, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TopicsTableTable extends TopicsTable
    with TableInfo<$TopicsTableTable, TopicsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
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
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, subjectId, title, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(
    Insertable<TopicsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TopicsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TopicsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $TopicsTableTable createAlias(String alias) {
    return $TopicsTableTable(attachedDatabase, alias);
  }
}

class TopicsTableData extends DataClass implements Insertable<TopicsTableData> {
  final String id;
  final String subjectId;
  final String title;
  final int orderIndex;
  const TopicsTableData({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  TopicsTableCompanion toCompanion(bool nullToAbsent) {
    return TopicsTableCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      title: Value(title),
      orderIndex: Value(orderIndex),
    );
  }

  factory TopicsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TopicsTableData(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  TopicsTableData copyWith({
    String? id,
    String? subjectId,
    String? title,
    int? orderIndex,
  }) => TopicsTableData(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  TopicsTableData copyWithCompanion(TopicsTableCompanion data) {
    return TopicsTableData(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TopicsTableData(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subjectId, title, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TopicsTableData &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex);
}

class TopicsTableCompanion extends UpdateCompanion<TopicsTableData> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> title;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const TopicsTableCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsTableCompanion.insert({
    required String id,
    required String subjectId,
    required String title,
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       title = Value(title);
  static Insertable<TopicsTableData> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? title,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? title,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return TopicsTableCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsTableCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonsTableTable extends LessonsTable
    with TableInfo<$LessonsTableTable, LessonsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
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
  static const VerificationMeta _contentTextMeta = const VerificationMeta(
    'contentText',
  );
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
    'content_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTrackMeta = const VerificationMeta(
    'contentTrack',
  );
  @override
  late final GeneratedColumn<String> contentTrack = GeneratedColumn<String>(
    'content_track',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topicId,
    title,
    contentText,
    contentTrack,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
        _contentTextMeta,
        contentText.isAcceptableOrUnknown(
          data['content_text']!,
          _contentTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    if (data.containsKey('content_track')) {
      context.handle(
        _contentTrackMeta,
        contentTrack.isAcceptableOrUnknown(
          data['content_track']!,
          _contentTrackMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTrackMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_text'],
      )!,
      contentTrack: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_track'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $LessonsTableTable createAlias(String alias) {
    return $LessonsTableTable(attachedDatabase, alias);
  }
}

class LessonsTableData extends DataClass
    implements Insertable<LessonsTableData> {
  final String id;
  final String topicId;
  final String title;
  final String contentText;
  final String contentTrack;
  final int orderIndex;
  const LessonsTableData({
    required this.id,
    required this.topicId,
    required this.title,
    required this.contentText,
    required this.contentTrack,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['title'] = Variable<String>(title);
    map['content_text'] = Variable<String>(contentText);
    map['content_track'] = Variable<String>(contentTrack);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  LessonsTableCompanion toCompanion(bool nullToAbsent) {
    return LessonsTableCompanion(
      id: Value(id),
      topicId: Value(topicId),
      title: Value(title),
      contentText: Value(contentText),
      contentTrack: Value(contentTrack),
      orderIndex: Value(orderIndex),
    );
  }

  factory LessonsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonsTableData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      title: serializer.fromJson<String>(json['title']),
      contentText: serializer.fromJson<String>(json['contentText']),
      contentTrack: serializer.fromJson<String>(json['contentTrack']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'title': serializer.toJson<String>(title),
      'contentText': serializer.toJson<String>(contentText),
      'contentTrack': serializer.toJson<String>(contentTrack),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  LessonsTableData copyWith({
    String? id,
    String? topicId,
    String? title,
    String? contentText,
    String? contentTrack,
    int? orderIndex,
  }) => LessonsTableData(
    id: id ?? this.id,
    topicId: topicId ?? this.topicId,
    title: title ?? this.title,
    contentText: contentText ?? this.contentText,
    contentTrack: contentTrack ?? this.contentTrack,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  LessonsTableData copyWithCompanion(LessonsTableCompanion data) {
    return LessonsTableData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      title: data.title.present ? data.title.value : this.title,
      contentText: data.contentText.present
          ? data.contentText.value
          : this.contentText,
      contentTrack: data.contentTrack.present
          ? data.contentTrack.value
          : this.contentTrack,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('contentText: $contentText, ')
          ..write('contentTrack: $contentTrack, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, topicId, title, contentText, contentTrack, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonsTableData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.title == this.title &&
          other.contentText == this.contentText &&
          other.contentTrack == this.contentTrack &&
          other.orderIndex == this.orderIndex);
}

class LessonsTableCompanion extends UpdateCompanion<LessonsTableData> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<String> title;
  final Value<String> contentText;
  final Value<String> contentTrack;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const LessonsTableCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentText = const Value.absent(),
    this.contentTrack = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsTableCompanion.insert({
    required String id,
    required String topicId,
    required String title,
    required String contentText,
    required String contentTrack,
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       topicId = Value(topicId),
       title = Value(title),
       contentText = Value(contentText),
       contentTrack = Value(contentTrack);
  static Insertable<LessonsTableData> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<String>? title,
    Expression<String>? contentText,
    Expression<String>? contentTrack,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (title != null) 'title': title,
      if (contentText != null) 'content_text': contentText,
      if (contentTrack != null) 'content_track': contentTrack,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? topicId,
    Value<String>? title,
    Value<String>? contentText,
    Value<String>? contentTrack,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return LessonsTableCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      contentText: contentText ?? this.contentText,
      contentTrack: contentTrack ?? this.contentTrack,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (contentTrack.present) {
      map['content_track'] = Variable<String>(contentTrack.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsTableCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('contentText: $contentText, ')
          ..write('contentTrack: $contentTrack, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonTasksTableTable extends LessonTasksTable
    with TableInfo<$LessonTasksTableTable, LessonTasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonTasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskStatusMeta = const VerificationMeta(
    'taskStatus',
  );
  @override
  late final GeneratedColumn<String> taskStatus = GeneratedColumn<String>(
    'task_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('backlog'),
  );
  static const VerificationMeta _curiosityCompletedMeta =
      const VerificationMeta('curiosityCompleted');
  @override
  late final GeneratedColumn<bool> curiosityCompleted = GeneratedColumn<bool>(
    'curiosity_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("curiosity_completed" IN (0, 1))',
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
    studentId,
    lessonId,
    taskStatus,
    curiosityCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonTasksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('task_status')) {
      context.handle(
        _taskStatusMeta,
        taskStatus.isAcceptableOrUnknown(data['task_status']!, _taskStatusMeta),
      );
    }
    if (data.containsKey('curiosity_completed')) {
      context.handle(
        _curiosityCompletedMeta,
        curiosityCompleted.isAcceptableOrUnknown(
          data['curiosity_completed']!,
          _curiosityCompletedMeta,
        ),
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
  LessonTasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonTasksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      taskStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_status'],
      )!,
      curiosityCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}curiosity_completed'],
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
  $LessonTasksTableTable createAlias(String alias) {
    return $LessonTasksTableTable(attachedDatabase, alias);
  }
}

class LessonTasksTableData extends DataClass
    implements Insertable<LessonTasksTableData> {
  final String id;
  final String studentId;
  final String lessonId;
  final String taskStatus;
  final bool curiosityCompleted;
  final String createdAt;
  final String updatedAt;
  const LessonTasksTableData({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.taskStatus,
    required this.curiosityCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['task_status'] = Variable<String>(taskStatus);
    map['curiosity_completed'] = Variable<bool>(curiosityCompleted);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  LessonTasksTableCompanion toCompanion(bool nullToAbsent) {
    return LessonTasksTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      lessonId: Value(lessonId),
      taskStatus: Value(taskStatus),
      curiosityCompleted: Value(curiosityCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LessonTasksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonTasksTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      taskStatus: serializer.fromJson<String>(json['taskStatus']),
      curiosityCompleted: serializer.fromJson<bool>(json['curiosityCompleted']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'lessonId': serializer.toJson<String>(lessonId),
      'taskStatus': serializer.toJson<String>(taskStatus),
      'curiosityCompleted': serializer.toJson<bool>(curiosityCompleted),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  LessonTasksTableData copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    String? taskStatus,
    bool? curiosityCompleted,
    String? createdAt,
    String? updatedAt,
  }) => LessonTasksTableData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
    taskStatus: taskStatus ?? this.taskStatus,
    curiosityCompleted: curiosityCompleted ?? this.curiosityCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LessonTasksTableData copyWithCompanion(LessonTasksTableCompanion data) {
    return LessonTasksTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      taskStatus: data.taskStatus.present
          ? data.taskStatus.value
          : this.taskStatus,
      curiosityCompleted: data.curiosityCompleted.present
          ? data.curiosityCompleted.value
          : this.curiosityCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonTasksTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('taskStatus: $taskStatus, ')
          ..write('curiosityCompleted: $curiosityCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    lessonId,
    taskStatus,
    curiosityCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonTasksTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId &&
          other.taskStatus == this.taskStatus &&
          other.curiosityCompleted == this.curiosityCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LessonTasksTableCompanion extends UpdateCompanion<LessonTasksTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> lessonId;
  final Value<String> taskStatus;
  final Value<bool> curiosityCompleted;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const LessonTasksTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.taskStatus = const Value.absent(),
    this.curiosityCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonTasksTableCompanion.insert({
    required String id,
    required String studentId,
    required String lessonId,
    this.taskStatus = const Value.absent(),
    this.curiosityCompleted = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       lessonId = Value(lessonId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LessonTasksTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? lessonId,
    Expression<String>? taskStatus,
    Expression<bool>? curiosityCompleted,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (taskStatus != null) 'task_status': taskStatus,
      if (curiosityCompleted != null) 'curiosity_completed': curiosityCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonTasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? lessonId,
    Value<String>? taskStatus,
    Value<bool>? curiosityCompleted,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return LessonTasksTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      taskStatus: taskStatus ?? this.taskStatus,
      curiosityCompleted: curiosityCompleted ?? this.curiosityCompleted,
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
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (taskStatus.present) {
      map['task_status'] = Variable<String>(taskStatus.value);
    }
    if (curiosityCompleted.present) {
      map['curiosity_completed'] = Variable<bool>(curiosityCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonTasksTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('taskStatus: $taskStatus, ')
          ..write('curiosityCompleted: $curiosityCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizQuestionsTableTable extends QuizQuestionsTable
    with TableInfo<$QuizQuestionsTableTable, QuizQuestionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizQuestionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionAMeta = const VerificationMeta(
    'optionA',
  );
  @override
  late final GeneratedColumn<String> optionA = GeneratedColumn<String>(
    'option_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionBMeta = const VerificationMeta(
    'optionB',
  );
  @override
  late final GeneratedColumn<String> optionB = GeneratedColumn<String>(
    'option_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionCMeta = const VerificationMeta(
    'optionC',
  );
  @override
  late final GeneratedColumn<String> optionC = GeneratedColumn<String>(
    'option_c',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionDMeta = const VerificationMeta(
    'optionD',
  );
  @override
  late final GeneratedColumn<String> optionD = GeneratedColumn<String>(
    'option_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctOptionMeta = const VerificationMeta(
    'correctOption',
  );
  @override
  late final GeneratedColumn<String> correctOption = GeneratedColumn<String>(
    'correct_option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    questionText,
    optionA,
    optionB,
    optionC,
    optionD,
    correctOption,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizQuestionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('option_a')) {
      context.handle(
        _optionAMeta,
        optionA.isAcceptableOrUnknown(data['option_a']!, _optionAMeta),
      );
    } else if (isInserting) {
      context.missing(_optionAMeta);
    }
    if (data.containsKey('option_b')) {
      context.handle(
        _optionBMeta,
        optionB.isAcceptableOrUnknown(data['option_b']!, _optionBMeta),
      );
    } else if (isInserting) {
      context.missing(_optionBMeta);
    }
    if (data.containsKey('option_c')) {
      context.handle(
        _optionCMeta,
        optionC.isAcceptableOrUnknown(data['option_c']!, _optionCMeta),
      );
    } else if (isInserting) {
      context.missing(_optionCMeta);
    }
    if (data.containsKey('option_d')) {
      context.handle(
        _optionDMeta,
        optionD.isAcceptableOrUnknown(data['option_d']!, _optionDMeta),
      );
    } else if (isInserting) {
      context.missing(_optionDMeta);
    }
    if (data.containsKey('correct_option')) {
      context.handle(
        _correctOptionMeta,
        correctOption.isAcceptableOrUnknown(
          data['correct_option']!,
          _correctOptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctOptionMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizQuestionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizQuestionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      optionA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_a'],
      )!,
      optionB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_b'],
      )!,
      optionC: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_c'],
      )!,
      optionD: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_d'],
      )!,
      correctOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_option'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $QuizQuestionsTableTable createAlias(String alias) {
    return $QuizQuestionsTableTable(attachedDatabase, alias);
  }
}

class QuizQuestionsTableData extends DataClass
    implements Insertable<QuizQuestionsTableData> {
  final String id;
  final String lessonId;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final int orderIndex;
  const QuizQuestionsTableData({
    required this.id,
    required this.lessonId,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['question_text'] = Variable<String>(questionText);
    map['option_a'] = Variable<String>(optionA);
    map['option_b'] = Variable<String>(optionB);
    map['option_c'] = Variable<String>(optionC);
    map['option_d'] = Variable<String>(optionD);
    map['correct_option'] = Variable<String>(correctOption);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  QuizQuestionsTableCompanion toCompanion(bool nullToAbsent) {
    return QuizQuestionsTableCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      questionText: Value(questionText),
      optionA: Value(optionA),
      optionB: Value(optionB),
      optionC: Value(optionC),
      optionD: Value(optionD),
      correctOption: Value(correctOption),
      orderIndex: Value(orderIndex),
    );
  }

  factory QuizQuestionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizQuestionsTableData(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      questionText: serializer.fromJson<String>(json['questionText']),
      optionA: serializer.fromJson<String>(json['optionA']),
      optionB: serializer.fromJson<String>(json['optionB']),
      optionC: serializer.fromJson<String>(json['optionC']),
      optionD: serializer.fromJson<String>(json['optionD']),
      correctOption: serializer.fromJson<String>(json['correctOption']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'questionText': serializer.toJson<String>(questionText),
      'optionA': serializer.toJson<String>(optionA),
      'optionB': serializer.toJson<String>(optionB),
      'optionC': serializer.toJson<String>(optionC),
      'optionD': serializer.toJson<String>(optionD),
      'correctOption': serializer.toJson<String>(correctOption),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  QuizQuestionsTableData copyWith({
    String? id,
    String? lessonId,
    String? questionText,
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    String? correctOption,
    int? orderIndex,
  }) => QuizQuestionsTableData(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    questionText: questionText ?? this.questionText,
    optionA: optionA ?? this.optionA,
    optionB: optionB ?? this.optionB,
    optionC: optionC ?? this.optionC,
    optionD: optionD ?? this.optionD,
    correctOption: correctOption ?? this.correctOption,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  QuizQuestionsTableData copyWithCompanion(QuizQuestionsTableCompanion data) {
    return QuizQuestionsTableData(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      optionA: data.optionA.present ? data.optionA.value : this.optionA,
      optionB: data.optionB.present ? data.optionB.value : this.optionB,
      optionC: data.optionC.present ? data.optionC.value : this.optionC,
      optionD: data.optionD.present ? data.optionD.value : this.optionD,
      correctOption: data.correctOption.present
          ? data.correctOption.value
          : this.correctOption,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionsTableData(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('questionText: $questionText, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctOption: $correctOption, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lessonId,
    questionText,
    optionA,
    optionB,
    optionC,
    optionD,
    correctOption,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizQuestionsTableData &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.questionText == this.questionText &&
          other.optionA == this.optionA &&
          other.optionB == this.optionB &&
          other.optionC == this.optionC &&
          other.optionD == this.optionD &&
          other.correctOption == this.correctOption &&
          other.orderIndex == this.orderIndex);
}

class QuizQuestionsTableCompanion
    extends UpdateCompanion<QuizQuestionsTableData> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> questionText;
  final Value<String> optionA;
  final Value<String> optionB;
  final Value<String> optionC;
  final Value<String> optionD;
  final Value<String> correctOption;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const QuizQuestionsTableCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.questionText = const Value.absent(),
    this.optionA = const Value.absent(),
    this.optionB = const Value.absent(),
    this.optionC = const Value.absent(),
    this.optionD = const Value.absent(),
    this.correctOption = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizQuestionsTableCompanion.insert({
    required String id,
    required String lessonId,
    required String questionText,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String correctOption,
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lessonId = Value(lessonId),
       questionText = Value(questionText),
       optionA = Value(optionA),
       optionB = Value(optionB),
       optionC = Value(optionC),
       optionD = Value(optionD),
       correctOption = Value(correctOption);
  static Insertable<QuizQuestionsTableData> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? questionText,
    Expression<String>? optionA,
    Expression<String>? optionB,
    Expression<String>? optionC,
    Expression<String>? optionD,
    Expression<String>? correctOption,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (questionText != null) 'question_text': questionText,
      if (optionA != null) 'option_a': optionA,
      if (optionB != null) 'option_b': optionB,
      if (optionC != null) 'option_c': optionC,
      if (optionD != null) 'option_d': optionD,
      if (correctOption != null) 'correct_option': correctOption,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizQuestionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? lessonId,
    Value<String>? questionText,
    Value<String>? optionA,
    Value<String>? optionB,
    Value<String>? optionC,
    Value<String>? optionD,
    Value<String>? correctOption,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return QuizQuestionsTableCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      questionText: questionText ?? this.questionText,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctOption: correctOption ?? this.correctOption,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (optionA.present) {
      map['option_a'] = Variable<String>(optionA.value);
    }
    if (optionB.present) {
      map['option_b'] = Variable<String>(optionB.value);
    }
    if (optionC.present) {
      map['option_c'] = Variable<String>(optionC.value);
    }
    if (optionD.present) {
      map['option_d'] = Variable<String>(optionD.value);
    }
    if (correctOption.present) {
      map['correct_option'] = Variable<String>(correctOption.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionsTableCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('questionText: $questionText, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctOption: $correctOption, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTableTable extends QuizAttemptsTable
    with TableInfo<$QuizAttemptsTableTable, QuizAttemptsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
    'passed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _attemptedAtMeta = const VerificationMeta(
    'attemptedAt',
  );
  @override
  late final GeneratedColumn<String> attemptedAt = GeneratedColumn<String>(
    'attempted_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    lessonId,
    score,
    passed,
    attemptedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttemptsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('passed')) {
      context.handle(
        _passedMeta,
        passed.isAcceptableOrUnknown(data['passed']!, _passedMeta),
      );
    } else if (isInserting) {
      context.missing(_passedMeta);
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
        _attemptedAtMeta,
        attemptedAt.isAcceptableOrUnknown(
          data['attempted_at']!,
          _attemptedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttemptsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttemptsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      passed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}passed'],
      )!,
      attemptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempted_at'],
      )!,
    );
  }

  @override
  $QuizAttemptsTableTable createAlias(String alias) {
    return $QuizAttemptsTableTable(attachedDatabase, alias);
  }
}

class QuizAttemptsTableData extends DataClass
    implements Insertable<QuizAttemptsTableData> {
  final String id;
  final String studentId;
  final String lessonId;
  final double score;
  final bool passed;
  final String attemptedAt;
  const QuizAttemptsTableData({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.score,
    required this.passed,
    required this.attemptedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['score'] = Variable<double>(score);
    map['passed'] = Variable<bool>(passed);
    map['attempted_at'] = Variable<String>(attemptedAt);
    return map;
  }

  QuizAttemptsTableCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      lessonId: Value(lessonId),
      score: Value(score),
      passed: Value(passed),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory QuizAttemptsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttemptsTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      score: serializer.fromJson<double>(json['score']),
      passed: serializer.fromJson<bool>(json['passed']),
      attemptedAt: serializer.fromJson<String>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'lessonId': serializer.toJson<String>(lessonId),
      'score': serializer.toJson<double>(score),
      'passed': serializer.toJson<bool>(passed),
      'attemptedAt': serializer.toJson<String>(attemptedAt),
    };
  }

  QuizAttemptsTableData copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    double? score,
    bool? passed,
    String? attemptedAt,
  }) => QuizAttemptsTableData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
    score: score ?? this.score,
    passed: passed ?? this.passed,
    attemptedAt: attemptedAt ?? this.attemptedAt,
  );
  QuizAttemptsTableData copyWithCompanion(QuizAttemptsTableCompanion data) {
    return QuizAttemptsTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      score: data.score.present ? data.score.value : this.score,
      passed: data.passed.present ? data.passed.value : this.passed,
      attemptedAt: data.attemptedAt.present
          ? data.attemptedAt.value
          : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('score: $score, ')
          ..write('passed: $passed, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, lessonId, score, passed, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttemptsTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId &&
          other.score == this.score &&
          other.passed == this.passed &&
          other.attemptedAt == this.attemptedAt);
}

class QuizAttemptsTableCompanion
    extends UpdateCompanion<QuizAttemptsTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> lessonId;
  final Value<double> score;
  final Value<bool> passed;
  final Value<String> attemptedAt;
  final Value<int> rowid;
  const QuizAttemptsTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.score = const Value.absent(),
    this.passed = const Value.absent(),
    this.attemptedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAttemptsTableCompanion.insert({
    required String id,
    required String studentId,
    required String lessonId,
    required double score,
    required bool passed,
    required String attemptedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       lessonId = Value(lessonId),
       score = Value(score),
       passed = Value(passed),
       attemptedAt = Value(attemptedAt);
  static Insertable<QuizAttemptsTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? lessonId,
    Expression<double>? score,
    Expression<bool>? passed,
    Expression<String>? attemptedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (score != null) 'score': score,
      if (passed != null) 'passed': passed,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAttemptsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? lessonId,
    Value<double>? score,
    Value<bool>? passed,
    Value<String>? attemptedAt,
    Value<int>? rowid,
  }) {
    return QuizAttemptsTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      score: score ?? this.score,
      passed: passed ?? this.passed,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<String>(attemptedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('score: $score, ')
          ..write('passed: $passed, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PastPaperQuestionsTableTable extends PastPaperQuestionsTable
    with TableInfo<$PastPaperQuestionsTableTable, PastPaperQuestionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PastPaperQuestionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    topicId,
    questionText,
    year,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'past_paper_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PastPaperQuestionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PastPaperQuestionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PastPaperQuestionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $PastPaperQuestionsTableTable createAlias(String alias) {
    return $PastPaperQuestionsTableTable(attachedDatabase, alias);
  }
}

class PastPaperQuestionsTableData extends DataClass
    implements Insertable<PastPaperQuestionsTableData> {
  final String id;
  final String lessonId;
  final String topicId;
  final String questionText;
  final int? year;
  final int orderIndex;
  const PastPaperQuestionsTableData({
    required this.id,
    required this.lessonId,
    required this.topicId,
    required this.questionText,
    this.year,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['topic_id'] = Variable<String>(topicId);
    map['question_text'] = Variable<String>(questionText);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  PastPaperQuestionsTableCompanion toCompanion(bool nullToAbsent) {
    return PastPaperQuestionsTableCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      topicId: Value(topicId),
      questionText: Value(questionText),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      orderIndex: Value(orderIndex),
    );
  }

  factory PastPaperQuestionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PastPaperQuestionsTableData(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      topicId: serializer.fromJson<String>(json['topicId']),
      questionText: serializer.fromJson<String>(json['questionText']),
      year: serializer.fromJson<int?>(json['year']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'topicId': serializer.toJson<String>(topicId),
      'questionText': serializer.toJson<String>(questionText),
      'year': serializer.toJson<int?>(year),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  PastPaperQuestionsTableData copyWith({
    String? id,
    String? lessonId,
    String? topicId,
    String? questionText,
    Value<int?> year = const Value.absent(),
    int? orderIndex,
  }) => PastPaperQuestionsTableData(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    topicId: topicId ?? this.topicId,
    questionText: questionText ?? this.questionText,
    year: year.present ? year.value : this.year,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  PastPaperQuestionsTableData copyWithCompanion(
    PastPaperQuestionsTableCompanion data,
  ) {
    return PastPaperQuestionsTableData(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      year: data.year.present ? data.year.value : this.year,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PastPaperQuestionsTableData(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('topicId: $topicId, ')
          ..write('questionText: $questionText, ')
          ..write('year: $year, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lessonId, topicId, questionText, year, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PastPaperQuestionsTableData &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.topicId == this.topicId &&
          other.questionText == this.questionText &&
          other.year == this.year &&
          other.orderIndex == this.orderIndex);
}

class PastPaperQuestionsTableCompanion
    extends UpdateCompanion<PastPaperQuestionsTableData> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> topicId;
  final Value<String> questionText;
  final Value<int?> year;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const PastPaperQuestionsTableCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.questionText = const Value.absent(),
    this.year = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PastPaperQuestionsTableCompanion.insert({
    required String id,
    required String lessonId,
    required String topicId,
    required String questionText,
    this.year = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lessonId = Value(lessonId),
       topicId = Value(topicId),
       questionText = Value(questionText);
  static Insertable<PastPaperQuestionsTableData> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? topicId,
    Expression<String>? questionText,
    Expression<int>? year,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (topicId != null) 'topic_id': topicId,
      if (questionText != null) 'question_text': questionText,
      if (year != null) 'year': year,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PastPaperQuestionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? lessonId,
    Value<String>? topicId,
    Value<String>? questionText,
    Value<int?>? year,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return PastPaperQuestionsTableCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      topicId: topicId ?? this.topicId,
      questionText: questionText ?? this.questionText,
      year: year ?? this.year,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PastPaperQuestionsTableCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('topicId: $topicId, ')
          ..write('questionText: $questionText, ')
          ..write('year: $year, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SurveyResponsesTableTable extends SurveyResponsesTable
    with TableInfo<$SurveyResponsesTableTable, SurveyResponsesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurveyResponsesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responsesMeta = const VerificationMeta(
    'responses',
  );
  @override
  late final GeneratedColumn<String> responses = GeneratedColumn<String>(
    'responses',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _respondedAtMeta = const VerificationMeta(
    'respondedAt',
  );
  @override
  late final GeneratedColumn<String> respondedAt = GeneratedColumn<String>(
    'responded_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, studentId, responses, respondedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'survey_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurveyResponsesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('responses')) {
      context.handle(
        _responsesMeta,
        responses.isAcceptableOrUnknown(data['responses']!, _responsesMeta),
      );
    } else if (isInserting) {
      context.missing(_responsesMeta);
    }
    if (data.containsKey('responded_at')) {
      context.handle(
        _respondedAtMeta,
        respondedAt.isAcceptableOrUnknown(
          data['responded_at']!,
          _respondedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_respondedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurveyResponsesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurveyResponsesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      responses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responses'],
      )!,
      respondedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responded_at'],
      )!,
    );
  }

  @override
  $SurveyResponsesTableTable createAlias(String alias) {
    return $SurveyResponsesTableTable(attachedDatabase, alias);
  }
}

class SurveyResponsesTableData extends DataClass
    implements Insertable<SurveyResponsesTableData> {
  final String id;
  final String studentId;
  final String responses;
  final String respondedAt;
  const SurveyResponsesTableData({
    required this.id,
    required this.studentId,
    required this.responses,
    required this.respondedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['responses'] = Variable<String>(responses);
    map['responded_at'] = Variable<String>(respondedAt);
    return map;
  }

  SurveyResponsesTableCompanion toCompanion(bool nullToAbsent) {
    return SurveyResponsesTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      responses: Value(responses),
      respondedAt: Value(respondedAt),
    );
  }

  factory SurveyResponsesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurveyResponsesTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      responses: serializer.fromJson<String>(json['responses']),
      respondedAt: serializer.fromJson<String>(json['respondedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'responses': serializer.toJson<String>(responses),
      'respondedAt': serializer.toJson<String>(respondedAt),
    };
  }

  SurveyResponsesTableData copyWith({
    String? id,
    String? studentId,
    String? responses,
    String? respondedAt,
  }) => SurveyResponsesTableData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    responses: responses ?? this.responses,
    respondedAt: respondedAt ?? this.respondedAt,
  );
  SurveyResponsesTableData copyWithCompanion(
    SurveyResponsesTableCompanion data,
  ) {
    return SurveyResponsesTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      responses: data.responses.present ? data.responses.value : this.responses,
      respondedAt: data.respondedAt.present
          ? data.respondedAt.value
          : this.respondedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurveyResponsesTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('responses: $responses, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, responses, respondedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurveyResponsesTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.responses == this.responses &&
          other.respondedAt == this.respondedAt);
}

class SurveyResponsesTableCompanion
    extends UpdateCompanion<SurveyResponsesTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> responses;
  final Value<String> respondedAt;
  final Value<int> rowid;
  const SurveyResponsesTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.responses = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurveyResponsesTableCompanion.insert({
    required String id,
    required String studentId,
    required String responses,
    required String respondedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       responses = Value(responses),
       respondedAt = Value(respondedAt);
  static Insertable<SurveyResponsesTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? responses,
    Expression<String>? respondedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (responses != null) 'responses': responses,
      if (respondedAt != null) 'responded_at': respondedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurveyResponsesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? responses,
    Value<String>? respondedAt,
    Value<int>? rowid,
  }) {
    return SurveyResponsesTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      responses: responses ?? this.responses,
      respondedAt: respondedAt ?? this.respondedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (responses.present) {
      map['responses'] = Variable<String>(responses.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<String>(respondedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveyResponsesTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('responses: $responses, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NudgeEventsTableTable extends NudgeEventsTable
    with TableInfo<$NudgeEventsTableTable, NudgeEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NudgeEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<String> sentAt = GeneratedColumn<String>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fcmMessageIdMeta = const VerificationMeta(
    'fcmMessageId',
  );
  @override
  late final GeneratedColumn<String> fcmMessageId = GeneratedColumn<String>(
    'fcm_message_id',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    sentAt,
    fcmMessageId,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nudge_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<NudgeEventsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('fcm_message_id')) {
      context.handle(
        _fcmMessageIdMeta,
        fcmMessageId.isAcceptableOrUnknown(
          data['fcm_message_id']!,
          _fcmMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NudgeEventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NudgeEventsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sent_at'],
      )!,
      fcmMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fcm_message_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $NudgeEventsTableTable createAlias(String alias) {
    return $NudgeEventsTableTable(attachedDatabase, alias);
  }
}

class NudgeEventsTableData extends DataClass
    implements Insertable<NudgeEventsTableData> {
  final String id;
  final String studentId;
  final String sentAt;
  final String? fcmMessageId;
  final String status;
  const NudgeEventsTableData({
    required this.id,
    required this.studentId,
    required this.sentAt,
    this.fcmMessageId,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['sent_at'] = Variable<String>(sentAt);
    if (!nullToAbsent || fcmMessageId != null) {
      map['fcm_message_id'] = Variable<String>(fcmMessageId);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  NudgeEventsTableCompanion toCompanion(bool nullToAbsent) {
    return NudgeEventsTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      sentAt: Value(sentAt),
      fcmMessageId: fcmMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(fcmMessageId),
      status: Value(status),
    );
  }

  factory NudgeEventsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NudgeEventsTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      sentAt: serializer.fromJson<String>(json['sentAt']),
      fcmMessageId: serializer.fromJson<String?>(json['fcmMessageId']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'sentAt': serializer.toJson<String>(sentAt),
      'fcmMessageId': serializer.toJson<String?>(fcmMessageId),
      'status': serializer.toJson<String>(status),
    };
  }

  NudgeEventsTableData copyWith({
    String? id,
    String? studentId,
    String? sentAt,
    Value<String?> fcmMessageId = const Value.absent(),
    String? status,
  }) => NudgeEventsTableData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    sentAt: sentAt ?? this.sentAt,
    fcmMessageId: fcmMessageId.present ? fcmMessageId.value : this.fcmMessageId,
    status: status ?? this.status,
  );
  NudgeEventsTableData copyWithCompanion(NudgeEventsTableCompanion data) {
    return NudgeEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      fcmMessageId: data.fcmMessageId.present
          ? data.fcmMessageId.value
          : this.fcmMessageId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NudgeEventsTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sentAt: $sentAt, ')
          ..write('fcmMessageId: $fcmMessageId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, sentAt, fcmMessageId, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NudgeEventsTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.sentAt == this.sentAt &&
          other.fcmMessageId == this.fcmMessageId &&
          other.status == this.status);
}

class NudgeEventsTableCompanion extends UpdateCompanion<NudgeEventsTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> sentAt;
  final Value<String?> fcmMessageId;
  final Value<String> status;
  final Value<int> rowid;
  const NudgeEventsTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.fcmMessageId = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NudgeEventsTableCompanion.insert({
    required String id,
    required String studentId,
    required String sentAt,
    this.fcmMessageId = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       sentAt = Value(sentAt),
       status = Value(status);
  static Insertable<NudgeEventsTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? sentAt,
    Expression<String>? fcmMessageId,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (sentAt != null) 'sent_at': sentAt,
      if (fcmMessageId != null) 'fcm_message_id': fcmMessageId,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NudgeEventsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? sentAt,
    Value<String?>? fcmMessageId,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return NudgeEventsTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      sentAt: sentAt ?? this.sentAt,
      fcmMessageId: fcmMessageId ?? this.fcmMessageId,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<String>(sentAt.value);
    }
    if (fcmMessageId.present) {
      map['fcm_message_id'] = Variable<String>(fcmMessageId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NudgeEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('sentAt: $sentAt, ')
          ..write('fcmMessageId: $fcmMessageId, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTableTable extends SessionsTable
    with TableInfo<$SessionsTableTable, SessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<String> startedAt = GeneratedColumn<String>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<String> endedAt = GeneratedColumn<String>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attributedNudgeIdMeta = const VerificationMeta(
    'attributedNudgeId',
  );
  @override
  late final GeneratedColumn<String> attributedNudgeId =
      GeneratedColumn<String>(
        'attributed_nudge_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    startedAt,
    endedAt,
    attributedNudgeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('attributed_nudge_id')) {
      context.handle(
        _attributedNudgeIdMeta,
        attributedNudgeId.isAcceptableOrUnknown(
          data['attributed_nudge_id']!,
          _attributedNudgeIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ended_at'],
      ),
      attributedNudgeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attributed_nudge_id'],
      ),
    );
  }

  @override
  $SessionsTableTable createAlias(String alias) {
    return $SessionsTableTable(attachedDatabase, alias);
  }
}

class SessionsTableData extends DataClass
    implements Insertable<SessionsTableData> {
  final String id;
  final String studentId;
  final String startedAt;
  final String? endedAt;
  final String? attributedNudgeId;
  const SessionsTableData({
    required this.id,
    required this.studentId,
    required this.startedAt,
    this.endedAt,
    this.attributedNudgeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['started_at'] = Variable<String>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<String>(endedAt);
    }
    if (!nullToAbsent || attributedNudgeId != null) {
      map['attributed_nudge_id'] = Variable<String>(attributedNudgeId);
    }
    return map;
  }

  SessionsTableCompanion toCompanion(bool nullToAbsent) {
    return SessionsTableCompanion(
      id: Value(id),
      studentId: Value(studentId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      attributedNudgeId: attributedNudgeId == null && nullToAbsent
          ? const Value.absent()
          : Value(attributedNudgeId),
    );
  }

  factory SessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      startedAt: serializer.fromJson<String>(json['startedAt']),
      endedAt: serializer.fromJson<String?>(json['endedAt']),
      attributedNudgeId: serializer.fromJson<String?>(
        json['attributedNudgeId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'startedAt': serializer.toJson<String>(startedAt),
      'endedAt': serializer.toJson<String?>(endedAt),
      'attributedNudgeId': serializer.toJson<String?>(attributedNudgeId),
    };
  }

  SessionsTableData copyWith({
    String? id,
    String? studentId,
    String? startedAt,
    Value<String?> endedAt = const Value.absent(),
    Value<String?> attributedNudgeId = const Value.absent(),
  }) => SessionsTableData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    attributedNudgeId: attributedNudgeId.present
        ? attributedNudgeId.value
        : this.attributedNudgeId,
  );
  SessionsTableData copyWithCompanion(SessionsTableCompanion data) {
    return SessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      attributedNudgeId: data.attributedNudgeId.present
          ? data.attributedNudgeId.value
          : this.attributedNudgeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('attributedNudgeId: $attributedNudgeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, startedAt, endedAt, attributedNudgeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionsTableData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.attributedNudgeId == this.attributedNudgeId);
}

class SessionsTableCompanion extends UpdateCompanion<SessionsTableData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> startedAt;
  final Value<String?> endedAt;
  final Value<String?> attributedNudgeId;
  final Value<int> rowid;
  const SessionsTableCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.attributedNudgeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsTableCompanion.insert({
    required String id,
    required String studentId,
    required String startedAt,
    this.endedAt = const Value.absent(),
    this.attributedNudgeId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       startedAt = Value(startedAt);
  static Insertable<SessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? startedAt,
    Expression<String>? endedAt,
    Expression<String>? attributedNudgeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (attributedNudgeId != null) 'attributed_nudge_id': attributedNudgeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? startedAt,
    Value<String?>? endedAt,
    Value<String?>? attributedNudgeId,
    Value<int>? rowid,
  }) {
    return SessionsTableCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      attributedNudgeId: attributedNudgeId ?? this.attributedNudgeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<String>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<String>(endedAt.value);
    }
    if (attributedNudgeId.present) {
      map['attributed_nudge_id'] = Variable<String>(attributedNudgeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('attributedNudgeId: $attributedNudgeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final String createdAt;
  final int retryCount;
  const SyncQueueTableData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<String>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
    );
  }

  factory SyncQueueTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<String>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncQueueTableData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    String? createdAt,
    int? retryCount,
  }) => SyncQueueTableData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> createdAt;
  final Value<int> retryCount;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    required String createdAt,
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueTableData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? createdAt,
    Expression<int>? retryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<String>? createdAt,
    Value<int>? retryCount,
    Value<int>? rowid,
  }) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncErrorLogTableTable extends SyncErrorLogTable
    with TableInfo<$SyncErrorLogTableTable, SyncErrorLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncErrorLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failedAtMeta = const VerificationMeta(
    'failedAt',
  );
  @override
  late final GeneratedColumn<String> failedAt = GeneratedColumn<String>(
    'failed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    errorMessage,
    failedAt,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_error_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncErrorLogTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_errorMessageMeta);
    }
    if (data.containsKey('failed_at')) {
      context.handle(
        _failedAtMeta,
        failedAt.isAcceptableOrUnknown(data['failed_at']!, _failedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_failedAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncErrorLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncErrorLogTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      )!,
      failedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failed_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncErrorLogTableTable createAlias(String alias) {
    return $SyncErrorLogTableTable(attachedDatabase, alias);
  }
}

class SyncErrorLogTableData extends DataClass
    implements Insertable<SyncErrorLogTableData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final String errorMessage;
  final String failedAt;
  final int retryCount;
  const SyncErrorLogTableData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.errorMessage,
    required this.failedAt,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['error_message'] = Variable<String>(errorMessage);
    map['failed_at'] = Variable<String>(failedAt);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncErrorLogTableCompanion toCompanion(bool nullToAbsent) {
    return SyncErrorLogTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      errorMessage: Value(errorMessage),
      failedAt: Value(failedAt),
      retryCount: Value(retryCount),
    );
  }

  factory SyncErrorLogTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncErrorLogTableData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      errorMessage: serializer.fromJson<String>(json['errorMessage']),
      failedAt: serializer.fromJson<String>(json['failedAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'errorMessage': serializer.toJson<String>(errorMessage),
      'failedAt': serializer.toJson<String>(failedAt),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncErrorLogTableData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    String? errorMessage,
    String? failedAt,
    int? retryCount,
  }) => SyncErrorLogTableData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    errorMessage: errorMessage ?? this.errorMessage,
    failedAt: failedAt ?? this.failedAt,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncErrorLogTableData copyWithCompanion(SyncErrorLogTableCompanion data) {
    return SyncErrorLogTableData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      failedAt: data.failedAt.present ? data.failedAt.value : this.failedAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncErrorLogTableData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('failedAt: $failedAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    errorMessage,
    failedAt,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncErrorLogTableData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.errorMessage == this.errorMessage &&
          other.failedAt == this.failedAt &&
          other.retryCount == this.retryCount);
}

class SyncErrorLogTableCompanion
    extends UpdateCompanion<SyncErrorLogTableData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> errorMessage;
  final Value<String> failedAt;
  final Value<int> retryCount;
  final Value<int> rowid;
  const SyncErrorLogTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.failedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncErrorLogTableCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    required String errorMessage,
    required String failedAt,
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       errorMessage = Value(errorMessage),
       failedAt = Value(failedAt);
  static Insertable<SyncErrorLogTableData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? errorMessage,
    Expression<String>? failedAt,
    Expression<int>? retryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (errorMessage != null) 'error_message': errorMessage,
      if (failedAt != null) 'failed_at': failedAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncErrorLogTableCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<String>? errorMessage,
    Value<String>? failedAt,
    Value<int>? retryCount,
    Value<int>? rowid,
  }) {
    return SyncErrorLogTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      errorMessage: errorMessage ?? this.errorMessage,
      failedAt: failedAt ?? this.failedAt,
      retryCount: retryCount ?? this.retryCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (failedAt.present) {
      map['failed_at'] = Variable<String>(failedAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncErrorLogTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('failedAt: $failedAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTableTable studentsTable = $StudentsTableTable(this);
  late final $SubjectsTableTable subjectsTable = $SubjectsTableTable(this);
  late final $TopicsTableTable topicsTable = $TopicsTableTable(this);
  late final $LessonsTableTable lessonsTable = $LessonsTableTable(this);
  late final $LessonTasksTableTable lessonTasksTable = $LessonTasksTableTable(
    this,
  );
  late final $QuizQuestionsTableTable quizQuestionsTable =
      $QuizQuestionsTableTable(this);
  late final $QuizAttemptsTableTable quizAttemptsTable =
      $QuizAttemptsTableTable(this);
  late final $PastPaperQuestionsTableTable pastPaperQuestionsTable =
      $PastPaperQuestionsTableTable(this);
  late final $SurveyResponsesTableTable surveyResponsesTable =
      $SurveyResponsesTableTable(this);
  late final $NudgeEventsTableTable nudgeEventsTable = $NudgeEventsTableTable(
    this,
  );
  late final $SessionsTableTable sessionsTable = $SessionsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $SyncErrorLogTableTable syncErrorLogTable =
      $SyncErrorLogTableTable(this);
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  late final QuizDao quizDao = QuizDao(this as AppDatabase);
  late final LessonDao lessonDao = LessonDao(this as AppDatabase);
  late final StudentDao studentDao = StudentDao(this as AppDatabase);
  late final SurveyDao surveyDao = SurveyDao(this as AppDatabase);
  late final DashboardDao dashboardDao = DashboardDao(this as AppDatabase);
  late final ContentDao contentDao = ContentDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    studentsTable,
    subjectsTable,
    topicsTable,
    lessonsTable,
    lessonTasksTable,
    quizQuestionsTable,
    quizAttemptsTable,
    pastPaperQuestionsTable,
    surveyResponsesTable,
    nudgeEventsTable,
    sessionsTable,
    syncQueueTable,
    syncErrorLogTable,
  ];
}

typedef $$StudentsTableTableCreateCompanionBuilder =
    StudentsTableCompanion Function({
      required String id,
      required String name,
      required String email,
      required String district,
      required String school,
      Value<String?> fcmToken,
      Value<bool> notificationsEnabled,
      Value<String?> deactivatedAt,
      Value<String?> deletedAt,
      required String lastActiveAt,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$StudentsTableTableUpdateCompanionBuilder =
    StudentsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String> district,
      Value<String> school,
      Value<String?> fcmToken,
      Value<bool> notificationsEnabled,
      Value<String?> deactivatedAt,
      Value<String?> deletedAt,
      Value<String> lastActiveAt,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$StudentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTableTable> {
  $$StudentsTableTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastActiveAt => $composableBuilder(
    column: $table.lastActiveAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTableTable> {
  $$StudentsTableTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastActiveAt => $composableBuilder(
    column: $table.lastActiveAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTableTable> {
  $$StudentsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get fcmToken =>
      $composableBuilder(column: $table.fcmToken, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deactivatedAt => $composableBuilder(
    column: $table.deactivatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get lastActiveAt => $composableBuilder(
    column: $table.lastActiveAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StudentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTableTable,
          StudentsTableData,
          $$StudentsTableTableFilterComposer,
          $$StudentsTableTableOrderingComposer,
          $$StudentsTableTableAnnotationComposer,
          $$StudentsTableTableCreateCompanionBuilder,
          $$StudentsTableTableUpdateCompanionBuilder,
          (
            StudentsTableData,
            BaseReferences<
              _$AppDatabase,
              $StudentsTableTable,
              StudentsTableData
            >,
          ),
          StudentsTableData,
          PrefetchHooks Function()
        > {
  $$StudentsTableTableTableManager(_$AppDatabase db, $StudentsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> district = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String?> fcmToken = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> deactivatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                Value<String> lastActiveAt = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsTableCompanion(
                id: id,
                name: name,
                email: email,
                district: district,
                school: school,
                fcmToken: fcmToken,
                notificationsEnabled: notificationsEnabled,
                deactivatedAt: deactivatedAt,
                deletedAt: deletedAt,
                lastActiveAt: lastActiveAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                required String district,
                required String school,
                Value<String?> fcmToken = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> deactivatedAt = const Value.absent(),
                Value<String?> deletedAt = const Value.absent(),
                required String lastActiveAt,
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StudentsTableCompanion.insert(
                id: id,
                name: name,
                email: email,
                district: district,
                school: school,
                fcmToken: fcmToken,
                notificationsEnabled: notificationsEnabled,
                deactivatedAt: deactivatedAt,
                deletedAt: deletedAt,
                lastActiveAt: lastActiveAt,
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

typedef $$StudentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTableTable,
      StudentsTableData,
      $$StudentsTableTableFilterComposer,
      $$StudentsTableTableOrderingComposer,
      $$StudentsTableTableAnnotationComposer,
      $$StudentsTableTableCreateCompanionBuilder,
      $$StudentsTableTableUpdateCompanionBuilder,
      (
        StudentsTableData,
        BaseReferences<_$AppDatabase, $StudentsTableTable, StudentsTableData>,
      ),
      StudentsTableData,
      PrefetchHooks Function()
    >;
typedef $$SubjectsTableTableCreateCompanionBuilder =
    SubjectsTableCompanion Function({
      required String id,
      required String name,
      Value<double> quizPassThreshold,
      Value<int> contentVersion,
      Value<int> rowid,
    });
typedef $$SubjectsTableTableUpdateCompanionBuilder =
    SubjectsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> quizPassThreshold,
      Value<int> contentVersion,
      Value<int> rowid,
    });

class $$SubjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableFilterComposer({
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

  ColumnFilters<double> get quizPassThreshold => $composableBuilder(
    column: $table.quizPassThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableOrderingComposer({
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

  ColumnOrderings<double> get quizPassThreshold => $composableBuilder(
    column: $table.quizPassThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableAnnotationComposer({
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

  GeneratedColumn<double> get quizPassThreshold => $composableBuilder(
    column: $table.quizPassThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );
}

class $$SubjectsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTableTable,
          SubjectsTableData,
          $$SubjectsTableTableFilterComposer,
          $$SubjectsTableTableOrderingComposer,
          $$SubjectsTableTableAnnotationComposer,
          $$SubjectsTableTableCreateCompanionBuilder,
          $$SubjectsTableTableUpdateCompanionBuilder,
          (
            SubjectsTableData,
            BaseReferences<
              _$AppDatabase,
              $SubjectsTableTable,
              SubjectsTableData
            >,
          ),
          SubjectsTableData,
          PrefetchHooks Function()
        > {
  $$SubjectsTableTableTableManager(_$AppDatabase db, $SubjectsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quizPassThreshold = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsTableCompanion(
                id: id,
                name: name,
                quizPassThreshold: quizPassThreshold,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<double> quizPassThreshold = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsTableCompanion.insert(
                id: id,
                name: name,
                quizPassThreshold: quizPassThreshold,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubjectsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTableTable,
      SubjectsTableData,
      $$SubjectsTableTableFilterComposer,
      $$SubjectsTableTableOrderingComposer,
      $$SubjectsTableTableAnnotationComposer,
      $$SubjectsTableTableCreateCompanionBuilder,
      $$SubjectsTableTableUpdateCompanionBuilder,
      (
        SubjectsTableData,
        BaseReferences<_$AppDatabase, $SubjectsTableTable, SubjectsTableData>,
      ),
      SubjectsTableData,
      PrefetchHooks Function()
    >;
typedef $$TopicsTableTableCreateCompanionBuilder =
    TopicsTableCompanion Function({
      required String id,
      required String subjectId,
      required String title,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$TopicsTableTableUpdateCompanionBuilder =
    TopicsTableCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> title,
      Value<int> orderIndex,
      Value<int> rowid,
    });

class $$TopicsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTableTable> {
  $$TopicsTableTableFilterComposer({
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

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TopicsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTableTable> {
  $$TopicsTableTableOrderingComposer({
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

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TopicsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTableTable> {
  $$TopicsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$TopicsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopicsTableTable,
          TopicsTableData,
          $$TopicsTableTableFilterComposer,
          $$TopicsTableTableOrderingComposer,
          $$TopicsTableTableAnnotationComposer,
          $$TopicsTableTableCreateCompanionBuilder,
          $$TopicsTableTableUpdateCompanionBuilder,
          (
            TopicsTableData,
            BaseReferences<_$AppDatabase, $TopicsTableTable, TopicsTableData>,
          ),
          TopicsTableData,
          PrefetchHooks Function()
        > {
  $$TopicsTableTableTableManager(_$AppDatabase db, $TopicsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsTableCompanion(
                id: id,
                subjectId: subjectId,
                title: title,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String title,
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsTableCompanion.insert(
                id: id,
                subjectId: subjectId,
                title: title,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TopicsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopicsTableTable,
      TopicsTableData,
      $$TopicsTableTableFilterComposer,
      $$TopicsTableTableOrderingComposer,
      $$TopicsTableTableAnnotationComposer,
      $$TopicsTableTableCreateCompanionBuilder,
      $$TopicsTableTableUpdateCompanionBuilder,
      (
        TopicsTableData,
        BaseReferences<_$AppDatabase, $TopicsTableTable, TopicsTableData>,
      ),
      TopicsTableData,
      PrefetchHooks Function()
    >;
typedef $$LessonsTableTableCreateCompanionBuilder =
    LessonsTableCompanion Function({
      required String id,
      required String topicId,
      required String title,
      required String contentText,
      required String contentTrack,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$LessonsTableTableUpdateCompanionBuilder =
    LessonsTableCompanion Function({
      Value<String> id,
      Value<String> topicId,
      Value<String> title,
      Value<String> contentText,
      Value<String> contentTrack,
      Value<int> orderIndex,
      Value<int> rowid,
    });

class $$LessonsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableFilterComposer({
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

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentTrack => $composableBuilder(
    column: $table.contentTrack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableOrderingComposer({
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

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentTrack => $composableBuilder(
    column: $table.contentTrack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTableTable> {
  $$LessonsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentTrack => $composableBuilder(
    column: $table.contentTrack,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$LessonsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTableTable,
          LessonsTableData,
          $$LessonsTableTableFilterComposer,
          $$LessonsTableTableOrderingComposer,
          $$LessonsTableTableAnnotationComposer,
          $$LessonsTableTableCreateCompanionBuilder,
          $$LessonsTableTableUpdateCompanionBuilder,
          (
            LessonsTableData,
            BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData>,
          ),
          LessonsTableData,
          PrefetchHooks Function()
        > {
  $$LessonsTableTableTableManager(_$AppDatabase db, $LessonsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentText = const Value.absent(),
                Value<String> contentTrack = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion(
                id: id,
                topicId: topicId,
                title: title,
                contentText: contentText,
                contentTrack: contentTrack,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String topicId,
                required String title,
                required String contentText,
                required String contentTrack,
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsTableCompanion.insert(
                id: id,
                topicId: topicId,
                title: title,
                contentText: contentText,
                contentTrack: contentTrack,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTableTable,
      LessonsTableData,
      $$LessonsTableTableFilterComposer,
      $$LessonsTableTableOrderingComposer,
      $$LessonsTableTableAnnotationComposer,
      $$LessonsTableTableCreateCompanionBuilder,
      $$LessonsTableTableUpdateCompanionBuilder,
      (
        LessonsTableData,
        BaseReferences<_$AppDatabase, $LessonsTableTable, LessonsTableData>,
      ),
      LessonsTableData,
      PrefetchHooks Function()
    >;
typedef $$LessonTasksTableTableCreateCompanionBuilder =
    LessonTasksTableCompanion Function({
      required String id,
      required String studentId,
      required String lessonId,
      Value<String> taskStatus,
      Value<bool> curiosityCompleted,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$LessonTasksTableTableUpdateCompanionBuilder =
    LessonTasksTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> lessonId,
      Value<String> taskStatus,
      Value<bool> curiosityCompleted,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$LessonTasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonTasksTableTable> {
  $$LessonTasksTableTableFilterComposer({
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

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskStatus => $composableBuilder(
    column: $table.taskStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get curiosityCompleted => $composableBuilder(
    column: $table.curiosityCompleted,
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
}

class $$LessonTasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonTasksTableTable> {
  $$LessonTasksTableTableOrderingComposer({
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

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskStatus => $composableBuilder(
    column: $table.taskStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get curiosityCompleted => $composableBuilder(
    column: $table.curiosityCompleted,
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

class $$LessonTasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonTasksTableTable> {
  $$LessonTasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get taskStatus => $composableBuilder(
    column: $table.taskStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get curiosityCompleted => $composableBuilder(
    column: $table.curiosityCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LessonTasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonTasksTableTable,
          LessonTasksTableData,
          $$LessonTasksTableTableFilterComposer,
          $$LessonTasksTableTableOrderingComposer,
          $$LessonTasksTableTableAnnotationComposer,
          $$LessonTasksTableTableCreateCompanionBuilder,
          $$LessonTasksTableTableUpdateCompanionBuilder,
          (
            LessonTasksTableData,
            BaseReferences<
              _$AppDatabase,
              $LessonTasksTableTable,
              LessonTasksTableData
            >,
          ),
          LessonTasksTableData,
          PrefetchHooks Function()
        > {
  $$LessonTasksTableTableTableManager(
    _$AppDatabase db,
    $LessonTasksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonTasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonTasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonTasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> taskStatus = const Value.absent(),
                Value<bool> curiosityCompleted = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonTasksTableCompanion(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                taskStatus: taskStatus,
                curiosityCompleted: curiosityCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String lessonId,
                Value<String> taskStatus = const Value.absent(),
                Value<bool> curiosityCompleted = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LessonTasksTableCompanion.insert(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                taskStatus: taskStatus,
                curiosityCompleted: curiosityCompleted,
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

typedef $$LessonTasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonTasksTableTable,
      LessonTasksTableData,
      $$LessonTasksTableTableFilterComposer,
      $$LessonTasksTableTableOrderingComposer,
      $$LessonTasksTableTableAnnotationComposer,
      $$LessonTasksTableTableCreateCompanionBuilder,
      $$LessonTasksTableTableUpdateCompanionBuilder,
      (
        LessonTasksTableData,
        BaseReferences<
          _$AppDatabase,
          $LessonTasksTableTable,
          LessonTasksTableData
        >,
      ),
      LessonTasksTableData,
      PrefetchHooks Function()
    >;
typedef $$QuizQuestionsTableTableCreateCompanionBuilder =
    QuizQuestionsTableCompanion Function({
      required String id,
      required String lessonId,
      required String questionText,
      required String optionA,
      required String optionB,
      required String optionC,
      required String optionD,
      required String correctOption,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$QuizQuestionsTableTableUpdateCompanionBuilder =
    QuizQuestionsTableCompanion Function({
      Value<String> id,
      Value<String> lessonId,
      Value<String> questionText,
      Value<String> optionA,
      Value<String> optionB,
      Value<String> optionC,
      Value<String> optionD,
      Value<String> correctOption,
      Value<int> orderIndex,
      Value<int> rowid,
    });

class $$QuizQuestionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTableTable> {
  $$QuizQuestionsTableTableFilterComposer({
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

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionA => $composableBuilder(
    column: $table.optionA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionB => $composableBuilder(
    column: $table.optionB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionC => $composableBuilder(
    column: $table.optionC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionD => $composableBuilder(
    column: $table.optionD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizQuestionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTableTable> {
  $$QuizQuestionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionA => $composableBuilder(
    column: $table.optionA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionB => $composableBuilder(
    column: $table.optionB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionC => $composableBuilder(
    column: $table.optionC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionD => $composableBuilder(
    column: $table.optionD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizQuestionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTableTable> {
  $$QuizQuestionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get optionA =>
      $composableBuilder(column: $table.optionA, builder: (column) => column);

  GeneratedColumn<String> get optionB =>
      $composableBuilder(column: $table.optionB, builder: (column) => column);

  GeneratedColumn<String> get optionC =>
      $composableBuilder(column: $table.optionC, builder: (column) => column);

  GeneratedColumn<String> get optionD =>
      $composableBuilder(column: $table.optionD, builder: (column) => column);

  GeneratedColumn<String> get correctOption => $composableBuilder(
    column: $table.correctOption,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$QuizQuestionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizQuestionsTableTable,
          QuizQuestionsTableData,
          $$QuizQuestionsTableTableFilterComposer,
          $$QuizQuestionsTableTableOrderingComposer,
          $$QuizQuestionsTableTableAnnotationComposer,
          $$QuizQuestionsTableTableCreateCompanionBuilder,
          $$QuizQuestionsTableTableUpdateCompanionBuilder,
          (
            QuizQuestionsTableData,
            BaseReferences<
              _$AppDatabase,
              $QuizQuestionsTableTable,
              QuizQuestionsTableData
            >,
          ),
          QuizQuestionsTableData,
          PrefetchHooks Function()
        > {
  $$QuizQuestionsTableTableTableManager(
    _$AppDatabase db,
    $QuizQuestionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizQuestionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizQuestionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizQuestionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String> optionA = const Value.absent(),
                Value<String> optionB = const Value.absent(),
                Value<String> optionC = const Value.absent(),
                Value<String> optionD = const Value.absent(),
                Value<String> correctOption = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsTableCompanion(
                id: id,
                lessonId: lessonId,
                questionText: questionText,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                correctOption: correctOption,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lessonId,
                required String questionText,
                required String optionA,
                required String optionB,
                required String optionC,
                required String optionD,
                required String correctOption,
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsTableCompanion.insert(
                id: id,
                lessonId: lessonId,
                questionText: questionText,
                optionA: optionA,
                optionB: optionB,
                optionC: optionC,
                optionD: optionD,
                correctOption: correctOption,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizQuestionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizQuestionsTableTable,
      QuizQuestionsTableData,
      $$QuizQuestionsTableTableFilterComposer,
      $$QuizQuestionsTableTableOrderingComposer,
      $$QuizQuestionsTableTableAnnotationComposer,
      $$QuizQuestionsTableTableCreateCompanionBuilder,
      $$QuizQuestionsTableTableUpdateCompanionBuilder,
      (
        QuizQuestionsTableData,
        BaseReferences<
          _$AppDatabase,
          $QuizQuestionsTableTable,
          QuizQuestionsTableData
        >,
      ),
      QuizQuestionsTableData,
      PrefetchHooks Function()
    >;
typedef $$QuizAttemptsTableTableCreateCompanionBuilder =
    QuizAttemptsTableCompanion Function({
      required String id,
      required String studentId,
      required String lessonId,
      required double score,
      required bool passed,
      required String attemptedAt,
      Value<int> rowid,
    });
typedef $$QuizAttemptsTableTableUpdateCompanionBuilder =
    QuizAttemptsTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> lessonId,
      Value<double> score,
      Value<bool> passed,
      Value<String> attemptedAt,
      Value<int> rowid,
    });

class $$QuizAttemptsTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTableTable> {
  $$QuizAttemptsTableTableFilterComposer({
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

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizAttemptsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTableTable> {
  $$QuizAttemptsTableTableOrderingComposer({
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

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizAttemptsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTableTable> {
  $$QuizAttemptsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<String> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => column,
  );
}

class $$QuizAttemptsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTableTable,
          QuizAttemptsTableData,
          $$QuizAttemptsTableTableFilterComposer,
          $$QuizAttemptsTableTableOrderingComposer,
          $$QuizAttemptsTableTableAnnotationComposer,
          $$QuizAttemptsTableTableCreateCompanionBuilder,
          $$QuizAttemptsTableTableUpdateCompanionBuilder,
          (
            QuizAttemptsTableData,
            BaseReferences<
              _$AppDatabase,
              $QuizAttemptsTableTable,
              QuizAttemptsTableData
            >,
          ),
          QuizAttemptsTableData,
          PrefetchHooks Function()
        > {
  $$QuizAttemptsTableTableTableManager(
    _$AppDatabase db,
    $QuizAttemptsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<bool> passed = const Value.absent(),
                Value<String> attemptedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsTableCompanion(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                score: score,
                passed: passed,
                attemptedAt: attemptedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String lessonId,
                required double score,
                required bool passed,
                required String attemptedAt,
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsTableCompanion.insert(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                score: score,
                passed: passed,
                attemptedAt: attemptedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizAttemptsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTableTable,
      QuizAttemptsTableData,
      $$QuizAttemptsTableTableFilterComposer,
      $$QuizAttemptsTableTableOrderingComposer,
      $$QuizAttemptsTableTableAnnotationComposer,
      $$QuizAttemptsTableTableCreateCompanionBuilder,
      $$QuizAttemptsTableTableUpdateCompanionBuilder,
      (
        QuizAttemptsTableData,
        BaseReferences<
          _$AppDatabase,
          $QuizAttemptsTableTable,
          QuizAttemptsTableData
        >,
      ),
      QuizAttemptsTableData,
      PrefetchHooks Function()
    >;
typedef $$PastPaperQuestionsTableTableCreateCompanionBuilder =
    PastPaperQuestionsTableCompanion Function({
      required String id,
      required String lessonId,
      required String topicId,
      required String questionText,
      Value<int?> year,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$PastPaperQuestionsTableTableUpdateCompanionBuilder =
    PastPaperQuestionsTableCompanion Function({
      Value<String> id,
      Value<String> lessonId,
      Value<String> topicId,
      Value<String> questionText,
      Value<int?> year,
      Value<int> orderIndex,
      Value<int> rowid,
    });

class $$PastPaperQuestionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PastPaperQuestionsTableTable> {
  $$PastPaperQuestionsTableTableFilterComposer({
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

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PastPaperQuestionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PastPaperQuestionsTableTable> {
  $$PastPaperQuestionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PastPaperQuestionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PastPaperQuestionsTableTable> {
  $$PastPaperQuestionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$PastPaperQuestionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PastPaperQuestionsTableTable,
          PastPaperQuestionsTableData,
          $$PastPaperQuestionsTableTableFilterComposer,
          $$PastPaperQuestionsTableTableOrderingComposer,
          $$PastPaperQuestionsTableTableAnnotationComposer,
          $$PastPaperQuestionsTableTableCreateCompanionBuilder,
          $$PastPaperQuestionsTableTableUpdateCompanionBuilder,
          (
            PastPaperQuestionsTableData,
            BaseReferences<
              _$AppDatabase,
              $PastPaperQuestionsTableTable,
              PastPaperQuestionsTableData
            >,
          ),
          PastPaperQuestionsTableData,
          PrefetchHooks Function()
        > {
  $$PastPaperQuestionsTableTableTableManager(
    _$AppDatabase db,
    $PastPaperQuestionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PastPaperQuestionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PastPaperQuestionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PastPaperQuestionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PastPaperQuestionsTableCompanion(
                id: id,
                lessonId: lessonId,
                topicId: topicId,
                questionText: questionText,
                year: year,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lessonId,
                required String topicId,
                required String questionText,
                Value<int?> year = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PastPaperQuestionsTableCompanion.insert(
                id: id,
                lessonId: lessonId,
                topicId: topicId,
                questionText: questionText,
                year: year,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PastPaperQuestionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PastPaperQuestionsTableTable,
      PastPaperQuestionsTableData,
      $$PastPaperQuestionsTableTableFilterComposer,
      $$PastPaperQuestionsTableTableOrderingComposer,
      $$PastPaperQuestionsTableTableAnnotationComposer,
      $$PastPaperQuestionsTableTableCreateCompanionBuilder,
      $$PastPaperQuestionsTableTableUpdateCompanionBuilder,
      (
        PastPaperQuestionsTableData,
        BaseReferences<
          _$AppDatabase,
          $PastPaperQuestionsTableTable,
          PastPaperQuestionsTableData
        >,
      ),
      PastPaperQuestionsTableData,
      PrefetchHooks Function()
    >;
typedef $$SurveyResponsesTableTableCreateCompanionBuilder =
    SurveyResponsesTableCompanion Function({
      required String id,
      required String studentId,
      required String responses,
      required String respondedAt,
      Value<int> rowid,
    });
typedef $$SurveyResponsesTableTableUpdateCompanionBuilder =
    SurveyResponsesTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> responses,
      Value<String> respondedAt,
      Value<int> rowid,
    });

class $$SurveyResponsesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SurveyResponsesTableTable> {
  $$SurveyResponsesTableTableFilterComposer({
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

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responses => $composableBuilder(
    column: $table.responses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SurveyResponsesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SurveyResponsesTableTable> {
  $$SurveyResponsesTableTableOrderingComposer({
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

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responses => $composableBuilder(
    column: $table.responses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurveyResponsesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurveyResponsesTableTable> {
  $$SurveyResponsesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get responses =>
      $composableBuilder(column: $table.responses, builder: (column) => column);

  GeneratedColumn<String> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => column,
  );
}

class $$SurveyResponsesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurveyResponsesTableTable,
          SurveyResponsesTableData,
          $$SurveyResponsesTableTableFilterComposer,
          $$SurveyResponsesTableTableOrderingComposer,
          $$SurveyResponsesTableTableAnnotationComposer,
          $$SurveyResponsesTableTableCreateCompanionBuilder,
          $$SurveyResponsesTableTableUpdateCompanionBuilder,
          (
            SurveyResponsesTableData,
            BaseReferences<
              _$AppDatabase,
              $SurveyResponsesTableTable,
              SurveyResponsesTableData
            >,
          ),
          SurveyResponsesTableData,
          PrefetchHooks Function()
        > {
  $$SurveyResponsesTableTableTableManager(
    _$AppDatabase db,
    $SurveyResponsesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurveyResponsesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurveyResponsesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SurveyResponsesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> responses = const Value.absent(),
                Value<String> respondedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SurveyResponsesTableCompanion(
                id: id,
                studentId: studentId,
                responses: responses,
                respondedAt: respondedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String responses,
                required String respondedAt,
                Value<int> rowid = const Value.absent(),
              }) => SurveyResponsesTableCompanion.insert(
                id: id,
                studentId: studentId,
                responses: responses,
                respondedAt: respondedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SurveyResponsesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurveyResponsesTableTable,
      SurveyResponsesTableData,
      $$SurveyResponsesTableTableFilterComposer,
      $$SurveyResponsesTableTableOrderingComposer,
      $$SurveyResponsesTableTableAnnotationComposer,
      $$SurveyResponsesTableTableCreateCompanionBuilder,
      $$SurveyResponsesTableTableUpdateCompanionBuilder,
      (
        SurveyResponsesTableData,
        BaseReferences<
          _$AppDatabase,
          $SurveyResponsesTableTable,
          SurveyResponsesTableData
        >,
      ),
      SurveyResponsesTableData,
      PrefetchHooks Function()
    >;
typedef $$NudgeEventsTableTableCreateCompanionBuilder =
    NudgeEventsTableCompanion Function({
      required String id,
      required String studentId,
      required String sentAt,
      Value<String?> fcmMessageId,
      required String status,
      Value<int> rowid,
    });
typedef $$NudgeEventsTableTableUpdateCompanionBuilder =
    NudgeEventsTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> sentAt,
      Value<String?> fcmMessageId,
      Value<String> status,
      Value<int> rowid,
    });

class $$NudgeEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NudgeEventsTableTable> {
  $$NudgeEventsTableTableFilterComposer({
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

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fcmMessageId => $composableBuilder(
    column: $table.fcmMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NudgeEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NudgeEventsTableTable> {
  $$NudgeEventsTableTableOrderingComposer({
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

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fcmMessageId => $composableBuilder(
    column: $table.fcmMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NudgeEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NudgeEventsTableTable> {
  $$NudgeEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<String> get fcmMessageId => $composableBuilder(
    column: $table.fcmMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$NudgeEventsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NudgeEventsTableTable,
          NudgeEventsTableData,
          $$NudgeEventsTableTableFilterComposer,
          $$NudgeEventsTableTableOrderingComposer,
          $$NudgeEventsTableTableAnnotationComposer,
          $$NudgeEventsTableTableCreateCompanionBuilder,
          $$NudgeEventsTableTableUpdateCompanionBuilder,
          (
            NudgeEventsTableData,
            BaseReferences<
              _$AppDatabase,
              $NudgeEventsTableTable,
              NudgeEventsTableData
            >,
          ),
          NudgeEventsTableData,
          PrefetchHooks Function()
        > {
  $$NudgeEventsTableTableTableManager(
    _$AppDatabase db,
    $NudgeEventsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NudgeEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NudgeEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NudgeEventsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> sentAt = const Value.absent(),
                Value<String?> fcmMessageId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NudgeEventsTableCompanion(
                id: id,
                studentId: studentId,
                sentAt: sentAt,
                fcmMessageId: fcmMessageId,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String sentAt,
                Value<String?> fcmMessageId = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => NudgeEventsTableCompanion.insert(
                id: id,
                studentId: studentId,
                sentAt: sentAt,
                fcmMessageId: fcmMessageId,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NudgeEventsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NudgeEventsTableTable,
      NudgeEventsTableData,
      $$NudgeEventsTableTableFilterComposer,
      $$NudgeEventsTableTableOrderingComposer,
      $$NudgeEventsTableTableAnnotationComposer,
      $$NudgeEventsTableTableCreateCompanionBuilder,
      $$NudgeEventsTableTableUpdateCompanionBuilder,
      (
        NudgeEventsTableData,
        BaseReferences<
          _$AppDatabase,
          $NudgeEventsTableTable,
          NudgeEventsTableData
        >,
      ),
      NudgeEventsTableData,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableTableCreateCompanionBuilder =
    SessionsTableCompanion Function({
      required String id,
      required String studentId,
      required String startedAt,
      Value<String?> endedAt,
      Value<String?> attributedNudgeId,
      Value<int> rowid,
    });
typedef $$SessionsTableTableUpdateCompanionBuilder =
    SessionsTableCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> startedAt,
      Value<String?> endedAt,
      Value<String?> attributedNudgeId,
      Value<int> rowid,
    });

class $$SessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableFilterComposer({
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

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attributedNudgeId => $composableBuilder(
    column: $table.attributedNudgeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attributedNudgeId => $composableBuilder(
    column: $table.attributedNudgeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTableTable> {
  $$SessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get attributedNudgeId => $composableBuilder(
    column: $table.attributedNudgeId,
    builder: (column) => column,
  );
}

class $$SessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTableTable,
          SessionsTableData,
          $$SessionsTableTableFilterComposer,
          $$SessionsTableTableOrderingComposer,
          $$SessionsTableTableAnnotationComposer,
          $$SessionsTableTableCreateCompanionBuilder,
          $$SessionsTableTableUpdateCompanionBuilder,
          (
            SessionsTableData,
            BaseReferences<
              _$AppDatabase,
              $SessionsTableTable,
              SessionsTableData
            >,
          ),
          SessionsTableData,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableTableManager(_$AppDatabase db, $SessionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> startedAt = const Value.absent(),
                Value<String?> endedAt = const Value.absent(),
                Value<String?> attributedNudgeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsTableCompanion(
                id: id,
                studentId: studentId,
                startedAt: startedAt,
                endedAt: endedAt,
                attributedNudgeId: attributedNudgeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String startedAt,
                Value<String?> endedAt = const Value.absent(),
                Value<String?> attributedNudgeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsTableCompanion.insert(
                id: id,
                studentId: studentId,
                startedAt: startedAt,
                endedAt: endedAt,
                attributedNudgeId: attributedNudgeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTableTable,
      SessionsTableData,
      $$SessionsTableTableFilterComposer,
      $$SessionsTableTableOrderingComposer,
      $$SessionsTableTableAnnotationComposer,
      $$SessionsTableTableCreateCompanionBuilder,
      $$SessionsTableTableUpdateCompanionBuilder,
      (
        SessionsTableData,
        BaseReferences<_$AppDatabase, $SessionsTableTable, SessionsTableData>,
      ),
      SessionsTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableTableCreateCompanionBuilder =
    SyncQueueTableCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      required String createdAt,
      Value<int> retryCount,
      Value<int> rowid,
    });
typedef $$SyncQueueTableTableUpdateCompanionBuilder =
    SyncQueueTableCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<String> createdAt,
      Value<int> retryCount,
      Value<int> rowid,
    });

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTableTable,
          SyncQueueTableData,
          $$SyncQueueTableTableFilterComposer,
          $$SyncQueueTableTableOrderingComposer,
          $$SyncQueueTableTableAnnotationComposer,
          $$SyncQueueTableTableCreateCompanionBuilder,
          $$SyncQueueTableTableUpdateCompanionBuilder,
          (
            SyncQueueTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncQueueTableTable,
              SyncQueueTableData
            >,
          ),
          SyncQueueTableData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableTableManager(
    _$AppDatabase db,
    $SyncQueueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueTableCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                required String createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueTableCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTableTable,
      SyncQueueTableData,
      $$SyncQueueTableTableFilterComposer,
      $$SyncQueueTableTableOrderingComposer,
      $$SyncQueueTableTableAnnotationComposer,
      $$SyncQueueTableTableCreateCompanionBuilder,
      $$SyncQueueTableTableUpdateCompanionBuilder,
      (
        SyncQueueTableData,
        BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>,
      ),
      SyncQueueTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncErrorLogTableTableCreateCompanionBuilder =
    SyncErrorLogTableCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      required String errorMessage,
      required String failedAt,
      Value<int> retryCount,
      Value<int> rowid,
    });
typedef $$SyncErrorLogTableTableUpdateCompanionBuilder =
    SyncErrorLogTableCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<String> errorMessage,
      Value<String> failedAt,
      Value<int> retryCount,
      Value<int> rowid,
    });

class $$SyncErrorLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncErrorLogTableTable> {
  $$SyncErrorLogTableTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failedAt => $composableBuilder(
    column: $table.failedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncErrorLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncErrorLogTableTable> {
  $$SyncErrorLogTableTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failedAt => $composableBuilder(
    column: $table.failedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncErrorLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncErrorLogTableTable> {
  $$SyncErrorLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failedAt =>
      $composableBuilder(column: $table.failedAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncErrorLogTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncErrorLogTableTable,
          SyncErrorLogTableData,
          $$SyncErrorLogTableTableFilterComposer,
          $$SyncErrorLogTableTableOrderingComposer,
          $$SyncErrorLogTableTableAnnotationComposer,
          $$SyncErrorLogTableTableCreateCompanionBuilder,
          $$SyncErrorLogTableTableUpdateCompanionBuilder,
          (
            SyncErrorLogTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncErrorLogTableTable,
              SyncErrorLogTableData
            >,
          ),
          SyncErrorLogTableData,
          PrefetchHooks Function()
        > {
  $$SyncErrorLogTableTableTableManager(
    _$AppDatabase db,
    $SyncErrorLogTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncErrorLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncErrorLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncErrorLogTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> errorMessage = const Value.absent(),
                Value<String> failedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncErrorLogTableCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                errorMessage: errorMessage,
                failedAt: failedAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                required String errorMessage,
                required String failedAt,
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncErrorLogTableCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                errorMessage: errorMessage,
                failedAt: failedAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncErrorLogTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncErrorLogTableTable,
      SyncErrorLogTableData,
      $$SyncErrorLogTableTableFilterComposer,
      $$SyncErrorLogTableTableOrderingComposer,
      $$SyncErrorLogTableTableAnnotationComposer,
      $$SyncErrorLogTableTableCreateCompanionBuilder,
      $$SyncErrorLogTableTableUpdateCompanionBuilder,
      (
        SyncErrorLogTableData,
        BaseReferences<
          _$AppDatabase,
          $SyncErrorLogTableTable,
          SyncErrorLogTableData
        >,
      ),
      SyncErrorLogTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableTableManager get studentsTable =>
      $$StudentsTableTableTableManager(_db, _db.studentsTable);
  $$SubjectsTableTableTableManager get subjectsTable =>
      $$SubjectsTableTableTableManager(_db, _db.subjectsTable);
  $$TopicsTableTableTableManager get topicsTable =>
      $$TopicsTableTableTableManager(_db, _db.topicsTable);
  $$LessonsTableTableTableManager get lessonsTable =>
      $$LessonsTableTableTableManager(_db, _db.lessonsTable);
  $$LessonTasksTableTableTableManager get lessonTasksTable =>
      $$LessonTasksTableTableTableManager(_db, _db.lessonTasksTable);
  $$QuizQuestionsTableTableTableManager get quizQuestionsTable =>
      $$QuizQuestionsTableTableTableManager(_db, _db.quizQuestionsTable);
  $$QuizAttemptsTableTableTableManager get quizAttemptsTable =>
      $$QuizAttemptsTableTableTableManager(_db, _db.quizAttemptsTable);
  $$PastPaperQuestionsTableTableTableManager get pastPaperQuestionsTable =>
      $$PastPaperQuestionsTableTableTableManager(
        _db,
        _db.pastPaperQuestionsTable,
      );
  $$SurveyResponsesTableTableTableManager get surveyResponsesTable =>
      $$SurveyResponsesTableTableTableManager(_db, _db.surveyResponsesTable);
  $$NudgeEventsTableTableTableManager get nudgeEventsTable =>
      $$NudgeEventsTableTableTableManager(_db, _db.nudgeEventsTable);
  $$SessionsTableTableTableManager get sessionsTable =>
      $$SessionsTableTableTableManager(_db, _db.sessionsTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$SyncErrorLogTableTableTableManager get syncErrorLogTable =>
      $$SyncErrorLogTableTableTableManager(_db, _db.syncErrorLogTable);
}

class User {
  String? id; // Alterado para String? para armazenar Firebase UID
  String name;
  String email;
  double height;
  double weight;
  int age;
  int checkedIn;
  String? lastCheckIn;
  String? goal;
  String? level;
  String? time;
  String? equipments;
  String? gender;
  String? experience;
  String? medicalRestrictions;
  List<String>? exercisePreferences;
  String? frequency;
  String? customGoal;
  bool? acceptTerms;
  String? profilePhotoPath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    this.checkedIn = 0,
    this.lastCheckIn,
    this.goal,
    this.level,
    this.time,
    this.equipments,
    this.gender,
    this.experience,
    this.medicalRestrictions,
    this.exercisePreferences,
    this.frequency,
    this.customGoal,
    this.acceptTerms,
    this.profilePhotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'age': age,
      'checkedIn': checkedIn,
      'lastCheckIn': lastCheckIn,
      'goal': goal,
      'level': level,
      'time': time,
      'equipments': equipments,
      'gender': gender,
      'experience': experience,
      'medicalRestrictions': medicalRestrictions,
      'exercisePreferences': exercisePreferences?.join(','),
      'frequency': frequency,
      'customGoal': customGoal,
      'acceptTerms': acceptTerms == true ? 1 : 0,
      'profilePhotoPath': profilePhotoPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      height: (map['height'] is int)
          ? (map['height'] as int).toDouble()
          : map['height'] as double,
      weight: (map['weight'] is int)
          ? (map['weight'] as int).toDouble()
          : map['weight'] as double,
      age: map['age'] as int,
      checkedIn: map['checkedIn'] ?? 0,
      lastCheckIn: map['lastCheckIn'] as String?,
      goal: map['goal'] as String?,
      level: map['level'] as String?,
      time: map['time'] as String?,
      equipments: map['equipments'] as String?,
      gender: map['gender'] as String?,
      experience: map['experience'] as String?,
      medicalRestrictions: map['medicalRestrictions'] as String?,
      exercisePreferences:
          map['exercisePreferences'] != null &&
              map['exercisePreferences'] is String
          ? (map['exercisePreferences'] as String).split(',')
          : <String>[],
      frequency: map['frequency'] as String?,
      customGoal: map['customGoal'] as String?,
      acceptTerms: map['acceptTerms'] == 1,
      profilePhotoPath: map['profilePhotoPath'] as String?,
    );
  }
}

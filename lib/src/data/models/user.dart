class User {
  final String? name;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? username;
  final bool? isProducer;
  final bool? isCompleted;
  final String? avatar;
  final String? bio;
  final String? address;
  final String? dob;

  User({
    this.name,
    this.lastName,
    this.phone,
    this.email,
    this.username,
    this.isProducer,
    this.isCompleted,
    this.avatar,
    this.bio,
    this.address,
    this.dob,
  });

  User copyWith({
    String? name,
    String? lastName,
    String? phone,
    String? email,
    String? username,
    bool? isProducer,
    bool? hasCompletedProfile,
    bool? isCompleted,
    String? avatar,
    String? bio,
    String? dob,
  }) => User(
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    username: username ?? this.username,
    isProducer: isProducer ?? this.isProducer,
    isCompleted: isCompleted ?? this.isCompleted,
    avatar: avatar ?? this.avatar,
    bio: bio ?? this.bio,
    dob: dob ?? this.dob,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      isProducer: json['is_producer'],
      isCompleted: json['is_completed'],
      avatar: json['avatar'],
      bio: json['bio'],
      dob: json['dob'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'username': username,
      'is_producer': isProducer,
      'avatar': avatar,
      'bio': bio,
      'address': address,
      'dob': dob,
    };
  }
}

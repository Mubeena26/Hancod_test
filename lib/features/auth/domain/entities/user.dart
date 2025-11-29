class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;

  User({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}


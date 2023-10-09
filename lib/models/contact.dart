class Contact {
  int? id;
  String name;
  String email;
  String phone;
  String? imagePath;

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imagePath': imagePath,
    };
  }
}

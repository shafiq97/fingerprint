class User {
  final int id;
  final String username;
  final String password;
  final String imageUrl; // Assuming you store or can derive the image URL

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.imageUrl});

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'],
        username: data['username'],
        password: data['password'],
        imageUrl: data['imageUrl'], // Make sure to handle this in your database
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'imageUrl': imageUrl,
    };
  }
}

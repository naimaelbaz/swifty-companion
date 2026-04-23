class User {
  String login;
  String displayName;
  String email;
  String phone;
  String imageUrl;
  String location;
  int wallet;
  double level;
  List<dynamic> skills;
  List<dynamic> projects;

  User ({
    required this.login,
    required this.displayName,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.location,
    required this.wallet,
    required this.level,
    required this.skills,
    required this.projects,
  });

  factory User.fromJson(Map<String, dynamic> json){

    final List<dynamic> cursusUsers = json['cursus_users'];
    final mainCursus = cursusUsers.firstWhere(
      (c) => c['cursus_id'] == 21,
      orElse: () => cursusUsers.isNotEmpty ? cursusUsers[0] : {},
    );
    return User(
      login: json['login'],
      displayName: json['displayname'],
      phone: json['phone'] ?? 'hidden',
      email: json['email'],
      imageUrl: json['image']?['link'] ?? '',
      location: json['location'] ?? 'unavailable',
      wallet: json['wallet'],
      level: mainCursus.isNotEmpty
          ? (mainCursus['level'] ?? 0.0).toDouble()
          : 0.0,
      skills: mainCursus['skills'] ?? [],
      projects: (json['projects_users'] as List).where((p) {
          final cursusIds = p['cursus_ids'] as List;
          return cursusIds.contains(21);
        }).toList(),
  );
  }
}

class Coalition {
  final String name;
  final String imageUrl;
  final String color;

  Coalition ({
    required this.name,
    required this.imageUrl,
    required this.color,
    
  });

  factory Coalition.fromJson(Map<String, dynamic> json){
    return Coalition(
      name: json['name'],
      imageUrl: json['cover_url'] ?? '', 
      color: json['color'] ?? '#00babc',
      );
  }
}
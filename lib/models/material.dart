class Material {
  final int id;
  final String nom;
  final double densiteTheoriqueMin;
  final double densiteTheoriqueMax;

  Material({
    required this.id,
    required this.nom,
    required this.densiteTheoriqueMin,
    required this.densiteTheoriqueMax,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'] as int,
      nom: json['nom'] as String,
      densiteTheoriqueMin: json['densite_theorique_min'] as double,
      densiteTheoriqueMax: json['densite_theorique_max'] as double,
    );
  }
}
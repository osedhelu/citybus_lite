class BusRouteEntity {
  const BusRouteEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.from,
    required this.to,
    required this.description,
    required this.stops,
    this.isFavorite = false,
  });

  final int id;
  final String code;
  final String name;
  final String from;
  final String to;
  final String description;
  final List<String> stops;
  final bool isFavorite;

  BusRouteEntity copyWith({
    int? id,
    String? code,
    String? name,
    String? from,
    String? to,
    String? description,
    List<String>? stops,
    bool? isFavorite,
  }) {
    return BusRouteEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      from: from ?? this.from,
      to: to ?? this.to,
      description: description ?? this.description,
      stops: stops ?? List<String>.from(this.stops),
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory BusRouteEntity.fromJson(Map<String, dynamic> json) {
    return BusRouteEntity(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      description: json['description'] as String,
      stops: (json['stops'] as List<dynamic>).cast<String>(),
      isFavorite: (json['isFavorite'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'from': from,
      'to': to,
      'description': description,
      'stops': stops,
      'isFavorite': isFavorite,
    };
  }

  static List<BusRouteEntity> fromListJson(List<dynamic> json) {
    return json
        .map(
          (routeJson) =>
              BusRouteEntity.fromJson(routeJson as Map<String, dynamic>),
        )
        .toList();
  }
}

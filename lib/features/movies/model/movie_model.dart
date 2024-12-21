class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double rating;
  bool isFavorite;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.rating,
    this.isFavorite = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? json['posterPath'],
      overview: json['overview'],
      rating: (json['vote_average'] ?? json['rating'] as num).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'rating': rating,
        'isFavorite': isFavorite,
      };
}

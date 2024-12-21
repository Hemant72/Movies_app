import 'package:movies_app/core/network/api_client.dart';
import 'package:movies_app/features/movies/model/movie_model.dart';

class MoviesService {
  final ApiService _apiService = ApiService();

  Future<List<MovieModel>> getMovies(int page) async {
    final response = await _apiService.get(
      '/movie/popular',
      params: {'page': page},
    );
    return (response.data['results'] as List)
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  }

  Future<MovieModel> getMovieDetails(String movieId) async {
    final response = await _apiService.get('/movie/$movieId');
    return MovieModel.fromJson(response.data);
  }
}

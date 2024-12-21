part of 'movie_bloc.dart';

@immutable
class MoviesState {
  final List<MovieModel> movies;
  final bool isLoading;
  final bool hasError;
  final int currentPage;

  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.hasError = false,
    this.currentPage = 1,
  });

  MoviesState copyWith({
    List<MovieModel>? movies,
    bool? isLoading,
    bool? hasError,
    int? currentPage,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

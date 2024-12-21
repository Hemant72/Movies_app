import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/model/movie_model.dart';
import 'package:movies_app/features/movies/services/movie_service.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MoviesState> {
  final _service = MoviesService();
  MovieBloc() : super(MoviesState()) {
    on<FetchMovies>(_onFetchMovies);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MoviesState> emit) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    try {
      final movies = await _service.getMovies(state.currentPage);
      emit(state.copyWith(
        movies: [...state.movies, ...movies],
        currentPage: state.currentPage + 1,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(hasError: true, isLoading: false));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<MoviesState> emit) {
    final updatedMovies = state.movies.map((movie) {
      if (movie.id == event.movie.id) {
        movie.isFavorite = !movie.isFavorite;
      }
      return movie;
    }).toList();
    emit(state.copyWith(movies: updatedMovies));
  }
}

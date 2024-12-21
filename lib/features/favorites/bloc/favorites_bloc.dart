import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/core/storage/storage_service.dart';
import 'package:movies_app/features/movies/model/movie_model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final _storageService = StorageService();
  FavoritesBloc() : super(FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    add(LoadFavorites());
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final favorites = await _storageService.getFavorites();
      emit(state.copyWith(favorites: favorites, isLoading: false));
    } catch (e) {
      emit(state.copyWith(favorites: [], isLoading: false));
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<FavoritesState> emit) async {
    try {
      final movie = event.movie..isFavorite = true;
      await _storageService.addFavorite(movie);
      final updatedFavorites = [...state.favorites, movie];
      emit(state.copyWith(favorites: updatedFavorites));
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<FavoritesState> emit) async {
    try {
      final movie = event.movie..isFavorite = false;
      await _storageService.removeFavorite(movie);
      final updatedFavorites =
          state.favorites.where((m) => m.id != movie.id).toList();
      emit(state.copyWith(favorites: updatedFavorites));
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '0ff4fa8a93aed15cc7975401b8ac6793'; // Ideally should be stored securely
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Helper method to handle the HTTP request and error handling
  Future<Map<String, dynamic>> _fetchData(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from $endpoint: ${response.statusCode}');
    }
  }


Future<List<dynamic>> getMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/discover/movie?with_genres=$genreId&api_key=0ff4fa8a93aed15cc7975401b8ac6793'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // Mengembalikan daftar film
    } else {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  }



  // Fetch popular movies with pagination support
  Future<List<dynamic>> getPopularMovies({int page = 1}) async {
    final endpoint = '/movie/popular?api_key=$apiKey&language=en-US&page=$page';
    final data = await _fetchData(endpoint);
    return data['results'];
  }

  // Fetch movie details by movieId
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final endpoint = '/movie/$movieId?api_key=$apiKey&language=en-US';
    return await _fetchData(endpoint);
  }

  // Fetch movie categories (genres)
  Future<List<dynamic>> getCategories() async {
    final endpoint = '/genre/movie/list?api_key=$apiKey&language=en-US';
    final data = await _fetchData(endpoint);
    return data['genres'];
  }

  // Search movies by title with pagination
  Future<List<dynamic>> searchMovies(String query, {int page = 1}) async {
    final endpoint = '/search/movie?api_key=$apiKey&language=en-US&page=$page&query=$query';
    final data = await _fetchData(endpoint);
    return data['results'];
  }

  // Fetch the latest movie (returns a single movie as a list with one element)
  Future<List<dynamic>> getNewestMovies() async {
    final endpoint = '/movie/latest?api_key=$apiKey&language=en-US';
    final data = await _fetchData(endpoint);
    return [data]; // Wrapping the single movie in a list
  }
}

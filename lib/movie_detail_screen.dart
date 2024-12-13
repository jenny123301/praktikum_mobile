import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Map<String, dynamic>> _movieDetails;

  @override
  void initState() {
    super.initState();
    _movieDetails = ApiService().getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          }

          var movie = snapshot.data!;
          var posterPath = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
          var backdropPath = 'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}';

          return SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: backdropPath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text(
                  movie['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CachedNetworkImage(
                  imageUrl: posterPath,
                  width: 150,
                  height: 225,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    movie['overview'],
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

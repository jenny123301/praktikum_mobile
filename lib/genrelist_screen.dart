import 'package:flutter/material.dart';
import 'api_service.dart'; // Pastikan ini ada untuk akses API
import 'package:cached_network_image/cached_network_image.dart';
import 'home_screen.dart';
import 'movie_detail_screen.dart';

class GenreListScreen extends StatefulWidget {
  @override
  _GenreListScreenState createState() => _GenreListScreenState();
}

class _GenreListScreenState extends State<GenreListScreen> {
  final List<Map<String, dynamic>> genres = [
    {'id': 35, 'icon': Icons.theater_comedy, 'name': 'Comedy'},
    {'id': 28, 'icon': Icons.sports_kabaddi, 'name': 'Action'},
    {'id': 10749, 'icon': Icons.favorite, 'name': 'Romance'},
    {'id': 878, 'icon': Icons.science, 'name': 'Sci-Fi'},
    {'id': 53, 'icon': Icons.psychology, 'name': 'Thriller'},
  ];

  int? selectedGenreId;

  Future<List<dynamic>> _fetchMoviesByGenre(int genreId) {
    return ApiService()
        .getMoviesByGenre(genreId); // Mengambil film berdasarkan genre
  }

  Widget _buildMovieGrid(List<dynamic> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        var movie = movies[index];
        var posterPath =
            'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

        return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: posterPath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text('Genres'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Genre selection section
          Container(
            height: 120,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                final isSelected = genre['id'] == selectedGenreId;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGenreId = genre['id'];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 97, 4, 4) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color.fromARGB(255, 97, 4, 4) : Colors.grey,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          genre['icon'],
                          color: isSelected ? Colors.white : const Color.fromARGB(255, 97, 4, 4),
                        ),
                        SizedBox(height: 8),
                        Text(
                          genre['name'],
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isSelected ? Colors.white : const Color.fromARGB(255, 97, 4, 4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Movies grid section
          Expanded(
            child: selectedGenreId == null
                ? Center(
                    child: Text(
                      'Please select a genre to view movies',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : FutureBuilder<List<dynamic>>(
                    future: _fetchMoviesByGenre(selectedGenreId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No movies found for this genre.'),
                        );
                      }
                      if (selectedGenreId == null) {
                        return Center(
                          child: Text('Please select a genre to view movies'),
                        );
                      }

                      return _buildMovieGrid(snapshot.data!);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

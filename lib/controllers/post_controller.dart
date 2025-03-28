import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

// Future : un résultat de calcul disponible plus tard
// Les fonctions asynchrones renvoient un obejt Future
class PostController {
  Future<List<Post>> fetchPosts() async {
    // requete get
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Échec du chargement des posts');
    }
  }
}

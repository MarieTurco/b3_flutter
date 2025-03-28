import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final PostController postController = PostController();
  final ScrollController _scrollController = ScrollController();

  List<Post> _posts = []; // Liste de tous les posts récupérés
  List<Post> _visiblePosts = []; // Liste des posts actuellement affichés
  bool _isInitialLoading = true; // Indicateur de chargement initial
  bool _isLoadingMore = false; // Indicateur de chargement de plus d'articles
  int _batchSize = 20; // Nombre d'articles à charger à la fois

  @override
  void initState() {
    super.initState();
    _loadInitialPosts(); // Charger les 20 premiers articles
    _scrollController.addListener(_onScroll); // Ajouter le listener pour le scroll
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialPosts() async {
    try {
      final posts = await postController.fetchPosts(); // Charger tous les posts
      setState(() {
        _posts = posts;
        _visiblePosts = _posts.take(_batchSize).toList(); // Charger le premier lot
        _isInitialLoading = false; // Fin du chargement initial
      });
    } catch (e) {
      print('Erreur de chargement des posts: $e');
      setState(() {
        _isInitialLoading = false; // Assurer que le chargement se termine même en cas d'erreur
      });
      // Optionnel : afficher un message d'erreur à l'utilisateur
    }
  }

  void _onScroll() {
    // Vérifier si l'utilisateur est proche du bas de la liste
    // _scrollController.position.pixels : position actuelle
    // _scrollController.position.maxScrollExtent : longueur totale scrollable
    // le -100 est pour commencer à charger avant d'arriver à la fin de la page
    // !_isLoadingMore : assure qu'aucun chargement n'est déjà en cours
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() async {
    // Si les posts sont déjà chargés, on arrete
    if (_visiblePosts.length >= _posts.length) return;

    // affichage du rond de chargement
    setState(() {
      _isLoadingMore = true;
    });

    // Simuler un petit délai pour montrer le chargement
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculer le début et la fin du prochain lot de posts
    int start = _visiblePosts.length;
    int end = start + _batchSize;

    // S'assurer de ne pas dépasser le nombre total de posts
    end = end > _posts.length ? _posts.length : end;

    // Ajouter le nouveau lot de posts
    setState(() {
      _visiblePosts.addAll(_posts.sublist(start, end));
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Liste vide
    if (_posts.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Aucun article disponible'),
        ),
      );
    }

    // Liste des articles avec chargement progressif
    return Scaffold(
      body: ListView.builder(
            controller: _scrollController,
            itemCount: _visiblePosts.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Articles existants
              if (index < _visiblePosts.length) {
                final post = _visiblePosts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(post.title),
                    leading: CircleAvatar(child: Text('${post.id}')),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailView(post: post),
                        ),
                      );
                    },
                  ),
                );
              }
              // Indicateur de chargement en bas de liste
              else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
      );
  }
}

// La classe PostDetailView reste inchangée
class PostDetailView extends StatelessWidget {
  final Post post;

  const PostDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          post.body,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
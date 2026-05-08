import 'package:flutter/material.dart';

import '../core/facades/potion_facade.dart';
import '../models/potion_comment.dart';
import '../models/potion_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.facade,
  });

  final PotionFacade facade;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PotionPost>> _potionsFuture;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _imagenesController = TextEditingController();

  bool _isSaving = false;

  PotionFacade get _facade => widget.facade;

  String? get _username => _facade.getUser()?.username;

  @override
  void initState() {
    super.initState();
    _potionsFuture = _facade.fetchPotions();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _duracionController.dispose();
    _imagenesController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _potionsFuture = _facade.fetchPotions();
    });
  }

  Future<void> _logout() async {
    await _facade.logout();

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _createPotion() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final duracionText = _duracionController.text.trim();
    final imagenesText = _imagenesController.text.trim();

    final duracionSegundos = int.tryParse(duracionText);

    final imagenes = imagenesText
        .split(',')
        .map((image) => image.trim())
        .where((image) => image.isNotEmpty)
        .toList();

    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        duracionSegundos == null ||
        duracionSegundos <= 0 ||
        imagenes.isEmpty) {
      _showSnack(
        'Completa nombre, descripción, duración e imágenes.',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _facade.createPotion(
        nombre: nombre,
        descripcion: descripcion,
        duracionSegundos: duracionSegundos,
        imagenes: imagenes,
      );

      _nombreController.clear();
      _descripcionController.clear();
      _duracionController.clear();
      _imagenesController.clear();

      _refresh();
      _showSnack('Poción registrada correctamente.');
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deletePotion(int id) async {
    try {
      await _facade.deletePotion(id);
      _refresh();
      _showSnack('Poción eliminada.');
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    }
  }

  Future<void> _reactToPotion(int potionPostId, String type) async {
    try {
      await _facade.reactToPotion(
        potionPostId: potionPostId,
        type: type,
      );

      _refresh();
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    }
  }

  Future<void> _openComments(PotionPost potion) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _PotionCommentsSheet(
          facade: _facade,
          potion: potion,
          onChanged: _refresh,
        );
      },
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _facade.getUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pociones'),
        actions: [
          Center(
            child: Text('@${user?.username ?? 'usuario'}'),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
          await _potionsFuture;
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildForm(),
            const SizedBox(height: 20),
            const Text(
              'Pociones registradas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPotionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Nueva poción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
              maxLines: 3,
            ),
            TextField(
              controller: _duracionController,
              decoration: const InputDecoration(
                labelText: 'Duración en segundos',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imagenesController,
              decoration: const InputDecoration(
                labelText: 'Imágenes',
                hintText: 'URL o varias URL separadas por coma',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isSaving ? null : _createPotion,
              child: Text(_isSaving ? 'Guardando...' : 'Guardar poción'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPotionList() {
    return FutureBuilder<List<PotionPost>>(
      future: _potionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final potions = snapshot.data ?? [];

        if (potions.isEmpty) {
          return const Text('No hay pociones registradas.');
        }

        return Column(
          children: potions.map(_buildPotionCard).toList(),
        );
      },
    );
  }

  Widget _buildPotionCard(PotionPost potion) {
    final isMine = potion.postedByUsername == _username;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (potion.firstImage != null)
              Image.network(
                potion.firstImage!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text('No se pudo cargar la imagen'),
                    ),
                  );
                },
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    potion.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isMine)
                  IconButton(
                    onPressed: () => _deletePotion(potion.id),
                    icon: const Icon(Icons.delete),
                  ),
              ],
            ),
            Text(potion.descripcion),
            const SizedBox(height: 6),
            Text('Duración: ${potion.duracionSegundos} segundos'),
            const SizedBox(height: 6),
            Text('Comentarios: ${potion.commentsCount}'),
            Text('Reacciones: ${potion.reactionsCount}'),
            if (potion.postedByUsername != null)
              Text('Publicado por: @${potion.postedByUsername}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => _openComments(potion),
                  child: const Text('Comentarios'),
                ),
                OutlinedButton(
                  onPressed: () =>
                      _reactToPotion(potion.id, 'REACTION_LIKE'),
                  child: const Text('Me gusta'),
                ),
                OutlinedButton(
                  onPressed: () =>
                      _reactToPotion(potion.id, 'REACTION_LOVE'),
                  child: const Text('Me encanta'),
                ),
                OutlinedButton(
                  onPressed: () =>
                      _reactToPotion(potion.id, 'REACTION_FAVORITE'),
                  child: const Text('Favorita'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PotionCommentsSheet extends StatefulWidget {
  const _PotionCommentsSheet({
    required this.facade,
    required this.potion,
    required this.onChanged,
  });

  final PotionFacade facade;
  final PotionPost potion;
  final VoidCallback onChanged;

  @override
  State<_PotionCommentsSheet> createState() => _PotionCommentsSheetState();
}

class _PotionCommentsSheetState extends State<_PotionCommentsSheet> {
  late Future<List<PotionComment>> _commentsFuture;

  final TextEditingController _commentController = TextEditingController();

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _commentsFuture = widget.facade.fetchPotionComments(widget.potion.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _refreshComments() {
    setState(() {
      _commentsFuture = widget.facade.fetchPotionComments(widget.potion.id);
    });
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();

    if (text.isEmpty) return;

    setState(() => _isSending = true);

    try {
      await widget.facade.createPotionComment(
        potionPostId: widget.potion.id,
        content: text,
      );

      _commentController.clear();
      _refreshComments();
      widget.onChanged();
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            ListTile(
              title: const Text('Comentarios'),
              subtitle: Text(widget.potion.nombre),
              trailing: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PotionComment>>(
                future: _commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final comments = snapshot.data ?? [];

                  if (comments.isEmpty) {
                    return const Center(
                      child: Text('No hay comentarios.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      return ListTile(
                        title: Text(comment.content),
                        subtitle: Text('@${comment.commentedByUsername}'),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un comentario...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSending ? null : _sendComment,
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
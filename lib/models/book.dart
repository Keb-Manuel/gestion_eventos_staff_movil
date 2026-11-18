
class Book {
  final String key;
  final String title;
  final String author;
  final int? year;
  final int? coverId;
  final String notes;
  final String? photoPath;
  final bool isLocal;

  const Book({
    required this.key,
    required this.title,
    required this.author,
    this.year,
    this.coverId,
    this.notes = '',
    this.photoPath,
    this.isLocal = false,
  });

  // Google Books utiliza el ID del volumen para obtener la portada.
  String? get coverUrl => key.isEmpty
      ? null
      : 'https://books.google.com/books/content?id=$key&printsec=frontcover&img=1&zoom=1&source=gbs_api';

  factory Book.fromApi(Map<String, dynamic> json) {
    final volumeInfo =
        json['volumeInfo'] as Map<String, dynamic>? ?? {};

    final authors = (volumeInfo['authors'] as List?)
            ?.whereType<String>()
            .toList() ??
        [];

    final publishedDate =
        volumeInfo['publishedDate']?.toString() ?? '';

    final year = publishedDate.length >= 4
        ? int.tryParse(publishedDate.substring(0, 4))
        : null;

    return Book(
      key: (json['id'] ?? '').toString(),
      title: (volumeInfo['title'] ?? 'Sin título').toString(),
      author: authors.isEmpty
          ? 'Autor desconocido'
          : authors.join(', '),
      year: year,
    );
  }

  factory Book.fromMap(Map<String, Object?> map) => Book(
        key: map['book_key'] as String,
        title: map['title'] as String,
        author: map['author'] as String,
        year: map['year'] as int?,
        coverId: map['cover_id'] as int?,
        notes: (map['notes'] as String?) ?? '',
        photoPath: map['photo_path'] as String?,
        isLocal: true,
      );

  Map<String, Object?> toMap() => {
        'book_key': key,
        'title': title,
        'author': author,
        'year': year,
        'cover_id': coverId,
        'notes': notes,
        'photo_path': photoPath,
      };
}

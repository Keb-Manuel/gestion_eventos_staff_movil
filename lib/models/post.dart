class Post {
  final int id;
  final int? remoteId;
  final int userId;
  final String title;
  final String body;
  final bool pendienteSincronizar;

  const Post({
    required this.id,
    required this.remoteId,
    required this.userId,
    required this.title,
    required this.body,
    this.pendienteSincronizar = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        remoteId: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
      );

  factory Post.fromRow(Map<String, dynamic> r) => Post(
        id: r['id'] as int,
        remoteId: r['remote_id'] as int?,
        userId: r['user_id'] as int,
        title: r['title'] as String,
        body: r['body'] as String,
        pendienteSincronizar: (r['pendiente_sincronizar'] as int) == 1,
      );

  Post copyWith({
    int? id,
    int? remoteId,
    int? userId,
    String? title,
    String? body,
    bool? pendienteSincronizar,
  }) =>
      Post(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        body: body ?? this.body,
        pendienteSincronizar: pendienteSincronizar ?? this.pendienteSincronizar,
      );
}

class Note {
  int? id;
  String title;
  String content;
  String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Note.formMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? "",
      content: map['content'] as String? ?? "",
      date: map['date'] as String? ?? "",
    );
  }
}

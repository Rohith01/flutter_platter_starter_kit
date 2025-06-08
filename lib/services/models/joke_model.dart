import 'dart:convert';

class Joke {
  Joke({
    required this.type,
    required this.setup,
    required this.punchline,
    required this.id,
  });

  factory Joke.fromRawJson(String str) => Joke.fromJson(json.decode(str));

  factory Joke.fromJson(Map<String, dynamic> json) => Joke(
    type: json['type'],
    setup: json['setup'],
    punchline: json['punchline'],
    id: json['id'],
  );
  String type;
  String setup;
  String punchline;
  int id;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    'type': type,
    'setup': setup,
    'punchline': punchline,
    'id': id,
  };
}

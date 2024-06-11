class Repository {
  final String name;
  final String description;
  final String htmlUrl;
  final int stargazersCount;
  String? lastCommitMessage;
  DateTime? lastCommitDate;
  String? lastCommitAuthor;

  Repository({
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    this.lastCommitMessage,
    this.lastCommitDate,
    this.lastCommitAuthor,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'] ?? '',
      htmlUrl: json['html_url'],
      stargazersCount: json['stargazers_count'],
    );
  }

  void updateLastCommit(String message, DateTime date, String author) {
    lastCommitMessage = message;
    lastCommitDate = date;
    lastCommitAuthor = author;
  }
}

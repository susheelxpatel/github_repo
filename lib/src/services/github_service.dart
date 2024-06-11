import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:github_repos/src/models/repository.dart';

class GithubService {
  static const String apiUrl =
      'https://api.github.com/users/freeCodeCamp/repos';

  Future<List<Repository>> fetchRepositories() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Repository> repositories =
          body.map((dynamic item) => Repository.fromJson(item)).toList();
      return repositories;
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<void> fetchLastCommit(Repository repo) async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/freeCodeCamp/${repo.name}/commits'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      if (body.isNotEmpty) {
        final lastCommit = body.first;
        final commitMessage = lastCommit['commit']['message'];
        final commitDate =
            DateTime.parse(lastCommit['commit']['committer']['date']);
        repo.lastCommitMessage = commitMessage;
        repo.lastCommitDate = commitDate;
      }
    } else {
      throw Exception('Failed to load commits for ${repo.name}');
    }
  }
}

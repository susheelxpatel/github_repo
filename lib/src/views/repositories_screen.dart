import 'package:flutter/material.dart';
import 'package:github_repos/src/models/repository.dart';
import 'package:github_repos/src/services/github_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoriesScreen extends StatefulWidget {
  const RepositoriesScreen({super.key});

  @override
  _RepositoriesScreenState createState() => _RepositoriesScreenState();
}

class _RepositoriesScreenState extends State<RepositoriesScreen> {
  late Future<List<Repository>> futureRepositories;
  final GithubService _githubService = GithubService();

  @override
  void initState() {
    super.initState();
    futureRepositories = _githubService.fetchRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub Repositories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Repository>>(
        future: futureRepositories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No repositories found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Repository repo = snapshot.data![index];
              _githubService.fetchLastCommit(repo).then((_) {
                setState(() {});
              });
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: RepositoryListTile(repo: repo),
                  ));
            },
          );
        },
      ),
    );
  }
}

class RepositoryListTile extends StatelessWidget {
  final Repository repo;

  const RepositoryListTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(repo.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(repo.description),
          if (repo.lastCommitMessage != null)
            Text(
                'Last commit: ${repo.lastCommitMessage} by ${repo.lastCommitAuthor} on ${repo.lastCommitDate}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.yellow),
          const SizedBox(width: 5),
          Text(repo.stargazersCount.toString()),
        ],
      ),
      onTap: () => _launchURL(Uri.parse(repo.htmlUrl)),
    );
  }

  void _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}

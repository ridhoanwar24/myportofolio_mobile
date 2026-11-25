import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widget/left_drawer.dart';
import 'package:provider/provider.dart';

//import 'package:myportfolio_mobile/screens/project_detail_screen.dart';

class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experienceFuture;

  @override
  void initState() {
    super.initState();
    _experienceFuture = context.read<ApiClient>().getExperience();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getExperience();
    setState(() {
      _experienceFuture = future;
    });
    await future;
  }

  String _period(Experience e) {
    final start = e.startedAt?.year.toString() ?? '?';
    final end = e.isOngoing ? 'Present' : e.endedAt!.year.toString();
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Experiences')),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Experience>>(
        future: _experienceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load experiences: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final experiences = snapshot.data ?? const <Experience>[];
          if (experiences.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const Center(child: Text("No experiences found.")),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return Card(
                  child: ListTile(
                    title: Text(experience.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${experience.category.name} · ${_period(experience)}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          experience.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    //TODO: onTap
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

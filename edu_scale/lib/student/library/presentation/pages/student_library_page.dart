import 'package:edu_scale/core/file_chache_manager/file_chache_manager.dart';
import 'package:edu_scale/core/helper_functions/get_file_icon.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/library/data/models/student_subjects_based_on_timetable_model.dart';
import 'package:edu_scale/student/library/presentation/providers/student_library_resources_provider.dart';
import 'package:edu_scale/student/library/presentation/providers/student_library_subjects_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentLibraryPage extends StatefulWidget {
  const StudentLibraryPage({super.key});

  @override
  State<StudentLibraryPage> createState() => _StudentLibraryPageState();
}

class _StudentLibraryPageState extends State<StudentLibraryPage> {
  StudentSubjectsBasedOnTimetableModel? selectedSubject;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final subjectsProvider = context.read<StudentLibrarySubjectsProvider>();
      final resourcesProvider = context.read<StudentLibraryResourcesProvider>();

      await subjectsProvider.getSubjects();

      if (!mounted) return;

      if (subjectsProvider.subjects.isNotEmpty) {
        final firstSubject = subjectsProvider.subjects.first;

        setState(() {
          selectedSubject = firstSubject;
        });

        await resourcesProvider.getResources(firstSubject.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectsProvider = context.watch<StudentLibrarySubjectsProvider>();
    final resourcesProvider = context.watch<StudentLibraryResourcesProvider>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // ---------- Header ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
              decoration: BoxDecoration(
                color: AppStyle.colors.brown,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                image: const DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/pics/shape_3.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppStyle.colors.surface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Library',
                        style: AppStyle.theme.primaryTextTheme.bodyLarge
                            ?.copyWith(
                              color: AppStyle.colors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            if (subjectsProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: LinearProgressIndicator(),
              )
            else if (subjectsProvider.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  subjectsProvider.errorMessage,
                  style: TextStyle(color: AppStyle.colors.red),
                ),
              )
            else if (subjectsProvider.subjects.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No subjects assigned to you.'),
              )
            else
              SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: subjectsProvider.subjects.map((subject) {
                      final isSelected = selectedSubject?.id == subject.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppStyle.colors.black
                                : AppStyle.colors.grey,
                            foregroundColor: isSelected
                                ? AppStyle.colors.grey
                                : AppStyle.colors.black,
                          ),
                          onPressed: () async {
                            setState(() {
                              selectedSubject = subject;
                            });

                            await context
                                .read<StudentLibraryResourcesProvider>()
                                .getResources(subject.id);
                          },
                          child: Text(subject.name),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (resourcesProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (resourcesProvider.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        resourcesProvider.errorMessage,
                        style: TextStyle(color: AppStyle.colors.red),
                      ),
                    );
                  }

                  if (resourcesProvider.resources.isEmpty) {
                    return const Center(child: Text('No resources available.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: resourcesProvider.resources.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final resource = resourcesProvider.resources[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () async {
                            await FileCacheManager.openLibraryFile(
                              resource.fileUrl,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppStyle.colors.grey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    getFileIcon(resource.fileType),
                                    size: 32,
                                    color: AppStyle.colors.brown,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resource.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${resource.fileType.toUpperCase()} • ${resource.fileSizeInKb} KB',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'dd MMM yyyy • hh:mm a',
                                        ).format(resource.createdAt.toLocal()),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: AppStyle.colors.brown,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

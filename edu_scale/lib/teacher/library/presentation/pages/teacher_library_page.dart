import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/file_chache_manager/file_chache_manager.dart';
import 'package:edu_scale/core/helper_functions/get_file_icon.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/library/data/models/teacher_library_grade_class_model.dart';
import 'package:edu_scale/teacher/library/presentation/providers/teacher_library_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TeacherLibraryPage extends StatefulWidget {
  const TeacherLibraryPage({super.key});

  @override
  State<TeacherLibraryPage> createState() => _TeacherLibraryPageState();
}

class _TeacherLibraryPageState extends State<TeacherLibraryPage> {
  TeacherLibraryGradeClassModel? selectedGradeClass;
  final TextEditingController fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<TeacherLibraryProvider>();
      await provider.getGradeClasses();

      if (!mounted) return;
      if (provider.classes.isNotEmpty) {
        setState(() {
          selectedGradeClass = provider.classes.first;
        });

        await provider.loadResources(
          gradeId: provider.classes.first.gradeId,
          classId: provider.classes.first.classId,
        );
      }
    });
  }

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherLibraryProvider>();

    return WillPopScope(
      onWillPop: () async {
        // Prevent going back while an upload is in progress
        if (provider.isUploading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload in progress. Please wait...')),
          );
          return false;
        }
        return true;
      },
      child: SafeArea(
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
                  image: DecorationImage(
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
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // ---------- Grade / Class Filter Row ----------
              Builder(
                builder: (context) {
                  if (provider.isLoadingGradeClasses) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: LinearProgressIndicator(),
                    );
                  }
                  if (provider.gradeClassesErrorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        provider.gradeClassesErrorMessage!,
                        style: TextStyle(color: AppStyle.colors.red),
                      ),
                    );
                  }
                  if (provider.classes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No classes assigned to you.'),
                    );
                  }

                  return SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: provider.classes.map((item) {
                          final isSelected = selectedGradeClass == item;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
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
                              onPressed: () {
                                setState(() {
                                  selectedGradeClass = item;
                                });
                                provider.loadResources(
                                  gradeId: item.gradeId,
                                  classId: item.classId,
                                );
                              },
                              child: Text(
                                '${item.gradeName} - ${item.className}',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),

              // ---------- Resources List ----------
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoadingResources) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.resourcesErrorMessage != null) {
                      return Center(
                        child: Text(
                          provider.resourcesErrorMessage!,
                          style: TextStyle(color: AppStyle.colors.red),
                        ),
                      );
                    }
                    if (selectedGradeClass == null) {
                      return const Center(
                        child: Text('Select a grade/class to view resources.'),
                      );
                    }
                    if (provider.libraryResources.isEmpty) {
                      return const Center(child: Text('No resources found.'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.libraryResources.length,
                      itemBuilder: (context, index) {
                        final resource = provider.libraryResources[index];
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
                                  // ----- Icon container (white rounded square) -----
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
                                      color: AppStyle.colors.brown, // optional
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // ----- Title & subtitle -----
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
                                        Row(
                                          children: [
                                            Text(
                                              '${resource.fileType.toUpperCase()} • ${resource.fileSizeInKb} KB • ',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            Text(
                                              resource.status,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    resource.status ==
                                                        'pendding'
                                                    ? Colors.grey.shade700
                                                    : resource.status ==
                                                          'approved'
                                                    ? AppStyle.colors.green
                                                    : AppStyle.colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          DateFormat(
                                            'dd MMM yyyy • hh:mm a',
                                          ).format(
                                            resource.createdAt.toLocal(),
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // ----- Trailing arrow -----
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: AppStyle.colors.brown, // or grey
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

          // ---------- Floating Action Button (Upload) ----------
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppStyle.colors.brown,
            foregroundColor: AppStyle.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            onPressed: () => _showUploadDialog(context),
            label: Row(
              children: [
                Icon(CupertinoIcons.add),
                const SizedBox(width: 8),
                Text('Add file'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Upload Form Dialog ----------
  void _showUploadDialog(BuildContext context) {
    final provider = context.read<TeacherLibraryProvider>();

    // Reset error message from previous attempts
    provider.uploadErrorMessage = null;

    showDialog(
      context: context,
      barrierDismissible: !provider.isUploading,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppStyle.colors.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: fileNameController,
                  decoration: const InputDecoration(hintText: 'File name...'),
                ),
                const SizedBox(height: 12),
                if (provider.uploadErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      provider.uploadErrorMessage!,
                      style: TextStyle(color: AppStyle.colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: provider.isUploading
                          ? null
                          : () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.colors.green,
                      ),
                      onPressed: provider.isUploading
                          ? null
                          : () async {
                              if (selectedGradeClass == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select a grade/class first.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (fileNameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a file name.'),
                                  ),
                                );
                                return;
                              }

                              // Close the form dialog
                              Navigator.pop(dialogContext);

                              // Start the upload with progress dialog
                              await _startUpload(
                                context,
                                title: fileNameController.text,
                                gradeId: selectedGradeClass!.gradeId,
                                classId: selectedGradeClass!.classId,
                              );

                              final currentUser =
                                  await AccountManager.currentAccount();

                              PushNotificationsService.sendNotification.sendByTopic(
                                'school-${currentUser?.schoolId}-grade-${selectedGradeClass!.gradeId}-class-${selectedGradeClass!.classId}-student',
                                'Library',
                                'A new file has been uploaded! Click to view.',
                              );
                            },
                      child: const Text('Upload'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- Upload Execution with Progress Dialog ----------
  Future<void> _startUpload(
    BuildContext context, {
    required String title,
    required int gradeId,
    int? classId,
  }) async {
    final provider = context.read<TeacherLibraryProvider>();

    // Show progress dialog (cannot be dismissed)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (progressContext) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back gesture
          child: Dialog(
            backgroundColor: AppStyle.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Uploading...',
                    style: AppStyle.theme.primaryTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please do not close this screen.',
                    style: AppStyle.theme.primaryTextTheme.bodyMedium?.copyWith(
                      color: AppStyle.colors.black.withAlpha(200),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Perform the upload
    await provider.upload(title: title, gradeId: gradeId, classId: classId);

    // Dismiss the progress dialog (it's the topmost dialog)
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Dismiss progress dialog
    }

    // Show result snackbar
    if (provider.uploadErrorMessage != null) {
      // Upload failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: ${provider.uploadErrorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Upload succeeded
      fileNameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Reload resources for the current grade/class
      if (selectedGradeClass != null) {
        provider.loadResources(
          gradeId: selectedGradeClass!.gradeId,
          classId: selectedGradeClass!.classId,
        );
      }
    }
  }
}

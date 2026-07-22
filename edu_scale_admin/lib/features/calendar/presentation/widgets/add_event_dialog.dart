import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/themes.dart';

class AddEventDialog extends StatefulWidget {
  final Future<void> Function({
    required String title,
    required String description,
    required DateTime dayDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  })
  onCreate;

  const AddEventDialog({super.key, required this.onCreate});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool isLoading = false;

  Future<void> pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> pickStartTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        startTime = result;
      });
    }
  }

  Future<void> pickEndTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        endTime = result;
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || startTime == null || endTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields'.tr())));
      return;
    }

    final startMinutes = (startTime!.hour * 60) + startTime!.minute;
    final endMinutes = (endTime!.hour * 60) + endTime!.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End time should be after start time'.tr())),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await widget.onCreate(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        dayDate: selectedDate!,
        startTime: startTime!,
        endTime: endTime!,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: BoxConstraints(maxWidth: 800),
      backgroundColor: AppStyle.colors.surface,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Event'.tr(),
                style: AppStyle.theme.primaryTextTheme.titleMedium,
              ),

              const SizedBox(height: 24),

              // Title
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(hint: Text('Title'.tr())),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required'.tr();
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(hint: Text('Description'.tr())),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required'.tr();
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppStyle.colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'.tr()
                        : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: pickStartTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyle.colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          startTime == null
                              ? 'Start Time'.tr()
                              : startTime!.format(context),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: InkWell(
                      onTap: pickEndTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyle.colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          endTime == null
                              ? 'End Time'.tr()
                              : endTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: Text('Back'.tr()),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submit,
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Add'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

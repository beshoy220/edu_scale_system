import 'package:edu_scale_admin/core/shared_components/builders/responsive_layout_builder.dart';
import 'package:edu_scale_admin/core/app_meta/educational_systems_list.dart';
import 'package:edu_scale_admin/core/app_meta/default_grades_list.dart';
import '../../../dashboard_base/presentation/pages/dashboard_base_page.dart';
import '../providers/school_setup_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetSchoolPage extends StatelessWidget {
  const SetSchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SchoolSetupProvider(),
      child: ResponsiveLayoutBuilder(
        small: const SetSchoolSmallView(),
        medium: const SetSchoolMediumView(),
      ),
    );
  }
}

class SetSchoolSmallView extends StatefulWidget {
  const SetSchoolSmallView({super.key});

  @override
  State<SetSchoolSmallView> createState() => _SetSchoolSmallViewState();
}

class _SetSchoolSmallViewState extends State<SetSchoolSmallView> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting School')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stepper(
              currentStep: _currentStep,
              onStepContinue: _nextStep,
              onStepCancel: _cancelStep,
              steps: [_step1(), _step2(), _step3(), _step4()],
            ),
          ],
        ),
      ),
    );
  }

  Step _step1() {
    return Step(
      title: const Text('Set School Info'),
      content: RepaintBoundary(
        child: Consumer<SchoolSetupProvider>(
          builder: (_, provider, __) => Column(
            children: [
              TextField(
                controller: provider.schoolNameController,
                decoration: const InputDecoration(hintText: 'School Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: provider.schoolAddressController,
                decoration: const InputDecoration(hintText: 'School Address'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownMenu<String>(
                      width: 200,
                      enableFilter: false,
                      requestFocusOnTap: false,
                      initialSelection: provider.selectedEducationalSystem,
                      dropdownMenuEntries: educationalSystemsList
                          .map(
                            (system) =>
                                DropdownMenuEntry(value: system, label: system),
                          )
                          .toList(),
                      onSelected: provider.updateEducationalSystem,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.classCapacityController,
                      decoration: const InputDecoration(
                        hintText: 'Class Capacity...',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

  Step _step2() {
    return Step(
      title: const Text('Set Grades'),
      content: RepaintBoundary(
        child: Consumer<SchoolSetupProvider>(
          builder: (_, provider, __) => Column(
            children: defaultGradesList.map((grade) {
              return Selector<SchoolSetupProvider, bool>(
                selector: (_, p) => p.selectedGrades.contains(grade),
                builder: (_, isSelected, __) => CheckboxListTile(
                  title: Text(grade),
                  value: isSelected,
                  onChanged: (val) => provider.toggleGrade(grade, val),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Step _step3() {
    // Heavy content built only when this step is active
    final isActive = _currentStep == 2;
    return Step(
      title: const Text('Set Classes'),
      content: isActive
          ? RepaintBoundary(
              child: Consumer<SchoolSetupProvider>(
                builder: (_, provider, __) {
                  final selectedGrades = provider.selectedGrades;
                  if (selectedGrades.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No grades selected. Please go back to Step 2.',
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var grade in selectedGrades) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Text(
                            grade,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ...(SchoolSetupProvider
                                    .gradeToAvailableClasses[grade] ??
                                [])
                            .map((className) {
                              return Selector<SchoolSetupProvider, bool>(
                                selector: (_, p) =>
                                    p.isClassSelectedForGrade(grade, className),
                                builder: (_, isSelected, __) =>
                                    CheckboxListTile(
                                      title: Text(className),
                                      value: isSelected,
                                      onChanged: (val) =>
                                          provider.toggleClassForGrade(
                                            grade,
                                            className,
                                            val,
                                          ),
                                      dense: true,
                                    ),
                              );
                            }),
                        const Divider(),
                      ],
                    ],
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Step _step4() {
    return Step(
      title: const Text('Subjects'),
      content: Consumer<SchoolSetupProvider>(
        builder: (_, provider, __) {
          return Column(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  ...provider.availableSubjects.map((subject) {
                    return SizedBox(
                      width: 200,
                      child: CheckboxListTile(
                        title: Text(subject),
                        value: provider.selectedSubjects.contains(subject),
                        onChanged: (val) =>
                            provider.toggleSubject(subject, val),
                      ),
                    );
                  }),

                  SizedBox(
                    width: 200,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final controller = TextEditingController();

                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Add Subject"),
                            content: TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: "Subject name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  provider.addCustomSubject(controller.text);
                                  Navigator.pop(context);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Custom Subject"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      context.read<SchoolSetupProvider>().setUpSchoolInDatabase();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardBasePage()),
      );
    }
  }

  void _cancelStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
}

class SetSchoolMediumView extends StatefulWidget {
  const SetSchoolMediumView({super.key});

  @override
  State<SetSchoolMediumView> createState() => _SetSchoolMediumViewState();
}

class _SetSchoolMediumViewState extends State<SetSchoolMediumView> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting School')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: Stepper(
              elevation: 0,
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: _nextStep,
              onStepCancel: _cancelStep,
              steps: [_step1(), _step2(), _step3(), _step4()],
            ),
          ),
        ),
      ),
    );
  }

  Step _step1() {
    return Step(
      title: const Text('School Info'),
      content: RepaintBoundary(
        child: Consumer<SchoolSetupProvider>(
          builder: (_, provider, __) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: provider.schoolNameController,
                      decoration: const InputDecoration(
                        hintText: 'School Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownMenu<String>(
                      width: double.maxFinite,
                      enableFilter: false,
                      requestFocusOnTap: false,
                      initialSelection: provider.selectedEducationalSystem,
                      dropdownMenuEntries: educationalSystemsList
                          .map(
                            (system) =>
                                DropdownMenuEntry(value: system, label: system),
                          )
                          .toList(),
                      onSelected: provider.updateEducationalSystem,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: provider.schoolAddressController,
                decoration: const InputDecoration(hintText: 'School Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: provider.classCapacityController,
                    decoration: const InputDecoration(
                      hintText: 'Class Capacity...',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Step _step2() {
    return Step(
      title: const Text('Grades'),
      content: RepaintBoundary(
        child: Consumer<SchoolSetupProvider>(
          builder: (_, provider, __) => Wrap(
            spacing: 16,
            runSpacing: 8,
            children: defaultGradesList.map((grade) {
              return Selector<SchoolSetupProvider, bool>(
                selector: (_, p) => p.selectedGrades.contains(grade),
                builder: (_, isSelected, __) => SizedBox(
                  width: 200,
                  child: CheckboxListTile(
                    title: Text(grade),
                    value: isSelected,
                    onChanged: (val) => provider.toggleGrade(grade, val),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Step _step3() {
    final isActive = _currentStep == 2;
    return Step(
      title: const Text('Classes'),
      content: isActive
          ? RepaintBoundary(
              child: Consumer<SchoolSetupProvider>(
                builder: (_, provider, __) {
                  final selectedGrades = provider.selectedGrades;
                  if (selectedGrades.isEmpty) {
                    return const SizedBox(
                      width: 300,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No grades selected. Please go back to Step 2.',
                          ),
                        ),
                      ),
                    );
                  }
                  return Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: selectedGrades.map((grade) {
                      final availableClasses =
                          SchoolSetupProvider.gradeToAvailableClasses[grade] ??
                          [];
                      return SizedBox(
                        width: 300,
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  grade,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Divider(),
                                ...availableClasses.map((className) {
                                  return Selector<SchoolSetupProvider, bool>(
                                    selector: (_, p) =>
                                        p.isClassSelectedForGrade(
                                          grade,
                                          className,
                                        ),
                                    builder: (_, isSelected, __) =>
                                        CheckboxListTile(
                                          title: Text(className),
                                          value: isSelected,
                                          onChanged: (val) =>
                                              provider.toggleClassForGrade(
                                                grade,
                                                className,
                                                val,
                                              ),
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Step _step4() {
    return Step(
      title: const Text('Subjects'),
      content: Consumer<SchoolSetupProvider>(
        builder: (_, provider, __) {
          return Column(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  ...provider.availableSubjects.map((subject) {
                    return SizedBox(
                      width: 200,
                      child: CheckboxListTile(
                        title: Text(subject),
                        value: provider.selectedSubjects.contains(subject),
                        onChanged: (val) =>
                            provider.toggleSubject(subject, val),
                      ),
                    );
                  }),

                  SizedBox(
                    width: 200,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final controller = TextEditingController();

                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Add Subject"),
                            content: TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: "Subject name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  provider.addCustomSubject(controller.text);
                                  Navigator.pop(context);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Custom Subject"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      context.read<SchoolSetupProvider>().setUpSchoolInDatabase();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardBasePage()),
      );
    }
  }

  void _cancelStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
}

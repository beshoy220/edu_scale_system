// import 'package:edu_scale/core/account_manager/account_manager.dart';
// import 'package:edu_scale/core/themes/themes.dart';
// import 'package:edu_scale/teacher/quizzes/data/models/teacher_quiz_grade_class_model.dart';
// import 'package:edu_scale/teacher/quizzes/presentation/pages/teacher_quizzes_page.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // This file is AI gerated and may need refactoring ASAP

// int _idCounter = 0;
// int _nextId() => _idCounter++;

// class TeacherQuizOptionModel {
//   final int id;
//   final TextEditingController controller;
//   TeacherQuizOptionModel({String text = ''})
//     : id = _nextId(),
//       controller = TextEditingController(text: text);
// }

// class TeacherQuizQuestionModel {
//   final int id;
//   final TextEditingController titleController;
//   final List<TeacherQuizOptionModel> options;
//   int correctIndex; // -1 = none selected

//   TeacherQuizQuestionModel()
//     : id = _nextId(),
//       titleController = TextEditingController(),
//       options = [
//         TeacherQuizOptionModel(),
//         TeacherQuizOptionModel(),
//       ], // start with 2 options
//       correctIndex = -1;
// }

// class TeacherAddQuizPage extends StatefulWidget {
//   final String QuizName;
//   final TeacherQuizGradeClassModel selectedGradeClass;
//   final DateTime dueDate;

//   const TeacherAddQuizPage({
//     super.key,
//     required this.QuizName,
//     required this.selectedGradeClass,
//     required this.dueDate,
//   });

//   @override
//   State<TeacherAddQuizPage> createState() =>
//       _TeacherAddQuizPageState();
// }

// class _TeacherAddQuizPageState extends State<TeacherAddQuizPage> {
//   static const int maxQuestions = 20;
//   static const int maxOptions = 6;

//   final List<TeacherQuizQuestionModel> _questions = [
//     TeacherQuizQuestionModel(),
//   ];
//   int _currentIndex = 0;

//   TeacherQuizQuestionModel get _current => _questions[_currentIndex];

//   // ---------------- Question navigation ----------------

//   void _goBack() {
//     if (_currentIndex > 0) {
//       setState(() => _currentIndex--);
//     }
//   }

//   void _addQuestion() {
//     if (_questions.length >= maxQuestions) {
//       _showSnack(
//         'Maximum of $maxQuestions questions reached',
//         AppStyle.colors.black.withAlpha(200),
//       );
//       return;
//     }
//     setState(() {
//       _questions.add(TeacherQuizQuestionModel());
//       _currentIndex = _questions.length - 1;
//     });
//   }

//   void _deleteQuestion(int index) {
//     if (_questions.length == 1) {
//       _showSnack(
//         'At least one question is required',
//         AppStyle.colors.black.withAlpha(200),
//       );
//       return;
//     }
//     setState(() {
//       _questions.removeAt(index);
//       if (_currentIndex >= _questions.length) {
//         _currentIndex = _questions.length - 1;
//       } else if (_currentIndex > index) {
//         _currentIndex--;
//       }
//     });
//   }

//   // ---------------- Options ----------------

//   void _addOption() {
//     if (_current.options.length >= maxOptions) {
//       _showSnack(
//         'Maximum of $maxOptions options reached',
//         AppStyle.colors.black.withAlpha(200),
//       );
//       return;
//     }
//     setState(() => _current.options.add(TeacherQuizOptionModel()));
//   }

//   void _removeOption(int optionIndex) {
//     setState(() {
//       final removedId = _current.options[optionIndex].id;
//       _current.options.removeAt(optionIndex);
//       // Fix up correct-answer index after removal
//       if (_current.correctIndex == optionIndex) {
//         _current.correctIndex = -1;
//       } else if (_current.correctIndex > optionIndex) {
//         _current.correctIndex--;
//       }
//       removedId; // no-op, keeps analyzer quiet about unused var patterns
//     });
//   }

//   void _setCorrect(int optionIndex) {
//     setState(() {
//       _current.correctIndex = _current.correctIndex == optionIndex
//           ? -1
//           : optionIndex;
//     });
//   }

//   // ---------------- Save ----------------

//   // void _saveAll() {
//   //   final buffer = StringBuffer();
//   //   buffer.writeln('===== Quiz QUESTIONS (${_questions.length}) =====');
//   //   for (var i = 0; i < _questions.length; i++) {
//   //     final q = _questions[i];
//   //     buffer.writeln('\nQ${i + 1}: ${q.titleController.text}');
//   //     for (var j = 0; j < q.options.length; j++) {
//   //       final isCorrect = q.correctIndex == j;
//   //       buffer.writeln(
//   //         '   ${String.fromCharCode(65 + j)}. ${q.options[j].controller.text}'
//   //         '${isCorrect ? '   <-- correct' : ''}',
//   //       );
//   //     }
//   //   }

//   //   debugPrint(buffer.toString());
//   //   _showSnack(
//   //     'Saved ${_questions.length} question(s) succesfully',
//   //     AppStyle.colors.green,
//   //   );
//   //   Navigator.pop(context);
//   //   Navigator.pop(context);
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute<void>(
//   //       builder: (BuildContext context) => TeacherQuizzesPage(),
//   //     ),
//   //   );
//   // }

//   void _showSnack(String msg, Color color) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(msg),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: color,
//         ),
//       );
//   }

//   // --------- Validate Questions (used before saving to database) --------

//   bool _validateQuestions() {
//     for (int i = 0; i < _questions.length; i++) {
//       final question = _questions[i];

//       // Question title
//       if (question.titleController.text.trim().isEmpty) {
//         _showSnack(
//           'Question ${i + 1} is invalid.\nReason: Question title is empty.',
//           AppStyle.colors.red,
//         );
//         return false;
//       }

//       // Non-empty options
//       final validOptions = question.options
//           .where((o) => o.controller.text.trim().isNotEmpty)
//           .toList();

//       if (validOptions.length < 2) {
//         _showSnack(
//           'Question ${i + 1} is invalid.\nReason: At least 2 options are required.',
//           AppStyle.colors.red,
//         );
//         return false;
//       }

//       // Empty option check
//       for (int j = 0; j < question.options.length; j++) {
//         if (question.options[j].controller.text.trim().isEmpty) {
//           _showSnack(
//             'Question ${i + 1} is invalid.\nReason: Option ${String.fromCharCode(65 + j)} is empty.',
//             AppStyle.colors.red,
//           );
//           return false;
//         }
//       }

//       // Correct answer selected
//       if (question.correctIndex == -1) {
//         _showSnack(
//           'Question ${i + 1} is invalid.\nReason: No correct answer selected.',
//           AppStyle.colors.red,
//         );
//         return false;
//       }

//       // Correct answer not empty
//       if (question.options[question.correctIndex].controller.text
//           .trim()
//           .isEmpty) {
//         _showSnack(
//           'Question ${i + 1} is invalid.\nReason: Selected correct answer is empty.',
//           AppStyle.colors.red,
//         );
//         return false;
//       }

//       // Duplicate options check
//       final optionTexts = question.options
//           .map((o) => o.controller.text.trim().toLowerCase())
//           .toList();

//       final uniqueOptions = optionTexts.toSet();

//       if (uniqueOptions.length != optionTexts.length) {
//         _showSnack(
//           'Question ${i + 1} is invalid.\nReason: Options must be different.',
//           AppStyle.colors.red,
//         );
//         return false;
//       }
//     }

//     // Everything is valid -> print questions
//     debugPrint("===== Quiz (${_questions.length} Questions) =====");

//     for (int i = 0; i < _questions.length; i++) {
//       final q = _questions[i];

//       debugPrint("Q${i + 1}: ${q.titleController.text}");

//       for (int j = 0; j < q.options.length; j++) {
//         debugPrint(
//           "${j == q.correctIndex ? '✓' : ' '} ${String.fromCharCode(65 + j)}. ${q.options[j].controller.text}",
//         );
//       }
//     }

//     return true;
//   }

//   // ---------------- Question list sheet (jump / delete) ----------------

//   void _openQuestionList() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppStyle.colors.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (sheetContext) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: AppStyle.colors.grey,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Jump to question',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                           color: AppStyle.colors.brown,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     SingleChildScrollView(
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           maxHeight: MediaQuery.of(context).size.height * 0.4,
//                         ),
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           // physics: NeverScrollableScrollPhysics(),
//                           itemCount: _questions.length,
//                           separatorBuilder: (_, __) =>
//                               const SizedBox(height: 8),
//                           itemBuilder: (context, index) {
//                             final q = _questions[index];
//                             final preview =
//                                 q.titleController.text.trim().isEmpty
//                                 ? '(empty question)'
//                                 : q.titleController.text.trim();
//                             final isActive = index == _currentIndex;
//                             return Material(
//                               color: isActive
//                                   ? AppStyle.colors.brown
//                                   : AppStyle.colors.surface,
//                               borderRadius: BorderRadius.circular(16),
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(16),
//                                 onTap: () {
//                                   setState(() => _currentIndex = index);
//                                   Navigator.pop(sheetContext);
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 14,
//                                     vertical: 12,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 12,
//                                         backgroundColor: isActive
//                                             ? Colors.white24
//                                             : AppStyle.colors.surface,
//                                         child: Text(
//                                           '${index + 1}',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w700,
//                                             color: isActive
//                                                 ? Colors.white
//                                                 : AppStyle.colors.brown,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Text(
//                                           preview,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             color: isActive
//                                                 ? Colors.white
//                                                 : AppStyle.colors.brown,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.delete_outline,
//                                           color: isActive
//                                               ? Colors.white70
//                                               : AppStyle.colors.grey,
//                                         ),
//                                         onPressed: _questions.length == 1
//                                             ? null
//                                             : () {
//                                                 _deleteQuestion(index);
//                                                 setSheetState(() {});
//                                                 if (_questions.isEmpty) {
//                                                   Navigator.pop(sheetContext);
//                                                 }
//                                               },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // --------------------- helpers ----------------------------
//   List<QuestionData> _buildQuestionDataList() {
//     return _questions.asMap().entries.map((entry) {
//       final index = entry.key;
//       final q = entry.value;
//       final optionTexts = q.options
//           .map((o) => o.controller.text.trim())
//           .toList();
//       final correctIndex = q.correctIndex;
//       final modelAnswer =
//           (correctIndex >= 0 && correctIndex < optionTexts.length)
//           ? optionTexts[correctIndex]
//           : '';

//       return QuestionData(
//         questionOrder: index + 1,
//         questionText: q.titleController.text.trim(),
//         options: optionTexts,
//         modelAnswer: modelAnswer,
//       );
//     }).toList();
//   }

//   void _saveToSupabase() async {
//     // 1. Validate questions (you already have this)
//     if (!_validateQuestions()) return;

//     // 2. Build the Quiz data object
//     //    You need to get these values from your app state or UI.
//     //    For demonstration, I'll use placeholder values.

//     final currentUser = await AccountManager.currentAccount();
//     final teacherId = currentUser!.id;
//     final schoolId = currentUser.schoolId;
//     final subjectId = currentUser.ids.subjectId;

//     final QuizData = QuizData(
//       schoolId: schoolId,
//       teacherId: teacherId,
//       subjectId: subjectId ?? 0,
//       gradeId: widget.selectedGradeClass.gradeId,
//       classId: widget.selectedGradeClass.classId,
//       topic: widget.QuizName,
//       publishStatus: 'published',
//       dueDate: widget.dueDate,
//       questions: _buildQuestionDataList(),
//     );

//     // 3. Insert into Supabase
//     try {
//       final supabase = Supabase.instance.client;

//       // Insert Quiz
//       final QuizResponse = await supabase
//           .from('quizzes')
//           .insert(QuizData.toJson())
//           .select('id')
//           .single();
//       final int QuizId = QuizResponse['id'];

//       // Insert questions
//       final questionJsons = QuizData.questions
//           .map((q) => q.toJson(QuizId, QuizData.schoolId))
//           .toList();
//       await supabase.from('Quiz_questions').insert(questionJsons);

//       // Show success message
//       _showSnack('Quiz saved successfully!', AppStyle.colors.green);

//       if (!mounted) return;
//       Navigator.pop(context);
//       Navigator.pop(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute<void>(
//           builder: (BuildContext context) => TeacherQuizzesPage(),
//         ),
//       );
//     } catch (e) {
//       _showSnack('Error saving Quiz: $e', AppStyle.colors.red);
//     }
//   }

//   // ---------------- Build ----------------

//   @override
//   Widget build(BuildContext context) {
//     final q = _current;

//     return Scaffold(
//       backgroundColor: AppStyle.colors.surface,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.maxFinite,
//               padding: const EdgeInsets.fromLTRB(8, 18, 8, 18),
//               decoration: BoxDecoration(
//                 color: AppStyle.colors.surface,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(24),
//                   bottomRight: Radius.circular(24),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withAlpha(40),
//                     blurRadius: 10,
//                     spreadRadius: 0,
//                     offset: const Offset(0, 4), // Bottom shadow
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.arrow_back_ios),
//                   ),

//                   SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Quiz',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text('Quiz'),
//                     ],
//                   ),

//                   Spacer(),

//                   Padding(
//                     padding: const EdgeInsets.only(right: 12),
//                     child: GestureDetector(
//                       onTap: _openQuestionList,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFEFE7DC),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'Q${_currentIndex + 1} of ${_questions.length}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: AppStyle.colors.brown,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             // ---- Question title (borderless text field) ----
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: TextField(
//                 key: ValueKey('title_${q.id}'),
//                 controller: q.titleController,
//                 maxLines: null,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w800,
//                   color: AppStyle.colors.brown,
//                   height: 1.25,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: 'Question title here...?',
//                   fillColor: Colors.transparent,
//                   hintStyle: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     color: AppStyle.colors.brown.withAlpha(100),
//                   ),
//                   border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   contentPadding: EdgeInsets.zero,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 28),

//             // ---- Options list ----
//             Expanded(
//               child: ListView(
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   for (int i = 0; i < q.options.length; i++)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 14),
//                       child: _OptionPill(
//                         key: ValueKey('opt_${q.options[i].id}'),
//                         controller: q.options[i].controller,
//                         isCorrect: q.correctIndex == i,
//                         onTapCircle: () => _setCorrect(i),
//                         onDelete: () => _removeOption(i),
//                       ),
//                     ),
//                   if (q.options.length < maxOptions)
//                     _AddOptionPill(onTap: _addOption),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: _currentIndex > 0 ? _goBack : null,
//                   child: Row(children: [Icon(Icons.arrow_back), Text('Back')]),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: _addQuestion,
//                   child: Row(children: [Icon(Icons.add), Text('Add Q')]),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _saveToSupabase();
//                   },
//                   child: Row(children: [Icon(Icons.check), Text('Save')]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ------------------------------------------------------------
// // Reusable widgets
// // ------------------------------------------------------------

// /// A single answer option: plain text field inside a pill, with a
// /// circle on the right the teacher taps to mark it as the correct
// /// answer. Swipe left to remove the option.
// class _OptionPill extends StatelessWidget {
//   final TextEditingController controller;
//   final bool isCorrect;
//   final VoidCallback onTapCircle;
//   final VoidCallback onDelete;

//   const _OptionPill({
//     super.key,
//     required this.controller,
//     required this.isCorrect,
//     required this.onTapCircle,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Dismissible(
//         key: key!,
//         direction: DismissDirection.endToStart,
//         onDismissed: (_) => onDelete(),
//         background: Container(
//           alignment: Alignment.centerRight,
//           padding: const EdgeInsets.only(right: 24),
//           decoration: BoxDecoration(
//             color: Colors.red.shade300,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Icon(Icons.delete, color: AppStyle.colors.surface),
//         ),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             color: isCorrect ? AppStyle.colors.green : AppStyle.colors.grey,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withAlpha(20),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: controller,

//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: isCorrect
//                         ? AppStyle.colors.black
//                         : AppStyle.colors.brown,
//                   ),
//                   decoration: InputDecoration(
//                     fillColor: isCorrect
//                         ? AppStyle.colors.green
//                         : AppStyle.colors.grey,
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.transparent),
//                     ),
//                     hintText: 'Answer',
//                     hintStyle: TextStyle(
//                       color: isCorrect
//                           ? Colors.black
//                           : AppStyle.colors.black.withAlpha(100),
//                       fontWeight: FontWeight.w600,
//                     ),
//                     border: InputBorder.none,
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: onTapCircle,
//                 child: Container(
//                   width: 26,
//                   height: 26,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isCorrect ? Colors.white : Colors.transparent,
//                     border: Border.all(
//                       color: isCorrect ? Colors.white : AppStyle.colors.brown,
//                       width: 2,
//                     ),
//                   ),
//                   child: isCorrect
//                       ? Center(
//                           child: Container(
//                             width: 12,
//                             height: 12,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: AppStyle.colors.brown,
//                             ),
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Dashed "+ Add option" pill shown when fewer than the max options exist.
// class _AddOptionPill extends StatelessWidget {
//   final VoidCallback onTap;
//   const _AddOptionPill({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           decoration: BoxDecoration(
//             color: AppStyle.colors.grey.withAlpha(150),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Add option',
//                 style: TextStyle(
//                   color: AppStyle.colors.black,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               Icon(Icons.add, color: AppStyle.colors.black),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Quiz_data.dart

// class QuizData {
//   final int? id; // only for updates
//   final int schoolId;
//   final String teacherId; // UUID from users table
//   final int subjectId;
//   final int gradeId;
//   final int? classId; // null = whole grade
//   final String topic;
//   final String publishStatus; // 'published' or 'unpublished'
//   final DateTime dueDate;
//   final List<QuestionData> questions;

//   QuizData({
//     this.id,
//     required this.schoolId,
//     required this.teacherId,
//     required this.subjectId,
//     required this.gradeId,
//     this.classId,
//     required this.topic,
//     required this.publishStatus,
//     required this.dueDate,
//     required this.questions,
//   });

//   /// Converts the entire Quiz + questions into JSON for Supabase.
//   Map<String, dynamic> toJson() => {
//     if (id != null) 'id': id,
//     'school_id': schoolId,
//     'teacher_id': teacherId,
//     'subject_id': subjectId,
//     'grade_id': gradeId,
//     'class_id': classId,
//     'topic': topic,
//     'publish_status': publishStatus,
//     'due_date': dueDate.toIso8601String(),
//     'number_of_questions': questions.length,
//     // Questions are inserted separately after the Quiz is created.
//     // We don't include them here – they go into the Quiz_questions table.
//   };
// }

// class QuestionData {
//   final int? id; // only for updates
//   final int questionOrder;
//   final String questionText;
//   final List<String> options; // length between 2 and 6
//   final String modelAnswer; // text of the correct option

//   QuestionData({
//     this.id,
//     required this.questionOrder,
//     required this.questionText,
//     required this.options,
//     required this.modelAnswer,
//   });

//   /// Maps to the six option columns in the Quiz_questions table.
//   Map<String, dynamic> toJson(int QuizId, int schoolId) {
//     // Ensure options are padded to 6 (null for missing ones)
//     final paddedOptions = List<String?>.filled(6, null);
//     for (int i = 0; i < options.length && i < 6; i++) {
//       paddedOptions[i] = options[i];
//     }
//     return {
//       if (id != null) 'id': id,
//       'school_id': schoolId,
//       'Quiz_id': QuizId,
//       'question_order': questionOrder,
//       'question_text': questionText,
//       'options_1': paddedOptions[0],
//       'options_2': paddedOptions[1],
//       'options_3': paddedOptions[2],
//       'options_4': paddedOptions[3],
//       'options_5': paddedOptions[4],
//       'options_6': paddedOptions[5],
//       'model_answer': modelAnswer,
//     };
//   }
// }

// // Future<void> _insertQuiz(QuizData data) async {
// //   final supabase = Supabase.instance.client;

// //   // 1. Insert the Quiz row.
// //   final QuizResponse = await supabase
// //       .from('quizzes')
// //       .insert(data.toJson())
// //       .select('id')
// //       .single();

// //   final int QuizId = QuizResponse['id'];

// //   // 2. Insert each question row.
// //   final questionJsons = data.questions.map((q) {
// //     return q.toJson(QuizId, data.schoolId);
// //   }).toList();

// //   await supabase.from('Quiz_questions').insert(questionJsons);

// //   // 3. (Optional) Update the Quiz's number_of_questions if you want.
// //   // It's already set in the Quiz row, but you can also set it during insert.
// // }

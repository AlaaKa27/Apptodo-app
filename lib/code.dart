// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/modles.dart';
// import 'package:flutter_application_1/sqdb_data.dart';
// import 'package:intl/intl.dart';

// class NoteDialog extends StatefulWidget {
//   final Note? note;
//   final VoidCallback onSaved; // ✅ تعديل: إعادة تسمية onSevd إلى onSaved
//   const NoteDialog({super.key, this.note, required this.onSaved});

//   @override
//   State<NoteDialog> createState() => _NoteDialogState();
// }

// class _NoteDialogState extends State<NoteDialog> {
//   late TextEditingController _contentController;
//   late TextEditingController _titleController;
//   DateTime? _selectedDateTime;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.note?.title ?? '');
//     _contentController = TextEditingController(
//       text: widget.note?.content ?? '',
//     );
//     if (widget.note != null && widget.note!.date.isNotEmpty) {
//       _selectedDateTime = DateTime.tryParse(widget.note!.date);
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDateTime() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime ?? DateTime.now(),
//       firstDate: DateTime(1980),
//       lastDate: DateTime(2032),
//     );
//     if (date == null) return;

//     final time = await showTimePicker(
//       context: context,
//       initialTime: _selectedDateTime != null
//           ? TimeOfDay.fromDateTime(_selectedDateTime!)
//           : TimeOfDay.now(),
//     );
//     if (time == null) return;

//     setState(() {
//       _selectedDateTime = DateTime(
//         date.year,
//         date.month,
//         date.day,
//         time.hour,
//         time.minute,
//       );
//     });
//   }

//   Future<void> _save() async {
//     final title = _titleController.text.trim();
//     final content = _contentController.text.trim();
//     if (title.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("أدخل عنوانًا")));
//       return;
//     }

//     final datestring = _selectedDateTime?.toIso8601String() ?? "";
//     if (widget.note == null) {
//       final newNote = Note(title: title, content: content, date: datestring);
//       await DBHelper.insertNote(newNote);
//     } else {
//       final update = Note(
//         id: widget.note!.id,
//         title: title,
//         content: content,
//         date: datestring,
//       );
//       await DBHelper.updateNote(update);
//     }
//     widget.onSaved();
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final formatted = _selectedDateTime == null
//         ? 'لم يتم اختيار التاريخ'
//         : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!);

//     return AlertDialog(
//       title: Text(
//         widget.note == null ? "إضافة مهمة" : "تعديل المهمة", // ✅ Title ديناميكي
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.blueAccent,
//         ),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16), // ✅ حواف دائرية
//       ),
//       backgroundColor: const Color.fromARGB(255, 240, 250, 255), // ✅ لون خلفية
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.title), // ✅ أيقونة للعنوان
//                 labelText: 'عنوان المهمة',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _contentController,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.description), // ✅ أيقونة للمحتوى
//                 labelText: 'المهمة',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _pickDateTime,
//                   icon: const Icon(Icons.access_time),
//                   label: const Text('اختيار الوقت'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orangeAccent, // ✅ لون الزر
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text(formatted)),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton.icon(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.cancel, color: Colors.red),
//           label: const Text(
//             "إلغاء",
//             style: TextStyle(color: Colors.red),
//           ), // ✅ زر إلغاء بأيقونة ولون
//         ),
//         ElevatedButton.icon(
//           onPressed: _save,
//           icon: const Icon(Icons.save),
//           label: Text(widget.note == null ? 'إضافة' : 'حفظ'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green, // ✅ زر حفظ أخضر مع أيقونة
//           ),
//         ),
//       ],
//     );
//   }
// }






















// lib/models/note.dart



// موديل بسيط للملاحظة (Note)
// class Note {
//   int? id;           // id قد يكون null قبل الحفظ في قاعدة البيانات
//   String title;      // عنوان الملاحظة
//   String content;    // نص/محتوى الملاحظة
//   String date;       // نخزن التاريخ كسلسلة نصية (ISO) أو فارغ ""

//   // الكونستركتور، الحقول title وcontent وdate مطلوبة (required)
//   Note({this.id, required this.title, required this.content, required this.date});

//   // تحويل كائن Note إلى Map لإدخالها في sqlite
//   Map<String, dynamic> toMap() {
//     final map = <String, dynamic>{
//       'title': title,
//       'content': content,
//       'date': date,
//     };
//     if (id != null) {
//       map['id'] = id;
//     }
//     return map;
//   }

//   // تحويل صف من قاعدة البيانات (Map) إلى كائن Note
//   factory Note.fromMap(Map<String, dynamic> map) {
//     return Note(
//       id: map['id'] as int?,
//       title: map['title'] as String? ?? '',
//       content: map['content'] as String? ?? '',
//       date: map['date'] as String? ?? '',
//     );
//   }

// }

// // lib/db/db_helper.dart

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/note.dart';

// // كلاس بسيط يحتوي وظائف CRUD كـ static لتسهيل الاستخدام
// class DBHelper {
//   static Database? _db; // كائن قاعدة البيانات داخل الكلاس

//   // تهيئة / فتح قاعدة البيانات (lazy)
//   static Future<Database> initDB() async {
//     if (_db != null) return _db!; // إن كانت مهيأة بالفعل نعيدها

//     // مسار ملفات قواعد البيانات على الجهاز
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'notes.db');

//     // فتح أو إنشاء قاعدة البيانات
//     _db = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         // إنشاء جدول notes إن لم يكن موجودًا
//         await db.execute('''
//           CREATE TABLE notes(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             title TEXT,
//             content TEXT,
//             date TEXT
//           )
//         ''');
//       },
//     );

//     return _db!;
//   }

//   // إدراج ملاحظة جديدة
//   static Future<int> insertNote(Note note) async {
//     final db = await initDB();
//     return await db.insert('notes', note.toMap());
//   }

//   // قراءة كل الملاحظات مرتبة تنازلياً حسب id
//   static Future<List<Note>> getNotes() async {
//     final db = await initDB();
//     final result = await db.query('notes', orderBy: 'id DESC');
//     return result.map((map) => Note.fromMap(map)).toList();
//   }

//   // تحديث ملاحظة موجودة
//   static Future<int> updateNote(Note note) async {
//     final db = await initDB();
//     return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
//   }

//   // حذف ملاحظة حسب id
//   static Future<int> deleteNote(int id) async {
//     final db = await initDB();
//     return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
//   }
// }

// lib/widgets/note_bottom_sheet.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/note.dart';
// import '../db/db_helper.dart';

// /// StatefulWidget لأننا سنعدل الحالة (نص الحقول، التاريخ المختار)
// class NoteBottomSheet extends StatefulWidget {
//   final Note? note; // إن تم تمرير ملاحظة -> هذا وضع التعديل، وإلا إضافة جديدة
//   final VoidCallback onSaved; // دالة يستدعيها الأب بعد الحفظ لتحديث القائمة

//   const NoteBottomSheet({Key? key, this.note, required this.onSaved})
//     : super(key: key);

//   @override
//   State<NoteBottomSheet> createState() => _NoteBottomSheetState();
// }

// class _NoteBottomSheetState extends State<NoteBottomSheet> {
//   late TextEditingController _titleController;
//   late TextEditingController _contentController;
//   DateTime? _selectedDateTime;

//   @override
//   void initState() {
//     super.initState();
//     // نملأ القيم إن كانت ممررة (وضع التعديل) أو نتركها فارغة (وضع الإضافة)
//     _titleController = TextEditingController(text: widget.note?.title ?? '');
//     _contentController = TextEditingController(
//       text: widget.note?.content ?? '',
//     );
//     if (widget.note != null && widget.note!.date.isNotEmpty) {
//       _selectedDateTime = DateTime.tryParse(widget.note!.date);
//     } else {
//       _selectedDateTime = null;
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   // دالة لاختيار التاريخ والوقت بواسطة pickers
//   Future<void> _pickDateTime() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (date == null) return; // المستخدم ألغى

//     final time = await showTimePicker(
//       context: context,
//       initialTime: _selectedDateTime != null
//           ? TimeOfDay.fromDateTime(_selectedDateTime!)
//           : TimeOfDay.now(),
//     );
//     if (time == null) return;

//     setState(() {
//       _selectedDateTime = DateTime(
//         date.year,
//         date.month,
//         date.day,
//         time.hour,
//         time.minute,
//       );
//     });
//   }

  // // حفظ (إضافة أو تعديل)
  // Future<void> _save() async {
  //   final title = _titleController.text.trim();
  //   final content = _contentController.text.trim();

  //   if (title.isEmpty) {
  //     // يمكنك تعديل هذه الرسالة أو استخدام SnackBar
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('أدخل عنواناً')));
  //     return;
  //   }

  //   final dateString = _selectedDateTime?.toIso8601String() ?? '';

  //   if (widget.note == null) {
  //     // إضافة جديدة
  //     final newNote = Note(title: title, content: content, date: dateString);
  //     await DBHelper.insertNote(newNote);
  //   } else {
  //     // تحديث موجود
  //     final updated = Note(
  //       id: widget.note!.id,
  //       title: title,
  //       content: content,
  //       date: dateString,
  //     );
  //     await DBHelper.updateNote(updated);
  //   }

  //   widget.onSaved(); // نطلب من الصفحة الرئيسية إعادة تحميل الملاحظات
  //   Navigator.of(context).pop(); // إغلاق الـ bottom sheet
  // }

//   @override
//   Widget build(BuildContext context) {
//     // لعرض التاريخ بشكل جميل (مثال: 2025-08-10 14:30)
//     final formatted = _selectedDateTime == null
//         ? 'لم يتم اختيار التاريخ'
//         : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!);

//     // العنصر الفعلي في الـ bottom sheet
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 16,
//         right: 16,
//         top: 16,
//         // هذا السطر يرفع الـ bottom sheet عندما تفتح لوحة المفاتيح
//         bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // حقل العنوان
//           TextField(
//             controller: _titleController,
//             decoration: const InputDecoration(
//               labelText: 'العنوان',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 8),

//           // حقل المحتوى
//           TextField(
//             controller: _contentController,
//             decoration: const InputDecoration(
//               labelText: 'المحتوى',
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 3,
//           ),
//           const SizedBox(height: 8),

//           // صف لاختيار التاريخ والوقت وعرض التاريخ المختار
//           Row(
//             children: [
//               Expanded(child: Text(formatted)),
//               ElevatedButton(
//                 onPressed: _pickDateTime,
//                 child: const Text('اختر التاريخ والوقت'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           // أزرار حفظ/إلغاء
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: _save,
//                   child: Text(widget.note == null ? 'إضافة' : 'حفظ التعديل'),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('إلغاء'),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }


















// تمام 👍
// إذًا بدك تغيّري من showModalBottomSheet إلى showDialog بحيث تظهر نافذة في وسط الشاشة بدل ما تطلع من الأسفل.

// في حالتك، التغيير بسيط:


// ---

// الكود القديم (BottomSheet)

// void _openSheet({Note? note}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//     ),
//     builder: (context) => BottomSheetOpen(note: note, onSevd: _loadNotes),
//   );
// }


// ---

// الكود الجديد (Dialog)

// void _openDialog({Note? note}) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: BottomSheetOpen(
//             note: note,
//             onSevd: () {
//               Navigator.pop(context); // إغلاق الـ Dialog
//               _loadNotes(); // تحديث القائمة
//             },
//           ),
//         ),
//       );
//     },
//   );
// }


// ---

// التعديل في زر الإضافة والتعديل

// بدل:

// onPressed: () => _openSheet(),

// خليه:

// onPressed: () => _openDialog(),

// ونفس الشيء في زر التعديل:

// onPressed: () => _openDialog(note: note),


// ---

// بهذا الشكل، راح تفتح نافذة وسط الشاشة بدل البوتوم شيت، وتقدر تضيف لها عنوان وتنسيق بسهولة.

// تحب أعمل لك نسخة أجمل من الـ Dialog بحيث فيها عنوان واضح وأزرار "حفظ" و"إلغاء"؟





























// // lib/screens/notes_page.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/note.dart';
// import '../db/db_helper.dart';
// import '../widgets/note_bottom_sheet.dart';

// class NotesPage extends StatefulWidget {
//   const NotesPage({Key? key}) : super(key: key);

//   @override
//   State<NotesPage> createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   List<Note> _notes = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadNotes(); // تحميل الملاحظات عند بداية الشاشة
//   }

//   // تحميل الملاحظات من DBHelper
//   Future<void> _loadNotes() async {
//     final notes = await DBHelper.getNotes();
//     setState(() {
//       _notes = notes;
//     });
//   }

//   // فتح الـ bottom sheet (لوضع إضافة أو تعديل)
//   void _openSheet({Note? note}) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//       ),
//       builder: (context) => NoteBottomSheet(note: note, onSaved: _loadNotes),
//     );
//   }

//   // حذف ملاحظة
//   Future<void> _deleteNote(int id) async {
//     await DBHelper.deleteNote(id);
//     await _loadNotes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ملاحظاتي')),
//       body: _notes.isEmpty
//           ? const Center(child: Text('لا توجد ملاحظات بعد'))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               itemCount: _notes.length,
//               itemBuilder: (context, index) {
//                 final note = _notes[index];
//                 // تاريخ منسق للعرض
//                 final dateText = note.date.isNotEmpty
//                     ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(note.date))
//                     : 'بدون تاريخ';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: ListTile(
//                     title: Text(note.title),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(note.content),
//                         const SizedBox(height: 6),
//                         Text(dateText, style: const TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                     isThreeLine: true,
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () => _openSheet(note: note), // تعديل
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () => _deleteNote(note.id!), // حذف
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       // زر مركزي بالأسفل مع أيقونة الإضافة
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _openSheet(), // فتح الـ bottom sheet لوضع إضافة جديدة
//         child: const Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }






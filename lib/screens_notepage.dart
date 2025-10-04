import 'package:flutter/material.dart';
import 'package:flutter_application_1/modles.dart';
import 'package:flutter_application_1/note_bottom_sheet.dart';
import 'package:flutter_application_1/sqdb_data.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];

  @override
  void initState() {
    _loadNotes();
    super.initState();
    // تحميل الملاحظات عند بداية الشاشة
  }

  // تحميل الملاحظات من DBHelper
  Future<void> _loadNotes() async {
    final notes = await DBHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  // فتح الـ bottom sheet (لوضع إضافة أو تعديل)
  void _openDilog({Note? note}) {
    showDialog(
      context: context,
      builder: (context) {
        return BottomSheetOpen(
          note: note,
          onsevd: () {
            _loadNotes();
          },
        );
      },
    );
  }

  // حذف ملاحظة
  Future<void> _deletNote(int id) async {
    await DBHelper.deleteNote(id);
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NOTES'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDilog(),
        child: Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('لا توجد ملاحطات '))
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final datetext = note.date.isNotEmpty
                    ? DateFormat(
                        'yyyy-MM-dd HH:mm',
                      ).format(DateTime.parse(note.date))
                    : 'لا يوجد تاريخ';
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.content),
                        SizedBox(height: 10),
                        Text(datetext, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _openDilog(note: note),
                          icon: Icon(Icons.edit),
                        ),
                        SizedBox(height: 10),
                        IconButton(
                          onPressed: () => _deletNote(note.id!),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

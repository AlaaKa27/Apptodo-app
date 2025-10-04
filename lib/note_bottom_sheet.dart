import 'package:flutter/material.dart';
import 'package:flutter_application_1/modles.dart';
import 'package:flutter_application_1/sqdb_data.dart';
import 'package:intl/intl.dart';

class BottomSheetOpen extends StatefulWidget {
  final Note? note;
  final VoidCallback onsevd;
  const BottomSheetOpen({super.key, this.note, required this.onsevd});

  @override
  State<BottomSheetOpen> createState() => _BottomSheetOpenState();
}

class _BottomSheetOpenState extends State<BottomSheetOpen> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    if (widget.note != null && widget.note!.date.isNotEmpty) {
      _selectedDateTime = DateTime.tryParse(widget.note!.date);
    } else {
      _selectedDateTime = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2032),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("أدخل  عنوانا")));
      return;
    }

    final datestring = _selectedDateTime?.toIso8601String() ?? "";
    if (widget.note == null) {
      final newNote = Note(title: title, content: content, date: datestring);
      await DBHelper.insertNote(newNote);
    } else {
      final update = Note(
        id: widget.note!.id,
        title: title,
        content: content,
        date: datestring,
      );
      await DBHelper.updateNote(update);
    }
    widget.onsevd();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formetted = _selectedDateTime == null
        ? 'لم يتم اختيار التاريخ'
        : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!);

    return AlertDialog(
      title: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Text(
              widget.note == null ? 'أضافة ملاحظة' : 'تعديل الملاحظة',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 1),
          Divider(color: Colors.black26, thickness: 3),
        ],
      ),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'المهمة',
                labelText: 'ادخل النص',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDateTime,
                  label: Text('أدخل الوقت'),
                  icon: const Icon(Icons.access_time),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 234, 127),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(child: Text(formetted)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            label: Text('ألغاء'),
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton.icon(
          onPressed: _save,
          label: Text('حفظ'),
          icon: const Icon(Icons.save),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
        ),
      ],
    );
  }
}

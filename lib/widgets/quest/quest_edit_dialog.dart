import 'package:flutter/material.dart';

class QuestEditDialog extends StatefulWidget {
  final String id;
  final String initialTitle;
  final String initialRank;
  final Function(String title, String rank) onSave;

  const QuestEditDialog({
    super.key,
    required this.id,
    required this.initialTitle,
    required this.initialRank,
    required this.onSave,
  });

  @override
  State<QuestEditDialog> createState() => _QuestEditDialogState();
}

class _QuestEditDialogState extends State<QuestEditDialog> {
  late TextEditingController _titleCtrl;
  late String _rank;
  final List<String> validRanks = ['C', 'B', 'A', 'S'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle);
    _rank = validRanks.contains(widget.initialRank) ? widget.initialRank : 'C';
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Dialog agar ukurannya lebih fleksibel dan bisa dibuat kotak
    return Dialog(
      backgroundColor: const Color(0xFF1E222A),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFE58F28), width: 3), // Border oranye
        borderRadius: BorderRadius.zero, // Kotak sempurna
      ),
      child: Container(
        width: 300, // Ukuran lebar tetap biar kotak
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "EDIT QUEST",
              style: TextStyle(
                color: Color(0xFFE58F28),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            // Input Judul
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),

            // Dropdown Rank (Dibuat ringkas)
            DropdownButton<String>(
              value: _rank,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E222A),
              style: const TextStyle(color: Colors.white),
              items: validRanks
                  .map(
                    (r) => DropdownMenuItem(value: r, child: Text("Rank $r")),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _rank = val!),
            ),

            const SizedBox(height: 25),

            // Tombol Save
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE58F28),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  widget.onSave(_titleCtrl.text, _rank);
                  Navigator.pop(context);
                },
                child: const Text(
                  "SAVE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

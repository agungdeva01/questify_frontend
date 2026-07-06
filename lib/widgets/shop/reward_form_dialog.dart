import 'package:flutter/material.dart';
import '../../models/reward_model.dart';

class RewardFormDialog extends StatefulWidget {
  final RewardModel?
  reward; // Jika null -> mode Create, jika ada -> mode Update
  final Function(String title, int cost) onSubmit;

  const RewardFormDialog({super.key, this.reward, required this.onSubmit});

  @override
  State<RewardFormDialog> createState() => _RewardFormDialogState();
}

class _RewardFormDialogState extends State<RewardFormDialog> {
  late TextEditingController _titleController;
  late TextEditingController _costController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reward?.title ?? '');
    _costController = TextEditingController(
      text: widget.reward?.cost.toString() ?? '10',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reward != null;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E222A),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFE58F28), width: 3),
        borderRadius: BorderRadius.zero, // Gaya piksel
      ),
      title: Text(
        isEditing ? 'EDIT REWARD' : 'CREATE NEW REWARD',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input Judul Reward
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Reward Name / Title',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE58F28)),
                ),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Judul tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),
            // Input Harga Koin
            TextFormField(
              controller: _costController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cost (Coins)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF7D038)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE58F28),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final title = _titleController.text.trim();
              final cost = int.parse(_costController.text.trim());
              widget.onSubmit(title, cost);
              Navigator.pop(context);
            }
          },
          child: Text(
            isEditing ? 'UPDATE' : 'CREATE',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

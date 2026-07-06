import '../widgets/quest/quest_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quest_provider.dart';
import '../models/quest_response.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Memanggil API saat layar pertama kali dibuka menggunakan PostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestProvider>().loadQuests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== AKSI / LOGIKA UI ====================

  // Membuka form tambah quest
  void _addNewQuest(String title, String rank) async {
    final success = await context.read<QuestProvider>().addNewQuest(
      title,
      rank,
    );
    if (success) {
      _showSnackBar('Quest Baru Berhasil Ditambahkan! 📜', Colors.amber);
    } else {
      _showSnackBar('Gagal membuat Quest baru.', Colors.redAccent);
    }
  }

  // Menyelesaikan quest
  void _completeQuest(String id) async {
    final success = await context.read<QuestProvider>().completeQuest(id);
    if (success) {
      _showSnackBar(
        'Quest berhasil diselesaikan! 🎉 +EXP & Gold',
        Colors.green,
      );
    }
  }

  // Menghapus quest
  void _deleteQuest(String id) async {
    final success = await context.read<QuestProvider>().deleteQuest(id);
    if (success) {
      _showSnackBar(
        'Quest berhasil dihapus dari papan tugas.',
        Colors.redAccent,
      );
    }
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==================== TAMPILAN UTAMA (BUILD) ====================

  @override
  Widget build(BuildContext context) {
    final questProvider = context.watch<QuestProvider>();

    return Scaffold(
      backgroundColor: const Color(
        0xFF15171E,
      ), // Warna dasar gelap dungeon/retro
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E222B),
        elevation: 4,
        title: const Text(
          'QUEST BOARD',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(
            0xFFFF9F43,
          ), // Warna oranye keemasan khas game
          labelColor: const Color(0xFFFF9F43),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          tabs: [
            Tab(text: 'ACTIVE (${questProvider.activeQuests.length})'),
            Tab(text: 'COMPLETED (${questProvider.completedQuests.length})'),
          ],
        ),
      ),
      body: questProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9F43)),
            )
          : RefreshIndicator(
              onRefresh: () => questProvider.loadQuests(),
              color: const Color(0xFFFF9F43),
              backgroundColor: const Color(0xFF1E222B),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildQuestList(
                    questProvider.activeQuests,
                    isActiveList: true,
                  ),
                  _buildQuestList(
                    questProvider.completedQuests,
                    isActiveList: false,
                  ),
                ],
              ),
            ),
      // Tombol mengambang (+) bergaya retro kotak tajam
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF9F43),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Colors.black, width: 2.5),
        ),
        onPressed: () => _showCreateQuestDialog(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
    );
  }

  // Pembuat list untuk menampung card item
  Widget _buildQuestList(
    List<QuestResponse> quests, {
    required bool isActiveList,
  }) {
    if (quests.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActiveList
                      ? Icons.hourglass_empty
                      : Icons.assignment_turned_in_outlined,
                  size: 64,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(height: 16),
                Text(
                  isActiveList
                      ? 'TIDAK ADA QUEST AKTIF'
                      : 'BELUM ADA QUEST YANG SELESAI',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return _buildQuestCard(quest, isActive: isActiveList);
      },
    );
  }

  // Pembuat Kartu Misi (Quest Card) Bergaya Retro RPG
  Widget _buildQuestCard(QuestResponse quest, {required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF222631),
        borderRadius: BorderRadius.circular(
          4,
        ), // Kaku bersudut tajam khas pixel-art
        border: Border.all(
          color: isActive ? const Color(0xFF3E4557) : Colors.black,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(3, 3),
            blurRadius: 0, // Solid shadow khas game retro
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Badge Tingkat Rank (S, A, B, C) dengan warna dinamis
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getRankColor(quest.rank),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Text(
                quest.rank.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Informasi teks detail misi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: isActive
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? 'Status: Active Misi' : 'Status: Quest Clear',
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFFFF9F43)
                          : Colors.greenAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Sisi tombol aksi interaktif kanan
            if (isActive)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.greenAccent,
                      size: 28,
                    ),
                    onPressed: () => _completeQuest(quest.id),
                    tooltip: 'Selesaikan',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                    onPressed: () => _showDeleteDialog(quest.id),
                    tooltip: 'Hapus Misi',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => QuestEditDialog(
                          id: quest.id,
                          initialTitle: quest.title,
                          initialRank: quest.rank,
                          onSave: (newTitle, newRank) async {
                            final success = await context
                                .read<QuestProvider>()
                                .updateQuest(quest.id, newTitle, newRank);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Quest berhasil diupdate! ✨"),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Gagal mengupdate quest ❌"),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.verified,
                  color: Colors.greenAccent,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== DIALOG MODAL FORM POP-UP ====================

  // Dialog Form Pengisian untuk Create Quest Baru
  void _showCreateQuestDialog() {
    final TextEditingController titleController = TextEditingController();
    String selectedRank = 'C';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 3),
          ),
          title: const Text(
            'TAMBAH QUEST BARU',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Judul Misi:',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul tugas...',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF9F43)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pilih Rank Kesulitan:',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              DropdownButton<String>(
                value: selectedRank,
                dropdownColor: const Color(0xFF1E222B),
                isExpanded: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                iconEnabledColor: const Color(0xFFFF9F43),
                items: ['C', 'B', 'A', 'S'].map((String v) {
                  return DropdownMenuItem<String>(
                    value: v,
                    child: Text('Rank $v'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => selectedRank = val);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'BATAL',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9F43),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  _addNewQuest(titleController.text, selectedRank);
                }
              },
              child: const Text(
                'BUAT MISI',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Pop-up Konfirmasi Penolakan/Hapus Quest
  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF222631),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        title: const Text(
          'Hapus Quest?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah kamu yakin ingin membuang misi ini dari papan pengumuman?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              _deleteQuest(id);
            },
            child: const Text(
              'HAPUS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper pewarnaan dinamis untuk teks Rank Game RPG
  Color _getRankColor(String rank) {
    switch (rank.toLowerCase()) {
      case 's':
        return const Color(0xFFFF4757); // Merah membara
      case 'a':
        return const Color(0xFFFFA502); // Jingga/Oranye terang
      case 'b':
        return const Color(0xFF2ED573); // Hijau botol cerah
      case 'c':
        return const Color(0xFF1E90FF); // Biru langit neon
      default:
        return const Color(0xFFCED6E0);
    }
  }
}

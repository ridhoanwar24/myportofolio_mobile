import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widget/auth_guard.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widget/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _experienceTitle = "";
  String _description = "";
  ExperienceCategory _category = ExperienceCategory.fullTime; //default
  String _thumbnail = "";
  DateTime? _endedAt;
  bool _isSubmitting = false;

  // key: nilai yang disimpan, value: teks yang ditampilkan
  final Map<ExperienceCategory, String> _categories = {
    ExperienceCategory.internship: 'Internship',
    ExperienceCategory.research: 'Research',
    ExperienceCategory.volunteer: 'Volunteer',
    ExperienceCategory.partTime: 'Part-Time',
    ExperienceCategory.fullTime: 'Full-Time',
    ExperienceCategory.freelance: 'Freelance',
  };

  Future<void> _pickEndedAt() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? DateTime.now(),
      firstDate: DateTime(2007),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endedAt = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d-$m-${date.year}';
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _experienceTitle = "";
      _description = "";
      _category = ExperienceCategory.fullTime;
      _thumbnail = "";
      _endedAt = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Pastikan sudah login, kalau belum akan diarahkan ke LoginScreen.
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final authState = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);
    final token = authState.token!;

    final thumbnail = _thumbnail.trim();
    final newExperience = Experience(
      title: _experienceTitle.trim(),
      description: _description.trim(),
      category: _category,
      thumbnail: thumbnail.isEmpty ? null : thumbnail,
      endedAt: _endedAt,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await apiClient.createExperience(
        newExperience,
        token: token,
      );
      if (!mounted) return;
      await _showSuccessDialog(created); // 201 Created
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Token tidak valid / kedaluwarsa: logout lalu minta login ulang.
        await authState.logout();
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(content: Text('Sesi berakhir, silakan login ulang.')),
        );
        await ensureLoggedIn(context);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Gagal menyimpan (${e.statusCode}).')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showSuccessDialog(Experience e) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Experience: ${e.title}'),
                Text('Deskripsi: ${e.description}'),
                Text('Kategori: ${_categories[e.category]}'),
                Text('Thumbnail: ${e.thumbnail ?? "-"}'),
                Text(
                  e.endedAt == null
                      ? 'Selesai: -'
                      : 'Selesai: ${_formatDate(e.endedAt!)}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Experience Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    hintText: "Experience Title",
                    labelText: "Experience Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _experienceTitle = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Experience title tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Experience Description",
                    labelText: "Experience Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi experience tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<ExperienceCategory>(
                  decoration: InputDecoration(
                    labelText: "Experience Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (ExperienceCategory? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Thumbnail ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://contoh.com/gambar.jpg",
                    labelText: "Thumbnail URL (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value!;
                    });
                  },
                  validator: (String? value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;
                    final uri = Uri.tryParse(text);
                    final valid =
                        uri != null &&
                        uri.hasAuthority &&
                        (uri.scheme == 'http' || uri.scheme == 'https');
                    return valid
                        ? null
                        : "URL harus diawali http:// atau https://";
                  },
                ),
              ),

              // === Ended At (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _endedAt == null
                            ? 'Selesai: -'
                            : 'Selesai: ${_formatDate(_endedAt!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickEndedAt,
                      child: const Text('Pilih tanggal'),
                    ),
                    if (_endedAt != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _endedAt = null;
                          });
                        },
                      ),
                  ],
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

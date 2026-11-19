import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widget/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _experienceTitle = "";
  String _description = "";
  String _category = "full-time"; //default
  String _thumbnail = "";
  DateTime? _endedAt;

  // key: nilai yang disimpan, value: teks yang ditampilkan
  final Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
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
      _category = "full-time";
      _thumbnail = "";
      _endedAt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Experience Form',
          ),
        ),
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
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Experience Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories.entries
                      .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                        ))
                      .toList(),
                  onChanged: (String? newValue) {
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
                    final valid = uri != null && uri.hasAuthority && (
                      uri.scheme == 'http' || uri.scheme == 'https'
                    );
                    return valid ? null : "URL harus diawali http:// atau https://";
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
                          : 'Selesai: ${_formatDate(_endedAt!)}'
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
                      backgroundColor: 
                        WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Experience berhasil ditambahkan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Experience: $_experienceTitle'),
                                    Text('Deskripsi: $_description'),
                                    Text('Kategori: ${_categories[_category]}'),
                                    Text('Thumbnail: ${_thumbnail.isEmpty ? "-" : _thumbnail}'),
                                    Text(_endedAt == null
                                      ? 'Selesai: -'
                                      : 'Selesai: ${_formatDate(_endedAt!)}'
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
                    },
                    child: const Text(
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
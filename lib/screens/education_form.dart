import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widget/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _institutionName = "";
  String _category = "university";
  String _thumbnail = "";
  int? _yearStarted;
  int? _yearEnded;

  // key: nilai yang disimpan, value: teks yang ditampilkan
  final Map<String, String> _categories = {
    'elementary school': 'Elementary School',
    'junior high school': 'Junior High School',
    'high school': 'High School',
    'university': 'University',
  };

  //Untuk mengosongkan field angka saat reset
  final _yearStartedController = TextEditingController();
  final _yearEndedController = TextEditingController();

  @override
  void dispose() {
    _yearStartedController.dispose();
    _yearEndedController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _yearStartedController.clear();
    _yearEndedController.clear();
    setState(() {
      _institutionName = "";
      _category = "university";
      _thumbnail = "";
      _yearStarted = null;
      _yearEnded = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Education Form')),
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
              // === Institution Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    hintText: "Institution Name",
                    labelText: "Institution Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _institutionName = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama Institusi tidak boleh kosong!";
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
                    labelText: "Institution Category",
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
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Thumbnail (opsional) ===
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

              // === Year Started ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _yearStartedController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "Contoh: 2022",
                    labelText: "Year Started",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _yearStarted = int.tryParse(value ?? '');
                    });
                  },
                  validator: (String? value) {
                    final started = int.tryParse(value?.trim() ?? '');
                    if (started == null) {
                      return "Tahun mulai tidak boleh kosong!";
                    }
                    if (started.bitLength < 11 || started.bitLength > 13) {
                      return "Tahun tidak valid.";
                    }
                    return null;
                  },
                ),
              ),

              // === Year Ended ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _yearEndedController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "Kosongkan jika masih berlangsung",
                    labelText: "Year Ended",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _yearEnded = int.tryParse(value ?? '');
                    });
                  },
                  validator: (String? value) {
                    final ended = int.tryParse(value?.trim() ?? '');
                    if (ended == null) return null;
                    if (ended.bitLength < 11 || ended.bitLength > 13) {
                      return "Tahun tidak valid.";
                    }
                    if (_yearStarted != null && ended < _yearStarted!) {
                      return "Tahun selesai tidak bisa lebih awal dari tahun mulai!";
                    }
                    return null;
                  },
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Education berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Institution: $_institutionName'),
                                    Text('Kategori: ${_categories[_category]}'),
                                    Text(
                                      'Thumbnail: ${_thumbnail.isEmpty ? "-" : _thumbnail}',
                                    ),
                                    Text('Tahun Mulai: $_yearStarted'),
                                    Text(
                                      _yearEnded == null
                                          ? 'Tahun Selesai: -'
                                          : 'Tahun Selesai: $_yearEnded',
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

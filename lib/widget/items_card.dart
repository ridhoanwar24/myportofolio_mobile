import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/widget/auth_guard.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Menggunakan warna sekunder dari skema tema aplikasi.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          final authState = context.read<AuthState>();

          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Kamu telah menekan tombol ${item.name}')),
            );

          if (item.name == "Tambah Experience") {
            final ok = await ensureLoggedIn(context);
            if (!ok || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExperienceFormPage()),
            );
          }

          if (item.name == "Tambah Education") {
            final ok = await ensureLoggedIn(context);
            if (!ok || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EducationFormPage()),
            );
          }

          if (item.name == "Logout") {
            if (!authState.isLoggedIn) {
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text("Kamu belum login.")),
                );
              return;
            }
            try {
              await authState.logout();
            } catch (_) {}
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text("Kamu telah logout.")),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

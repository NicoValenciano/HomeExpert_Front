import 'package:flutter/material.dart';
import 'package:flutter_application_base/providers/people_provider.dart';
import 'package:flutter_application_base/providers/theme_provider.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ProfileScreen'),
        elevation: 10,
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfile(size: size),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: BodyProfile(),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyProfile extends StatelessWidget {
  const BodyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final temaProvider = Provider.of<ThemeProvider>(context, listen: false);
    final peopleProvider = Provider.of<PeopleProvider>(context);

    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Dark Mode'),
          value: temaProvider.isDarkMode,
          onChanged: (bool value) {
            value ? temaProvider.setDark() : temaProvider.setLight();
          },
        ),

        const SizedBox(height: 15),

        // Teléfono
        TextFormField(
          onChanged: (value) {},
          style: const TextStyle(fontSize: 18),
          decoration: decorationInput(
            label: 'Teléfono',
            icon: Icons.phone,
            helperText: 'Ingresar número sin 0 ni 15',
          ),
        ),
        const SizedBox(height: 15),

        // Email
        TextFormField(
          onChanged: (value) {},
          style: const TextStyle(fontSize: 18),
          decoration: decorationInput(
            label: 'Email',
            icon: Icons.alternate_email_outlined,
          ),
        ),
        const SizedBox(height: 15),

        // Apellido
        TextFormField(
          onChanged: (value) {
            peopleProvider.setApellido(value);
          },
          style: const TextStyle(fontSize: 18),
          initialValue: peopleProvider.apellido,
          keyboardType: TextInputType.text,
          decoration: decorationInput(label: 'Apellido'),
        ),
        const SizedBox(height: 15),

        // Nombre
        TextFormField(
          onChanged: (value) {
            peopleProvider.setNombre(value);
          },
          style: const TextStyle(fontSize: 18),
          initialValue: peopleProvider.nombre,
          keyboardType: TextInputType.text,
          decoration: decorationInput(label: 'Nombre'),
        ),
        const SizedBox(height: 15),

        // Género
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                  value: peopleProvider.isMale,
                  onChanged: (bool? value) {
                    if (value == true) {
                      peopleProvider.setGender(isMale: true);
                    }
                  },
                ),
                const Text('Masculino'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: !peopleProvider.isMale,
                  onChanged: (bool? value) {
                    if (value == true) {
                      peopleProvider.setGender(isMale: false);
                    }
                  },
                ),
                const Text('Femenino'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration decorationInput({
    IconData? icon,
    String? hintText,
    String? helperText,
    String? label,
  }) {
    return InputDecoration(
      fillColor: Colors.black,
      label: Text(label ?? ''),
      hintText: hintText,
      helperText: helperText,
      helperStyle: const TextStyle(fontSize: 16),
      prefixIcon: (icon != null) ? Icon(icon) : null,
    );
  }
}

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);

    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      color: const Color(0xff2d3e4f),
      child: Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage(
            peopleProvider.isMale
                ? 'assets/avatars/avatar1.png'
                : 'assets/avatars/avatar5.png',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:munix/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: authService.value.currentUser!.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      String newName = _nameController.text;
      print('Saving profile with name: $newName');
      setState(() {
      authService.value.updateUsername(username: newName).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar perfil: $error')),
        );
      });
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context, builder: (_) {
                    return SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Tirar Foto'),
                            onTap: () {
                              // Implementar lógica para tirar foto
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Selecionar da Galeria'),
                            onTap: () {
                              // Implementar lógica para selecionar da galeria
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.link),
                            title: const Text('Inserir URL'),
                            onTap: () {
                              showDialog(context: context, builder: (_) {
                                String url = '';
                                return AlertDialog(
                                  title: const Text('Inserir URL da Imagem'),
                                  content: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'URL da Imagem',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      url = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('Salvar'),
                                      onPressed: () {
                                        authService.value.updateProfilePicture(url: url);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Foto de perfil atualizada!')),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              });
                            },
                          )
                        ],
                      ),
                    );
                  });
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[700],
                      backgroundImage: NetworkImage(
            authService.value.currentUser?.photoURL ??
                'https://static.vecteezy.com/system/resources/previews/003/715/527/non_2x/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-vector.jpg',
            
          ),
                        
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  labelText: authService.value.currentUser?.displayName ?? 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
            
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar Alterações'),
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Make button wider
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munix/config/rotas.dart';
import 'package:munix/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _buildHomeScreen(),
      Center(child: Text('Pesquisa')),
      Center(child: Text('Biblioteca')),
      _buildProfileScreen(context),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        actions: _getAppBarActions(_selectedIndex),
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 110,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(3);
                },
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff536976), Color(0xff292e49)],
                      stops: [0, 1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          authService.value.currentUser?.photoURL ??
                              'https://static.vecteezy.com/system/resources/previews/003/715/527/non_2x/picture-profile',
                        ),
                      ),
                      SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authService.value.currentUser?.displayName ??
                                'Usuário',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            'Ver perfil',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize:
                                  MediaQuery.of(context).size.width > 500
                                      ? 15
                                      : 12,
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up_rounded),
              title: Text('Novidades'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Estatisticas'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Sobre'),
              onTap: () {
                showAdaptiveAboutDialog(context: context, applicationName: 'Munix', applicationVersion: '1.0.0', applicationIcon: SvgPicture.network(
                "https://upload.wikimedia.org/wikipedia/commons/2/26/Beats_Music_logo.svg",
                height: 100,
                width: 100,
              ), children: [
                  Text('Munix é um aplicativo de streaming de música que oferece uma vasta biblioteca de músicas e playlists personalizadas.'),
                ]);
                Navigator.pop(context); 
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Sair', style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                try {
                  showDialog(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                          title: Text('Sair'),
                          content: Text('Você tem certeza que deseja sair?'),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text('Sair'),
                              onPressed: () async {
                                Navigator.of(context).pop(); 
                                await AuthService().signOut(); 
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Rotas.home,
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                  );
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white70, 
        backgroundColor: Colors.grey[900], 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Biblioteca',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Munix';
      case 1:
        return 'Pesquisa';
      case 2:
        return 'Sua Biblioteca';
      case 3:
        return 'Perfil';
      default:
        return 'Munix';
    }
  }


  List<Widget>? _getAppBarActions(int index) {
    if (index == 0) {

      return [
        const SizedBox(width: 10),
        Container(
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              authService.value.currentUser?.photoURL ??
                  'https://static.vecteezy.com/system/resources/previews/003/715/527/non_2x/picture-profile',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Padding(padding: const EdgeInsets.only(right: 16.0)),
      ];
    }
    return null; // No actions for other screens
  }
}


Widget _buildHomeScreen() {
  return ListView(
    children: <Widget>[
      _buildSectionTitle('Tocadas recentemente'),
      _buildHorizontalList(), 
      _buildSectionTitle('Feito para você'),
      _buildHorizontalList(), 
      _buildSectionTitle('Novos Lançamentos'),
      _buildHorizontalList(), 

    ],
  );
}


Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildHorizontalList() {
  return SizedBox(
    height: 180, // Adjust height as needed
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: 5, // Example item count
      itemBuilder: (context, index) {
        return Container(
          width: 140, // Adjust width as needed
          margin: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // Placeholder for album/playlist art
                height: 140,
                color: Colors.grey[700],
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 50,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Item ${index + 1}', 
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildProfileScreen(BuildContext context) {
  return SingleChildScrollView(
    // Use SingleChildScrollView to prevent overflow if content is long
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[700], 
          backgroundImage: NetworkImage(
            authService.value.currentUser?.photoURL ??
                'https://static.vecteezy.com/system/resources/previews/003/715/527/non_2x/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-vector.jpg',
          ),
        ),
        SizedBox(height: 15),
        ValueListenableBuilder(
          valueListenable: authService,
          builder: (context, AuthService auth, _) {
            return Text(
              auth.currentUser?.displayName ?? 'Usuário',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            );
          },
        ),
        SizedBox(height: 30),
        Divider(), 
        ListTile(
          leading: Icon(Icons.edit_note),
          title: Text('Editar Perfil'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, Rotas.profile_edit);
          },
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notificações'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.lock_outline),
          title: Text('Privacidade'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Configurações da Conta'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.redAccent),
          title: Text('Sair', style: TextStyle(color: Colors.redAccent)),
          onTap: () async {
            try {
              showDialog(
                context: context,
                builder:
                    (BuildContext context) => AlertDialog(
                      title: Text('Sair'),
                      content: Text('Você tem certeza que deseja sair?'),
                      actions: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text('Sair'),
                          onPressed: () async {
                            Navigator.of(context).pop(); 
                            await AuthService().signOut(); 
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Rotas.home,
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
              );
            } catch (e) {
              print(e.toString());
            }
          },
        ),
      ],
    ),
  );
}

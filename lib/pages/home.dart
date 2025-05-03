import 'package:flutter/material.dart';
import 'package:munix/config/rotas.dart';
import 'package:munix/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Updated widget options - Late initialization needed because _buildProfileScreen needs context potentially
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Initialize _widgetOptions here where context is available if needed,
    // or pass context to the build functions if they require it.
    // For this example, context isn't strictly needed yet for these simple widgets.
    _widgetOptions = <Widget>[
      _buildHomeScreen(), // Use a dedicated function for the home screen
      Center(child: Text('Pesquisa')),
      Center(child: Text('Biblioteca')),
      _buildProfileScreen(context), // Pass context to the profile screen
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
      // Keep AppBar simple for now, or customize as needed
      // AppBar might need to change based on the selected tab
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)), // Dynamic title
        actions: _getAppBarActions(_selectedIndex), // Dynamic actions
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // To show all labels
        selectedItemColor: Colors.white, // Example color
        unselectedItemColor: Colors.white70, // Example color
        backgroundColor: Colors.grey[900], // Example background color
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

  // Helper to get AppBar title based on index
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

  // Helper to get AppBar actions based on index
  List<Widget>? _getAppBarActions(int index) {
    if (index == 0) {
      // Only show these actions on the Home screen
      return [
        IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
        IconButton(icon: Icon(Icons.history), onPressed: () {}),
        IconButton(icon: Icon(Icons.settings), onPressed: () {}),
      ];
    } 
    return null; // No actions for other screens
  }
}

// Function to build the Home Screen content
Widget _buildHomeScreen() {
  return ListView(
    children: <Widget>[
      _buildSectionTitle('Tocadas recentemente'),
      _buildHorizontalList(), // Placeholder for recently played items
      _buildSectionTitle('Feito para você'),
      _buildHorizontalList(), // Placeholder for recommendations
      _buildSectionTitle('Novos Lançamentos'),
      _buildHorizontalList(), // Placeholder for new releases
      // Add more sections as needed
    ],
  );
}

// Helper function to build section titles
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

// Helper function to build a horizontal list (placeholder)
Widget _buildHorizontalList() {
  return Container(
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
                'Item ${index + 1}', // Placeholder title
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

// --- New Function to build the Profile Screen ---
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
          backgroundColor: Colors.grey[700], // Placeholder background
          // Replace with NetworkImage or AssetImage for actual image
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
        Divider(), // Visual separator
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
            // TODO: Navigate to notification settings
          },
        ),
        ListTile(
          leading: Icon(Icons.lock_outline),
          title: Text('Privacidade'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to privacy settings
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Configurações da Conta'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to account settings
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.redAccent),
          title: Text('Sair', style: TextStyle(color: Colors.redAccent)),
          onTap: () async {
            try {
              showDialog(context: context, builder: (BuildContext context) => AlertDialog(
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
                      Navigator.of(context).pop(); // Close the dialog
                      await AuthService().signOut(); // Sign out
                      // Optionally navigate to login screen or show a message
                      Navigator.pushNamedAndRemoveUntil(context, Rotas.home, (route) => false);
                    },
                  ),
                ],
              ));
            } catch (e) {
                print(e.toString());
            }
          },
        ),
      ],
    ),
  );
}

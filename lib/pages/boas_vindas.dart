import 'package:flutter/material.dart';
import 'package:munix/config/rotas.dart';

class BoasVindasPage extends StatefulWidget {
  const BoasVindasPage({super.key});

  @override
  State<BoasVindasPage> createState() => _BoasVindasPageState();
}

class _BoasVindasPageState extends State<BoasVindasPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _termsAccepted = false;

  final List<Widget> _featurePages = [
    const _FeaturePage(
      title: 'Bem-vindo ao Munix!',
      description: 'Seu app de produtividade.',
      icon: Icons.lightbulb_outline,
    ),
    const _FeaturePage(
      title: 'Funcionalidade 1',
      description: 'Descrição detalhada da primeira funcionalidade incrível.',
      icon: Icons.dashboard_customize_outlined,
    ),
    const _FeaturePage(
      title: 'Funcionalidade 2',
      description: 'Explore como a segunda funcionalidade pode te ajudar.',
      icon: Icons.bar_chart_outlined,
    ),
    const _FeaturePage(
      title: 'Vamos começar?',
      description: 'Agora é só continuar para a sua experiência.',
      icon: Icons.star,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToLogin() {
    if (_termsAccepted) {
      Navigator.pushReplacementNamed(context, Rotas.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos de uso para continuar.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _featurePages,
              ),
            ),
            Padding( // Added padding around the navigation controls
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Previous Button
                  TextButton(
                    onPressed: _currentPage == 0
                        ? null
                        : () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: const Text('Anterior'),
                  ),
                  // Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_featurePages.length, (int index) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 10,
                          width: (index == _currentPage) ? 30 : 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10), // Adjusted vertical margin
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                  // Next Button
                  TextButton(
                    onPressed: _currentPage == _featurePages.length - 1
                        ? null
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: const Text('Próximo'),
                  ),
                ],
              ),
            ),
            if (_currentPage == _featurePages.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Termos de Uso'),
                              content: const SingleChildScrollView(
                                child: Text(
                                  'Aqui vão os termos e condições de uso do aplicativo Munix. '
                                  'Leia atentamente antes de prosseguir.\n\n'
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                                  'nisi ut aliquip ex ea commodo consequat...',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Fechar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Eu li e concordo com os Termos de Uso.',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_currentPage == _featurePages.length - 1)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4), // Adjust the radius as needed
                              ),
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: _termsAccepted ? Colors.black : Colors.grey,
                  ),
                  onPressed: _termsAccepted ? _navigateToLogin : null,
                  child: const Text('Continuar', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _FeaturePage({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 100.0,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 30.0),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
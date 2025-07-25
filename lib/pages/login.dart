// lib/pages/login.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Substitua pelos seus imports corretos
import '../config/rotas.dart';
import '../services/auth_service.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscureText = true;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    // 1. Valida o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 2. Tenta fazer o login
      await authService.value.singIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      // 3. Navega para a tela principal em caso de sucesso
      Navigator.pushNamedAndRemoveUntil(context, Rotas.main, (route) => false);

    } on FirebaseAuthException catch (e) {
      // Tradução simples para os erros mais comuns
      switch (e.code) {
        case 'invalid-email':
          _errorMessage = 'O formato do e-mail é inválido.';
          break;
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          _errorMessage = 'E-mail ou senha incorretos.';
          break;
        default:
          _errorMessage = 'Ocorreu um erro. Tente novamente.';
      }
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
    } finally {
      // 4. Garante que o estado de loading seja atualizado
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea garante que o conteúdo não fique sob a barra de status ou notch
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Padding para dar um respiro nas bordas da tela
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              // Define uma largura máxima para o conteúdo em telas grandes
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 48.0),
                    _buildFormFields(),
                    if (_errorMessage.isNotEmpty) _buildErrorMessage(),
                    const SizedBox(height: 24.0),
                    _buildActionButtons(),
                    const SizedBox(height: 24.0),
                    _buildForgotPassword(context),
                    const SizedBox(height: 48.0),
                    _buildSocialLoginDivider(),
                    const SizedBox(height: 16.0),
                    _buildSocialLoginButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SvgPicture.network(
          "https://upload.wikimedia.org/wikipedia/commons/2/26/Beats_Music_logo.svg",
          height: 80,
          colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color!, BlendMode.srcIn),
        ),
        const SizedBox(height: 16),
        Text(
          'Munix',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'E-mail',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite seu e-mail';
            }
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              return 'Por favor, digite um e-mail válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Senha',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite sua senha';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        _errorMessage,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botão de Login principal
        FilledButton(
          onPressed: _isLoading ? null : _performLogin,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                )
              : const Text('Login', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 12.0),
        // Botão secundário para Registrar
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, Rotas.register),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Criar conta', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navegação simples para a tela de recuperação de senha
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPassword()),
        );
      },
      child: const Text('Esqueceu sua senha?'),
    );
  }

  Widget _buildSocialLoginDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Ou entre com'),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context) {
    return Center(
      child: IconButton(
        iconSize: 40,
        icon: SvgPicture.network(
          'https://www.svgrepo.com/show/475656/google-color.svg', // Ícone do Google
        ),
        onPressed: () async {
          // Lógica para login com Google
          // await authService.value.signInWithGoogle();
          // if (mounted) Navigator.pushNamedAndRemoveUntil(context, Rotas.main, (route) => false);
        },
      ),
    );
  }
}
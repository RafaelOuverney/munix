// ignore_for_file: unused_import

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munix/config/rotas.dart';
import 'package:munix/pages/aplicativo_cadastro.dart';
import 'package:munix/pages/forgot_password.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:munix/firebase_options.dart';
import 'package:munix/services/auth_service.dart';
// import 'package:munix/services/spotify_api.dart';
import 'package:translator/translator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              MediaQuery.of(context).size.width > 500
                  ? EdgeInsets.all(250)
                  : EdgeInsets.all(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.network(
                "https://upload.wikimedia.org/wikipedia/commons/2/26/Beats_Music_logo.svg",
                height: 100,
                width: 100,
              ),
              Text(
                'Munix',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 150),
                CupertinoTextField(
                controller: emailController,
                placeholder: 'E-mail',
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.email, color: Colors.blueGrey),
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: BoxDecoration(
                  border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              ),
              const SizedBox(height: 10),
                CupertinoTextField(
                controller: passwordController,
                placeholder: 'Senha',
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.lock, color: Colors.blueGrey),
                ),
                suffix: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                  _obscureText == true
                    ? CupertinoIcons.eye_fill
                    : CupertinoIcons.eye_slash_fill,
                  color: Colors.blueGrey,
                  ),
                  onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                  },
                ),
                obscureText: _obscureText,
                decoration: BoxDecoration(
                  border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                ),
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              Center(
                child: Column(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 500,
                      child: CupertinoButton(
                        color: Colors.black87,
                        onPressed: () async {
                        try {
                          await authService.value.singIn(
                          email: emailController.text,
                          password: passwordController.text,
                          );
                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(context, Rotas.main, (route) => false);
                        } on FirebaseAuthException catch (e) {
                          String finalErrorMessage;
                          try {
                          // Perform async translation first
                          final translation = await GoogleTranslator().translate(
                            e.message ?? 'Erro desconhecido', // Default message if e.message is null
                            from: 'en',
                            to: 'pt',
                          );
                          finalErrorMessage = translation.text;
                          } catch (translationError) {
                          // Fallback if translation fails: use the original Firebase message (if available)
                          // or a generic Portuguese error message.
                          finalErrorMessage = e.message ?? 'Ocorreu um erro de autenticação.';
                          }
                          
                          if (!mounted) return;
                          setState(() {
                          errorMessage = finalErrorMessage;
                          });
                        }
                        },
                        child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      child: CupertinoButton(
                        color: const Color.fromARGB(255, 199, 199, 199),
                        onPressed: () {
                          Navigator.pushNamed(context, Rotas.register);
                        },
                        child: const Text(
                          'Registrar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
                GestureDetector(
                onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                  title: const Text('Recuperar senha'),
                  message: const Text('Digite seu e-mail para redefinir a senha.'),
                  actions: [
                    ForgotPassword(),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  ),
                ),
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: Color.fromARGB(255, 0, 88, 160)),
                ),
                ),
              const SizedBox(height: 120),

              Center(
                child: const Text(
                  'Ou faça login com',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.network(
                        'https://img.icons8.com/?size=512&id=17949&format=png',
                        scale: 12,
                      ),
                      onPressed: () async {
                        Navigator.pushNamed(context, Rotas.aplicativo_cadastro);
                        // await RemoteService();
                        // Navigator.pushNamed(context, Rotas.main);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

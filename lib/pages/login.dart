// ignore_for_file: unused_import

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munix/config/rotas.dart';
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
              Form(
                child:  TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText == true
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                obscureText: _obscureText,
              ),
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 50),
              GestureDetector(
                onTap:
                    () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => ForgotPassword(),
                    ),
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: Color.fromARGB(255, 0, 88, 160)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await authService.value.singIn(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          Navigator.pushNamedAndRemoveUntil(context, Rotas.main, (route) => false);
                        } on FirebaseAuthException catch (e) {
                          setState(() async {
                            final translation = await GoogleTranslator().translate(e.message ?? 'Erro desconhecido', from: 'en', to: 'pt');
                            setState(() {
                              errorMessage = translation.text;
                            });
                          });
                        }
                      },
                      label: const Text('Login'),
                      icon: const Icon(Icons.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        iconColor: Colors.white,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, Rotas.register);
                      },
                      label: Text('Registrar'),
                      icon: Icon(Icons.person_add_alt_1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        iconColor: Colors.white,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 150),

              Center(
                child: const Text(
                  'Ou faça login com',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.network(
                      'https://img.icons8.com/?size=512&id=17949&format=png',
                      scale: 12,
                    ),
                    onPressed: () async {
                      print('Google login');
                      // await RemoteService();
                      Navigator.pushNamed(context, Rotas.main);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

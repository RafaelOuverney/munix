// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:munix/config/rotas.dart';
import 'package:munix/pages/aplicativo_cadastro.dart';
import 'package:munix/pages/edit_profile.dart';
import 'package:munix/pages/forgot_password.dart';
import 'package:munix/pages/home.dart';
import 'package:munix/pages/login.dart';
import 'package:munix/pages/register.dart';
import 'package:munix/pages/boas_vindas.dart';

class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicativo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Rotas.home,
      routes: {
        Rotas.home: (context) =>  Login(),
        Rotas.main: (context) =>  const HomePage(),
        Rotas.forgotPassword: (context) => const ForgotPassword(),
        Rotas.register: (context) =>  Register(),
        Rotas.profile_edit: (context) =>  const EditProfilePage(),
        Rotas.aplicativo_cadastro: (context) =>  AplicativoCadastro(),
        Rotas.boas_vindas: (context) =>  BoasVindasPage(),
      },
      // 
    );
  }
}